# R1 Bezout original loop and first guard structure — checkpoint 640

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Using the actual part7 successful parse and the pinned token prefix, small
structural parser inversions prove that the original part7 AST begins with the
constant-true for-loop, containing a scoped int r declaration followed by the
first if with exactly the pinned (alen>=3 || blen>=3) guard. This establishes
the precise source projection that hit OOM in637 without expanding the full
185-line AST or raising limits.

On one selected witness, assuming the earlier good guard and both nonunit
conditions, original parts3–6 execute, the same declaration executes as a
standalone statement and that exact guard evaluates to the symbolic length
Boolean. This does NOT yet execute the part7 loop or either branch body; no
branch truth, loop termination or complete Bezout result is asserted.

Canonical keygen_ast640_canonical accepted9/9, exit0, diagnostics0/0,
warningAsError; 10 axiom results use only propext/Classical.choice/Quot.sound.
Lean time 1058.712s; maximum cumulative child RSS 1769432 KiB. One Lean job, -j1,
-M6144, unchanged AS/RSS/wall budgets and bwrap --unshare-net were maintained.
Some sources use maxRecDepth262144 as established; no memory limit raised.
Independent review: NOT_RUN.

Nine local attempts retain one elaboration failure, fixed by normalizing the
for token and case equality. Raw snapshots/logs and all earlier findings remain;
no mathematical counterexample or failed lane-cache artifact is claimed.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all220 predecessor639 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next641: actual first loop iteration and selected accelerated/small branch,
then remaining Bezout/root/certificate/codec/full B1. No mathematical NTT/CRT/
root/table/centering/Montgomery/integer law, full KeyGen/Sign/compiler/security
or unconditional positivity/probability is claimed. Old110/measured/five do_sign
retain prior scope.
