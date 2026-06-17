# Project Status

Last checked: 2026-06-17

Repository: `niirmataa/free_falcon_sign`

## Git State

Remote:

- `origin`: `https://github.com/niirmataa/free_falcon_sign.git`
- default branch: `main`
- local `main` is aligned with `origin/main`
- latest local and remote commit: `1c0298f` - `docs: add ternary1536 empirical attack matrix`

Local workspace:

- clean
- no ahead/behind divergence
- no uncommitted changes before this status document was added

## Current Scope

This repository contains the FREE Falcon signing research implementation and related notes.

Important existing documents:

- `FREE_FALCON.md`
- `RESULTS.md`
- `TERNARY1536_STANDARD_TESTS.md`
- `TERNARY1536_WORKFLOW.md`

## Current Role In The Nexum Stack

This repository should be treated as a research/reference source for Falcon-family experimentation.

It should not be presented as production-audited cryptography.

Recommended use:

- reference implementation notes,
- empirical testing notes,
- source material for a future reproducible WASM package,
- comparison material for protocol and verifier experiments.

## Risk Notes

- The Falcon variant is experimental and must be labelled clearly in downstream repositories.
- Do not copy generated or modified crypto code into production packages without review.
- Do not claim compatibility with audited/reference Falcon unless verified with test vectors.
- Keep implementation notes separate from protocol-level promises.

## Recommended Next Step

Create a clean `nexum-falcon-wasm` repository or package under `lukasz82338233`.

That package should include:

- explicit source provenance,
- reproducible Docker build,
- Node and browser loader tests,
- tampered-signature tests,
- clear experimental status labels.
