# Imports the YOLO class from the Ultralytics library, which contains the tools needed to load and run the YOLO models.
from ultralytics import YOLO

# Imports OpenCV.
import cv2 

# Loads a pretrained YOLO model.
# ("yolo11n.pt") is the model file, and the model variable now contains the neural network ready to make predictions.
model = YOLO("yolo11n.pt") 

#source = 0 is using the default webcam where object detection is ran.
#show = True displays a window showing webcam frames and bounding boxes.
#results will contain a list of prediction objects, including detected classes and bounding box coordinates.

results = model.predict(source="0", show=True) 

#Displays YOLO's raw prediction data in the terminal.
print(results)
