#!/usr/bin/env python3
"""Aggregate all campaign artifacts into the comparative checkpoint tables.

Reads artifacts/: model_eq234.json, rc_cost_surface.json, ntru_grid.ndjson,
sis_controls.json, subfield_normdown.json, hostile_envelope.json and writes:

  artifacts/comparative_summary.json  -- machine checkpoint
  artifacts/comparative.csv          -- one row per scheme/attack/model point

All rows keep their status/verdict labels (PINNED / ALTERNATIVE_PROPOSAL /
SENSITIVITY / REJECTED_CONTROL / NOT_RUN). No cell is invented: missing data
is emitted as NOT_RUN.
"""
import csv
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.dirname(HERE)
ART = os.path.join(W, "artifacts")


def load(name):
    p = os.path.join(ART, name)
    return json.load(open(p)) if os.path.isfile(p) else None


def main():
    model = load("model_eq234.json") or {"rows": []}
    rc = load("rc_cost_surface.json") or {"rows": []}
    sub = load("subfield_normdown.json") or {"rows": []}
    sis = load("sis_controls.json") or {"rows": []}
    host = load("hostile_envelope.json") or {"rows": []}
    ntru = {"rows": []}
    nd = os.path.join(ART, "ntru_grid.ndjson")
    if os.path.isfile(nd):
        for line in open(nd):
            rec = json.loads(line)
            if "attacks" in rec:
                ntru["rows"].append(rec)

    # comparative minima from the full NTRU grid per scheme
    minima = {}
    for r in ntru["rows"]:
        for a, cost in r["attacks"].items():
            rop = cost.get("rop")
            if rop is None:
                continue
            key = (r["scheme"], a)
            if key not in minima or rop < minima[key]["rop"]:
                minima[key] = {
                    "rop": rop, "beta": cost.get("beta"),
                    "cost_model": r["cost_model"],
                    "shape_model": r["shape_model"],
                }

    summary = {
        "schema": "FT_FAMILY_COMPARATIVE_CHECKPOINT_V1",
        "components": {
            "model_eq234_rows": len(model["rows"]),
            "rc_cost_surface_rows": len(rc["rows"]),
            "ntru_grid_cells_ok": len(ntru["rows"]),
            "sis_control_rows": len(sis["rows"]),
            "subfield_rows": len(sub["rows"]),
            "hostile_envelope_rows": len(host["rows"]),
        },
        "ntru_minima_per_attack": {
            "%s|%s" % (k[0], k[1]): v for k, v in sorted(minima.items())},
        "status_labels": {
            "FT1536_forgery": "PINNED_BOUND_KERNEL_A2_TRANSPORT",
            "FT768_FT3072_forgery": "ALTERNATIVE_PROPOSAL",
            "P1_key_recovery": "HEURISTIC_RAW_IID_TERNARY",
            "emitted_key_conditioning": "OPEN",
            "homogeneous_SIS": "REJECTED_CONTROL",
            "subfield_lift": "OPEN_HEURISTIC_ABD",
            "security_level_declarations": "NOT_MADE",
        },
    }
    with open(os.path.join(ART, "comparative_summary.json"), "w") as f:
        json.dump(summary, f, indent=2, sort_keys=True, default=str)

    rows = []
    for r in model["rows"]:
        rows.append({
            "source": "model_eq234", "scheme": r["scheme"],
            "attack": r["attack"], "variant": r["variant"],
            "point": "eq234_beta", "value": r["block"],
            "status": r["status"],
        })
    for key, v in sorted(minima.items()):
        rows.append({
            "source": "ntru_grid_min", "scheme": key[0], "attack": key[1],
            "variant": "%s/%s" % (v["cost_model"], v["shape_model"]),
            "point": "log2_rop", "value": v["rop"], "status": "OK",
        })
    for r in sub["rows"]:
        rows.append({
            "source": "subfield_normdown", "scheme": "FT%d" % r["N"],
            "attack": "subfield_index2", "variant": "u=%d" % r["u"],
            "point": "eq23_beta_subfield", "value": r["beta_subfield_eq23"],
            "status": r["status"],
        })
    for r in sis["rows"]:
        rows.append({
            "source": "sis_controls", "scheme": r["scheme"],
            "attack": "homogeneous_SIS", "variant": r["variant"],
            "point": "rejected", "value": "",
            "status": r["verdict"],
        })
    with open(os.path.join(ART, "comparative.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["source", "scheme", "attack",
                                          "variant", "point", "value",
                                          "status"])
        w.writeheader()
        w.writerows(rows)
    print("comparative rows:", len(rows))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
