# Imports are used to load, export, quantize, run, and benchmark the YOLO model in ONNX format
# Ultralytics YOLO loads the trained .pt model and handles ONNX export format
from ultralytics import YOLO

# quantize_dynamic performs INT8 quantization on the ONNX model
# QuantType specifies the quantization type that we are running
from onnxruntime.quantization import quantize_dynamic, QuantType

# ONNX Runtime is responsible for loading and running ONNX models during benchmarking
import onnxruntime as ort

# Used to calculate benchmark statistics
import numpy as np

# Used to accurately time each inference run
import time

# Used to get model file sizes in bytes and convert to MB
import os

# Used to load and resize images from the dataset folders
from PIL import Image

# Used to find all images in a folder
from pathlib import Path


# Larger model from train2
MODEL_TRAIN2  = r"C:\Users\jacob\SeniorDesignLM\yolov11\runs\detect\train2\weights\best.pt"

# Output path for the original FP32 ONNX model
ONNX_ORIGINAL = r"C:\Users\jacob\SeniorDesignLM\yolov11\runs\detect\train2\weights\best.onnx"

# Output path for the quantized INT8 ONNX model
# we want two paths to compare the quantization model to the original model, so we can see the difference in size and speed
ONNX_QUANT    = r"C:\Users\jacob\SeniorDesignLM\best_quantized.onnx"

# Dataset A is used to benchmark the original FP32 model
DATASET_A     = r"C:\Users\jacob\SeniorDesignLM\yolov11\data\datasetA"

# Dataset B is used to benchmark the quantized INT8 model
DATASET_B     = r"C:\Users\jacob\SeniorDesignLM\yolov11\data\datasetB"


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
    paths = list(Path(folder).glob("*.jpg")) + list(Path(folder).glob("*.png"))
    for p in paths:
        img = Image.open(p).convert("RGB").resize((640, 640))
        arr = np.array(img).astype(np.float32) / 255.0
        arr = arr.transpose(2, 0, 1)       
        arr = np.expand_dims(arr, axis=0)
        images.append(arr)
    print(f"  Loaded {len(images)} images from {folder}")
    return images


# Benchmark function that loads an ONNX model and measures inference speed over real images
# Reports avg latency, P95 latency, FPS, and the model size
def benchmark(model_path, label, images):
    sess = ort.InferenceSession(model_path, providers=["CPUExecutionProvider"])
    input_name = sess.get_inputs()[0].name

    # Trial runs to stabilize CPU before timing
    for img in images:
        sess.run(None, {input_name: img})

    # Timed inference runs on real images
    latencies = []
    for img in images:
        start = time.perf_counter()
        sess.run(None, {input_name: img})
        latencies.append((time.perf_counter() - start) * 1000)

    avg  = np.mean(latencies)
    p95  = np.percentile(latencies, 95)
    size = os.path.getsize(model_path) / (1024 ** 2)

    print(f"\n{'='*50}")
    print(f"  {label}")
    print(f"{'='*50}")
    print(f"  Model size   : {size:.2f} MB")
    print(f"  Images tested: {len(images)}")
    print(f"  Avg latency  : {avg:.2f} ms")
    print(f"  P95 latency  : {p95:.2f} ms")
    print(f"  Throughput   : {1000/avg:.1f} FPS")

    return {"size": size, "avg": avg, "p95": p95, "fps": 1000/avg}


# Here we Run Benchmarks for the quantization model versus the normal model and compare
# Runs both models and prints a final side by side comparison
print("\n[3/4] Benchmarking original FP32 model on Dataset A...")
images_a = load_images(DATASET_A)
orig = benchmark(ONNX_ORIGINAL, "Original FP32 - Dataset A", images_a)

print("\n[4/4] Benchmarking quantized INT8 model on Dataset B...")
images_b = load_images(DATASET_B)
quant = benchmark(ONNX_QUANT, "Quantized INT8 - Dataset B", images_b)

print(f"\n{'='*50}")
print("  FINAL COMPARISON")
print(f"{'='*50}")
print(f"  Speed improvement : {orig['avg']/quant['avg']:.2f}x faster")
print(f"  Size reduction    : {(1 - quant['size']/orig['size'])*100:.1f}% smaller")
print(f"  Original FPS      : {orig['fps']:.1f}")
print(f"  Quantized FPS     : {quant['fps']:.1f}")