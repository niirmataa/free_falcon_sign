# Continuation after the R1 window — s6/s7 and the s4-s7 chain closed, discharge open

The R1 continuation window (this stage's previous route) closed the
three named execution statements: `SelectedStepGsProduct194` (s6 through
StepGsProductKeep194 with the gs/igm keeps, jobs 475),
`SelectedStepGsInverse194` (s7, the gs bind instance over the closed
NttInverseWhole192 corpus at stride 1, job 476) and
`SelectedStepGsChain194` (the composed s4-s7 stage statement from the
assembled `after`-state shape of SelectedStepChain193.source with
explicit stage hypotheses, job 478). Workshop failure 477 is retained
(unbounded gs/igm separation refuted by omega; fixed with j<512/k<512).
At resume verify the entry receipt `.build/stepgs194/ENTRY_PINS.json`
(SHA256 `99ac47a1d981ebfc3afe3c54aac98c02773816faa489682d205682fd31c475b8`)
against the pins in `KEYGEN_STEP_GS_194_REPORT.md`, re-check the
inherited pin chain and confirm no active owned job/Lean/Sage process
before any new proof work. Next unused proof job suffix is **479**. Keep
one Lean process (`tools/job111.py`, `-j1 -M6144`), logs 0/0, standard
axioms. Never edit sealed 187-193 sources; the 194 modules of this stage
stay byte-stable too (edit-by-new-module only).

## Exact remaining obligations (in order)

1. Bystander-load preservation through the inverse corpus's final pass
   and correction, in the per-cell shape `NttInverseMiddleRounds192.source`
   already exports:
   `∀ q, (∀ x, x<512 → Separate (walk a x stride) q) → ∀ w,
   Load32 s.heap q w → Load32 after.heap q w` plus writable transport.
   Concretely: keep-extended re-proofs of the two writer loops (sealed
   `NttInverseFinalLoop192.remaining`, 256 iterations with two writes
   each, and `NttInverseCorrectionLoop192.remaining`, 512 steps with one
   write each) in new modules, then keep-threaded re-compositions of
   `NttInversePrograms192.finalPass` (wAssign/uInit/r1Init/r2Init are
   heap-free) and `NttInversePrograms192.correction` (setNi/uInit
   heap-free; scaleLoop the only writer), then a whole-inverse keep over
   the NttInverseWhole192.source composition (prologue and the skipped
   triple pass are heap-free; the middle pass already exports the keep).
   This also yields the fd and gd image keeps through s3/s7 for free.
2. Re-assembly of s0-s3 with the extra keeps (gs source image, igm
   twiddle reads, fd written image) so the gs image and igm reads at the
   assembled state become unconditional. Arity gap to close: s0 needs
   two simultaneous image keeps (StepCopyKeep193 keeps one), s2 needs
   three (StepProductKeep193 keeps two), s3 uses the per-cell keep from
   item 1. Either build N-image keep variants of both loops in new
   modules or run the existing keep theorems in parallel and identify
   the witnesses by execution determinism. Export follows the export
   follow-up pattern: fs transformed, fd written image, gs image, igm
   reads, caller frames at the assembled state.
3. The unconditional full first-prime assembly: instantiate
   SelectedStepGsChain194.source at the re-assembled state (its stage
   hypotheses are then free), giving `Exec fullPrefix base ⟨final,.normal⟩`
   with the gs transformed words, the gd written image (extend it to the
   `final` state using the item-1 bystander keep through s7) and the
   caller frames. The fd written image at the 193 assembly is the
   inherited gap of the same kind, closed by item 2.
4. Then the outer u++/final guard tail, both `zint_rebuild_CRT` calls,
   the additional-prime part (slen 1 / tlen 2), the remaining d-levels
   and the root/certificate/codec path, before the complete emitted
   witness can instantiate the corrected KeygenProbability134 consumers
   (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective bound
   remains Z>=2^-256 and is NOT established by this window.

## Traps met (do not re-derive)

- The assembled s0-s3 state carries `v = 256`; SelectedStepGsCopy194's
  init is stated over `some (.uint64,none)`. The chain module carries the
  generalized `init_gs` (arbitrary prior v value); reuse it instead of
  editing the 194 modules.
- Cross-region separation lemmas need exact index bounds: the unbounded
  gs (2206+j) and igm (3230+k) ranges overlap at j = k + 1024 (omega
  refutes the unbounded form; failure 477).
- The export follow-up keeps the stage hypotheses EXPLICIT in the chain
  statement (gs image, igm reads, heap writability); the 193 export
  provides only the fs image and the caller frames.

Only executed-word semantics is in scope: no transform property, table
law, root law or positivity claim; unconditional Z>0, numerical p_accept,
conditional coding and positive p_K remain OPEN. Old110 stays frozen;
measured wording 8192/23628 with the separate 256/739 control and the
five do_sign items remain unchanged. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Retained failures: `KEYGEN_STEP_GS_194_FAILURES.json` (4 workshop jobs),
the inherited checkpoint192 register (58) and checkpoint193 register (4).
