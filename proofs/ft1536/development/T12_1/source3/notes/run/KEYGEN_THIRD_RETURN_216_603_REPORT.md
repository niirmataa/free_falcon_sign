# R1 complete selected d=3 make_fg_step body and caller return — checkpoint 603

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The complete original third make_fg_step body now executes from its actual
selected caller and bound entry, after the constructed first and second
steps. Its part2 first-prime loop, part3 fs/gs CRT calls and part4 extra
prime loop share one output. All six fd and six gd product columns are
present on that output. The six columns of each array are exported as a
flat384-word executed image at the original stride6 layout. No desired
source run or output is supplied as a premise of this complete export.

The original602 extra loop's LoopKeep framed reads outside every product
column; it did not expose the preservation of first-loop columns0..2.
A new ThreeKeep contract is proved on the same execution witness and
outputs as the u3..5 loop. It transports earlier product columns without
combining independent existential runs. Part3's CRT write frame similarly
preserves all product columns. Sealed602 sources and proofs are unchanged.

The original third .step call and enclosing body return both flat images
to their actual caller. The source d3-to4 increment and true d<depth guard
are constructed; further d levels are not executed by this theorem.
Context cells and readonly PRIMES3/REV10 facts are obtained from the
actual source states and pinned input, including the actual REV10 binding.
Executed-word formulas remain separate from mathematical transform laws.

Canonical keygen_body603_canonical accepted10/10, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and22 axiom results use only
propext/Classical.choice/Quot.sound. Lean time55.675s; maximum cumulative
child RSS5617552 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall
budgets and internal bwrap --unshare-net were maintained. Some new source
modules inherit maxRecDepth262144 from602; no memory limit was raised.
Independent review: NOT_RUN.

Twelve local attempts retain three elaboration/parser failures:006 assumed
a generic caller's REV10 binding without its domain,008 used the reserved
binder prefix,010 mismatched gather binder order. Each was repaired with
an explicit domain, legal binder or lambda respectively; no mathematical
counterexample or failed cache artifact occurred. The prior602 register,
including its two resource-ceiling failures, and all raw attempts remain.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after. Canonical602 source/snapshot/olean/logs
and4973 reused source/artifact pairs yielded9993 hash checks before/after.
Python handles scaffolding/jobs/hashes; source semantics and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. A local source commit is not independent acceptance.

Next604: actual d4 entry/layout/move using n64, slen6, tlen12, then the
remaining d levels and root/certificate/codec/full B1. No mathematical
CRT/centering/Montgomery/NTT/root/table or integer law, full KeyGen/Sign/
compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain their prior scope.
