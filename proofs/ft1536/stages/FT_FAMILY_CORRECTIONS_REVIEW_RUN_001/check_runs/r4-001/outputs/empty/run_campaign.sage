#!/usr/bin/env python
"""FT family estimator campaign runner -- R4 repair (S01). STATUS: NOT_RUN.

The historical runner preserved at
`scripts/historical/INVALID_FOR_P2_run_campaign.sage` (byte-identical copy of
CANDIDATE_R2 `run_campaign.sage`) routed homogeneous `SIS.estimate` into the
P2 cell.  Homogeneous SIS is NOT the P2 game of ATTACK_PROBLEMS.md
(inhomogeneous coset search "find any vector below B_N" over ROM-table
targets) and is therefore labelled **INVALID_FOR_P2**; the mismatch is a model
defect, not a measurement.

This replacement implements the scope-limited repair of TASK S01 R4
("withdraw the flawed runner from the active interface"):

  * the active P2 entry is an explicit `NOT_RUN_MODEL_UNRESOLVED` record;
  * no backend (`estimator`) is imported or called unless a premises record
    (model mapping + estimator SHA + closed modeling points) is supplied and
    validates;
  * any P2 routing to a SIS-family model (by `model_kind` or by estimator
    symbol) is rejected BEFORE any backend call
    (`INVALID_MODEL_SIS_FOR_P2`), as is any missing mapping/SHA/premises;
  * every call that does happen is recorded in `backend_calls` (audit).

Usage:
    python run_campaign.sage OUT_DIR [--premises PREMISES.json]
                                [--allow-backend]

Exit codes:
    0  processed (backend calls happened only if --allow-backend and the
       premises validated; see backend_calls in the record),
    3  NOT_RUN_MODEL_UNRESOLVED (default state: no premises supplied),
    4  validation rejected the premises (see `validation.reasons`),
    2  usage error.

This runner has NOT been executed against the real estimator for this
deliverable (`estimator_campaign_executed_in_this_task=false`); tests exercise
the guards with an instrumented mock backend only (scripts/test_r4_routing.py).
"""
import hashlib
import json
import os
import re
import sys

Q = 18433
NS = [768, 1536, 3072]
SIGMA_FT1536 = 768                 # pinned FT1536 candidate global width
MARGIN_NUM, MARGIN_DEN = 43, 40    # 1.075

REQUIRED_MODELING_POINTS = ("circulant_vs_phi3n", "p2_coset_threshold_semantics")
SIS_SYMBOL_RE = re.compile(r"(^|[^A-Za-z_])(SIS|SISParameters|SIS\.estimate)"
                           r"([^A-Za-z_]|$)")
SIS_KINDS = {"SIS", "HOMOGENEOUS_SIS"}
SHA40_RE = re.compile(r"^[0-9a-f]{40}$")
SHA64_RE = re.compile(r"^[0-9a-f]{64}$")


def bound_for(N, sigma):
    """B_N = floor((43/40)^2 * 2N * sigma^2); only N=1536 is pinned."""
    return (MARGIN_NUM ** 2 * 2 * N * sigma * sigma) // (MARGIN_DEN ** 2)


def cells_spec():
    """The fixed problem/N grid of ATTACK_PROBLEMS.md (P1 key recovery,
    P2 relation/byte production).  P3 is not an attack-cost cell."""
    out = [{"problem": "P1", "N": N} for N in NS]
    out += [{"problem": "P2", "N": N} for N in NS]
    return out


