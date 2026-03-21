# Imports are used to load, export, quantize, run, and benchmark the YOLO model in ONNX format
# Ultralytics YOLO loads the trained .pt model and handles ONNX export format
from ultralytics import YOLO

# quantize_dynamic performs INT8 quantization on the ONNX model
# QuantType specifies the quantization type that we are running
from onnxruntime.quantization import quantize_dynamic, QuantType

# Used to calculate benchmark statistics
import numpy as np

# Used to accurately time each inference run
import time

# Used to get model file sizes in bytes and convert to MB
import os

# Used to load and resize images from the dataset folders
from PIL import Image

# Used to find all images in a folder
from collections import OrderedDict
from pathlib import Path

# Repo root for yolov11 (parent of this quantization_model/ folder)
_YOLOV11_ROOT = Path(__file__).resolve().parent.parent

# Used to compute F1, AUC, AP, Precision, and Recall against ground truth labels
from sklearn.metrics import (
    average_precision_score,
    f1_score,
    precision_score,
    recall_score,
    roc_auc_score,
)


# Larger model from train2
MODEL_TRAIN2  = r"C:\Users\jacob\SeniorDesignLM\yolov11\runs\detect\train2\weights\best.pt"

# Output path for the original FP32 ONNX model
ONNX_ORIGINAL = r"C:\Users\jacob\SeniorDesignLM\yolov11\runs\detect\train2\weights\best.onnx"

# Output path for the quantized INT8 ONNX model
# we want two paths to compare the quantization model to the original model, so we can see the difference in size and speed
ONNX_QUANT    = r"C:\Users\jacob\SeniorDesignLM\best_quantized.onnx"

# COCO benchmarks: coco128 (128 COCO train images) includes GT for person/bicycle/car/motorcycle.
# coco8 only has 8 images and **no** labels for classes 1–3, so P/R/F1 for those stay empty on coco8.
_COCO_DATASETS_DIR = _YOLOV11_ROOT / "datasets"
_COCO128_ROOT = _COCO_DATASETS_DIR / "coco128"
_COCO128_IMAGES = _COCO128_ROOT / "images" / "train2017"

# "Dataset A" = FP32 run, "Dataset B" = INT8 run — **same image folder**, not two different datasets.
# Quantized vs non-quantized is the **model**, not the folder.
DATASET_A = _COCO128_IMAGES
DATASET_B = _COCO128_IMAGES


def ensure_coco128():
    """Download Ultralytics coco128 if missing (~7 MB) so per-class metrics exist for COCO IDs 0–3."""
    img_dir = _COCO128_IMAGES
    if img_dir.is_dir() and (list(img_dir.glob("*.jpg")) or list(img_dir.glob("*.jpeg"))):
        return _COCO128_ROOT
    print("\n  (Downloading coco128: 128 COCO images + labels — needed for bicycle/car/motorcycle GT.)")
    from ultralytics.utils.downloads import download

    url = "https://github.com/ultralytics/assets/releases/download/v0.0.0/coco128.zip"
    download(url, dir=_COCO_DATASETS_DIR, unzip=True)
    return _COCO128_ROOT

# COCO class IDs for metrics (coco8 labels use full 80-class COCO indices)
TARGET_COCO_IDS = (0, 1, 2, 3)  # person, bicycle, car, motorcycle
NUM_TARGET_CLASSES = len(TARGET_COCO_IDS)
TARGET_COCO_SET = frozenset(TARGET_COCO_IDS)

# Readable names (must align with TARGET_COCO_IDS order)
CLASS_NAMES = {0: "person", 1: "bicycle", 2: "car", 3: "motorcycle"}

# IOU threshold to determine if a predicted box matches a ground truth box
IOU_THRESHOLD = 0.5

# Confidence threshold below which detections are discarded
CONF_THRESHOLD = 0.25


# Exporting to ONNX
# Converts the trained .pt model into ONNX format
print("\n[1/4] Exporting model to ONNX...")
model = YOLO(MODEL_TRAIN2)
model.export(format="onnx", simplify=True, half=False)
print(f"ONNX model saved to: {ONNX_ORIGINAL}")

