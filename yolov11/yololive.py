# Imports the YOLO class from the Ultralytics library, which contains the tools needed to load and run the YOLO models.
from ultralytics import YOLO

# Imports OpenCV.
import cv2 

# Loads a pretrained YOLO model.
# ("yolo11n.pt") is the model file, and the model variable now contains the neural network ready to make predictions.
model = YOLO("yolo11n.pt") 

#source = 0 is using the default webcam where object detection is ran.
#show = True displays a window showing webcam frames and bounding boxes.
#conf = 0.5 is showing a confidence threshold of at least 50%. 
#results will contain a list of prediction objects, including detected classes and bounding box coordinates.

results = model.predict(source="0", conf=0.5, show=True) 

#Displays YOLO's raw prediction data and a text file for each frame, with each row having the format: object class, x center, y center, x width, y width.
for frame_id, r in enumerate(results):
    if r.boxes is None:
        continue

    print(f"\nFrame {frame_id}")

    for box in r.boxes:
        cls = int(box.cls[0])
        x, y, w, h = box.xywh[0].tolist() 

        print(f"{cls}, {x:.3f}, {y:.3f}, {w:.3f}, {h:.3f}")
