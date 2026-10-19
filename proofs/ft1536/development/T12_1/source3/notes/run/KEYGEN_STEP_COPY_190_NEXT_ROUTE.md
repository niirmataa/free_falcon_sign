# Continuation after checkpoint190 — first-prime f copy path closed

Whole owner goal ACTIVE / NOT_COMPLETE. Checkpoint190 is
PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED. The exact resume point
is the copy output state of SelectedStepCopy190.source: obtain
`⟨out, copyRun, fixRun, vRun, xRun, copyRun, localRun, arrayRun, skipRun⟩`
from `SelectedStepCopy190.source` and continue with the original pair-product
statement `MakeFgTailShape190.s2` at `out`. Next unused proof job suffix361.
Keep the same limits and one Lean process. Never edit sealed190 sources.

## Exact next source obligations

1. `KeygenMakeFgSource.Exec MakeFgTailShape190.s2 out out'` — the original
   v=0, x=fd+u setup and 256 pair products into fd with stride tlen2:
   loads t1[(v<<1)+0] and t1[(v<<1)+1], two nested modp_montymul calls with
   the source p/p0i/R2 and the store through the walked pointer. The words
   are exactly `SelectedStepCopy190.fv` from the executed copy
   (`PrefixImage out t1 fv 512`); the products are source executions, not
   transform identities. p/p0i/R2 cells come from the preserved root locals
   through `localRun`.
2. `KeygenMakeFgSource.Exec MakeFgTailShape190.s3 out' out''` — the active
   `modp_iNTT3_ext(fs+u, slen, igm, logn, 0, p, p0i)` call at the true
   in_ntt/ter branches: `KeygenLevelCalls.Call .inverse` with the original
   `KeygenLevelNtt.inverse` body. No complete inverse-body execution exists
   yet; it needs the same prologue/pass treatment as the forward body in
   182-185 (logn9/full0 shape), plus the corrective factor loop.
3. Repeat the copy/products/inverse path for gs/t1/gd (statements s4-s7),
   reusing the f proofs with the g read facts (SelectedGen0Frame189.g_read).
4. Execute the false !out_ntt branch s8 (out_ntt=1), restore the iteration
   scope, outer u++ to1 and the final false u<slen guard; then both
   zint_rebuild_CRT calls and the additional-prime part (slen1,tlen2) with
   its own transforms/products.
5. Complete the remaining d-levels, deepest CRT/Bezout/carries, intermediate
   and depth0/root validation, certificate and encoding. Only the complete
   emitted source witness can instantiate the corrected134 consumers.

## Established actual state

SelectedStepCopy190.source closes the original fs-to-t1 copy loop at the
actual selected first-prime state: copyInit (v=0 and x=fs+u), all 512 source
copies with the two-clause increment (v++, x+=slen), the exact walked
pointer, and the false !in_ntt branch. The image of t1[0..512) is exactly
the preserved fs words (`SelectedStepCopy190.fv`), all as executed loads;
v=512 and x=fs+512 afterwards. Locals outside v and arrays outside x are
preserved to the root state (`localRun`/`arrayRun`), so the p/p0i/R2, hn,
tlen, in_ntt, out_ntt and u cells of the step are all still readable at the
copy output.

Generic infrastructure added: StepCopyBody190 (one copy iteration and its
increment, exact PointerAdd walks), StepCopyFixed190 (invariant with stable
source reads and the copied prefix), StepCopyLoop190 (512-step induction),
MakeFgTailShape190 (the nine original tail statements named against the
parser by decide, including the copy, product, inverse and out_ntt shapes).

## Remaining and whole witness

KeygenModelUnlock134.package_of_witness and
KeygenSuccessMass134.success_lower_of_witness remain conditional on the
complete emitted witness. Their prospective bound is Z>=2^-256>0, NOT a
theorem instantiated by190. Old110 stays frozen with its recorded dispatch
defect; KeygenProbability134 is the corrected target. No numeric p_accept,
conditional coding lower bound or concrete positive p_K is established.

Paper wording remains measured8192/23628 with separate256/739 control.
No IID/D1/F04/empirical premise; exactly five do_sign items remain:
key/certificate transport; AttemptShape/ReplyShapeAt; PointwiseStageRoad's
four conditions; rounding/int16/syndrome; sampler loop and honest-signing
PRG hybrid. Keep all failed jobs and their recorded causes. No push or
independent-review claim. Sources and exact hashes are listed in
KEYGEN_STEP_COPY_190_PINS.md.
