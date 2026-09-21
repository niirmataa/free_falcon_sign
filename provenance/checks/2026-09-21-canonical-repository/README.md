# Canonical repository relocation checks — 2026-09-21

Author: Niirmata. Status: **PASS_CANONICAL_REPOSITORY_AND_PRESERVED_OLD_CHECKOUT**.
The owner's canonical main checkout is /home/footfalcon/free_falcon_sign.

The backup/migration/cleanup receipts record verified durable copies of the
temporary main and test worktrees, preservation of the original staged checkout,
and removal of the project entries from /tmp/opencode. The canonical main was
at9d5789d before the persistent-storage policy change. Existing Astra/dudect
work directories retained their filesystem identities and absolute paths.

Post-move verification:
- git fsck --full --no-dangling: PASS;
- archive integrity:23 checkpoints and36 documents PASS;
- archive unit tests:11 PASS; duration/profile tests:11 PASS;
- canonical make verify-FT1536-sources:17/17, FLOOR_CT manifest56974571…;
- canonical make check-FT1536: PASS,18 FPEMU checks and preserved rejection
 of the historical S17 witness; build commands/full streams are retained here.

CHECKS.sha256 seals25 files, SHA-256:
`d391f81b704fc1111afabc8a9efd552957bdcb5d85ae594e851f0a191325d246`.
The original index, staged patch, private/local recovery data and complete
inventories remain in the ignored durable relocation workspace; they are not
part of this published check record. Historical absolute paths in frozen
evidence are preserved. These are storage/integrity checks, not new proof claims.

Dudect RUN_002 remains unstarted and deferred to the owner's nighttime signal.
Its prepared21600-second budget and sealed source/harness inputs are retained.
