from ultralytics import YOLO
import os
import numpy as np
import cv2
from sklearn.metrics import roc_curve, auc, precision_recall_curve, f1_score

Image_Dir = "data/images"
Label_Dir = "data/labels"
Saved_Dir = "data/saved"

os.makedirs(Label_Dir, exist_ok=True)
os.makedirs(Saved_Dir, exist_ok=True)

model = YOLO("yolo11n.pt")

def iou(b1, b2):
    x1_min, y1_min = b1[1]-b1[3]/2, b1[2]-b1[4]/2
    x1_max, y1_max = b1[1]+b1[3]/2, b1[2]+b1[4]/2
    x2_min, y2_min = b2[1]-b2[3]/2, b2[2]-b2[4]/2
    x2_max, y2_max = b2[1]+b2[3]/2, b2[2]+b2[4]/2

    inter_w = max(0, min(x1_max, x2_max) - max(x1_min, x2_min))
    inter_h = max(0, min(y1_max, y2_max) - max(y1_min, y2_min))
    inter = inter_w * inter_h

    area1 = (x1_max - x1_min) * (y1_max - y1_min)
    area2 = (x2_max - x2_min) * (y2_max - y2_min)

    return inter / (area1 + area2 - inter + 1e-6)

y_true = []
y_scores = []
IOU_Threshold = 0.5

for img_name in os.listdir(Image_Dir):
    if not img_name.lower().endswith(".jpg"):
        continue

    print(f"\nProcessing {img_name}")

    img_path = os.path.join(Image_Dir, img_name)

    label_path = os.path.join(Label_Dir, img_name.replace(".jpg", ".txt"))
    gt_boxes = []

    if os.path.exists(label_path):
        with open(label_path, "r") as f:
            for line in f:
                cls, x, y, w, h = map(float, line.split())
                gt_boxes.append([int(cls), x, y, w, h])

    multi_y_true = []
    multi_y_scores = []

    results = model(img_path)

    pred_label_path = os.path.join(Label_Dir, img_name.replace(".jpg", ".txt"))

    with open(pred_label_path, "w") as f_txt:
        for r in results:
            if r.boxes is None:
                continue

            for box in r.boxes:
                cls = int(box.cls[0])
                x, y, w_box, h_box = box.xywhn[0].tolist()
                conf = float(box.conf[0])

                f_txt.write(f"{cls} {x:.6f} {y:.6f} {w_box:.6f} {h_box:.6f}\n")

                best_iou = 0
                for gt in gt_boxes:
                    if gt[0] == cls:
                        best_iou = max(best_iou, iou([cls, x, y, w_box, h_box], gt))

                label = 1 if best_iou >= IOU_Threshold else 0

                multi_y_true.append(label)
                multi_y_scores.append(conf)

                y_true.append(label)
                y_scores.append(conf)

    save_path = os.path.join(Saved_Dir, img_name)
    r.save(filename=save_path)

    print(f"Saved image: {save_path}")
    print(f"Saved labels: {pred_label_path}")

    print(f"Metrics for {img_name}")

    fpr, tpr, _ = roc_curve(multi_y_true, multi_y_scores)
    roc_auc_i = auc(fpr, tpr)

    precision_i, recall_i, _ = precision_recall_curve(multi_y_true, multi_y_scores)
    pr_auc_i = auc(recall_i, precision_i)

    y_pred_i = (np.array(multi_y_scores) >= 0.5).astype(int)
    f1_i = f1_score(multi_y_true, y_pred_i) if len(multi_y_true) else 0

    print(f"AU-ROC: {roc_auc_i:.3f}")
    print(f"AU-PR: {pr_auc_i:.3f}")
    print(f"F1: {f1_i:.3f}")

print("Dataset metrics")

fpr, tpr, _ = roc_curve(y_true, y_scores)
roc_auc = auc(fpr, tpr)

precision, recall, _ = precision_recall_curve(y_true, y_scores)
pr_auc = auc(recall, precision)

y_pred = (np.array(y_scores) >= 0.5).astype(int)
f1 = f1_score(y_true, y_pred)

print(f"AU-ROC: {roc_auc:.3f}")
print(f"AU-PR: {pr_auc:.3f}")
print(f"F1: {f1:.3f}")
