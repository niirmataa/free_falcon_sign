#!/usr/bin/env python3
"""Independent exact-Fraction nearest-even oracle for the fpr_rint slice runs.

Parses harness output ("HEXWORD RESULT" lines), decodes IEEE764-binary64 words
exactly as dyadic rationals, computes nearest-even rint independently (Fraction
arithmetic, symmetric tie handling), and reports mismatches.
"""
import json, os, sys
from fractions import Fraction as F

def decode(u):
    """Exact value of a binary64-shaped raw word (fpr-emulated model):
    sign/8-bit... 11-bit exponent, 52-bit mantissa; supports zero, subnormal,
    normal; rejects inf/nan encodings (out of the proved domain)."""
    s = -1 if (u >> 63) & 1 else 1
    ex = (u >> 52) & 0x7FF
    frac = u & ((1 << 52) - 1)
    if ex == 0x7FF:
        return None  # out of domain (guarded by the harness preflight)
    if ex == 0:
        val = F(frac, 1 << 52)  # subnormal: 0.frac * 2^-1022
        return s * val * F(2) ** -1022
    val = F((1 << 52) | frac, 1 << 52)
    return s * val * F(2) ** (ex - 1023)

def nearest_even(t):
    n, d = t.numerator, t.denominator
    q, r = divmod(n, d)
    if 2 * r > d or (2 * r == d and (q % 2 == 1)):
        q += 1
    return q

def main(paths):
    total = mismatch = skipped_lines = 0
    cases = []
    for p in paths:
        with open(p) as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("SUMMARY"):
                    continue
                hx, res = line.split()
                u = int(hx, 16)
                got = int(res)
                v = decode(u)
                if v is None:
                    skipped_lines += 1
                    continue
                want = nearest_even(v)
                total += 1
                if got != want:
                    mismatch += 1
                    if len(cases) < 10:
                        cases.append({"word": hx, "value": str(v), "got": got, "want": want})
    out = {
        "schema": "ft1536.reference_integer_recovery.rint_slice_oracle/1",
        "runs": paths,
        "cases_checked": total,
        "out_of_domain_lines": skipped_lines,
        "mismatches": mismatch,
        "mismatch_head": cases,
        "pass": mismatch == 0 and total > 0,
    }
    print(json.dumps(out, indent=1))
    return 0 if out["pass"] else 1

if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