def validate_premises(prem):
    """Return (ok, reasons, cells).  Any gap blocks the backend."""
    reasons = []
    if not isinstance(prem, dict):
        return False, ["premises: not an object"], []
    commit = prem.get("estimator_commit")
    if not (isinstance(commit, str) and SHA40_RE.match(commit)):
        reasons.append("premises: estimator_commit missing/unpinned")
    closed = set(prem.get("modeling_points_closed", []))
    for need in REQUIRED_MODELING_POINTS:
        if need not in closed:
            reasons.append("premises: modeling point not closed: " + need)
    mapping = prem.get("model_mapping")
    if not isinstance(mapping, dict):
        reasons.append("premises: model_mapping missing")
        mapping = {}
    cells = []
    for spec in cells_spec():
        key = "%s:%d" % (spec["problem"], spec["N"])
        entry = mapping.get(key)
        if not isinstance(entry, dict):
            reasons.append("cell %s: no mapping" % key)
            cells.append(dict(spec, route="BLOCKED", result=
                              "NOT_RUN_MODEL_UNRESOLVED"))
            continue
        kind = entry.get("model_kind")
        symbol = str(entry.get("estimator_symbol", ""))
        mapping_sha = entry.get("mapping_sha")
        cell = dict(spec, route=None, result=None, model_kind=kind,
                    estimator_symbol=symbol)
        if not SHA64_RE.match(str(mapping_sha)):
            reasons.append("cell %s: mapping_sha missing" % key)
        # R4 core: SIS-family must never back the P2 game
        sis_hit = (kind in SIS_KINDS) or bool(SIS_SYMBOL_RE.search(symbol))
        if spec["problem"] == "P2" and sis_hit:
            reasons.append("cell %s: INVALID_MODEL_SIS_FOR_P2 (%s / %s)"
                           % (key, kind, symbol))
            cell["route"] = "REJECTED_SIS_FOR_P2"
            cell["result"] = "INVALID_MODEL_SIS_FOR_P2"
        elif sis_hit:
            reasons.append("cell %s: SIS-family symbol outside the rejected "
                           "control row (%s / %s)" % (key, kind, symbol))
            cell["route"] = "REJECTED"
            cell["result"] = "INVALID_MODEL_SIS"
        elif spec["problem"] == "P2" and kind != "ISIS_COSET":
            reasons.append("cell %s: P2 requires model_kind ISIS_COSET, got %r"
                           % (key, kind))
            cell["route"] = "BLOCKED"
            cell["result"] = "NOT_RUN_MODEL_UNRESOLVED"
        else:
            cell["route"] = "MAPPED"
            cell["result"] = "PENDING_BACKEND"
        cells.append(cell)
    ok = not reasons
    return ok, reasons, cells


def call_backend(cells, out):
    """The ONLY place that may touch the `estimator` backend.  Preconditions
    (validated premises + --allow-backend) must already hold."""
    import estimator  # late import: a guard failure must never reach here
    for cell in cells:
        if cell.get("route") != "MAPPED":
            continue
        symbol = cell["estimator_symbol"]
        mod, fn = symbol.split(".") if "." in symbol else (symbol, "estimate")
        call = "%s.%s" % (mod, fn)
        obj = getattr(getattr(estimator, mod), fn)
        res = obj({"problem": cell["problem"], "N": cell["N"],
                   "q": Q, "bound": (bound_for(cell["N"], SIGMA_FT1536)
                                     if cell["problem"] == "P2" else None)})
        cell["result"] = str(res)
        out["backend_calls"].append({"problem": cell["problem"], "N": cell["N"],
                                     "call": call})


def main(argv):
    if len(argv) < 2:
        print("usage: run_campaign.sage OUT_DIR [--premises P.json] "
              "[--allow-backend]")
        return 2
    out_dir = argv[1]
    premises_path = None
    allow_backend = False
    i = 2
    while i < len(argv):
        if argv[i] == "--premises":
            i += 1
            premises_path = argv[i]
        elif argv[i] == "--allow-backend":
            allow_backend = True
        i += 1

    out = {"status": None, "backend_calls": [], "cells": [], "validation":
           {"ok": False, "reasons": []}, "premises_sha256": None,
           "estimator_run": False,
           "note": "R4 repaired interface; all cells NOT_RUN unless a fully "
                   "resolved premises record validates; homogeneous SIS is "
                   "INVALID_FOR_P2 (see scripts/historical label)."}

    if premises_path is None:
        # Default active input: explicit unresolved record, no backend call.
        out["status"] = "NOT_RUN_MODEL_UNRESOLVED"
        out["cells"] = [dict(c, route="BLOCKED", result="NOT_RUN_MODEL_UNRESOLVED")
                        for c in cells_spec()]
        out["validation"]["reasons"] = ["no premises record supplied"]
        code = 3
    else:
        with open(premises_path, "rb") as f:
            raw = f.read()
        out["premises_sha256"] = hashlib.sha256(raw).hexdigest()
        prem = json.loads(raw.decode("utf-8"))
        ok, reasons, cells = validate_premises(prem)
        out["validation"] = {"ok": ok, "reasons": reasons}
        out["cells"] = cells
        if not ok:
            out["status"] = "VALIDATION_REJECTED"
            code = 4
        elif allow_backend:
            call_backend(cells, out)
            out["status"] = "RUN_RECORD"
            out["estimator_run"] = True
            code = 0
        else:
            for cell in out["cells"]:
                if cell.get("result") == "PENDING_BACKEND":
                    cell["result"] = "NOT_RUN"
            out["status"] = "NOT_RUN"
            code = 0

    os.makedirs(out_dir, exist_ok=True)
    with open(os.path.join(out_dir, "campaign.json"), "w",
              encoding="utf-8") as f:
        json.dump(out, f, indent=1, sort_keys=True)
        f.write("\n")
    print("status:", out["status"], "backend_calls:", len(out["backend_calls"]))
    return code


if __name__ == "__main__":
    sys.exit(main(sys.argv))
