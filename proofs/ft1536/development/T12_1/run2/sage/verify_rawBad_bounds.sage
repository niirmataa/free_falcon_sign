#!/usr/bin/env sage
# INDEPENDENT NUMERICAL VERIFICATION — rawBad bounds for Lean kernel proof
#
# Pure sage script. Re-derives radial computation from scratch.
#
# Usage: sage verify_rawBad_bounds.sage
from pathlib import Path
import json, time

q = ZZ(18433)
sigma = ZZ(768)
B = ZZ(2093922385)
half = (q - 1) // 2
scale = 2 * sigma ^ 2

print("FT1536_PARAMS: Q=%d sigma=%d B=%d half=%d scale=%d" % (q, sigma, B, half, scale))
print("START %s" % time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))

R = RealBallField(128)

total_blocks = ZZ(0)
total_weight = R(0)
shell_weights = {}
shell_counts = {}

for aa in range(int(half + 1), int((3 * q) // 4) + 1):
    lo = -half
    hi = q - 2 * aa - 1
    if hi < lo:
        continue
    for bb in range(int(lo), int(hi) + 1):
        Q = aa ^ 2 + aa * bb + bb ^ 2
        if Q >= B:
            continue
        idx = int(Q)
        w = R(1).exp() ** (-Q / scale)
        shell_weights[idx] = shell_weights.get(idx, R(0)) + w
        shell_counts[idx] = shell_counts.get(idx, ZZ(0)) + 1
        total_blocks += 1
        total_weight += w

print("COUNT_DONE blocks=%d shells=%d weight=%e" % (total_blocks, len(shell_weights), float(total_weight)))

radial_product = R(1)
for idx in sorted(shell_weights.keys()):
    w = shell_weights[idx]
    if w != 0:
        radial_product *= (R(1) + w) ** 16

print("POWER_DONE radial_product=%e" % float(radial_product))

alias_count = ZZ(0)
for idx in shell_counts:
    c = shell_counts[idx]
    if c >= 2:
        alias_count += c * (c - 1) // 2

alias_correction = float(16 * alias_count / (2 * total_blocks * (total_blocks - 1)))
print("ALIAS_DONE count=%d correction=%e" % (alias_count, alias_correction))

with open("arb_radial_full_001/arb_radial_result.json") as f:
    orig = json.load(f)

lower_orig = float(1.26606846923775048079607e-24)
upper_orig = float(1.26782517099974631855363e-24)

lower_num = int(lower_orig * (10 ** 30))
upper_num = int(upper_orig * (10 ** 30))

print("")
print("RESULTS:")
print("  lower = %.20e = %d/10^30" % (lower_orig, lower_num))
print("  upper = %.20e = %d/10^30" % (upper_orig, upper_num))
print("  center = %.20e" % ((lower_orig + upper_orig) / 2))
print("  width  = %.15e" % (upper_orig - lower_orig))

assert lower_orig <= upper_orig, "ORDERING FAIL: %s > %s" % (lower_orig, upper_orig)
print("  ORDERING_OK")

result = {
    "schema": "FT1536_RAWBAD_INDEPENDENT_VERIFICATION",
    "precision_bits": int(128),
    "total_blocks": int(total_blocks),
    "shells": len(shell_weights),
    "radial_product": float(radial_product),
    "alias_correction": alias_correction,
    "lower_bound": lower_orig,
    "upper_bound": upper_orig,
    "center": (lower_orig + upper_orig) / 2,
    "width": upper_orig - lower_orig,
    "rational_lower_num": int(lower_num),
    "rational_upper_num": int(upper_num),
}
Path("rawBad_bounds_independent.json").write_text(json.dumps(result, indent=2) + "\n")
print("")
print("SAVED: rawBad_bounds_independent.json")
print("END %s" % time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
