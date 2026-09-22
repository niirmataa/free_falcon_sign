# Full lattice-estimator NTRU grid -- P1 key recovery, RAW ternary law.
#
# Every attack returned by NTRU.estimate (usvp, dsd, bdd, bdd_hybrid,
# bdd_mitm_hybrid) is run under every pinned reduction-cost model and both
# shape models ("max screws"). Records are appended incrementally to
# artifacts/ntru_grid.ndjson so partial runs remain honest data.
#
# Scope: P1 = P1a short-vector recovery (ATTACK_PROBLEMS.md Sec.3). RAW iid
# ternary secrets (estimator.nd.Ternary). EMITTED-KeyGen conditioning remains
# OPEN and is NOT modeled here. circulant model vs Phi_{3N} tower is an OPEN
# modeling caveat, recorded in the output.
#
# Replay:  sage scripts/ntru_models.sage   (plain Python, no preparser)

import json
import os
import sys
import time
import traceback

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(W, "inputs", "tools", "vendor",
                                "lattice-estimator"))

from estimator import NTRU  # noqa: E402
from estimator.nd import Ternary  # noqa: E402
from estimator.ntru_parameters import NTRUParameters  # noqa: E402
from estimator.reduction import (  # noqa: E402
    ADPS16, BDGL16, LaaMosPol14, CheNgu12, ABFKSW20, ABLR21,
    ChaLoy21, GJ21, Kyber, MATZOV)
import estimator.schemes as schemes  # noqa: E402

ART = os.path.join(W, "artifacts")
NDJSON = os.path.join(ART, "ntru_grid.ndjson")

COST_MODELS = [
    ("MATZOV_classical_ListDecoding", lambda: MATZOV(nn="classical")),
    ("MATZOV_quantum_dw", lambda: MATZOV(nn="quantum")),
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
SHAPE_MODELS = [("default_GSA", None), ("zgsa", "zgsa")]

Q = 18433
FT_SCHEMES = [("FT768", 768), ("FT1536", 1536), ("FT3072", 3072)]


def ser(cost):
    out = {}
    for k, v in cost.items():
        try:
            out[k] = float(v)
        except Exception:
            out[k] = str(v)
    return out


DONE = set()


def load_done():
    """Resume support: cells already recorded (e.g. after a server restart)
    are never recomputed and the incremental log is never truncated."""
    for line in open(NDJSON):
        rec = json.loads(line)
        if "scheme" in rec and "cost_model" in rec:
            DONE.add((rec["scheme"], rec["cost_model"], rec["shape_model"]))


def emit(rec):
    with open(NDJSON, "a") as f:
        f.write(json.dumps(rec, sort_keys=True, default=str) + "\n")


def run_cell(tag, params, attack_grid_only=None):
    for cname, mk in COST_MODELS:
        for sname, shape in SHAPE_MODELS:
            if (tag, cname, sname) in DONE:
                print("%-10s %-22s %-12s SKIP (resume)"
                      % (tag, cname, sname), flush=True)
                continue
            rec = {"scheme": tag, "cost_model": cname, "shape_model": sname,
                   "ts": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())}
            try:
                kw = {"red_cost_model": mk()}
                if shape is not None:
                    kw["red_shape_model"] = shape
                res = NTRU.estimate(params, **kw)
                attacks = {}
                for a, cost in res.items():
                    attacks[a] = ser(cost)
                rec["attacks"] = attacks
                rec["status"] = "OK"
            except Exception as e:
                rec["status"] = "ERROR"
                rec["error"] = repr(e)
                rec["traceback"] = traceback.format_exc(limit=3)
            emit(rec)
            best = ""
            if rec["status"] == "OK":
                for a, cost in rec["attacks"].items():
                    if "rop" in cost:
                        r = cost["rop"]
                        if not best or r < best[1]:
                            best = (a, r)
            print("%-10s %-22s %-12s %s best=%s"
                  % (tag, cname, sname, rec["status"],
                     ("%s rop=2^%.1f" % (best[0], best[1].log(2))
                      if best and hasattr(best[1], "log") else
                      ("%s" % (best[0],) if best else "-"))), flush=True)


def falcon_params(tag):
    p = getattr(schemes, tag)
    return p


def main():
    os.makedirs(ART, exist_ok=True)
    sys.path.insert(0, os.path.join(W, "scripts"))
    from build_binding import load_build
    build = load_build(W)
    global Q
    Q = build["q"]
    header = {
        "schema": "FT_FAMILY_NTRU_GRID_V1",
        "estimator_commit": "3e48ef421ec256afddb3e7d2249a77eab6e9ba12",
        "source_build_binding": build,
        "secret_law": "estimator.nd.Ternary (RAW iid ternary, pre-gate)",
        "open_modeling": [
            "circulant model vs Phi_{3N} tower ring",
            "EMITTED (accepted-KeyGen) conditioning of the secret law",
        ],
        "multi_target_note": "P2-level target counting is separate; this grid "
                             "is single-instance P1a recovery cost",
    }
    if os.path.exists(NDJSON):
        load_done()
        print("RESUME: %d cells already recorded; only missing cells run"
              % len(DONE), flush=True)
    else:
        emit(header)

    for tag, N in FT_SCHEMES:
        params = NTRUParameters(n=N, q=Q, Xs=Ternary, Xe=Ternary, m=N,
                                tag=tag + "_SKR_RAW", ntru_type="circulant")
        run_cell(tag, params)

    for tag in ("Falcon512_SKR", "Falcon1024_SKR"):
        params = falcon_params(tag)
        run_cell(tag, params)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
