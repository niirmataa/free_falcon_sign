# Repair pass for the NTRU grid: the MATZOV default-classical (ListDecoding)
# cells. The first grid run used nn="ListDecoding" which is NOT a valid key in
# this estimator version (Kyber.__init__ maps only "classical" ->
# "list_decoding-classical" and "quantum" -> "list_decoding-dw"); all five
# attacks in those cells were rejected with KeyError 'ListDecoding' and the
# cells were recorded EMPTY. This pass computes the correct default-classical
# variant and appends records flagged "repair": true to ntru_grid.ndjson.
#
# Replay:  sage_env_python scripts/repair_cells.sage   (plain Python)

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
from estimator.reduction import MATZOV  # noqa: E402
import estimator.schemes as schemes  # noqa: E402

ART = os.path.join(W, "artifacts")
NDJSON = os.path.join(ART, "ntru_grid.ndjson")

SHAPE_MODELS = [("default_GSA", None), ("zgsa", "zgsa")]
FT_SCHEMES = [("FT768", 768), ("FT1536", 1536), ("FT3072", 3072)]


def ser(cost):
    out = {}
    for k, v in cost.items():
        try:
            out[k] = float(v)
        except Exception:
            out[k] = str(v)
    return out


def emit(rec):
    with open(NDJSON, "a") as f:
        f.write(json.dumps(rec, sort_keys=True, default=str) + "\n")


def main():
    sys.path.insert(0, os.path.join(W, "scripts"))
    from build_binding import load_build
    build = load_build(W)
    Q = build["q"]
    cells = []
    for tag, N in FT_SCHEMES:
        params = NTRUParameters(n=N, q=Q, Xs=Ternary, Xe=Ternary, m=N,
                                tag=tag + "_SKR_RAW", ntru_type="circulant")
        cells.append((tag, params))
    cells.append(("Falcon512_SKR", schemes.Falcon512_SKR))
    cells.append(("Falcon1024_SKR", schemes.Falcon1024_SKR))

    for tag, params in cells:
        for sname, shape in SHAPE_MODELS:
            rec = {"scheme": tag,
                   "cost_model": "MATZOV_classical_ListDecoding",
                   "shape_model": sname, "repair": True,
                   "ts": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())}
            try:
                kw = {"red_cost_model": MATZOV(nn="classical")}
                if shape is not None:
                    kw["red_shape_model"] = shape
                res = NTRU.estimate(params, **kw)
                rec["attacks"] = {a: ser(c) for a, c in res.items()}
                rec["status"] = "OK" if rec["attacks"] else "EMPTY"
            except Exception as e:
                rec["status"] = "ERROR"
                rec["error"] = repr(e)
                rec["traceback"] = traceback.format_exc(limit=3)
            emit(rec)
            print(tag, sname, rec["status"],
                  sorted(rec.get("attacks", {}).keys()), flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
