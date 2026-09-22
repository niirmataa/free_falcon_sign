# Reproduction scope

This checkpoint preserves the author's completed research package and a
maintainer review. Archive protocol: **replay=none** (no single complete
package replay declared), rather than claiming the whole manuscript is proved.

Integrity is checked with:

```sh
python3 -B proofs/ft1536/tools/archive.py verify FT_FAMILY_SCALING_REVIEW_RUN_001
```

The performed commands, stdout/stderr, tool paths and bounded sandbox setup
are in `review/REVIEW_CHECKS.json`, `review/EXTRA_CHECKS.json` and `review/logs/`.
`review/check.py`, `extra.py` and the original absolute locations record that
particular review; they are not a portable command to overwrite an archived
work directory. The source snapshot and author's manifest remain immutable.

To reproduce the scoped calculations, work in a NEW durable directory:

1. Reconstruct a mirror with the author's files under
   `MIRROR/proofs/ft1536/work/FT_FAMILY_SCALING_2026-09-21/` and the pinned
   `inputs/source/*` under `MIRROR/Extra/c/`. This preserves the five-level
   source-header path in the original FFT checker.
2. Use a new writable HOME/TMPDIR/DOT_SAGE/cache in that review directory;
   the original archive and original worker directory remain read-only.
3. In the mirrored package, compile each of `lean/FTA2.lean`, `FTLayout.lean`,
   `FTRoots.lean`, `FTBounds.lean` with Lean4.34.0-j1/-M2048. The reviewer
   additionally checked14 named declarations in `review/ReviewAudit.lean`.
4. Run `python3 -B scripts/check_geometry.py`, `check_layout.py`,
   `check_bounds_table.py`. Compare the five JSON/CSV hashes to SHA256SUMS
   and inspect their boolean results.
5. With Sage10.9 (`sage file.py`, no preparser), run the standalone
   `review/independent_checks.py` from a copy to reproduce the algebra and
   conditional ideal-Gaussian diagnostic. Run `review/fft_oracle.py` with
   the mirrored package as cwd for the12 independent ball-oracle controls.

The original `sage_exact.sage` remains available under PACKAGE instructions;
the maintainer used independent Newton-sum/group checks rather than repeating
its entire quadratic-time sample calculation. Estimator campaign NOT_RUN is
intentional; review R1–R4 must be resolved before interpreting such a campaign.
High-precision FFT-port checks do not prove a universal source-FPEMU bound.
