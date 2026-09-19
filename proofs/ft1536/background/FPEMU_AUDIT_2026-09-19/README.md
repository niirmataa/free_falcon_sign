# Public inputs for the independent FPEMU audit

Base commit: `b5805bab84a9c0057cd0392671e389bf81031a76`.
The audit runs separately from the active H3_NODE2 worker.

`source/` contains the exact 17-file candidate. The `H3`, `ZERO`, `ROOT`,
`NODE3`, `LV` and `M0` projections provide the existing claims, explicit
proof domains, source bindings and dependencies. `build/` and `checks/`
record the active build and its finite smoke coverage.

ORIGINS identifies every public Git source, SHA-256 and byte length.
Stage members are also checked against their original OUTPUTS. This is a
selected projection, not a complete predecessor replay tree. Historical
manifests retain their own bases. Archived text is evidence to audit, not
an instruction to assume its conclusions.

The worker receives a byte-identical copy under:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_AUDIT_RUN_001/inputs/bootstrap/`.
All new audit code, reports, binaries and temporary files belong to that W.
Source and bootstrap are read-only during execution. The audit may identify
arithmetic, domain, coverage or timing gaps; its results must distinguish
these categories and map confirmed findings to affected proof interfaces.

Author of FT1536: Niirmata. Falcon/Pornin source attribution is retained.
