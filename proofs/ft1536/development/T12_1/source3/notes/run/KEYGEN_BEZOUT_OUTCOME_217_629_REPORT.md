# R1 conditional selected bezout outcomes — checkpoint 629

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Both outcomes of the selected symbolic initial bezout guard are connected
to the same actual source witness. If the guard is true, the original full
zint_bezout callee exits with int32 0, the actual solve_NTRU_deepest source
returns0, and the root-search deepest gate rejects. If the guard is false,
the actual guard continues normally and both source length values are
nonzero with a nonzero low-bit conjunction. Input images remain available.

This is a conditional source result: the guard has not been evaluated to a
concrete value, so neither an actual failure nor an actual success is
asserted. In the false case the remaining Bezout initialization, loops and
return still require proof. No mathematical coprimality, Bezout identity or
security claim follows from this checkpoint.

Canonical keygen_flow629_canonical accepted5/5, exit0, diagnostics0/0,
warningAsError. Four checked interfaces and nine axiom results use only
propext/Classical.choice/Quot.sound. Lean time137.19s; maximum cumulative child
RSS4741096 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Selected source uses maxRecDepth262144;
no memory limit was raised. Independent review: NOT_RUN.

Ten local attempts include four retained elaboration failures involving a
redundant tactic, missing noncomputable marker, Bool simplification and
conjunction association. Each was corrected; raw snapshots/logs and earlier
retained findings remain. No mathematical counterexample, new resource
failure, linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all131 predecessor628 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next630: execute original Bezout initialization and remaining source under
the good branch, or derive the selected guard value without assuming it;
then finish root/certificate/codec/full B1. No mathematical NTT/CRT/root/
table/centering/Montgomery/integer law, full KeyGen/Sign/compiler/security
or unconditional positivity/probability is claimed. Old110/measured/five
do_sign retain prior scope.
