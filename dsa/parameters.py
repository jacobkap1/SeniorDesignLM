import json
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.backends import default_backend
from sympy import isprime

# ---- Parameters ----
L = 2048  # p size
N = 256   # q size
OUT_FILE = f"dsa/dsa_params_{L}_{N}.json"

# ---- Generate DSA parameters ----
params = dsa.generate_parameters(
    key_size=L,
    backend=default_backend()
)

numbers = params.parameter_numbers()
p = numbers.p
q = numbers.q
g = numbers.g

# ---- Sanity checks ----
assert p.bit_length() == L
assert q.bit_length() == N
assert isprime(p)
assert isprime(q)
assert (p - 1) % q == 0
assert pow(g, q, p) == 1
assert g > 1

# ---- Generate key pair ----
private_key = params.generate_private_key()
priv_nums = private_key.private_numbers()
pub_nums = priv_nums.public_numbers

x = priv_nums.x  # private key
y = pub_nums.y  # public key

# ---- Helper: int -> fixed-width hex ----
def to_hex(x, bits):
    width = (bits + 3) // 4
    return format(x, f"0{width}x")

# ---- Build JSON structure ----
data = {
    "L": L,
    "N": N,
    "p": to_hex(p, L),
    "q": to_hex(q, N),
    "g": to_hex(g, L),
    "x": to_hex(x, N),
    "y": to_hex(y, L),
}

# ---- Write JSON ----
with open(OUT_FILE, "w") as f:
    json.dump(data, f, indent=2)

print(f"DSA parameters written to {OUT_FILE}")
