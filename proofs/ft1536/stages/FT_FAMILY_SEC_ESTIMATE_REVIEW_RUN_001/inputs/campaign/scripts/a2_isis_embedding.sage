# P2 forgery rows -- inhomogeneous A2-ISIS embedding, full RC cost surface.
#
# Reads artifacts/model_eq234.json (the eq. (2.3)/(2.4) block sizes solved
# with the exact A2 metric transport) and computes, for every row, the full
# reduction-cost surface: rop (log2) under ALL pinned RC cost models at the
# solved beta and at beta-2/beta+2 (sensitivity brackets). This is the
# "all cost models on the same attack geometry" companion of the model rows.
#
# Scope notes (ATTACK_PROBLEMS.md Sec.1-2): this is the Falcon eq. (2.4)
# inhomogeneous target-coset convention (DBKZ + MW16 Cor.1 heuristic).
# Homogeneous SIS is NOT used (see sis_models.sage, REJECTED controls).
#
# Replay:  sage scripts/a2_isis_embedding.sage   (plain Python, no preparser)

import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(W, "inputs", "tools", "vendor",
                                "lattice-estimator"))

from estimator.reduction import (  # noqa: E402
    ADPS16, BDGL16, LaaMosPol14, CheNgu12, ABFKSW20, ABLR21,
    ChaLoy21, GJ21, Kyber, MATZOV)

ART = os.path.join(W, "artifacts")

COST_MODELS = [
    ("MATZOV_ListDecoding", lambda: MATZOV(nn="ListDecoding")),
    ("MATZOV_quantum", lambda: MATZOV(nn="quantum")),
    ("GJ21", lambda: GJ21()),
    ("ChaLoy21", lambda: ChaLoy21()),
    ("ABFKSW20", lambda: ABFKSW20()),
    ("ABLR21", lambda: ABLR21()),
    ("ADPS16_classical", lambda: ADPS16(mode="classical")),
    ("ADPS16_quantum", lambda: ADPS16(mode="quantum")),
    ("ADPS16_paranoid", lambda: ADPS16(mode="paranoid")),
    ("BDGL16", lambda: BDGL16()),
    ("LaaMosPol14", lambda: LaaMosPol14()),
    ("CheNgu12", lambda: CheNgu12()),
]


def log2(x):
    from sage.all import log
    return float(log(x) / log(2))


def main():
    model = json.load(open(os.path.join(ART, "model_eq234.json")))
    rows = []
    for m in model["rows"]:
        beta = int(m["block"])
        d = int(m["d"])
        for cname, mk in COST_MODELS:
            rc = mk()
            entry = {
                "scheme": m["scheme"], "attack": m["attack"],
                "variant": m["variant"], "cost_model": cname,
                "beta": beta, "d": d,
                "ts": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
            }
            try:
                for shift in (-2, 0, 2):
                    b = beta + shift
                    c = rc(b, d)
                    entry["log2_rop_%+d" % shift] = log2(c)
                    entry["delta_%+d" % shift] = float(rc.delta(b))
            except Exception as e:
                entry["error"] = repr(e)
            rows.append(entry)
        print("%-12s %-13s %-22s beta=%5d done"
              % (m["scheme"], m["attack"], m["variant"], beta), flush=True)
    with open(os.path.join(ART, "rc_cost_surface.json"), "w") as f:
        json.dump({"schema": "FT_FAMILY_RC_COST_SURFACE_V1",
                   "rows": rows}, f, indent=2, sort_keys=True, default=str)
    import csv
    fields = sorted({k for r in rows for k in r})
    with open(os.path.join(ART, "rc_cost_surface.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
