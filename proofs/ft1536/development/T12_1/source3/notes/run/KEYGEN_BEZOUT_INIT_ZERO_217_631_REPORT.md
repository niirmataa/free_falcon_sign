# R1 conditional selected bezout initialization and zeroing — checkpoint 631

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Under the explicit condition that the selected initial guard is false, the
original Bezout initialization continues after the first two copies:
alen=xlen, blen=ylen, u0[0]=1 and the source u0/v0 memset statements execute
on the same selected witness. Exact zero-word ranges are exported, including
the empty first range when ylen=1. u0[0]=1 and the selected x/y inputs and
a/b copied prefixes remain intact; bounded lengths and required memory
frames are established from earlier source execution.

The guard condition has not been evaluated. This result does not assert
unconditional reachability, completion of Bezout initialization, the
algorithm's return or root-solve success. It is a source-word execution
result, not a mathematical Bezout or CRT law.

Canonical keygen_init631_canonical accepted11/11, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and28 axiom results use only
propext/Classical.choice/Quot.sound. Lean time39.098s; maximum cumulative child
RSS3732216 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Some source modules use maxRecDepth262144
as in602; no memory limit was raised. Independent review: NOT_RUN.

Sixteen local attempts include six retained elaboration/lint failures,
corrected without changing limits. Raw snapshots/logs and earlier findings
remain. No mathematical counterexample, new resource failure, linter
suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all186 predecessor630 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next632: execute remaining original Bezout initialization, including u1/v1
copies and v1 low-bit update, followed by upper-word zeroing and full body;
root/certificate/codec/full B1 remain open. No mathematical NTT/CRT/root/
table/centering/Montgomery/integer law, full KeyGen/Sign/compiler/security
or unconditional positivity/probability is claimed. Old110/measured/five
do_sign retain prior scope.
