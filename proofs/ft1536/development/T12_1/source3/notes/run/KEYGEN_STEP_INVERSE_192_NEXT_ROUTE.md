# Continuation after the 192 window — inverse call s3 in progress

Whole owner goal ACTIVE / NOT_COMPLETE. Checkpoint 192 is NOT sealed and
has no POSTSEAL; the stage stays IN_PROGRESS / PARTIAL_PROOF /
NOT_REVIEWED. At resume verify ENTRY_PINS192 (`.build/stepinverse192/
ENTRY_PINS.json`, SHA256
`9842d9ffedece50b7b19787b8c77cafe9629edbaa7d245c5439e661bf44cc60d`)
against its external pin and re-check the inherited chain
(POSTSEAL_191 `97d24fde…`, receipt `cd2798f1…`, all 71052 pins) before
any new proof work. Next unused proof job suffix is 444. Keep one Lean
process (`tools/job111.py`, `-j1 -M6144`), logs 0/0, standard axioms.
Never edit sealed 191 sources.

## State of the source obligations (in order)

1. (closed) `NttInverseMiddleRounds192` remainder (part 2 tail): the
   mInner round execution (ht = t >> 1 as the u64 shr word, the u1
   instance at (tOf i, htOf i, mOf i), the t <<= 1 body shift, the block
   scope), the m >>= 1 increment, the eight-iteration m loop (guard
   t < n, induction i+count = 8) and the tInit/mInit composition closing
   `Exec NttInversePrograms192.intermediatePass` with the composed image
   at (tOf 8, htOf 8, mOf 8) and the load keeps. Jobs 441/443 accepted
   (drafts 439/440/442 retained); commits 1bd5fa4d/b7989b8a.
2. (closed) `NttInverseFinal*192`: `Exec NttInversePrograms192.finalPass`
   is closed by NttInverseFinalPass192 (job 422): w = igm[0], the
   u/r1/r2 initialization, the 256-iteration loop and the trailing skip.
3. (closed) Correction composition `NttInverseCorrectionSource192`
   (job 405) exports the scaled array image.

4. `NttInverseWhole192`: compose `Exec KeygenLevelNtt.inverse` from
   prologue (NttInversePrologue192.source), triplePass
   (NttInverseTriple192.source at full=0), the three passes and the
   chain trailing skip (NttInversePrograms192.body_source rewrites to
   the accepted corpus). Word bridges to write: the round-8 image at
   index 0 gives exactly the final-pass pairs (j, j+256) for j < 256
   (lowWord/highWord over the fvAt 8 words); the final-pass output image
   feeds the correction input through a finalWord case split at 256; the
   correction words are the scale/mont words over those, with the
   modp_R/modp_div words exported by NttInverseCorrectionSource192. The
   w = igm[0] final-pass read is the twLoads 0 instance of the round
   Fixed. TRAP (recorded in the report): the correction source takes
   `uDeclared : some (.uint64,none)` but the final pass leaves u = 256;
   compose the correction with a generalized uInit over old :=
   some (u64 256), mirroring NttInverseCorrectionSource192.init_run.
5. `SelectedStepInverse192`: build
   `KeygenLevelCalls.Bind before (KeygenLevelCalls.params .inverse)
   MakeFgInverseShape192.inverseArgs entry` at the product output of
   SelectedStepProduct192/SelectedStepProduct191.source (u=0 cell, fs
   binding, slen=1 cell, igm binding, logn=9 cell, full argument literal
   0, p/p0i slots), run the body, then compose the s3 branch
   (`MakeFgInverseShape192.s3Yes_shape`/`terBranch_shape`/
   `terYes_shape` rewrite the projections) to the stage statement
   `KeygenMakeFgSource.Exec MakeFgTailShape190.s3 productOutput out`.
   The exported image should record the transformed fs words as the
   executed modp_add/modp_sub/modp_montymul/modp_R/modp_div word terms
   over the copied fs image, and locals/arrays preservation outside v/x.

After the s3 statement is closed and audited: write
`.build/stepinverse192/AUDIT_MODULES.json`, run
`keygen_isolated_audit192.py` (one declaration per command, one module
per process, unchanged checks), the final audit job, `keygen_audit192_
collect.py`, then `keygen_stepinverse192_seal.py seal` and
`postseal RECEIPT_SHA256`, the _PINS.md external pins and the R1 tail
register entry. Next unused job suffix 444; all failed jobs and their
recorded causes stay retained (register 48 entries).

The gs path s4-s7 (copy/product/inverse on gs/t1/gd), the false !out_ntt
guard s8 (its body is the fd/gd inverse pair at logn-1=8 and tlen=2 — a
DIFFERENT instance of the corpus that will need a logn-8 control variant
of the prologue size lemma), the outer u++/final guard tail, both CRT
calls and the additional-prime part (slen1/tlen2), the remaining
d-levels and the root/certificate/codec path stay OPEN. Only the complete
emitted source witness can instantiate the corrected134 consumers
(KeygenModelUnlock134.package_of_witness,
KeygenSuccessMass134.success_lower_of_witness); their prospective bound
remains Z>=2^-256>0 and is NOT a theorem established by 192.

Paper wording stays measured 8192/23628 with the separate 256/739
control. No IID/D1/F04/empirical premise; exactly five do_sign items
remain. Keep all failed jobs and their recorded causes. No push or
independent-review claim.
