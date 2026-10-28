# R1 selected bezout exact-length calls — checkpoint 627

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The actual pinned zint_exact_length body executes its descending scan by
structural induction over any bounded input word image, preserving heap and
returning the index one past its highest nonzero word, or zero if all words
are zero. Its source expression, loop, return, C counter arithmetic and
highest-index properties are kernel checked.

The original two calls in zint_bezout part2 are executed on the actual
selected reconstructed fp/gp images from625/626. The resulting xlen/ylen
cells equal the corresponding highest-nonzero-word specifications, and both
335-word input images remain on the same source execution witness. These
are symbolic values, not evaluated numeric lengths. No desired run/output
or positive length is assumed.

Canonical keygen_exact627_canonical accepted10/10, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and25 axiom results use only
propext/Classical.choice/Quot.sound. Lean time34.241s; maximum cumulative child
RSS4418020 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Selected sources inherit
maxRecDepth262144; no memory limit was raised. Independent review: NOT_RUN.

Twenty-two local attempts include eleven retained elaboration, lint or
heartbeat failures. In particular, concrete composition016 and partially
specialized frame018 hit the unchanged two-million heartbeat limit; a fully
generic state frame followed by specialization passed. Raw snapshots/logs
and earlier retained findings remain. No mathematical counterexample, new
memory failure, linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all142 predecessor626 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next628: execute the original bezout initial zero-length/oddness checks on
these selected images, preserving both possible outcomes as needed; then
continue the complete Bezout source and derive its actual return. Root/
certificate/codec and full B1 remain open. No mathematical NTT/CRT/root/
table/centering/Montgomery/integer law, full KeyGen/Sign/compiler/security
or unconditional positivity/probability is claimed. Old110/measured/five
do_sign retain prior scope.
