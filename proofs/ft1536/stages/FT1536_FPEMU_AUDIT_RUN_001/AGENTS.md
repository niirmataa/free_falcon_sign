# Independent FPEMU audit worker

The owner starts this audit manually in a separate Astra session.
You are that independent worker; the existing NODE2 worker is separate.
No automatically launched subagent is required. Read PREPARATION.md for
the provenance of the supplied helper scripts and the interrupted launch.
Project author: Niirmata. Read REPO/AGENTS and this task:
`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_FPEMU_AUDIT_2026-09-19.md`.
Task SHA-256:
`d5b064ba6082f1f563bfba717ee1d167254e2aedcea667576bfb3f56a9103de9`.

Only writable working directory:
`/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_AUDIT_RUN_001`.
Bootstrap:126 members,124 public Git originals, BASEb5805bab84a9c0057cd0392671e389bf81031a76.
External MANIFEST SHA-256:
`f836a37c9247de53ff70297e809fa55c46812d749e69886857d24e89db7de166`.

Verify all members/exact scope before consuming. Audit only the pinned
source, not REPO/Extra/c. Bootstrap/source remain read-only during jobs.
Do not access or modify the active H3_NODE2 W. No Git, further agents,
network/installations, private keys/seeds/coefficient material, .private,
private_extraction, KeyGen/private loader/Sign or full test_falcon runs.
Public deterministic synthetic FPR fixtures are permitted.

The task is an AUDIT: independently examine domains, source-model binding,
proof coverage, native arithmetic/UB behavior and timing evidence. Earlier
PROVED/PASS labels are inputs to assess, not conclusions to assume. Known
-0/underflow behavior is not automatically a new in-domain bug. Map every
confirmed issue or gap to affected proof interfaces and required re-review.

Use the provided bounded W-only bwrap runner for computations. Keep HOME,
TMPDIR/DOT_SAGE/LEAN_PATH/cache/binaries under W. Normal jobs8GiB, separate
ASan shadow mode, finite wall/CPU limits. AGENTS is not an OS sandbox.
New oracle should be independent exact dyadic/QQ/RBF; copying the same
instructions or host double alone is insufficient.

Do not call a non-dudect custom test dudect. If tool/measurement conditions
are unavailable, record NOT_RUN/INCONCLUSIVE with an exact follow-up recipe.
Timing builds are separate from sanitizers; no current CT claim from a
Makefile comment, CT_BEREXP flag, or absence of a sampled timing signal.

Do not patch production source or change earlier reports/statuses. Preserve
full logs and failed attempts. Deliver the audit matrix, findings, impact
map, timing review, REPORT/RESULT and a frozen, self-contained standard
replay package with external REPORT/OUTPUTS hashes. Parent will independently
review/import/commit. Stop after the handoff; do not start another task.
