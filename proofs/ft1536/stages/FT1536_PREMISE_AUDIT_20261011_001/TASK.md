# T12.1 — premise audit / vacuity hunt (owner instruction, 2026-10-11)

This work is a report-only audit under ROADMAP T12.1, not a new proof lane or a change to its status. The owner requested all impossible/vacuous premises in Source3 and a short run2 pass before further proof/paper consumption. For every exported theorem premise, check satisfiability, constructor reachability, triviality and explicit proof/world/interface provenance. Use IMPOSSIBLE / VACUOUS / TRIVIAL / SUSPECT / OK, exact pins and consumer names. Suggest repairs without applying them; §40.1 owns repairs.

Scope: committed bytes at ef354c48226ac6bcf6193efa70289698a4a61d6a. Live Source3 contains ongoing unrelated repairs and is not frozen by this audit. W is FT1536_PREMISE_AUDIT_20261011_001; all new probes, logs and build products stay here. No existing worker, relay or reviewer is started. One Lean child at a time. No changes to formal mainline files, T12.1/B20 statuses, other work, Git branches, or push. At close: Polish explanation and a local checkpoint of this report only. No owner acceptance or independent acceptance is asserted.

A complete file/type inventory is distinct from a complete satisfiability proof. Any unproved existential or unexamined joint-premise combination stays SUSPECT. Proof import success and finite controls are not satisfiability certificates.
