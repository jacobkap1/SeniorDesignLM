# Imports the YOLO class from the Ultralytics library, which contains the tools needed to load and run the YOLO models.
from ultralytics import YOLO
# Loads the model and runs inference on the input image.
# This returns a list of YOLO prediction results.
model = YOLO("yolo11n.pt")
results = model("thanks.jpg")
# Loop to iterate over each property returned in the results for the input image.
for result in results:
    boxes = result.boxes   # bounding boxes: give the location and size of an object in the image.
    masks = result.masks   # segmentation masks: identify exact pixels that belong to an object.
    keypoints = result.keypoints # keypoints: represent specific landmark positions on an object.
    probs = result.probs # classification probabilities: represent the model’s confidence for every possible class it can predict.
    obb = result.obb     # oriented bounding boxes: rotated bounding boxes that can tilt or angle and can follow the actual angle of the object.
    
    # Saves the prediction image.
    result.save(filename="result2.jpg")
