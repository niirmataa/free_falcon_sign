# R1 complete selected d=4 make_fg_step and caller return — checkpoint 606

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The complete original fourth make_fg_step body now executes from its
actual selected caller after the constructed d1/d2/d3 calls. The first
six-prime loop from605, the part3 fs/gs zint_rebuild_CRT pair and the
part4 extra-prime loop u6..11 share the same output state. The actual CRT
callee initializes tmp[0] from PRIMES3[0], executes the bounded co-loop
at num64 and xlen=xstride6, then runs signed normalization on384 words.
The generic exact-room co-loop from602 is reused; no mathematical CRT or
centering law is assumed.

The extra loop uses source-bound PRIMES3 rows6..11, the actual p/p0i/R2/Rx
prefix (slen6), signed-store walks,64-word Level5 ternary forwards and the
32-product stride12 marches for both sides. An inductive invariant binds
all generator tables to the same execution and preserves the first six
product columns, every earlier extra column, normalized source rows and
readonly static objects. The original u6 initialization and false u<12
terminal guard are executed.

All twelve fd and twelve gd product columns are gathered into both flat
384-word output arrays at the actual stride12. The original fourth call
and enclosing source body return these arrays to the caller; the actual
d4-to5 increment and true d<depth guard are constructed. No desired
source run or output is a premise of the concrete selected export. Later
d levels are not executed by that theorem.

Canonical keygen_fourth606_canonical accepted17/17, exit0, diagnostics0/0,
warningAsError. Seven checked interfaces and116 axiom results use only
propext/Classical.choice/Quot.sound. Lean time93.417s; maximum cumulative
child RSS5816740 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets
and bwrap --unshare-net were maintained. Some modules inherit the602
maxRecDepth262144 source setting; no memory limit was raised.
Independent review: NOT_RUN.

Fourteen local attempts retain one elaboration failure:007's scaffolding
substitution changed a uint64 state word into BitVec32. Lean reported a
generated error placeholder after the type errors; no proof marker was
inserted into a source. Restoring BitVec64 resolved the failure. No new
mathematical counterexample, resource failure, linter suppression or failed
lane-cache artifact occurred. Prior retained findings, including605's
-M6144 ceiling failure and its604 documentation supplement, are preserved.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all361 predecessor605 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. A local source commit is not independent acceptance.

Next607: actual d5 entry/layout/move; source gd from the preceding d4 output
starts at1054, while the new d5 destination gd starts at1022. The move must
bind the previous source layout correctly before later d5 computation.
Later d5..9, root/certificate/codec and full B1 remain open. No mathematical
CRT/centering/Montgomery/NTT/root/table/integer law, broad KeyGen/Sign/
compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain their prior scope.
