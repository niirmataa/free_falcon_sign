# R1 CRT prime prefix and prime round with real proofs — checkpoint 599

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall B1 is IN_PROGRESS.
Owner decision 2026-10-27: Source3 modules are produced with real proofs,
zero markers, or not at all; scratch stays in .build. Window 599 closes
CrtPrimePrefix214 and CrtRound214.

The generalized CRT prime prefix executes the original seven statements
(declare p/p0i/s/R2 and v, read p = primes[u].p and s = primes[u].s,
p0i = modp_ninv31(p), R2 = modp_R2(p, p0i)) for an arbitrary bounded
loop index u. The p/s words are the executed struct-member reads of the
actual PRIMES3 PrimeObject at the u-th parsed row (KeygenLevelCalls.
PrimeRead), and p0i/R2 are the words returned by the actual modp_ninv31
and modp_R2 source bodies. Every private local is restored, arrays match
the caller, and the prefix state carries the exact executed words. No
desired output, certificate, table law or CRT law is supplied.

The composed prime round runs the prefix, the complete coefficient walk
(CrtWalkWhole214) and the generic multiply call (CrtMulCall213) with the
CrtRoundShape205 local names. Its output images are exact executed
words: the u+1 rewritten coefficient words of every row and the
untouched later residues (CrtWalkFlat214.words), and the u+1 product
words of tmp (CrtMulCall213.words). Modulus/data images, caller
locals/arrays and all reads outside the written cells survive. The round
is the body of the original co-reduction loop; its row index equals the
reassembled length u exactly as in the source.

The original co-reduction u-loop `for (u = 1; u < xlen; u++)` executes
completely at source level (ZintRebuildCrt194.coLoop) from u = 1 to
u = xlen with the counted body/increment. The tmpAt/rowAt families
record the executed images at each counter: the reassembled rows and the
running product of processed prime moduli. The exit state has u = xlen,
the fully reassembled row image and the product image, with the readonly
PRIMES3 object transported across every round (its block is disjoint
from the writable root/tmp blocks by the writable map). The make_fg
signed normalization is exported at xstride = xlen from the accepted
ZintNormWalkFlat208 engine with its exact word image.

Executed: 3 modules. Validated: canonical keygen_crtprimeround214_599
accepted 3/3, exit 0, diagnostics 0/0, warningAsError; four public
interfaces and 29 axiom results using only propext/Classical.choice/
Quot.sound. Lean time 51.972s; maximum cumulative child RSS 5632868 KiB.
Original limits and internal network isolation unchanged. Independent
review: NOT_RUN.

Eleven local attempts retain seven failures: 001/002 scaffolding (List
get? lemma name, ambiguous .uint64 projections, 0+u rewrite mismatch),
004 missing reuse olean in the local runner, 005/006 defeq/rewrite
scaffolding and two transfer bugs (opaque have aliases hiding after_prefix
defeq, bare address rewrite matching the wrong elem), 009/010 loop
foundation and induction scaffolding (Bool lemma name, xlen cell chain,
Data heap rewrite before intro, Name-vs-String keep, keep adapters).
No mathematical counterexample, resource failure, suppression or
failed lane-cache artifact occurred. Every raw snapshot/log and all
inherited findings remain retained. The permanent 195 bodyHeap/stepState
defect remains unused; sealed predecessors and original syntax bindings
are unchanged.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all 133 predecessor 597 bindings
verified. Fresh entry/predecessor checks completed before the first 599
proof job and again after the canonical replay. Python handles
scaffolding/jobs/hashes; all source arithmetic/execution is kernel
checked. The untracked 598 sketches (12 sorries) were read as geometry
only; snapshots live in .build/crtprime599/sketches598/ and no marker
enters Source3 or the commit. No re-baseline, production C change,
migration, stages, reviewer start or push. This checkpoint is a local
source commit, not an independent acceptance of the overall package.

The sketch geometry was sharpened where it was not executable: the
prefix state carries the exact executed words instead of zero
placeholders/existentials, the round conclusion transports the tmp
product image instead of the stale input image, the outer loop is the
source-bound coLoop (the sketch outer_u_loop conflated the walk
increment), and the signed normalization is the zint_norm_zero row walk
at xstride = xlen (the sketch called modSigned with a walk conclusion).
Later d levels/root/certificate/codec/full B1 remain open. The round and
loop do not prove a mathematical CRT/centering/Montgomery/integer/NTT/
root/table law and assume no desired output. Full KeyGen/Sign/compiler/
security and unconditional positivity/probability remain open.
Old110/measured/five do_sign keep their previous scope. WORK_STATE
records the exact next proof route; no push was made.
