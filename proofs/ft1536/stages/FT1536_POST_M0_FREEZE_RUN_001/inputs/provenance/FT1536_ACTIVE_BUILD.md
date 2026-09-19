# Active FT1536 build — 2026-09-19

The owner requested that the working research build be the default source
visible on main. `Extra/c` therefore contains the **exact L_RHO candidate**
used by the completed L_NTT, L_V and M0 checkpoints, including FPEMU and
adaptive CDF tables.

Authoritative [17-file manifest](ft1536-candidate.sha256), relative to Extra/c:

```text
2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a
```

Verifier SHA-256:

```text
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42
```

The source changes from the exact S17 integration are precisely the
archived [L_RHO patch](../proofs/ft1536/stages/FT1536_L_RHO_RUN_001/candidate.patch).
All other 16 files are byte-identical. The build verifies every source hash,
uses a fresh out-of-tree copy and records the compiler, flags, commands,
binary hashes, helper hash and smoke-source hash.

```sh
make FT1536
make check-FT1536
```

The focused regression now requires rejection of the old S17 witness:
verify=raw=0, preNTT0=16866, norm=43058711057. The check also builds the CLI
and historical test executable, runs 12 finite FPEMU checks and the usage path.
It does not execute KeyGen, Sign or the full benchmark suite.

The archived reports' `source_integrated=false` fields describe their
original execution state. This later integration is recorded here and in
Git; the reports and their manifests are not rewritten. The proof model
remains GCC14.2.0/C99/Linux x86_64 LP64 with its explicit C/model bindings.

The M0 protocol contract is a distinct caller layer: 4096-byte honest payload
capacity and a nonce40 gate. The pinned 17-file source still contains the
historical CLI interface (2049-byte buffer, variable external rlen).
`protocol_wrapper_integrated=false`; no complete security reduction is claimed.
