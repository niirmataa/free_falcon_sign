#!/usr/bin/env python3
"""FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- extract pinned numeric constants.

Reads pinned bootstrap certificates and emits checks/constants_extract.json with
exact strings plus rounded floats for the composition ledger. Read-only inputs.
"""
import json, os
from fractions import Fraction

W = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
IN = os.path.join(W, "inputs", "bootstrap")
OUT = os.path.join(W, "checks", "constants_extract.json")

def load(rel):
    with open(os.path.join(IN, rel), "r", encoding="utf-8") as f:
        return json.load(f)

def walk(obj, path, out):
    """Collect scalar leaves with their key paths."""
    if isinstance(obj, dict):
        for k, v in obj.items():
            walk(v, path + [k], out)
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            walk(v, path + [str(i)], out)
    else:
        out.append((path, obj))

def fr(x):
    if isinstance(x, str) and ("/" in x or x.isdigit() or (x.startswith("-") and x[1:].isdigit())):
        try:
            return Fraction(x)
        except ValueError:
            return None
    return None

result = {}
targets = {
    "H6P/ERROR_LEDGER.json": None,
    "POST/artifacts/numeric_certificate.json": None,
    "TARGETS/INITIAL_TARGET_CERTIFICATE.json": None,
    "ROOT/ROOT_CERTIFICATE.json": None,
    "H6P/VARIANCE_BRIDGE.json": None,
    "POST/SOURCE_POSTPROCESSING_CERTIFICATE.json": None,
    "H6P/H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json": None,
    "JOINT/ORDERED_JOINT_CERTIFICATE.json": None,
}
for rel in targets:
    d = load(rel)
    leaves = []
    walk(d, [], leaves)
    sel = {}
    for path, val in leaves:
        key = ".".join(path)
        f = fr(val)
        if f is not None and f.denominator != 1:
            sel[key] = {"exact": str(val), "float": float(f)}
        elif isinstance(val, (int, float)) or isinstance(val, str):
            sel[key] = val
    result[rel] = sel

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, "w", encoding="utf-8") as f:
    json.dump(result, f, indent=1, sort_keys=True)

# Compact console view of the terms the composition needs.
want = [
    ("H6P/ERROR_LEDGER.json", ["terminal_source_sub_error", "terminal_half_error",
        "terminal_last_sub_error", "terminal_transport_error",
        "both_branch_reconstruction_delta", "root_CM_plus_sub_error",
        "actual_basis_a_lower", "actual_basis_a_upper",
        "orthogonal_residual_row_norm_squared_cap", "nonorthogonal_cross_cap",
        "joint_image_defect_energy", "graph_basis_coefficient_error",
        "post_CM_add_coefficient_error", "source_iFFT_error",
        "total_source_error_exact_outward", "total_source_error_integer_upper"]),
]
for rel, keys in want:
    for k in keys:
        v = result[rel].get(k)
        if isinstance(v, dict):
            print("%-46s %s   ~ %.12g" % (k, v["exact"][:60] + ("..." if len(v["exact"]) > 60 else ""), v["float"]))
        else:
            print("%-46s %r" % (k, v))

print()
print("== POST/artifacts/numeric_certificate.json ==")
for k, v in sorted(result["POST/artifacts/numeric_certificate.json"].items()):
    print("%-60s %s" % (k, (v["exact"] + "  ~ %.10g" % v["float"]) if isinstance(v, dict) else repr(v)[:90]))

print()
print("== TARGETS: fft/reciprocal/target error leaves ==")
for k, v in sorted(result["TARGETS/INITIAL_TARGET_CERTIFICATE.json"].items()):
    kl = k.lower()
    if any(w in kl for w in ("error", "recipro", "target", "fft_map", "component", "cap")):
        print("%-60s %s" % (k, (v["exact"] + "  ~ %.10g" % v["float"]) if isinstance(v, dict) else repr(v)[:90]))

print()
print("== ROOT constants/fft_map leaves ==")
for k, v in sorted(result["ROOT/ROOT_CERTIFICATE.json"].items()):
    kl = k.lower()
    if any(w in kl for w in ("constant", "fft_map", "error", "schur", "det", "gate", "a_min", "amin", "cap")):
        print("%-60s %s" % (k, (v["exact"] + "  ~ %.10g" % v["float"]) if isinstance(v, dict) else repr(v)[:90]))
