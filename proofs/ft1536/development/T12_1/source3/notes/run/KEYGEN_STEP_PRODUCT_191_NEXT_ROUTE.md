# Continuation after checkpoint191 — pair-product loop s2 closed

Whole owner goal ACTIVE / NOT_COMPLETE. Checkpoint191 is
PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED. At resume verify
POSTSEAL_191.json against its external pin and all inherited hashes into a
fresh ENTRY_PINS192, then inspect active processes and job directories.
Next unused proof job suffix after audit376 is377. Keep the same limits and
one Lean process. Never edit sealed191 sources.

## Exact next source obligation

```lean
KeygenMakeFgSource.Exec MakeFgTailShape190.s3 productOutput out
```

at the product-loop output state exported by SelectedStepProduct191.source
(the existential `out` of its composition with SelectedStepCopy190.source),
with the original first-prime iteration scope still to be kept. The
statement s3 is the
active inverse-call branch (in_ntt=1) containing modp_iNTT3_ext(fs+u, slen,
igm, logn, 0, p, p0i); its body must be split into prologue/passes/
correction like the forward 182-185 (NttPrologue182/NttFirst182/
NttMLoop183/NttTriple184 pattern), reusing only helpers whose actual
parameter types fit. The full0 inverse table is only read as executed loads.

## Established actual state

MakeFgProductShape191.s2_shape fixes the exact s2 syntax against the
parser. StepProductBody191.body_state shows one product iteration's net
effect is exactly one heap write; StepProductLoop191.source runs all 256
iterations. SelectedStepProduct191.source composes the original copyF
execution of SelectedStepCopy190 with the s2 execution: the output state
exports Fixed (fd/t1 buffers, cells p/p0i/R2/hn/tlen), v=256,
x=fd+512, the written product image as executed Montgomery words, and
locals/arrays preservation outside v/x relative to the root state.

## Remaining first iteration and whole witness

1. Execute the active inverse source call modp_iNTT3_ext(fs+u,slen,igm,
   logn9,full0,p,p0i) at the s2 output: prologue, passes, correction.
2. Repeat the source copy/product/inverse path for gs/t1/gd in order
   (s4-s7).
3. Execute the false !out_ntt guard (s8), restore the iteration scope,
   outer u++ to 1 and final false u1<slen1 guard. Then execute both CRT
   calls and the additional-prime part (slen1,tlen2), with its actual
   transforms/products.
4. Complete the remaining d-levels, deepest CRT/Bezout/carries, intermediate
   and depth0/root validation, certificate and encoding. Only the complete
   emitted source witness can instantiate the corrected134 consumers.

KeygenModelUnlock134.package_of_witness and
KeygenSuccessMass134.success_lower_of_witness remain conditional on that
complete witness. Their prospective bound is Z>=2^-256>0, NOT a theorem
instantiated by191. Old110 stays frozen with its recorded dispatch defect;
KeygenProbability134 is the corrected target. No numeric p_accept,
conditional coding lower bound or concrete positive p_K is established.

Paper wording remains measured8192/23628 with separate256/739 control.
No IID/D1/F04/empirical premise; exactly five do_sign items remain:
key/certificate transport; AttemptShape/ReplyShapeAt; PointwiseStageRoad's
four conditions; rounding/int16/syndrome; sampler loop and honest-signing
PRG hybrid. Keep all failed jobs and their recorded causes. No push or
independent-review claim. Sources and exact hashes are listed in
KEYGEN_STEP_PRODUCT_191_PINS.md.
