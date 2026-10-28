# R1 selected deepest bezout entry and source prefix — checkpoint 626

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

After the actual selected deepest CRT execution, both reconstructed335-word
fp/gp inputs are split and bound to x/y of the original zint_bezout call;
its u/v, length335 and scratch arguments are also bound to the actual caller
buffers. The pinned callee source parts0/1 execute all declarations and six
working-pointer setups; they preserve both input images on the same selected
execution witness. No desired source run or output is assumed.

The subsequent zint_exact_length calls, data-dependent checks, iterative
Bezout body and returned success/failure are not executed by this checkpoint.
In particular, this result does not claim the inputs are odd/coprime or that
Bezout succeeds, nor does it establish the whole root solve or B1.

Canonical keygen_bezout626_canonical accepted5/5, exit0, diagnostics0/0,
warningAsError. Four checked interfaces and15 axiom results use only
propext/Classical.choice/Quot.sound. Lean time30.26s; maximum cumulative child
RSS4843780 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Selected source uses maxRecDepth262144;
no memory limit was raised. Independent review: NOT_RUN.

Nine local attempts include three retained failures:003 used the wrong
helper namespace,005 hit the unchanged two-million heartbeat limit when
unfolding a heap equality, and007 used a reserved Lean identifier. Corrected
in004/006/008, with compositional heap proof and unchanged limits. Raw
snapshots/logs remain; no new mathematical counterexample, memory failure,
linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all128 predecessor625 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next627: execute the actual zint_exact_length calls on these inputs and the
initial data-dependent guards, then continue the full Bezout source and its
actual return. Root/certificate/codec and full B1 remain open. No mathematical
NTT/CRT/root/table/centering/Montgomery/integer law, full KeyGen/Sign/
compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain prior scope.
