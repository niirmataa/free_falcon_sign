# FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- independent exact nearest-even
# oracle for the fpr_rint source slices (Sage exact arithmetic).
# Run:  sage checks/sage/rint_oracle.sage   (cwd = W root)
# Reads checks/c_slice/out_{normal,asan,ubsan}.txt ("HEXWORD RESULT" lines),
# decodes IEEE764-binary64-shaped words as exact dyadic values, computes
# nearest-even rint independently (sign+magnitude, ties to even) and reports
# mismatches to checks/c_slice/oracle_result.json.

# preparser/toolchain preflight (principle doc 2026-09-22); not a goal proof
assert parent(1) is ZZ
assert parent(1 / 3) is QQ
assert 2 ^ 10 == 1024

import json
from sage.all import ZZ, QQ, RR

def decode(uu):
    """exact value of a binary64-shaped raw word; None for inf/nan (out of domain)"""
    s = -1 if (uu >> 63) & 1 else 1
    ex = (uu >> 52) & 0x7FF
    frac = uu & ((ZZ(1) << 52) - 1)
    if ex == 0x7FF:
        return None
    if ex == 0:
        val = (frac / (ZZ(1) << 52)) * QQ(2) ** -1022
    else:
        val = (((ZZ(1) << 52) + frac) / (ZZ(1) << 52)) * QQ(2) ** (ZZ(ex) - 1023)
    return s * val

def nearest_even(val):
    num, den = val.numerator(), val.denominator()
    neg = num < 0
    aa = -num if neg else num
    qq, rr = divmod(ZZ(aa), ZZ(den))
    if 2 * rr > den or (2 * rr == den and (ZZ(qq) % 2 == 1)):
        qq += 1
    return -qq if neg else qq

paths = ["checks/c_slice/out_normal.txt", "checks/c_slice/out_asan.txt",
         "checks/c_slice/out_ubsan.txt"]
total = mismatch = skipped = 0
cases = []
for p in paths:
    for line in open(p):
        line = line.strip()
        if not line or line.startswith("SUMMARY"):
            continue
        hx, res = line.split()
        u = ZZ(int(hx, 16))
        got = ZZ(res)
        val = decode(u)
        if val is None:
            skipped += 1
            continue
        want = nearest_even(val)
        total += 1
        if got != want:
            mismatch += 1
            if len(cases) < 10:
                cases.append({"word": hx, "value": str(val), "got": int(got),
                              "want": int(want)})
out = {
    "schema": "ft1536.reference_integer_recovery.rint_slice_oracle/1",
    "engine": "sage-10.9 (sage checks/sage/rint_oracle.sage; preparser on)",
    "runs": paths,
    "cases_checked": int(total),
    "out_of_domain_lines": int(skipped),
    "mismatches": int(mismatch),
    "mismatch_head": cases,
    "pass": bool(mismatch == 0 and total > 0),
}
with open("checks/c_slice/oracle_result.json", "w") as fh:
    json.dump(out, fh, indent=1, sort_keys=True)
print(json.dumps(out, indent=1, sort_keys=True))
if not out["pass"]:
    raise SystemExit(1)
