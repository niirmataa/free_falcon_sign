# Continuation after checkpoint 192 — inverse call s3 sealed

Checkpoint 192 is sealed: the original make_fg_step first-prime inverse
call s3 executes at the actual selected seed9 product output and the
stage statement `KeygenMakeFgSource.Exec MakeFgTailShape190.s3
productOut out` is closed (SelectedStepInverse192). Whole owner goal
stays ACTIVE / NOT_COMPLETE; the package is IN_PROGRESS /
PARTIAL_PROOF / NOT_REVIEWED with the 192 scope PROVED_KERNEL_SCOPED /
NOT_REVIEWED. At resume verify POSTSEAL_192 (`.build/stepinverse192/
POSTSEAL_192.json`) and the sealed receipt `notes/run/
KEYGEN_STEP_INVERSE_192.json` against their external pins in
`notes/run/KEYGEN_STEP_INVERSE_192_PINS.md`, re-check the inherited pin
chain carried inside POSTSEAL_192, and confirm no active owned job/
Lean/Sage process before any new proof work. Next unused proof job
suffix is 459. Keep one Lean process (`tools/job111.py`, `-j1 -M6144`),
logs 0/0, standard axioms. Never edit sealed 191/192 sources.

## State of the source obligations (in order)

1. (closed) s3 of the first-prime tail: the KeygenLevelCalls.Bind of
   `modp_iNTT3_ext(fs + u, slen, igm, logn, 0, p, p0i)` at the
   SelectedStepProduct191.source product output, the complete pinned
   corpus execution as one `Exec KeygenLevelNtt.inverse` (prologue with
   n = 512 / hn = 256, the skipped divide-by-three pass at full = 0,
   the eight intermediate doubling rounds, the degree-1 final pass at
   w = igm[0], and the corrective 1/n Montgomery scaling with the
   modp_R/modp_div cell words), the fvAt8-to-finalWord-to-scale word
   bridges, and the s3 branch composition. The u = none trap is fixed:
   the correction uInit runs over the old cell `some (u64 256)` left by
   the final pass (NttInverseCorrectionInit192).
2. `SelectedStepInverse192` export follow-up (open, small): the s3
   theorem takes the product-output facts as hypotheses — the copied
   fs image `∀ i < 512, Load32 productOut.heap (elem fs i) (fvs i)`,
   the igm twiddle loads `tws`, the fs writable/capacity/separation
   geometry and the caller frame (locals outside v, arrays outside x).
   Discharge the fs-image and twiddle-load keeps through the copy and
   product writes (separation of the fs/gm/igm regions from the t1/fd
   walk positions) and the product-output caller frame from
   SelectedStepProduct191.source's export at the step assembly; the
   stage statement itself is unconditional there.
3. The gs path s4-s7 (copy/product/inverse on gs/t1/gd), the false
   `!out_ntt` guard s8 (its body is the fd/gd inverse pair at
   logn-1 = 8 and tlen = 2 — a DIFFERENT instance of the corpus that
   will need a logn-8 control variant of the prologue size lemma), the
   outer u++/final guard tail, both CRT calls and the additional-prime
   part (slen1/tlen2), the remaining d-levels and the
   root/certificate/codec path stay OPEN.

Only the complete emitted source witness can instantiate the
corrected134 consumers (KeygenModelUnlock134.package_of_witness,
KeygenSuccessMass134.success_lower_of_witness); their prospective bound
remains Z>=2^-256>0 and is NOT a theorem established by 192.

Paper wording stays measured 8192/23628 with the separate 256/739
control. No IID/D1/F04/empirical premise; exactly five do_sign items
remain. Keep all failed jobs and their recorded causes (register 58
entries). No push or independent-review claim.
