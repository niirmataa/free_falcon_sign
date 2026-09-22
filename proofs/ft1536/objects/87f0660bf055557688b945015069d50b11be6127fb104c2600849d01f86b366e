# Homogeneous SIS controls -- REJECTED rows (kept as documented negative data).
#
# The P2 forgery problem is the INHOMOGENEOUS target-coset problem
# `u + h*v = c` with `Q < B_N` (ATTACK_PROBLEMS.md Sec.2). Generic homogeneous
# SIS (`A z = 0`) is NOT that problem: for FT1536 the Euclidean radius
# sqrt(B-1) exceeds q, so trivial kernel vectors q*e_i solve A z = 0 but not
# A z = c. These rows are therefore recorded and explicitly REJECTED from any
# forgery minimum (review R4 kept this discipline in the definitions; this
# script generates the control data, it does not feed P2).
#
# Replay:  sage scripts/sis_models.sage   (plain Python, no preparser)

import json
import os
import sys
import time
import traceback

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(W, "inputs", "tools", "vendor",
                                "lattice-estimator"))

from estimator import SIS  # noqa: E402
from estimator.sis_parameters import SISParameters  # noqa: E402
from estimator.reduction import ADPS16, BDGL16, MATZOV  # noqa: E402

ART = os.path.join(W, "artifacts")
OUT = os.path.join(ART, "sis_controls.json")

Q = 18433
VARIANTS = {
    "FT768": [(768, "V_A_fixed_width"), (768, "V_B_sqrtN_scaled")],
    "FT1536": [(1536, "PINNED")],
    "FT3072": [(3072, "V_A_fixed_width"), (3072, "V_B_sqrtN_scaled")],
}
BOUNDS = {
    ("FT1536", "PINNED"): 2093922385,
}


def ft_bound(N, sigma):
    return (43 * 43 * 2 * N * sigma * sigma) // (1600 * 1)


def sigma_for(N, vname):
    import math
    if vname == "V_B_sqrtN_scaled":
        return 768 * math.sqrt(N / 1536)
    return 768


def ser(cost):
    out = {}
    for k, v in cost.items():
        try:
            out[k] = float(v)
        except Exception:
            out[k] = str(v)
    return out


def main():
    os.makedirs(ART, exist_ok=True)
    sys.path.insert(0, os.path.join(W, "scripts"))
    from build_binding import load_build
    build = load_build(W)
    global Q, BOUNDS
    Q = build["q"]
    BOUNDS = {("FT1536", "PINNED"): build["B"]}
    rows = []
    for tag, variants in VARIANTS.items():
        for N, vname in variants:
            key = (tag, vname)
            if key in BOUNDS:
                B = BOUNDS[key]
            else:
                sigma = sigma_for(N, vname)
                s2 = int(round(sigma * sigma)) if abs(
                    sigma - round(sigma)) < 1e-9 else None
                B = (43 * 43 * 2 * N * int(round(sigma)) ** 2) // 1600 \
                    if s2 is None else (43 * 43 * 2 * N * s2) // 1600
            radius = (B - 1) ** 0.5
            params = SISParameters(n=N, q=Q, length_bound=radius, m=2 * N,
                                   norm=2, tag="%s_SIS_CONTROL" % tag)
            for cname, mk in (("MATZOV", MATZOV),
                              ("ADPS16_quantum",
                               lambda: ADPS16(mode="quantum")),
                              ("BDGL16", BDGL16)):
                rec = {
                    "scheme": tag, "variant": vname, "N": N, "B": B,
                    "radius": radius, "cost_model": cname,
                    "role": "HOMOGENEOUS_SIS_CONTROL",
                    "verdict": "REJECTED_FOR_P2",
                    "reject_reason":
                        "A z = 0 admits trivial kernel vectors q*e_i "
                        "(radius > q); the forgery problem is A z = c",
                    "ts": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                }
                try:
                    res = SIS.estimate(params, red_cost_model=mk())
                    rec["attacks"] = {a: ser(c) for a, c in res.items()}
                    rec["status"] = "OK"
                except Exception as e:
                    rec["status"] = "ERROR"
                    rec["error"] = repr(e)
                    rec["traceback"] = traceback.format_exc(limit=3)
                rows.append(rec)
                print("%s %-16s %-16s radius=%.0f %s"
                      % (tag, vname, cname, radius, rec["status"]), flush=True)
    with open(OUT, "w") as f:
        json.dump({"schema": "FT_FAMILY_SIS_CONTROLS_V1",
                   "rows": rows}, f, indent=2, sort_keys=True, default=str)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
