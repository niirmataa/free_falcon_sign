#!/usr/bin/env sage
"""Read-only exact decoding and root-of-unity audit for used FFT3 twiddles."""

import json
import hashlib
import math
import re
import struct
import sys
from pathlib import Path

if str(3/2) != "3/2":
    raise SystemExit("T5_FAIL:SAGE_PREPARSER_SENTINEL")


def require(condition, code):
    if not condition:
        raise SystemExit("T5_FAIL:" + code)


def binary64_exact(word):
    sign = -1 if (word >> 63) else 1
    exponent = (word >> 52) & 0x7FF
    fraction = word & ((1 << 52) - 1)
    require(exponent not in (0x7FF,), "NONFINITE_TABLE_VALUE")
    if exponent == 0:
        return QQ(sign * fraction) * QQ(2)^(-1074)
    return QQ(sign * ((1 << 52) + fraction)) * QQ(2)^(ZZ(exponent) - 1023 - 52)


def parse_array(text, name):
    match = re.search(
        r"static const fpr " + re.escape(name) + r"\[\] = \{(.*?)\n\};",
        text,
        flags=re.S,
    )
    require(match is not None, "ARRAY_MISSING_" + name)
    pairs = []
    for left, right in re.findall(
        r"FPC\(0x([0-9a-fA-F]{16})ULL,\s*0x([0-9a-fA-F]{16})ULL\)",
        match.group(1),
    ):
        pairs.append((binary64_exact(int(left, 16)), binary64_exact(int(right, 16))))
    require(len(pairs) > 0, "ARRAY_EMPTY_" + name)
    return pairs


def parse_constant(text, name):
    match = re.search(
        r"static const fpr " + re.escape(name)
        + r" = 0x([0-9a-fA-F]{16})ULL;",
        text,
    )
    require(match is not None, "CONSTANT_MISSING_" + name)
    return binary64_exact(int(match.group(1), 16))


require(len(sys.argv) == 2, "REPO_ROOT_ARGUMENT")
root = Path(sys.argv[1]).resolve()
source = (root / "build/fpr-emulated.h").read_text(encoding="utf-8")
square = parse_array(source, "fpr_gm3_square")
cubic = parse_array(source, "fpr_gm3_cubic")
require(len(square) >= 384, "SQUARE_LENGTH")
require(len(cubic) >= 768, "CUBIC_LENGTH")

RBF = RealBallField(256)
pi = RBF.pi()
step = 2 * pi / 4608


def identify(value):
    re_q, im_q = value
    angle_float = math.atan2(float(im_q), float(re_q))
    exponent = int(round(angle_float * 4608 / (2 * math.pi))) % 4608
    target_re = (RBF(2) * pi * exponent / 4608).cos()
    target_im = (RBF(2) * pi * exponent / 4608).sin()
    delta_re = abs(RBF(re_q) - target_re)
    delta_im = abs(RBF(im_q) - target_im)
    require(delta_re < RBF(2)^(-50), "TWIDDLE_REAL_ERROR")
    require(delta_im < RBF(2)^(-50), "TWIDDLE_IMAG_ERROR")
    return int(exponent), max(delta_re, delta_im)


def bit_reverse(value, bits):
    value = int(value)
    result = 0
    for _ in range(int(bits)):
        result = (result << 1) | (value & 1)
        value >>= 1
    return result


square_used = []
for m in [2, 4, 8, 16, 32, 64, 128, 256]:
    square_used.extend(range(m, m + m // 2))
square_used = sorted(set(square_used))
cubic_used = list(range(512, 768))

max_delta = RBF(0)
sqrt3_over_2 = RBF(3).sqrt() / 2
constant_targets = {
    "fpr_W1R": RBF(1) / 2,
    "fpr_W1I": sqrt3_over_2,
    "fpr_W2R": -RBF(1) / 2,
    "fpr_W2I": sqrt3_over_2,
    "fpr_W4R": -RBF(1) / 2,
    "fpr_W4I": -sqrt3_over_2,
}
for name, target in constant_targets.items():
    delta = abs(RBF(parse_constant(source, name)) - target)
    require(delta < RBF(2)^(-50), "FIXED_CONSTANT_ERROR_" + name)
    max_delta = max(max_delta, delta)
square_exponents = {}
for index in square_used:
    exponent, delta = identify(square[index])
    square_exponents[str(index)] = exponent
    max_delta = max(max_delta, delta)
cubic_exponents = {}
for index in cubic_used:
    exponent, delta = identify(cubic[index])
    cubic_exponents[str(index)] = exponent
    max_delta = max(max_delta, delta)

for m in [2, 4, 8, 16, 32, 64, 128, 256]:
    bits = int(m).bit_length() - 2
    for j in range(int(m // 2)):
        expected = int(768 // m + (4608 // m) * bit_reverse(j, bits))
        require(square_exponents[str(int(m + j))] == expected,
                "SQUARE_EXPONENT_PATTERN")
for j in range(256):
    expected = int(1 + 6 * bit_reverse(j, 8))
    require(cubic_exponents[str(512 + j)] == expected,
            "CUBIC_EXPONENT_PATTERN")

square_map_bytes = json.dumps(
    square_exponents, sort_keys=True, separators=(",", ":")
).encode("ascii")
cubic_map_bytes = json.dumps(
    cubic_exponents, sort_keys=True, separators=(",", ":")
).encode("ascii")

out = {
    "schema": "FT1536_T5_FFT3_TWIDDLE_AUDIT_V1",
    "status": "PASS",
    "root_order": int(4608),
    "fixed_constant_count": len(constant_targets),
    "square_used_count": len(square_used),
    "cubic_used_count": len(cubic_used),
    "component_error_lt_2^-50": True,
    "max_component_error_RBF256": str(max_delta),
    "square_exponent_pattern": "768/m+(4608/m)*bit_reverse(j,log2(m/2))",
    "cubic_exponent_pattern": "1+6*bit_reverse(j,8)",
    "square_exponent_map_sha256": hashlib.sha256(square_map_bytes).hexdigest(),
    "cubic_exponent_map_sha256": hashlib.sha256(cubic_map_bytes).hexdigest(),
}
print(json.dumps(out, indent=int(2), sort_keys=True))
