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






# Larger model from train2
MODEL_TRAIN2  = r"C:\Users\jacob\SeniorDesignLM\yolov11\runs\detect\train2\weights\best.pt"

# Output path for the original FP32 ONNX model
ONNX_ORIGINAL = r"C:\Users\jacob\SeniorDesignLM\yolov11\runs\detect\train2\weights\best.onnx"

# Output path for the quantized INT8 ONNX model
#we want two paths to compare the quantization model to the original model, so we can see the difference in size and speed
ONNX_QUANT    = r"C:\Users\jacob\SeniorDesignLM\best_quantized.onnx"



# Exporting to ONNX
# Converts the trained PyTorch .pt model into ONNX format
print("\n[1/4] Exporting model to ONNX...")
model = YOLO(MODEL_TRAIN2)
model.export(format="onnx", simplify=True)

print(f"ONNX model saved to: {ONNX_ORIGINAL}")


#Quantize to INT8
print("\n[2/4] Quantizing model to INT8...")
quantize_dynamic(
    model_input=ONNX_ORIGINAL,
    model_output=ONNX_QUANT,
    weight_type=QuantType.QInt8
)
print(f"Quantized model saved to: {ONNX_QUANT}")


# Benchmark function that loads an ONNX model and measures inference speed over 50 runs
# Reports avg latency, P95 latency, FPS, and the model size
def benchmark(model_path, label, runs=50):
    sess = ort.InferenceSession(model_path, providers=["CPUExecutionProvider"])
    input_name  = sess.get_inputs()[0].name
   
    # image input simulating real inference
    dummy = np.random.rand(1, 3, 640, 640).astype(np.float32)

    # Trial runs to stabilize CPU before timing
    for _ in range(5):
        sess.run(None, {input_name: dummy})

    # Timed inference runs
    latencies = []
    for _ in range(runs):
        start = time.perf_counter()
        sess.run(None, {input_name: dummy})
        latencies.append((time.perf_counter() - start) * 1000)

    avg  = np.mean(latencies)
    p95  = np.percentile(latencies, 95)
    size = os.path.getsize(model_path) / (1024 ** 2)

    print(f"\n{'='*50}")
    print(f"  {label}")
    print(f"{'='*50}")
    print(f"  Model size   : {size:.2f} MB")
    print(f"  Avg latency  : {avg:.2f} ms")
    print(f"  P95 latency  : {p95:.2f} ms")
    print(f"  Throughput   : {1000/avg:.1f} FPS")

    return {"size": size, "avg": avg, "p95": p95, "fps": 1000/avg}


# Here we Run Benchmarks for the quantization model versus the normal model and compare
# Runs both models and prints a final side by side comparison
print("\n[3/4] Benchmarking original model...")
orig = benchmark(ONNX_ORIGINAL, "Original FP32 (train2/best.pt)")

print("\n[4/4] Benchmarking quantized model...")
quant = benchmark(ONNX_QUANT, "Quantized INT8 (train2/best.pt)")

print(f"\n{'='*50}")
print("  FINAL COMPARISON")
print(f"{'='*50}")
print(f"  Speed improvement : {orig['avg']/quant['avg']:.2f}x faster")
print(f"  Size reduction    : {(1 - quant['size']/orig['size'])*100:.1f}% smaller")
print(f"  Original FPS      : {orig['fps']:.1f}")
print(f"  Quantized FPS     : {quant['fps']:.1f}")