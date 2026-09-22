#!/usr/bin/env sage
"""Pinned estimator campaign skeleton for the FT family -- STATUS: NOT_RUN.

This file defines the exact estimator invocations for problems P1/P2 of
ATTACK_PROBLEMS.md against `malb/lattice-estimator`. It has NOT been executed
in this deliverable; no output file from it may be cited as a result.

Preconditions before running (in this order):
  1. record estimator git commit SHA and `git status` here,
  2. resolve the open modeling points of ATTACK_PROBLEMS.md (circulant model
     vs Phi_{3N} structure; SIS-vs-ISIS threshold semantics),
  3. run with a fresh results directory; keep ALL stdout/stderr and the exact
     command lines (the review forbids tables without a full campaign record).

Environment used by the historical worksheet (2026-05-06): SageMath +
lattice-estimator; that worksheet's law was Gaussian-like and is not
transportable. The intended invocation shape:

    sage run_campaign.sage OUT_DIR
"""
import json
import os
import sys

Q = 18433
NS = [768, 1536, 3072]
SIGMA_FT1536 = 768           # pinned FT1536 candidate global width (sigma)
MARGIN_NUM, MARGIN_DEN = 43, 40   # 1.075

ESTIMATOR_COMMIT = None      # fill BEFORE running (required)


def bound_for(N, sigma):
    """B_N = floor((43/40)^2 * 2N * sigma^2); only N=1536 is pinned."""
    return (MARGIN_NUM ** 2 * 2 * N * sigma * sigma) // (MARGIN_DEN ** 2)


def main(out_dir):
    if ESTIMATOR_COMMIT is None:
        print("NOT_RUN: estimator commit not pinned; see preconditions.")
        return 2
    from estimator import NTRUParameters, SISParameters, NoiseDistribution
    from estimator import NTRU, SIS

    DUniform = NoiseDistribution.Uniform
    out = {"status": "RUN", "estimator_commit": ESTIMATOR_COMMIT, "cells": []}
    for N in NS:
        # P1 -- key recovery; TERNARY law, never the signing sigma
        p1 = NTRUParameters(n=N, q=Q, Xs=DUniform(-1, 1), Xe=DUniform(-1, 1),
                            m=N, ntru_type="circulant")
        try:
            r1 = NTRU.estimate(p1)
        except Exception as exc:            # keep failures recorded
            r1 = {"error": repr(exc)}
        out["cells"].append({"problem": "P1", "N": N, "result": str(r1)})
        # P2 -- accepted-byte production; threshold B_N (sigma choice OPEN
        # for N != 1536 -- do not fill numbers without a pinned sigma_N)
        if N == 1536:
            bnd = bound_for(N, SIGMA_FT1536)
            p2 = SISParameters(n=N, q=Q, length_bound=bnd ** 0.5, m=2 * N,
                               norm=2)
            try:
                r2 = SIS.estimate(p2)
            except Exception as exc:
                r2 = {"error": repr(exc)}
            out["cells"].append({"problem": "P2", "N": N, "B": bnd,
                                 "result": str(r2)})
        else:
            out["cells"].append({"problem": "P2", "N": N,
                                 "result": "NOT_RUN: sigma_N not pinned"})
    with open(os.path.join(out_dir, "campaign.json"), "w") as f:
        json.dump(out, f, indent=2, sort_keys=True)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else "."))
