# R1 complete selected d=5 make_fg_step and caller return — checkpoint 609

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The complete original fifth make_fg_step body now executes from its actual
selected caller after the constructed d1..d4 calls. The first twelve-prime
loop from608, part3 fs/gs zint_rebuild_CRT pair and part4 extra-prime loop
u12..21 share the same output state. The actual CRT callee initializes
tmp[0] from PRIMES3[0], executes the bounded co-loop at num32 and
xlen=xstride12, then runs signed normalization on384 words. The generic
exact-room co-loop from602 is reused; no mathematical CRT or centering law
is assumed.

The extra loop uses source-bound PRIMES3 rows12..21, actual p/p0i/R2/Rx
prefix (slen12), signed-store walks,32-word Level4 ternary forwards and
16-product stride22 marches for both sides. An inductive invariant binds
all generator tables to the same execution and preserves the first twelve
product columns, every earlier extra column, normalized source rows and
readonly static objects. The original u12 initialization and false u<22
terminal guard are executed, using the real d5 gd root1022.

All22 fd and22 gd product columns are gathered into both flat352-word
output arrays at the actual stride22. The original fifth call and enclosing
source body return these arrays to the caller; the actual d5-to6 increment
and true d<depth guard are constructed. No desired source run or output is
a premise of the concrete selected export. Later d levels are not executed
by that theorem.

Canonical keygen_fifth609_canonical accepted17/17, exit0, diagnostics0/0,
warningAsError. Seven checked interfaces and124 axiom results use only
propext/Classical.choice/Quot.sound. Lean time94.266s; maximum cumulative
child RSS5836432 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets
and bwrap --unshare-net were maintained. Some modules inherit the602
maxRecDepth262144 source setting; no memory limit was raised.
Independent review: NOT_RUN.

Ten local attempts were accepted with no failures. Prior retained findings,
including605's memory-ceiling failure and604's documentation supplement,
are preserved. No new mathematical counterexample, resource failure,
linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all300 predecessor608 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. A local source commit is not independent acceptance.

Next610: actual d6 entry/layout/move; source gd from the preceding d5 output
starts at1022, while new d6 destination gd starts at1006. The overlapping
move must use the previous source layout. Later d6..9, root/certificate/
codec and full B1 remain open. No mathematical CRT/centering/Montgomery/
NTT/root/table/integer law, broad KeyGen/Sign/compiler/security or
unconditional positivity/probability is claimed. Old110/measured/five
 do_sign retain their prior scope.
