#!/usr/bin/env python3
"""Hostile envelope for the comparative checkpoint (b1-style sensitivity).

Sweeps the modeling choices that the review flagged as fragile and records
the resulting block-size range per scheme/attack -- worst case first:

  H1  margin tau in {1.075 (pinned), 1.1 (Falcon v1.2), 1.2 (legacy)}
  H2  sigma variants for FT768/FT3072 (fixed width vs sqrtN-scaled)
  H3  A2 metric transport on/off for the forgery rows (the off-variant is the
      withdrawn Euclidean proxy -- kept ONLY as a hostile sensitivity row)

Output: artifacts/hostile_envelope.json/.csv. Pure Decimal arithmetic.
"""
import csv
import json
import math
import os
from decimal import Decimal, ROUND_FLOOR, getcontext

getcontext().prec = 110
D = Decimal
PI = D("3.141592653589793238462643383279502884197169399375105820974944592307"
      "81640628620899862803482534211706798214808651328230664709384460955058")
E = D(1).exp()

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.dirname(HERE)
ART = os.path.join(W, "artifacts")

Q = 18433
NS = [768, 1536, 3072]
TAUS = [("1.075_pinned", D(43) / D(40)), ("1.1_falcon_v1.2", D("1.1")),
        ("1.2_legacy", D("1.2"))]
SIGMAS = [("fixed_width", lambda N: D(768)),
          ("sqrtN_scaled", lambda N: D(768) * (D(N) / D(1536)).sqrt())]


def solve_forgery(n, root_det, radius):
    target = D(radius).ln()
    for block in range(100, 2 * n + 2):
        b = D(block)
        lhs = D(n) / b * (b / (D(2) * PI * E)).ln() + D(root_det).ln()
        if lhs <= target:
            return block
    raise RuntimeError("block not found")


def main():
    import sys
    sys.path.insert(0, os.path.join(W, "scripts"))
    from build_binding import load_build
    build = load_build(W)
    q = build["q"]
    rows = []
    root_a2 = (D(q) * (D(3) / D(4)).sqrt()).sqrt()   # (3/4)^(1/4) * sqrt(q)
    root_eucl = D(q).sqrt()
    for N in NS:
        for sname, sf in SIGMAS:
            sigma = sf(N)
            for tname, tau in TAUS:
                B = int((tau * tau * 2 * N * sigma * sigma)
                        .to_integral_value(rounding=ROUND_FLOOR))
                radius = (D(B - 1)).sqrt()
                for mname, root in (("A2_transport", root_a2),
                                    ("euclidean_proxy_withdrawn", root_eucl)):
                    beta = solve_forgery(N, root, radius)
                    rows.append({
                        "N": N, "sigma_variant": sname, "tau": tname,
                        "metric": mname, "B": B,
                        "block": beta,
                        "status": ("WITHDRAWN_SENSITIVITY_ONLY"
                                   if "euclidean" in mname else
                                   "SENSITIVITY"),
                    })
                print("N=%4d %-13s %-15s B=%12d beta_A2=%4d beta_eucl=%4d"
                      % (N, sname, tname, B, rows[-2]["block"],
                         rows[-1]["block"]), flush=True)
    os.makedirs(ART, exist_ok=True)
    with open(os.path.join(ART, "hostile_envelope.json"), "w") as f:
        json.dump({"schema": "FT_FAMILY_HOSTILE_ENVELOPE_V1",
                   "rows": rows}, f, indent=2, sort_keys=True)
    with open(os.path.join(ART, "hostile_envelope.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