# Quantize to INT8
print("\n[2/4] Quantizing model to INT8...")
quantize_dynamic(
    model_input=ONNX_ORIGINAL,
    model_output=ONNX_QUANT,
    weight_type=QuantType.QInt8
)
print(f"Quantized model saved to: {ONNX_QUANT}")


# Function to load and preprocess images from a folder
def load_images(folder):
    images = []
    paths = sorted(
        list(Path(folder).glob("*.jpg")) +
        list(Path(folder).glob("*.png"))
    )
    for p in paths:
        img = Image.open(p).convert("RGB").resize((640, 640))
        arr = np.array(img).astype(np.float32) / 255.0
        arr = arr.transpose(2, 0, 1)
        arr = np.expand_dims(arr, axis=0)
        images.append((arr, p))   # store path alongside array to load labels later
    print(f"  Loaded {len(images)} images from {folder}")
    return images


# Loads the YOLO .txt ground truth label file for a given image
# Tries: (1) label next to the image, (2) Ultralytics layout:
#       <dataset>/images/<split>/<name>.jpg -> <dataset>/labels/<split>/<name>.txt
def load_labels(image_path):
    p = Path(image_path)
    label_path = p.with_suffix(".txt")
    if not label_path.exists():
        label_path = p.parent.parent.parent / "labels" / p.parent.name / f"{p.stem}.txt"
    if not label_path.exists():
        label_path = p.parent.parent / "labels" / f"{p.stem}.txt"
    labels = []
    if label_path.exists():
        for line in label_path.read_text().strip().splitlines():
            parts = line.strip().split()
            if len(parts) == 5:
                labels.append({
                    "class_id": int(parts[0]),
                    "box": list(map(float, parts[1:]))
                })
    return labels


# Computes IoU between two YOLO-format boxes [cx, cy, w, h]
def compute_iou(a, b):
    def to_xyxy(box):
        return (box[0]-box[2]/2, box[1]-box[3]/2,
                box[0]+box[2]/2, box[1]+box[3]/2)
    ax1,ay1,ax2,ay2 = to_xyxy(a)
    bx1,by1,bx2,by2 = to_xyxy(b)
    inter = max(0, min(ax2,bx2)-max(ax1,bx1)) * max(0, min(ay2,by2)-max(ay1,by1))
    union = (ax2-ax1)*(ay2-ay1) + (bx2-bx1)*(by2-by1) - inter
    return inter / union if union > 0 else 0.0


def ultralytics_detections_to_yolo_format(result):
    """Convert Ultralytics Results to normalized YOLO cxcywh boxes (same format as label files)."""
    dets = []
    if result.boxes is None or len(result.boxes) == 0:
        return dets
    h, w = result.orig_shape
    for i in range(len(result.boxes)):
        xyxy = result.boxes.xyxy[i].cpu().numpy()
        cls_id = int(result.boxes.cls[i])
        conf = float(result.boxes.conf[i])
        x1, y1, x2, y2 = xyxy / np.array([w, h, w, h], dtype=np.float64)
        cx = (x1 + x2) / 2
        cy = (y1 + y2) / 2
        bw = x2 - x1
        bh = y2 - y1
        dets.append({"class_id": cls_id, "confidence": conf, "box": [cx, cy, bw, bh]})
    return dets


def _auc_and_ap(yt, ys):
    """ROC-AUC needs both labels; AP (average precision) is valid for ranking with imbalanced positives/negatives."""
    yt = np.asarray(yt, dtype=float)
    ys = np.asarray(ys, dtype=float)
    auc = float("nan")
    ap = float("nan")
    if len(yt) == 0:
        return auc, ap
    try:
        ap = float(average_precision_score(yt, ys))
    except ValueError:
        pass
    if len(np.unique(yt)) > 1:
        try:
            auc = float(roc_auc_score(yt, ys))
        except ValueError:
            pass
    return auc, ap


