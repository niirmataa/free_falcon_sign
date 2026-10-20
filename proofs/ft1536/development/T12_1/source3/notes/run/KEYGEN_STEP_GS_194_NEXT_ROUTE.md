# Continuation after the gs-window freeze — s4/s5 and s8 closed, s6/s7 open

The gs window (prompt `run2/notes/PROMPT_R1_RESUME_005.md`) froze at a
safe mid-point. Closed: the source naming of s4-s8 (MakeFgGsShape194),
the gs copy s4 with its igm keep and the skipped s5 branch
(StepGsCopyKeep194 / SelectedStepGsCopy194), the false `!out_ntt` guard
s8 as its skip with the fd/gd pair naming (SelectedStepOutNtt194) and the
logn-8 control variant of the prologue size lemma
(NttInverseSizeControl194), and the gd product loop keep module
(StepGsProductKeep194). At resume verify the entry receipt
`.build/stepgs194/ENTRY_PINS.json` (SHA256
`99ac47a1d981ebfc3afe3c54aac98c02773816faa489682d205682fd31c475b8`)
against the pins in `KEYGEN_STEP_GS_194_REPORT.md`, re-check the inherited
pin chain and confirm no active owned job/Lean/Sage process before any
new proof work. Next unused proof job suffix is **475**. Keep one Lean
process (`tools/job111.py`, `-j1 -M6144`), logs 0/0, standard axioms.
Never edit sealed 187-193 sources.

## Exact remaining obligations (in order)

1. `SelectedStepGsProduct194` — statement s6 at the SelectedStepGsCopy194
   copy output: the product init (v = 0, x = gd + u at the u = 0 cell),
   the 256 iterations through `StepGsProductKeep194.source` with the two
   keeps (gs image, igm twiddles), the FixedGd frame and the gd written
   image `value (gv (2v)) (gv (2v+1)) R2 p p0i`. Mirrors the s2 section
   of SelectedStepChain193 with gd.
2. `SelectedStepGsInverse194` — statement s7: the gs twin of
   SelectedStepInverse192 (its KeygenLevelCalls.Bind chain binds the
   `"fs"` name and `addr fs 0 0 1`; the gs instance binds `"gs"` and
   `addr gs 0 0 1`, reusing the generic entry/Bind helpers and the closed
   `NttInverseWhole192.source` at stride 1). Export: the transformed gs
   words as `scaledWord gvs tws p p0i` and the caller frame.
3. `SelectedStepGsChain194` — the composed s4-s7 stage statement from the
   assembled `after` state of SelectedStepChain193.source, with the stage
   hypotheses (gs source image and igm twiddle reads at `after`, heap
   writability) stated explicitly and the export (gs transformed, gd
   written image, locals/arrays frames).
4. Hypothesis discharge at the full first-prime assembly: bystander-load
   preservation through `NttInverseFinalPass192` and
   `NttInverseCorrectionSource192` (the middle pass already exports it in
   `NttInverseMiddleRounds192.source`), then a re-assembly of s0-s3 with
   the extra keeps so the gs image and igm reads at the assembled state
   become unconditional. The fd written image at the 193 assembly is a
   known inherited gap of the same kind.
5. Then the outer u++/final guard tail, both `zint_rebuild_CRT` calls, the
   additional-prime part (slen 1 / tlen 2), the remaining d-levels and
   the root/certificate/codec path, before the complete emitted witness
   can instantiate the corrected KeygenProbability134 consumers
   (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective bound
   remains Z>=2^-256 and is NOT established by this window.

Only executed-word semantics is in scope: no transform property, table
law, root law or positivity claim; unconditional Z>0, numerical p_accept,
conditional coding and positive p_K remain OPEN. Old110 stays frozen;
measured wording 8192/23628 with the separate 256/739 control and the
five do_sign items remain unchanged. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Retained failures: `KEYGEN_STEP_GS_194_FAILURES.json` (3 workshop jobs),
the inherited checkpoint192 register (58) and checkpoint193 register (4).
