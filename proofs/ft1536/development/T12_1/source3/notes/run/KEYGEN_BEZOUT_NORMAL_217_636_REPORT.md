# R1 conditional selected Bezout nonunit continuation — checkpoint 636

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Under explicit conditions that the initial guard passes and both unit tests
are false, original Bezout parts3/4/5 and part6 execute normally on one
selected witness. The latter calls the actual modp_ninv31 source twice and
stores the exact source-derived x0i/y0i word values. Heap and array bindings
are unchanged by these assignments. These conditions are symbolic; no claim
is made that the selected run satisfies them or that arbitrary inputs obey an
inverse arithmetic law.

Canonical keygen_normal636_canonical accepted5/5, exit0, diagnostics0/0,
warningAsError; 12 axiom results use only propext/Classical.choice/Quot.sound.
Lean time 196.648s; maximum cumulative child RSS 3192248 KiB. One Lean job, -j1,
-M6144, unchanged AS/RSS/wall budgets and bwrap --unshare-net were maintained.
Some sources use maxRecDepth262144 as established; no memory limit raised.
Independent review: NOT_RUN.

Five local attempts retain failure004, an elaboration error from assuming that
uint32 conversion reduces by rfl. The existing source slot lemma repaired it
in005 under unchanged limits. Raw snapshots/logs and earlier findings remain;
no mathematical counterexample or failed lane-cache artifact is claimed.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all159 predecessor635 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next637: original Bezout main loop entry and accelerated/small-case guards,
then full algorithm and selected result. Root/certificate/codec/full B1 remain
open. No mathematical NTT/CRT/root/table/centering/Montgomery/integer law,
full KeyGen/Sign/compiler/security or unconditional positivity/probability
is claimed. Old110/measured/five do_sign retain prior scope.
