# R1 conditional Bezout loop guard source line — checkpoint 637

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Under explicit initial good-guard and nonunit conditions, original Bezout
parts3–6 execute on one selected witness. A separately constructed local r
declaration executes afterward and, in that state, the expression parsed
by the kernel from pinned C source line4022 evaluates exactly to the symbolic
short-circuit Boolean (alen>=3 || blen>=3), with alen and blen equal to the
selected highest-word lengths. The conditions and Boolean are not evaluated
for a particular concrete input.

The original whole part7 parser's projection to this source line is NOT yet
proved, nor is execution of part7, the loop, or either branch. Attempts002 and
006 to expand the full parsed part exceeded -M6144; the short source-line parse
is an independently checked partial step and does not silently bridge that gap.
A structural parser decomposition remains necessary.

Canonical keygen_loop637_canonical accepted6/6, exit0, diagnostics0/0,
warningAsError; 11 axiom results use only propext/Classical.choice/Quot.sound.
Lean time 89.225s; maximum cumulative child RSS 3460864 KiB. One Lean job, -j1,
-M6144, unchanged AS/RSS/wall budgets and bwrap --unshare-net were maintained.
Some sources use maxRecDepth262144 as established; no memory limit raised.
Independent review: NOT_RUN.

Twelve completed local attempts retain six failures: two proof-size OOMs and
four elaboration failures, with successful factored partial results. Attempt008
was interrupted by turn reset and has no final receipt; source snapshot, preflight
and empty logs are preserved and pinned, neither success nor mathematical failure.
Raw snapshots/logs and earlier findings remain; no mathematical counterexample
or failed lane-cache artifact is claimed.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all99 predecessor636 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next638: structural source binding and original part7 loop/branch execution,
then full algorithm and selected result. Root/certificate/codec/full B1 remain
open. No mathematical NTT/CRT/root/table/centering/Montgomery/integer law,
full KeyGen/Sign/compiler/security or unconditional positivity/probability
is claimed. Old110/measured/five do_sign retain prior scope.
