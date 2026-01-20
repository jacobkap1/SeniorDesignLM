import json
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric.utils import (
    decode_dss_signature
)

# ---- Files ----
PARAM_FILE = "dsa/dsa_params_2048_256.json"
OUT_FILE   = "dsa/dsa_signature.json"

# ---- Load parameters ----
with open(PARAM_FILE, "r") as f:
    params = json.load(f)

L = params["L"]
N = params["N"]

p = int(params["p"], 16)
q = int(params["q"], 16)
g = int(params["g"], 16)
x = int(params["x"], 16)  # private key
y = int(params["y"], 16)

# ---- Construct DSA objects ----
param_numbers = dsa.DSAParameterNumbers(p, q, g)
public_numbers = dsa.DSAPublicNumbers(y, param_numbers)
private_numbers = dsa.DSAPrivateNumbers(x, public_numbers)

private_key = private_numbers.private_key(default_backend())

# ---- User message ----
message = input("Enter message to sign: ").encode()

# ---- Hash (SHA-256 required for N=256) ----
hash = hashes.Hash(hashes.SHA256(), backend=default_backend())
hash.update(message)
hash_bytes = hash.finalize()
hash_int = int.from_bytes(hash_bytes, "big")

# ---- Sign ----
signature = private_key.sign(
    message,
    hashes.SHA256()
)

# ---- Decode (r, s) ----
r, s = decode_dss_signature(signature)

# ---- Helper: int -> fixed-width hex ----
def to_hex(x, bits):
    width = (bits + 3) // 4
    return format(x, f"0{width}x")

# ---- Output JSON ----
out = {
    "message": message.decode(errors="replace"),
    "hash": to_hex(hash_int, N),
    "r": to_hex(r, N),
    "s": to_hex(s, N)
}

with open(OUT_FILE, "w") as f:
    json.dump(out, f, indent=2)

print(f"Signature written to {OUT_FILE}")
