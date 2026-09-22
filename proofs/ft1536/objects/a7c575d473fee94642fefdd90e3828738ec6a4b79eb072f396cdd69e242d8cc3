#!/usr/bin/env python3
"""FT family: archaeology of the falcon_is_short() candidate bound table.

Source (Extra/c/falcon-enc.c, falcon_is_short, ternary branch):
  per-logn squared-norm bounds for logn = 3..10, with the source comment
  "floor(1.075^2 * 2*N * 768^2). SIG-001 and the final norm/security
  selection remain open." Only the logn = 10 value is a #define
  (FALCON_FT1536_NORM_BOUND2 = 2093922385).

This script records, with exact rational arithmetic:
  B1  the logn = 10 value equals floor((43/40)^2 * 2N * 768^2).
  B2  for logn = 3..9 (and the historical May-2026 value 160982450 at
      logn = 10) the ratio bound/(2N) is a near-arithmetic sequence in logn;
      exact differences are recorded. No closed formula is claimed: the
      derivation of these candidate bounds is NOT present in the pinned
      sources and is reported as OPEN (SIG-001).
  B3  the implied sigma values under the 1.075-margin convention.

Output: results/bounds_table.json.
"""
import json
import os
from decimal import Decimal, getcontext
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "results")
os.makedirs(OUT, exist_ok=True)
getcontext().prec = 40

BOUNDS = {3: 987497, 4: 2052189, 5: 4258765, 6: 8826305,
          7: 18270159, 8: 37775417, 9: 78021029, 10: 2093922385}
MAY_2026_BOUND2 = 160982450  # TERNARY1536_WORKFLOW.md, logn = 10 era


def main():
    rep = {}
    print("=== check_bounds_table.py ===")

    N = lambda k: 3 << (k - 1)

    # B1
    b = (Fraction(43, 40) ** 2) * 2 * N(10) * 768 * 768
    floor_b = b.numerator // b.denominator
    print(f"B1  floor((43/40)^2 * 2N * 768^2) = {floor_b};"
          f" source value = {BOUNDS[10]}; equal = {floor_b == BOUNDS[10]}")
    rep["B1"] = {"computed": floor_b, "source": BOUNDS[10],
                 "equal": floor_b == BOUNDS[10]}

    rows = []
    prev = None
    for k in sorted(BOUNDS):
        r = Fraction(BOUNDS[k], 2 * N(k))
        imp_sigma2 = r / (Fraction(43, 40) ** 2)
        row = {
            "logn": k, "N": N(k), "bound": BOUNDS[k],
            "bound_over_2N": str(r),
            "implied_sigma2_margin1075": str(imp_sigma2),
            "implied_sigma_margin1075": float(Decimal(imp_sigma2.numerator) /
                                              Decimal(imp_sigma2.denominator)) ** 0.5,
        }
        if prev is not None:
            row["delta_bound_over_2N"] = str(r - prev)
        prev = r
        rows.append(row)
        delta_s = f"  delta = {float(r - Fraction(rows[-2]['bound_over_2N'])):10.4f}" \
            if len(rows) > 1 else ""
        print(f"    logn={k:2d} N={N(k):5d} bound/(2N) = {float(r):14.4f}{delta_s}")

    # B2: historical May-2026 value
    r_may = Fraction(MAY_2026_BOUND2, 2 * N(10))
    r9 = Fraction(BOUNDS[9], 2 * N(9))
    r8 = Fraction(BOUNDS[8], 2 * N(8))
    step = r9 - r8
    extrap10 = r9 + step
    print(f"B2  May-2026 bound2 = {MAY_2026_BOUND2}: bound/(2N) ="
          f" {float(r_may):.4f}; step(r9-r8) = {float(step):.4f};"
          f" r9+step = {float(extrap10):.4f};"
          f" match = {extrap10 == r_may} (exact) /"
          f" {abs(float(extrap10 - r_may)) < 1.0} (within 1.0)")
    rep["B2"] = {
        "may_2026_bound": MAY_2026_BOUND2,
        "may_bound_over_2N": str(r_may),
        "step_r8_r9": str(step),
        "extrapolated_r10": str(extrap10),
        "exact_match": extrap10 == r_may,
        "abs_diff": float(abs(extrap10 - r_may)),
        "status": "OPEN_SIG-001: no derivation in pinned sources",
    }

    rep["rows"] = rows
    with open(os.path.join(OUT, "bounds_table.json"), "w") as f:
        json.dump(rep, f, indent=2, sort_keys=True)
    print("Wrote bounds_table.json")


if __name__ == "__main__":
    main()
