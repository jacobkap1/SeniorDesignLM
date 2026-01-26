from ultralytics import YOLO
import numpy as np
import cv2
from sklearn.metrics import roc_curve, auc, precision_recall_curve, f1_score

model = YOLO("yolo11n.pt")
results = model("cup.jpg")
img = cv2.imread("cup.jpg")
H, W, _ = img.shape

ground_truth = []
with open("cup.txt", "r") as f:
    for line in f:
        cls, x, y, w, h = map(float, line.split())

        x /= W
        y /= H
        w /= W
        h /= H

        ground_truth.append([int(cls), x, y, w, h])

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
IOU_THRESHOLD = 0.5


for r in results:
    if r.boxes is None:
        continue

    for box in r.boxes:
        cls = int(box.cls[0])
        x, y, w, h = box.xywhn[0].tolist()
        conf = float(box.conf[0])

        best_iou = 0
        for gt in ground_truth:
            if gt[0] == cls:
                best_iou = max(best_iou, iou([cls, x, y, w, h], gt))

        y_true.append(1 if best_iou >= IOU_THRESHOLD else 0)
        y_scores.append(conf)

for frame_id, r in enumerate(results):
    if r.boxes is None:
        continue

    print(f"\nFrame {frame_id}")

    for box in r.boxes:
        cls = int(box.cls[0])
        x, y, w, h = box.xywh[0].tolist() 
        print(f"{cls}, {x:.3f}, {y:.3f}, {w:.3f}, {h:.3f}")

fpr, tpr, _ = roc_curve(y_true, y_scores)
roc_auc = auc(fpr, tpr)

precision, recall, _ = precision_recall_curve(y_true, y_scores)
pr_auc = auc(recall, precision)

y_pred = (np.array(y_scores) >= 0.5).astype(int)
f1 = f1_score(y_true, y_pred)

print(f"AU-ROC: {roc_auc:.3f}")
print(f"AU-PR : {pr_auc:.3f}")
print(f"F1 Score  : {f1:.3f}")