# Computes Precision, Recall, F1, AUC, and AP for TARGET_COCO_IDS only (person, bicycle, car, motorcycle)
def compute_metrics(predictions_per_image, labels_per_image):
    y_true  = {c: [] for c in range(NUM_TARGET_CLASSES)}
    y_score = {c: [] for c in range(NUM_TARGET_CLASSES)}

    for preds, gts in zip(predictions_per_image, labels_per_image):
        gt_by_class = {}
        for gt in gts:
            cid = gt["class_id"]
            if cid not in TARGET_COCO_SET:
                continue
            gt_by_class.setdefault(cid, []).append(gt)

        matched = set()

        for cls_id, gt_list in gt_by_class.items():
            cls_preds = sorted(
                [(i, p) for i, p in enumerate(preds) if p["class_id"] == cls_id],
                key=lambda x: -x[1]["confidence"]
            )
            for gt in gt_list:
                best_iou, best_conf, best_idx = 0.0, 0.0, -1
                for idx, p in cls_preds:
                    if idx in matched:
                        continue
                    iou = compute_iou(p["box"], gt["box"])
                    if iou > best_iou:
                        best_iou, best_conf, best_idx = iou, p["confidence"], idx
                if best_iou >= IOU_THRESHOLD:
                    y_true[cls_id].append(1)          # true positive
                    y_score[cls_id].append(best_conf)
                    matched.add(best_idx)
                else:
                    y_true[cls_id].append(1)          # false negative
                    y_score[cls_id].append(0.0)

        for idx, p in enumerate(preds):
            cls_id = p["class_id"]
            if cls_id not in TARGET_COCO_SET or idx in matched:
                continue
            y_true[cls_id].append(0)                  # false positive
            y_score[cls_id].append(p["confidence"])

    # Per-class scores
    all_true, all_pred, all_score = [], [], []
    per_class = {}
    for cls_id in range(NUM_TARGET_CLASSES):
        if not y_true[cls_id]:
            continue
        yt = np.array(y_true[cls_id])
        ys = np.array(y_score[cls_id])
        yp = (ys >= CONF_THRESHOLD).astype(int)
        auc, ap = _auc_and_ap(yt, ys)
        per_class[cls_id] = {
            "precision": float(precision_score(yt, yp, zero_division=0)),
            "recall":    float(recall_score(yt, yp, zero_division=0)),
            "f1":        float(f1_score(yt, yp, zero_division=0)),
            "auc":       auc,
            "ap":        ap,
        }
        all_true.extend(yt.tolist())
        all_pred.extend(yp.tolist())
        all_score.extend(ys.tolist())

    # Overall scores across target classes only
    if all_true:
        o_auc, o_ap = _auc_and_ap(all_true, all_score)
        return {
            "precision": float(precision_score(all_true, all_pred, zero_division=0)),
            "recall":    float(recall_score(all_true, all_pred, zero_division=0)),
            "f1":        float(f1_score(all_true, all_pred, zero_division=0)),
            "auc":       o_auc,
            "ap":        o_ap,
            "per_class": per_class
        }
    return {
        "precision": float("nan"), "recall": float("nan"), "f1": float("nan"),
        "auc": float("nan"), "ap": float("nan"), "per_class": {},
    }


def _per_class_with_all_slots(per_class):
    """Ensure every target class key exists for printing (N/A if no samples)."""
    out = {}
    for cls_id in range(NUM_TARGET_CLASSES):
        if cls_id in per_class:
            out[cls_id] = per_class[cls_id]
        else:
            out[cls_id] = {
                "precision": float("nan"), "recall": float("nan"),
                "f1": float("nan"), "auc": float("nan"), "ap": float("nan"),
            }
    return out


def _fmt_metric(x):
    if isinstance(x, float) and x != x:
        return "nan"
    return f"{x:.4f}"


