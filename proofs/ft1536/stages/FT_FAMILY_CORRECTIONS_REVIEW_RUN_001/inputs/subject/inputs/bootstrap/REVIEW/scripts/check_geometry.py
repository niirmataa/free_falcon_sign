#!/usr/bin/env python3
"""FT family: geometry and metric transport (deterministic computations).

Checks:
  G1  Verify bound: floor((1.075)^2 * 2N * 768^2) == 2093922385 (exact rational),
      and 2N*768^2 == 1811939328 (the margin-less expectation the withdrawn
      table used as B).
  G2  raw iid ternary secrets: E||f||_2^2 = 2N/3 (coeff metric) exactly;
      E||(g,-f)||^2 = 4N/3.
  G3  metric transport: Q_A2 metric Gram det = (3/4)^N on the 2N-dim
      (z1,z2) space; volume scaling sqrt(det) = (3/4)^(N/2);
      det^(1/2N) = (3/4)^(1/4) * sqrt(q).
  G4  Gaussian heuristic under BOTH conventions:
        exact:   GH = Gamma(d/2+1)^(1/d)/sqrt(pi) * det^(1/d)
        asym:    GH = sqrt(d/(2 pi e)) * det^(1/d)
      for the coefficient metric and the Q_A2 metric, for the three N.
  G5  RMS/GH ratios for the raw-ternary key vector (g,-f) and single f;
      asymptotic constants sqrt(4 pi e/(3 q)) and sqrt(2 pi e/(3 q)).
  G6  scaling of GH at fixed q: GH(2N)/GH(N) -> sqrt(2); log GH = (1/2) log N + c.

Output: results/geometry.json and results/geometry.csv.
"""
import csv
import json
import math
import os
from decimal import Decimal, getcontext
from fractions import Fraction

Q = 18433
SIGMA = 768
MARGIN = Fraction(43, 40)  # 1.075, exact
NS = [768, 1536, 3072]

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "results")
os.makedirs(OUT, exist_ok=True)
getcontext().prec = 50


def lgamma(x):
    return math.lgamma(x)


def gh_exact(d, det_root):
    """Gamma(d/2+1)^(1/d)/sqrt(pi) * det^(1/d), with det^(1/d) given."""
    return math.exp(lgamma(d / 2 + 1) / d) / math.sqrt(math.pi) * det_root


def gh_asym(d, det_root):
    return math.sqrt(d / (2 * math.pi * math.e)) * det_root


def main():
    rep = {}
    rows = []
    out = []

    def log(s):
        print(s)
        out.append(s)

    log("=== check_geometry.py ===")

    # G1
    for N in (1536,):
        b = (MARGIN * MARGIN * 2 * N * SIGMA * SIGMA)
        bound = b.numerator // b.denominator
        plain = 2 * N * SIGMA * SIGMA
        log(f"G1  floor(1.075^2 * 2N * sigma^2) = {bound} (expect 2093922385)"
            f"  |  2N*sigma^2 = {plain} (expect 1811939328)")
        rep["G1"] = {"N": N, "sigma": SIGMA,
                     "bound_floor": bound, "matches_pinned": bound == 2093922385,
                     "margin_less_2N_sigma2": plain,
                     "matches_withdrawn": plain == 1811939328,
                     "exact_margin_squared": str(MARGIN * MARGIN)}

    # G2
    for N in NS:
        e_f = Fraction(2 * N, 3)
        e_key = Fraction(4 * N, 3)
        log(f"G2  N={N}: E||f||^2 = {e_f} (=2N/3), E||(g,-f)||^2 = {e_key}"
            f" (=4N/3) for raw iid ternary")
    rep["G2"] = {"formula_f": "2N/3", "formula_key": "4N/3"}

    e = Decimal(math.e)
    pi = Decimal(str(math.pi))

    for N in NS:
        d = 2 * N
        coeff_root = math.sqrt(Q)                    # det_coeff^(1/d)
        det_qa2_f = (3.0 / 4.0) ** 0.25 * coeff_root  # det_Q_A2^(1/d)

        gh_c_e = gh_exact(d, coeff_root)
        gh_c_a = gh_asym(d, coeff_root)
        gh_q_e = gh_exact(d, det_qa2_f)
        gh_q_a = gh_asym(d, det_qa2_f)

        rms_key = math.sqrt(4 * N / 3)      # raw ternary key vector, coeff metric
        rms_f = math.sqrt(2 * N / 3)

        # Q_A2-metric RMS of the raw key vector (expected value is the same)
        rms_key_q = math.sqrt(4 * N / 3)

        row = {
            "N": N, "d": d,
            "det_coeff_root": coeff_root,
            "det_qa2_root": det_qa2_f,
            "det_transport_factor": (3.0 / 4.0) ** 0.25,
            "gh_coeff_exact": gh_c_e, "gh_coeff_asym": gh_c_a,
            "gh_qa2_exact": gh_q_e, "gh_qa2_asym": gh_q_a,
            "rms_key_coeff": rms_key, "rms_f_coeff": rms_f,
            "rms_key_over_gh_coeff": rms_key / gh_c_e,
            "rms_f_over_gh_coeff": rms_f / gh_c_e,
            "rms_key_over_gh_qa2": rms_key_q / gh_q_e,
        }
        rows.append(row)
        log(f"G3-G5  N={N}: det^(1/d) coeff = {coeff_root:.6f},"
            f" Q_A2 = {det_qa2_f:.6f};")
        log(f"        GH exact (coeff) = {gh_c_e:.6f}, asym = {gh_c_a:.6f};"
            f"  Q_A2: {gh_q_e:.6f} / {gh_q_a:.6f}")
        log(f"        RMS(key)/GH = {row['rms_key_over_gh_coeff']:.10f} (coeff),"
            f" {row['rms_key_over_gh_qa2']:.10f} (Q_A2);"
            f" RMS(f)/GH = {row['rms_f_over_gh_coeff']:.10f}")

    # asymptotic constants
    c_key = math.sqrt(4 * math.pi * math.e / (3 * Q))
    c_f = math.sqrt(2 * math.pi * math.e / (3 * Q))
    log(f"G5  asymptotic constants: sqrt(4 pi e/(3q)) = {c_key:.10f}"
        f"  (review: 0.0248538421)")
    log(f"                            sqrt(2 pi e/(3q)) = {c_f:.10f}"
        f"  (review: 0.0176)")
    rep["G5"] = {"asym_key_ratio": c_key, "asym_f_ratio": c_f}

    # G6 scaling
    for i in range(len(rows) - 1):
        r1, r2 = rows[i], rows[i + 1]
        log(f"G6  GH(2N)/GH(N) at N={r1['N']} -> {r2['N']}:"
            f" exact {r2['gh_coeff_exact'] / r1['gh_coeff_exact']:.6f},"
            f" asym {r2['gh_coeff_asym'] / r1['gh_coeff_asym']:.6f}"
            f"  (sqrt2 = {math.sqrt(2):.6f})")
    rep["G6"] = {"note": "GH proportional to sqrt(N) at fixed q;"
                          " log GH = (1/2) log N + c"}

    rep["rows"] = rows

    with open(os.path.join(OUT, "geometry.json"), "w") as f:
        json.dump(rep, f, indent=2, sort_keys=True)
    with open(os.path.join(OUT, "geometry.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    log(f"Wrote geometry.json and geometry.csv")


if __name__ == "__main__":
    main()
