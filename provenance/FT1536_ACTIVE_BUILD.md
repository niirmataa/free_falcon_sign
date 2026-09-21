# Active FT1536 build — 2026-09-21

The owner requested integration of the independently reviewed FLOOR_CT
candidate after the postprocessing checkpoint. `Extra/c` now contains the
**exact L_RHO + FLOOR_CT candidate** used by RAW_ASSEMBLY and subsequent H3
checkpoints, including the partial postprocessing result. FPEMU and adaptive
CDF remain selected by the original profile.

Authoritative [17-file manifest](ft1536-candidate.sha256), relative to Extra/c:

```text
56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985
```

Verifier SHA-256:

```text
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42
```

Relative to the previous L_RHO manifest2553358f…, only `fpr-emulated.h`
changes, exactly as in the archived [FLOOR_CT patch](../proofs/ft1536/stages/FT1536_FPEMU_FLOOR_CT_RUN_001/PATCH.diff).
Its SHA-256 is `6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f`.
The final floor selector uses unsigned AND/OR, with the same raw-word results,
including floor(-0)=-1. The other16 files are byte-identical to L_RHO.
Relative to S17, the source changes are the earlier
[L_RHO verifier patch](../proofs/ft1536/stages/FT1536_L_RHO_RUN_001/candidate.patch)
and this exact floor patch. The build verifies every source hash,
uses a fresh out-of-tree copy and records the compiler, flags, commands,
binary hashes, helper hash and smoke-source hash.

```sh
make FT1536
make check-FT1536
```

The focused regression now requires rejection of the old S17 witness:
verify=raw=0, preNTT0=16866, norm=43058711057. The check also builds the CLI
and historical test executable, runs18 finite FPEMU checks (including floor
signed-zero and selector-boundary regressions) and the usage path.
It does not execute KeyGen, Sign or the full benchmark suite.

[Integration and six-hour preparation checks](checks/2026-09-21-floor-integration/README.md)
retain the exact source comparison, build/regression streams, duration/profile
tests and refreshed static RUN_002 preparation. Physical timing starts only
after its separately recorded fresh preflight.

The archived reports' `source_integrated=false` fields describe their
original execution state. This later integration is recorded here and in
Git; the reports and their manifests are not rewritten. The historical dudect
baseline remains pinned to archived2553358f… sources; floor-ct remains pinned
to56974571…, now byte-identical to the default build. The proof model
remains GCC14.2.0/C99/Linux x86_64 LP64 with its explicit C/model bindings.

The M0 protocol contract is a distinct caller layer: 4096-byte honest payload
capacity and a nonce40 gate. The pinned 17-file source still contains the
historical CLI interface (2049-byte buffer, variable external rlen).
`protocol_wrapper_integrated=false`; no complete security reduction is claimed.
