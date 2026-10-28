# R1 conditional selected Bezout unit branches — checkpoint 635

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The actual first part6 short-circuit condition and early return are executed on
a selected witness, conditional on the initial guard passing and the symbolic
x-unit test being true. Original parts3/4/5 and the actual part6 return1 are
composed on that witness. The guard and unit-test truth are not asserted.

A separately quantified selected witness executes original parts3/4/5 and the
actual part6 second unit branch, assuming the initial guard passes, x-unit is
false and y-unit true. Both actual source copies run, part6 returns1 and the
u and v copied prefixes have exact selected word images Y and masked X. This
is not a claim about all remaining output words or an integer Bezout identity.

Canonical keygen_unit635_canonical accepted8/8, exit0, diagnostics0/0,
warningAsError; 14 axiom results use only propext/Classical.choice/Quot.sound.
Lean time 346.647s; maximum cumulative child RSS 3052088 KiB. One Lean job, -j1,
-M6144, unchanged AS/RSS/wall budgets and bwrap --unshare-net were maintained.
Some sources use maxRecDepth262144 as established; no memory limit raised.
Independent review: NOT_RUN.

Nine prior local attempts include retained failure007, an unknown identifier in
an intermediate source; corrected by the explicit pointer shape in008 under
unchanged limits. Raw snapshots/logs and all earlier retained findings remain.
No mathematical counterexample or failed lane-cache artifact is claimed.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all287 predecessor634 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next636: execute the original nonunit continuation, including its two actual
modp_ninv31 calls, without assuming branch outcomes, then continue the Bezout
algorithm and selected result. Root/certificate/codec/full B1 remain open.
No mathematical NTT/CRT/root/table/centering/Montgomery/integer law, full
KeyGen/Sign/compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain prior scope.