# Benchmark function: Ultralytics YOLO loads ONNX (FP32 or INT8) with correct postprocess (sigmoid + NMS)
def benchmark(model_path, label, images):
    model = YOLO(model_path, task="detect")

    warmup_path = str(images[0][1])
    for _ in range(3):
        model.predict(warmup_path, imgsz=640, verbose=False, conf=CONF_THRESHOLD)

    latencies, preds_all, labels_all = [], [], []
    for arr, img_path in images:
        start = time.perf_counter()
        result = model.predict(str(img_path), imgsz=640, verbose=False, conf=CONF_THRESHOLD)[0]
        latencies.append((time.perf_counter() - start) * 1000)
        preds_all.append(ultralytics_detections_to_yolo_format(result))
        labels_all.append(load_labels(img_path))

    avg  = np.mean(latencies)
    p95  = np.percentile(latencies, 95)
    size = os.path.getsize(model_path) / (1024 ** 2)

    m = compute_metrics(preds_all, labels_all)
    m["per_class"] = _per_class_with_all_slots(m["per_class"])

    print(f"\n{'='*50}")
    print(f"  {label}")
    print(f"{'='*50}")
    print(f"  Model size   : {size:.2f} MB")
    print(f"  Images tested: {len(images)}")
    print(f"  Avg latency  : {avg:.2f} ms")
    print(f"  P95 latency  : {p95:.2f} ms")
    print(f"  Throughput   : {1000/avg:.1f} FPS")
    print(f"  ---")
    print(f"  Target classes (COCO): person, bicycle, car, motorcycle (IDs 0–3)")
    print(f"  Detection Quality (IoU>={IOU_THRESHOLD}, conf>={CONF_THRESHOLD})")
    print(f"  Precision    : {_fmt_metric(m['precision'])}")
    print(f"  Recall       : {_fmt_metric(m['recall'])}")
    print(f"  F1 Score     : {_fmt_metric(m['f1'])}")
    print(f"  AUC          : {_fmt_metric(m['auc'])}  (nan if only one label type; use AP below)")
    print(f"  AP (mAP-pr)  : {_fmt_metric(m['ap'])}  (average precision — ranking metric)")
    print(f"  --- Per-Class (person / bicycle / car / motorcycle) ---")
    for cls_id in range(NUM_TARGET_CLASSES):
        scores = m["per_class"][cls_id]
        name = CLASS_NAMES[cls_id]
        print(f"  {name:<12s}  P={_fmt_metric(scores['precision'])}  R={_fmt_metric(scores['recall'])}  "
              f"F1={_fmt_metric(scores['f1'])}  AUC={_fmt_metric(scores['auc'])}  AP={_fmt_metric(scores['ap'])}")

    return {"size": size, "avg": avg, "p95": p95, "fps": 1000/avg, **m}


def _metric_delta(quant_val, fp32_val):
    if isinstance(quant_val, float) and isinstance(fp32_val, float):
        if quant_val != quant_val or fp32_val != fp32_val:  # nan
            return float("nan")
        return quant_val - fp32_val
    return quant_val - fp32_val


