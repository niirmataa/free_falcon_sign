# Continuation after the 192 window — inverse call s3 in progress

Whole owner goal ACTIVE / NOT_COMPLETE. Checkpoint 192 is NOT sealed and
has no POSTSEAL; the stage stays IN_PROGRESS / PARTIAL_PROOF /
NOT_REVIEWED. At resume verify ENTRY_PINS192 (`.build/stepinverse192/
ENTRY_PINS.json`, SHA256
`9842d9ffedece50b7b19787b8c77cafe9629edbaa7d245c5439e661bf44cc60d`)
against its external pin and re-check the inherited chain
(POSTSEAL_191 `97d24fde…`, receipt `cd2798f1…`) before any new proof
work. Next unused proof job suffix is 402. Keep one Lean process
(`tools/job111.py`, `-j1 -M6144`), logs 0/0, standard axioms. Never
edit sealed 191 sources.

## Exact next source obligations (in order)

1. `NttInverseMiddle*192`: `Exec NttInversePrograms192.intermediatePass
   s ⟨out,.normal⟩` at any state with the n/hn cells (512/256), the
   t/m/u1/v1/ht/v counters declared, p/p0i slots, the igm pointer with
   executed table loads, the a pointer with writable 4-byte words and
   r1/r2 cursor bindings. Suggested split like the forward 183: one
   butterfly body module (the two loads, the add store and the sub+mont
   store), one v-loop induction, one u1-loop module, one eight-round
   outer module. The loops walk r1/r2 by `stride` (the actual instance
   has stride=1); keep the stride magnitude symbolic where cheap and
   discharge the actual value at the instance. Reuse only type-compatible
   helpers: ModularAtoms178.assign/cell/mont, ModularWordOps182.add/sub,
   C99DeclarationStatements, StepProductBody191.cells_outside,
   Word32Memory176.source/write, RootBinding175.zero, the C99LoopScalar141
   counter patterns. The forward butterfly modules (NttFirstBody182,
   NttMBody183, NttTripleBody184) are a DIFFERENT word type/statement
   shape: reuse their induction patterns, not their statements.
2. `NttInverseFinal*192`: `Exec NttInversePrograms192.finalPass` — w =
   igm[0] load and the 256-iteration degree-1 butterfly loop (a0/a1/b/c
   block locals, the modp_add/modp_sub/modp_montymul words, the two
   stores per iteration).
3. Correction composition (`NttInverseCorrectionSource192`): the
   modp_R/modp_div words (NttInverseCorrection192) and the complete
   512-step scaling loop (NttInverseCorrectionLoop192) are CLOSED; bind
   rAssign/niAssign/cInit/loop into `Exec NttInversePrograms192.correction`
   and export the scaled array image.

4. `NttInverseWhole192`: compose `Exec KeygenLevelNtt.inverse` from
   prologue (NttInversePrologue192.source), triplePass
   (NttInverseTriple192.source at full=0), the three new passes and the
   chain trailing skip (NttInversePrograms192.body_source rewrites to
   the accepted corpus).
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
register entry. Next unused job suffix 391; all failed jobs and their
recorded causes stay retained.

The gs path s4-s7 (copy/product/inverse on gs/t1/gd), the false !out_ntt
guard s8 (its body is the fd/gd inverse pair at logn-1=8 and tlen=2 — a
DIFFERENT instance of the corpus that will need a logn-8 control variant
of the prologue size lemma), the outer u++/final guard tail, both CRT
calls and the additional-prime part (slen1/tlen2), the remaining d-levels
and the root/certificate/codec path stay OPEN. Only the complete emitted
source witness can instantiate the corrected134 consumers
(KeygenModelUnlock134.package_of_witness,
KeygenSuccessMass134.success_lower_of_witness); their prospective bound
remains Z>=2^-256>0 and is NOT a theorem established by 192.

Paper wording stays measured 8192/23628 with the separate 256/739
control. No IID/D1/F04/empirical premise; exactly five do_sign items
remain. Keep all failed jobs and their recorded causes. No push or
independent-review claim.
