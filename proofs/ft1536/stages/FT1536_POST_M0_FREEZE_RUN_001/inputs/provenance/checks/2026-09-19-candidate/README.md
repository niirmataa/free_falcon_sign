# Active-candidate integration check — 2026-09-19

The exact 17-file L_RHO candidate is the selected source in Extra/c:
manifest `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.

```sh
make verify-FT1536-sources
make check-FT1536
```

The checks run on a fresh source copy, retaining the pinned Makefile profile
and explicit C99. They build the CLI/test executable, exercise 12 finite
FPEMU cases and the usage path, and require the corrected verifier to reject
the historical public witness (norm43058711057, preNTT0=16866).

The final check passes in both plain and observed builds. The observer
captures the actual norm arguments and delegates to the original predicate;
it does not reconstruct a duplicate NTT trace. The reported normalized_s0
is obtained by calling the actual candidate helper.

The first attempt is retained under `attempts/legacy-s17-harness/`. Its
verifier correctly rejected the witness, but the old S17-only harness both
expected acceptance and duplicated the obsolete normalization in its trace.
That check failed and was replaced by the current source-bound regression.
The candidate source bytes were unchanged during this harness correction.

`build.json` and `logs/` preserve the commands, toolchain and exact streams;
`CHECKS.sha256` pins their bytes. Source hashes, build-helper and smoke-test
hashes are in the receipt. Its original build paths are provenance; binaries
and cache remain under the ignored .build directory. No KeyGen/Sign operation
or full benchmark suite is executed by these focused checks.