def print_fp32_vs_quant(fp32, quant, title):
    """Print detection-metric and latency deltas (quant minus FP32)."""
    print(f"\n{'='*50}")
    print(f"  COMPARISON: {title}")
    print(f"{'='*50}")
    ratio = fp32["avg"] / quant["avg"] if quant["avg"] > 0 else float("nan")
    if ratio == ratio and ratio >= 1:
        print(f"  Latency (quant) : {ratio:.2f}x faster vs FP32")
    elif ratio == ratio:
        print(f"  Latency (quant) : {1/ratio:.2f}x slower vs FP32")
    print(f"  Model size      : FP32 {fp32['size']:.2f} MB  |  INT8 {quant['size']:.2f} MB  "
          f"({(1 - quant['size']/fp32['size'])*100:.1f}% smaller)")
    print(f"  FPS             : FP32 {fp32['fps']:.1f}  |  INT8 {quant['fps']:.1f}")
    print(f"  --- Overall (target classes 0–3) INT8 − FP32 ---")
    for key, lab in [
        ("precision", "Precision"), ("recall", "Recall"), ("f1", "F1"),
        ("auc", "AUC"), ("ap", "AP"),
    ]:
        a, b = fp32[key], quant[key]
        d = _metric_delta(b, a) if a == a and b == b else float("nan")
        print(f"  {lab:<10s}  Δ = {d:+.4f}" if d == d else f"  {lab:<10s}  Δ = nan")
    print(f"  --- Per-class: person, bicycle, car, motorcycle ---")
    hdr = f"  {'class':<12} {'metric':<10} {'FP32':>10} {'INT8':>10} {'Δ':>10}"
    print(hdr)
    print(f"  {'-'*56}")
    for cls_id in range(NUM_TARGET_CLASSES):
        name = CLASS_NAMES[cls_id]
        for metric, mlab in [("precision", "P"), ("recall", "R"), ("f1", "F1"), ("auc", "AUC"), ("ap", "AP")]:
            a = fp32["per_class"][cls_id][metric]
            b = quant["per_class"][cls_id][metric]
            d = _metric_delta(b, a) if a == a and b == b else float("nan")
            print(
                f"  {name:<12s}  {mlab:<10s} {_fmt_metric(a):>10} {_fmt_metric(b):>10} "
                f"{(f'{d:+.4f}' if d == d else 'nan'):>10}"
            )


# FP32 run = "Dataset A", INT8 run = "Dataset B" — same COCO images, different models.
ensure_coco128()
print("\n[3/4] Benchmarking: same COCO images — Dataset A = FP32 ONNX, Dataset B = INT8 ONNX ...")
print(f"  Image root: {DATASET_A.resolve()}")
_path_groups = OrderedDict()
for label, folder in [("Dataset A (FP32)", DATASET_A), ("Dataset B (INT8)", DATASET_B)]:
    key = Path(folder).resolve()
    if key not in _path_groups:
        _path_groups[key] = []
    _path_groups[key].append(label)

_all_runs = []
for resolved_path, labels in _path_groups.items():
    group_title = " / ".join(labels)
    imgs = load_images(resolved_path)
    fp32 = benchmark(ONNX_ORIGINAL, f"Original FP32 — {group_title}", imgs)
    quant = benchmark(ONNX_QUANT, f"Quantized INT8 — {group_title}", imgs)
    print_fp32_vs_quant(
        fp32, quant,
        f"{group_title} — same folder, FP32 vs quantized model" if len(labels) > 1 else labels[0],
    )
    _all_runs.append((group_title, labels, fp32, quant))

print(f"\n{'='*50}")
print("  SUMMARY: FP32 vs INT8 (all dataset groups)")
print(f"{'='*50}")
for group_title, labels, fp32, quant in _all_runs:
    print(f"\n  [{group_title}]  (overall target classes)")
    print(f"    Precision  FP32 {_fmt_metric(fp32['precision'])}  INT8 {_fmt_metric(quant['precision'])}  "
          f"Δ {_metric_delta(quant['precision'], fp32['precision']):+.4f}")
    print(f"    Recall     FP32 {_fmt_metric(fp32['recall'])}  INT8 {_fmt_metric(quant['recall'])}  "
          f"Δ {_metric_delta(quant['recall'], fp32['recall']):+.4f}")
    print(f"    F1         FP32 {_fmt_metric(fp32['f1'])}  INT8 {_fmt_metric(quant['f1'])}  "
          f"Δ {_metric_delta(quant['f1'], fp32['f1']):+.4f}")
    dq = _metric_delta(quant["auc"], fp32["auc"])
    dp = _metric_delta(quant["ap"], fp32["ap"])
    print(f"    AUC        FP32 {_fmt_metric(fp32['auc'])}  INT8 {_fmt_metric(quant['auc'])}  "
          f"Δ {(f'{dq:+.4f}' if dq == dq else 'nan')}")
    print(f"    AP         FP32 {_fmt_metric(fp32['ap'])}  INT8 {_fmt_metric(quant['ap'])}  "
          f"Δ {(f'{dp:+.4f}' if dp == dp else 'nan')}")

print("\n[4/4] Done.")