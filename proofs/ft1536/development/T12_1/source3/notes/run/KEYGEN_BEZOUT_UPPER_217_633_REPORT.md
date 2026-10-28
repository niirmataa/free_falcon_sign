# R1 conditional selected Bezout upper zeroing — checkpoint 633

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Under the explicit condition that the selected initial guard is false, the
original Bezout part5 upper u/v memset statements and mlen conditional
execute after the earlier selected initialization. The resulting mlen is
max(alen,blen); earlier x/y/a/b/u1/v1 data, lower zero ranges and u0[0]=1
remain intact on the same witness. Bounds, source pointers and memory frames
are constructed, including empty upper ranges.

Generic kernel theorems also give exact upper zero-word images and combine
them with matching lower ranges. A direct wrapper exporting these images on
the selected symbolic witness hit the unchanged -M6144 memory limit in015;
it is retained and is not claimed as passed. Selected guard truth, full
part4 composition, remaining part5 a/b zeroing and Bezout result remain open.

Canonical keygen_upper633_canonical accepted9/9, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and22 axiom results use only
propext/Classical.choice/Quot.sound. Lean time40.297s; maximum cumulative child
RSS4508408 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Some source modules use maxRecDepth262144
as in602; no memory limit was raised. Independent review: NOT_RUN.

Seventeen local attempts include seven retained failures, including the015
OOM. Their source snapshots/logs and earlier findings remain. No mathematical
counterexample, linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all162 predecessor632 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next634: factor selected upper-image instantiation, compose actual part4,
execute remaining part5 a/b zeroing and continue Bezout without assuming the
guard outcome. Root/certificate/codec/full B1 remain open. No mathematical
NTT/CRT/root/table/centering/Montgomery/integer law, full KeyGen/Sign/
compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain prior scope.
