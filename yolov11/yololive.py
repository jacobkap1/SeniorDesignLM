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

#Iterate over each frame's detection results.
#Each element that is stored in the results variable corresponds to one video frame. 
#Displays YOLO's raw prediction data and a text file for each frame, with each row having the format: object class, x center, y center, x width, y height.
for frame_id, r in enumerate(results):
    
    #If no objects were detected in the video frame, skip it. 
    if r.boxes is None:
        continue
    #Print the current frame number. 
    print(f"\nFrame {frame_id}")


    #Loop through all the bounding boxes that are detected in the current frame. 
    for box in r.boxes:
        #Obtaining the predicted class ID for the detected object. 
        #Cls is an integer class ID, where the ID corresponds to a COCO dataset class, such as person or bicycle. 
        #x,y = center coordinates of the bounding box.
        #w,h = width and height of the bounding box.
        cls = int(box.cls[0])
        x, y, w, h = box.xywh[0].tolist() 

        #Print the detection in YOLO format
        #class ID, x center, y center, width, and height. 
        print(f"{cls}, {x:.3f}, {y:.3f}, {w:.3f}, {h:.3f}")
