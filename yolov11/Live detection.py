from ultralytics import YOLO
import cv2
import os
import numpy as np
from sklearn.metrics import roc_curve, auc, precision_recall_curve, f1_score

IOU_Threshold = 0.5
CONF_Threshold = 0.5

Frame_Dir = "data/live_frames"
Label_Dir = "data/live_labels"
Save_Dir = "data/live_saved"

os.makedirs(Save_Dir, exist_ok = True)
os.makedirs(Frame_Dir, exist_ok = True)
os.makedirs(Label_Dir, exist_ok = True)

model_coco = YOLO("yolo11n.pt")
model_pen = YOLO("pen/runs/detect/trains/weights/best.pt")

Pen_ID = {0: 80}

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

cap = cv2.VideoCapture(0)
frame_id = 0

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    frame_name = f"frame{frame_id:d}.jpg"
    frame_path = os.path.join(Frame_Dir, frame_name)
    cv2.imwrite(frame_path, frame)

    results_coco = model_coco(frame, conf = CONF_Threshold)
    results_pen = model_pen(frame, conf = CONF_Threshold)

    label_path = os.path.join(Label_Dir, frame_name.replace(".jpg", ".txt"))

    gt_boxes = []
    if os.path.exists(label_path):
        with open(label_path) as f:
            for line in f:
                cls, x, y, w, h = map(float, line.split())
                gt_boxes.append([int(cls), x, y, w, h])

    with open(label_path, "w") as f:
        for r in results_coco:
            if not r.boxes:
                continue
            for box in r.boxes:
                cls = int(box.cls[0])
                x, y, w, h = box.xywhn[0].tolist()
                conf = float(box.conf[0])

                f.write(f"{cls} {x:.6f} {y:.6f} {w:.6f} {h:.6f}\n")

                best_iou = 0
                for gt in gt_boxes:
                    if gt[0] == cls:
                        best_iou = max(best_iou, iou([cls, x, y, w, h], gt))

                label = 1 if best_iou >= IOU_Threshold else 0
                y_true.append(label)
                y_scores.append(conf)

        for r in results_pen:
            if not r.boxes:
                continue
            for box in r.boxes:
                cls_model = int(box.cls[0])
                cls = Pen_ID.get(cls_model, cls_model)

                x, y, w, h = box.xywhn[0].tolist()
                conf = float(box.conf[0])

                f.write(f"{cls} {x:.6f} {y:.6f} {w:.6f} {h:.6f}\n")

                best_iou = 0
                for gt in gt_boxes:
                    if gt[0] == cls:
                        best_iou = max(best_iou, iou([cls, x, y, w, h], gt))

                label = 1 if best_iou >= IOU_Threshold else 0
                y_true.append(label)
                y_scores.append(conf)

    saved = results_coco[0].plot(show = False)
    saved = results_pen[0].plot(img = saved, show = False)
    saved_path = os.path.join(Save_Dir, frame_name)

    cv2.imwrite(saved_path, saved) 
    cv2.imshow("Live Detection", saved)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    frame_id += 1

cap.release()
cv2.destroyAllWindows()

if len(set(y_true)) > 1:
    fpr, tpr, _ = roc_curve(y_true, y_scores)
    print(f"AU-ROC: {auc(fpr, tpr):.3f}")

    precision, recall, _ = precision_recall_curve(y_true, y_scores)
    print(f"AU-PR: {auc(recall, precision):.3f}")

    y_pred = (np.array(y_scores) >= CONF_Threshold).astype(int)
    print(f"F1: {f1_score(y_true, y_pred):.3f}")
