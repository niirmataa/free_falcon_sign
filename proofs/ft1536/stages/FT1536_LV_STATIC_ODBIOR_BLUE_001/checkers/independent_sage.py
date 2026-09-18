#!/usr/bin/env sage
"""Orthogonal exact Sage check; does not import RUN_001 checkers."""
import hashlib
import json
from pathlib import Path
import sys

from sage.all import GF, PolynomialRing

if len(sys.argv) != 2:
    raise SystemExit("usage: independent_sage.py INPUT_DIR")
base = Path(sys.argv[1])
N, q, B = 1536, 18433, 2093922385

def integers(path):
    out = [int(x) for x in path.read_text(encoding="ascii").split()]
    if len(out) != N:
        raise ValueError("vector length")
    return out

def decode_static(blob):
    if blob[0] != 0xAA:
        raise ValueError("header")
    bits = [(byte >> shift) & 1 for byte in blob[1:] for shift in range(7, -1, -1)]
    at = 0
    out = []
    for _ in range(N):
        sign = bits[at]
        at += 1
        low = sum(bits[at + j] << (7 - j) for j in range(8))
        at += 8
        high = 0
        while bits[at] == 0:
            high += 1
            at += 1
        at += 1
        if high > 255:
            raise ValueError("unary range")
        magnitude = low + 256 * high
        if magnitude >= 32768:
            raise ValueError("signed narrowing outside witness contract")
        out.append(-magnitude if sign else magnitude)
    if any(bits[at:]) or (at + 7) // 8 != len(blob) - 1:
        raise ValueError("padding or trailing data")
    return out

h = integers(base / "canonical_public_h.txt")
c = integers(base / "witness_c.txt")
payload = (base / "witness.bin").read_bytes()
s = decode_static(payload)
F = GF(q)
P = PolynomialRing(F, "X")
X = P.gen()
phi = X**1536 - X**768 + 1
hs_poly = (P(h) * P(s)).mod(phi)
hs = [int(hs_poly[i]) for i in range(N)]

def center(x):
    r = int(F(x))
    return r - q if r > q // 2 else r

z1 = [center(c[i] - hs[i]) for i in range(N)]
q0 = lambda v: sum(v[i]**2 + v[i]*v[i+768] + v[i+768]**2 for i in range(768))
first = int(q0(z1))
second = int(q0(s))
checks = {
    "payload": s == [-20000] + [0] * (N - 1),
    "challenge_spec": c == [int(F(8670 * x)) for x in h],
    "congruence": all(int(F(z1[i] + hs[i] - c[i])) == 0 for i in range(N)),
    "first_norm": first == 42658711057,
    "second_norm": second == 400000000,
    "full_norm": first + second == 43058711057,
    "not_short": first + second >= B,
}
out = {
    "schema": "DAYBREAK_INDEPENDENT_SAGE_V1",
    "sage_version": str(sys.version),
    "domain": "GF(18433)[X]/(X^1536-X^768+1)",
    "payload_sha256": hashlib.sha256(payload).hexdigest(),
    "ext_first_norm": first,
    "second_norm": second,
    "ext_norm": first + second,
    "excess": first + second - B,
    "checks": checks,
    "ok": all(checks.values()),
}
print(json.dumps(out, indent=2, sort_keys=True))
raise SystemExit(0 if out["ok"] else 1)
