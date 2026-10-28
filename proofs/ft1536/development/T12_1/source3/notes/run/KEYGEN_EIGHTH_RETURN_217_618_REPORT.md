# R1 complete selected d=8 make_fg_step and caller return — checkpoint 618

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The complete original eighth make_fg_step body executes from its actual
selected caller after constructed d1..d7 calls. First82-prime loop from617,
part3 fs/gs zint_rebuild_CRT pair and part4 extra-prime loop u82..165 share
the same output state. The actual CRT callee initializes tmp[0] from
PRIMES3[0], executes the bounded co-loop at num4 and xlen=xstride82, then
runs signed normalization on328 words. The generic exact-room co-loop from602
is reused; no mathematical CRT or centering law is assumed.

The extra loop uses generic source-bound PRIMES3 rows82..165, actual
p/p0i/R2/Rx prefix (slen82), signed-store walks,4-word Level1 ternary
forwards and2-product stride166 marches for both sides. An inductive
invariant binds all generator tables to the same execution and preserves
first82 product columns, every earlier extra column, normalized source rows
and readonly static objects. The original u82 initialization and false
u<166 terminal guard are executed, using actual d8 gd root1002.

All166 fd and166 gd product columns are gathered into both flat332-word
output arrays at stride166. Original eighth call and enclosing source body
return these arrays to the caller; the actual d8-to9 increment and true
next guard are constructed. No desired source run or output is a premise of
this concrete selected export. The later d9 level is not executed.

Canonical keygen_eighth618_canonical accepted16/16, exit0, diagnostics0/0,
warningAsError. Seven checked interfaces and104 axiom results use only
propext/Classical.choice/Quot.sound. Lean time131.995s; maximum cumulative child
RSS5852388 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Some modules inherit the602
maxRecDepth262144 source setting; no memory limit was raised.
Independent review: NOT_RUN.

Eleven local attempts include one retained failure: attempt004 changed a
Fin4 byte index to Fin2 and subsequently emitted a kernel memory diagnostic.
Corrected in005 under the same limit; raw source snapshot and logs remain.
This is no mathematical counterexample. Earlier retained findings remain;
no new linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all260 predecessor617 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. A local source commit is not independent acceptance.

Next619: actual d9 entry/layout/move, including the source outExpr: d+1=10
no longer satisfies d+1<depth10 and the selected top out_ntt is0. Its
argument and the resulting true !out_ntt branch must be constructed; the
previous false-branch skip cannot be reused. Later d9 body, root/certificate/
codec and full B1 remain open. No mathematical CRT/centering/Montgomery/NTT/root/
table/integer law, broad KeyGen/Sign/compiler/security or unconditional
positivity/probability is claimed. Old110/measured/five do_sign retain scope.
