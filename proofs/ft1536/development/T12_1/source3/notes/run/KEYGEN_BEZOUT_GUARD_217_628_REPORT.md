# R1 selected bezout initial guard — checkpoint 628

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Original bezout parts0..3 execute on the selected reconstructed fp/gp
inputs: declarations, working pointers, both exact-length calls and the
short-circuit zero-length/low-bit guard are composed on one witness. The
actual flow is expressed by a symbolic Boolean: xlen=0, ylen=0, or the
low-bit conjunction of x[0] and y[0] is zero yields returned int32 0;
otherwise the source continues normally. Both input images remain preserved.
No desired source run or output is a premise.

The Boolean is tied to the selected executed-word images and lengths, but is
not evaluated to a concrete true/false value here. Consequently neither
actual early failure nor progress through the remaining Bezout algorithm
is asserted. This result is not a proof that the inputs are odd/coprime or
that the root solve succeeds.

Canonical keygen_guard628_canonical accepted5/5, exit0, diagnostics0/0,
warningAsError. Four checked interfaces and10 axiom results use only
propext/Classical.choice/Quot.sound. Lean time21.604s; maximum cumulative child
RSS4450464 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Selected source uses maxRecDepth262144;
no memory limit was raised. Independent review: NOT_RUN.

Eight local attempts include two retained failures:002 needed explicit
low-bit coercion and proof-style corrections;003 hit the simplifier step
limit. Explicit source-word expressions passed in004; raw snapshots/logs
and earlier retained findings remain. No mathematical counterexample, new
memory failure, linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all307 predecessor627 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next629: determine or carry the selected guard outcome and execute the
appropriate source continuation/return; then continue full Bezout without
assuming success, followed by root/certificate/codec/full B1. No mathematical
NTT/CRT/root/table/centering/Montgomery/integer law, full KeyGen/Sign/
compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain prior scope.
