# FT_FAMILY_SEC_ESTIMATE — comparative estimator checkpoint (2026-09-22)

**Status: `DIAGNOSTIC_NOT_CANDIDATE_READY`** (house discipline of the S20
campaign: model-dependent concrete costs, not hardness proofs).

Full lattice-estimator campaign for the FT family on the **current source
build `Extra/c`** of this repository, in the style of
`S20-SEC-ESTIMATE-001-20260827-a1/-b1/-c1`, with all attack classes and all
reduction-cost models run at full grid ("max screws"), for the comparative
checkpoint of FT768 / FT1536 / FT3072 against Falcon-512/1024 anchors.

Quick map:

- **[report.md](report.md)** — comparative results and claim boundary.
- [SCOPE.md](SCOPE.md) / [TASK_PLAN.md](TASK_PLAN.md) — what is computed and
  how the problems are defined (binding: the repaired game definitions).
- [PROVENANCE.md](PROVENANCE.md) / [TOOLCHAIN.txt](TOOLCHAIN.txt) — pins.
- [NEGATIVE_RESULTS.md](NEGATIVE_RESULTS.md) — rejected rows and refutations.
- `inputs/family/build_inputs.json` — constants **extracted from `Extra/c`
  code** (file:line + verbatim lines + 17-file manifest), re-verified by
  every script at run time (`scripts/build_binding.py`).
- `inputs/tools/` — vendored lattice-estimator (upstream commit `3e48ef42…`,
  byte-identical to a fresh download; `artifacts/vendor_verification.json`)
  and the pinned Falcon reference materials.
- `artifacts/` — machine outputs; `scripts/` — all runners.
- `INPUTS.sha256` / `OUTPUTS.sha256` — manifests.

Estimator: https://github.com/malb/lattice-estimator (LGPLv3+).
Falcon reference: Falcon Project / Thomas Pornin, licenses preserved.
Author of the project: Niirmata; this campaign prepared by MiMo.
