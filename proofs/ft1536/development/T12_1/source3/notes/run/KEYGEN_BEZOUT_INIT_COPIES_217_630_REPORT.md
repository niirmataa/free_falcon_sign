# R1 conditional selected bezout initialization copies — checkpoint 630

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Under the explicit condition that the selected initial guard is false, the
original first two statements of bezout part4 execute on the selected state:
memcpy(a,x,xlen*4) and memcpy(b,y,ylen*4). The symbolic lengths are the
source-computed highest-nonzero word indices from627. Nonoverlap, initialized
source bytes, object bounds and writable memory are constructed against the
actual source pointer geometry. Both original335-word inputs remain intact,
and the copied a/b prefixes have exactly the source word images on the same
execution witness.

The guard condition has not been evaluated. This result does not assert the
copies are reached unconditionally, that the remaining initialization or
Bezout body executes, or that the root solve succeeds. It is a source-word
execution result, not a mathematical Bezout or CRT law.

Canonical keygen_init630_canonical accepted7/7, exit0, diagnostics0/0,
warningAsError. Four checked interfaces and17 axiom results use only
propext/Classical.choice/Quot.sound. Lean time48.633s; maximum cumulative child
RSS4502852 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Some source modules use maxRecDepth262144
as in602; no memory limit was raised. Independent review: NOT_RUN.

Twelve local attempts include three retained elaboration/recursion-depth
failures005/007/008 when concrete pointer/allocation terms were overexpanded;
an abstract-heap allocation lemma fixed the proof. Raw snapshots/logs and
earlier findings remain. No mathematical counterexample, new memory failure,
linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all151 predecessor629 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next631: original remaining Bezout initialization, including length
assignments, stores, memset and further copies, then the full algorithm and
actual return; root/certificate/codec/full B1 remain open. No mathematical
NTT/CRT/root/table/centering/Montgomery/integer law, full KeyGen/Sign/
compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain prior scope.
