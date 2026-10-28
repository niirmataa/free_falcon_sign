# R1 complete selected d=6 make_fg_step and caller return — checkpoint 612

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The complete original sixth make_fg_step body executes from its actual
selected caller after the constructed d1..d5 calls. The first 22-prime loop
from611, part3 fs/gs zint_rebuild_CRT pair and part4 extra-prime loop
u22..41 share the same output state. The actual CRT callee initializes
tmp[0] from PRIMES3[0], executes the bounded co-loop at num16 and
xlen=xstride22, then runs signed normalization on352 words. The generic
exact-room co-loop from602 is reused; no mathematical CRT or centering law
is assumed.

The extra loop uses generic source-bound PRIMES3 rows22..41, actual
p/p0i/R2/Rx prefix (slen22), signed-store walks,16-word Level3 ternary
forwards and8-product stride42 marches for both sides. An inductive
invariant binds all generator tables to the same execution and preserves
the first22 product columns, every earlier extra column, normalized source
rows and readonly static objects. The original u22 initialization and
false u<42 terminal guard are executed, using the real d6 gd root1006.

All42 fd and42 gd product columns are gathered into both flat336-word
output arrays at stride42. The original sixth call and enclosing source
body return these arrays to the caller; the actual d6-to7 increment and
true d<depth guard are constructed. No desired source run or output is a
premise of this concrete selected export. Later d levels are not executed.

Canonical keygen_sixth612_canonical accepted16/16, exit0, diagnostics0/0,
warningAsError. Seven checked interfaces and104 axiom results use only
propext/Classical.choice/Quot.sound. Lean time97.515s; maximum cumulative
child RSS5812988 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets
and bwrap --unshare-net were maintained. Some modules inherit the602
maxRecDepth262144 source setting; no memory limit was raised.
Independent review: NOT_RUN.

Nine local attempts were accepted with no failures. Prior retained
findings, including611's memory-ceiling failure and documentation
supplement for606/609, are preserved. No new mathematical counterexample,
resource failure, linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all255 predecessor611 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. A local source commit is not independent acceptance.

Next613: actual d7 entry/layout/move, checking separately the old source
and new destination roots in the overlapping move. Later d7..9,
root/certificate/codec and full B1 remain open. No mathematical CRT/
centering/Montgomery/NTT/root/table/integer law, broad KeyGen/Sign/compiler/
security or unconditional positivity/probability is claimed. Old110/
measured/five do_sign retain their prior scope.
