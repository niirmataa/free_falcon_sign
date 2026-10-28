# R1 conditional selected Bezout initialization parts4/5 — checkpoint 634

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Under the explicit condition that the selected initial guard is false, the
previously executed initialization fragments are re-associated into the
original Bezout source parts3/4/5. Both remaining source upper a/b memset
operations execute and the selected a/b outputs are exported on the same
witness as exact word images padded with zero up to mlen=max(xlen,ylen).
The actual source order, bounded symbolic lengths, memory separation and
frames are preserved.

Separately, an abstract frame produces a compact selected theorem showing
u0[0]=1, all334 remaining u0 words zero and all335 v0 words zero under the
same kind of good-guard condition. It repairs the retained633 direct-wrapper
OOM without raising limits. These are separate existential exports; no claim
is made here that their witnesses coincide without additional composition.
The selected guard truth is not evaluated and the later Bezout body/return
and root-solve outcome remain open.

Canonical keygen_upper634_canonical accepted13/13, exit0, diagnostics0/0,
warningAsError. Seven checked interfaces and17 axiom results use only
propext/Classical.choice/Quot.sound. Lean time116.865s; maximum cumulative child
RSS4173736 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Some sources use maxRecDepth262144 as in
602; no memory limit was raised. Independent review: NOT_RUN.

Seventeen local attempts include three retained failures:003 was an
elaboration issue,010 hit -M6144 OOM in an oversized selected all-images
export, and013 had a reversed skip equality. Compact/abstract exports passed
without increasing limits. Raw snapshots/logs and earlier findings remain;
no mathematical counterexample, linter suppression or failed lane-cache
artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all257 predecessor633 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next635: actual Bezout part6 special x=1/y=1 branches or normal continuation,
then the full algorithm and actual return without assuming selected outcome.
Root/certificate/codec/full B1 remain open. No mathematical NTT/CRT/root/
table/centering/Montgomery/integer law, full KeyGen/Sign/compiler/security
or unconditional positivity/probability is claimed. Old110/measured/five
do_sign retain prior scope.
