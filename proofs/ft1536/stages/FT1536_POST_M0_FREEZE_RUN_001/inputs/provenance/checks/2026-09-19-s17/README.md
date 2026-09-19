# S17 integration build/check — 2026-09-19

Commands, from the integration worktree:

```sh
make verify-FT1536-sources
make check-FT1536
```

Both passed. The source manifest is
`03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589`;
all 17 files match the selected S17 baseline. This check was run before the
source-integration commit, against these source hashes, not against the
then-current HEAD's older Extra/c tree.

The build uses the pinned S17 Makefile profile, GCC and explicit C99, in a
fresh `.build/FT1536/run-*/source` copy. It compiles the CLI and historical
test executable, then runs 12 finite exact-value FPEMU checks, the CLI usage
path, and the existing public synthetic verifier regression. No KeyGen or
Sign operation and no full historical benchmark suite is executed.

The original S17 regression deliberately accepts the old witness with
machine norm 400000000 and preNTT0=63969. This is reproduction of the known
normalization defect, not a proof of successful verifier security.

`build.json` records flags, compiler/target, every command, exit code, time,
stream hashes and binary hashes. Its original run paths are provenance.
`logs/` contains the recorded stdout/stderr; `CHECKS.sha256` covers the
receipt and all copied streams. Binaries and caches remain under `.build`.
These checks are distinct from the full candidate L_V and M0 replays in
`proofs/ft1536/validation/`.
