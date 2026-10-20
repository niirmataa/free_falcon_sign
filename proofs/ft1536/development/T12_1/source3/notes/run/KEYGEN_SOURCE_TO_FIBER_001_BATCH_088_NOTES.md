# BATCH088 — gs path s6/s7 and the composed s4-s7 stage statement

2026-10-20. **IN_PROGRESS / NOT_REVIEWED.** Window R1 continuation of the
gs stage (checkpoint194) per `KEYGEN_STEP_GS_194_NEXT_ROUTE.md`. Main
report: `KEYGEN_STEP_GS_194_REPORT.md` (new window section). Values only
as executed words; no transform property, table law, root law, positivity,
NTT or Z>0 claim.

## Checks and evidence

- Entry re-verified read-only before any proof work: POSTSEAL_193
  `386e4cbc…`, receipt `1d6f11ec…`, ENTRY_PINS `99ac47a1…`; all 73,564
  inherited pins re-checked with 0 missing / 0 changed; no active owned
  job/Lean/Sage process.
- Three accepted clean jobs (logs 0/0, standard three axioms,
  `-j1 -M6144`, `warningAsError=true`, one Lean process):
  `SelectedStepGsProduct194` (job 475, s6 through StepGsProductKeep194
  with the gs and igm keeps, FixedGd frame and the gd written image
  `value (gvs (2v)) (gvs (2v+1)) R2 p p0i`), `SelectedStepGsInverse194`
  (job 476, s7 = the gs bind instance over the closed NttInverseWhole192
  corpus at stride 1, export `scaledWord gvs tws p p0i`), and
  `SelectedStepGsChain194` (job 478, composed s4-s7 with explicit stage
  hypotheses and the composed s0-s7 execution).
- One retained workshop failure (477) with cause in
  `KEYGEN_STEP_GS_194_FAILURES.json`: the first chain draft stated the
  gs/igm separation without index bounds; omega correctly refuted the
  unbounded form. The bounded `j<512 / k<512` form is what the s7
  hypothesis carries. No sealed 187-193 source was touched.
- Structural findings recorded for the continuation: (a) the assembled
  s0-s3 state carries `v = 256`, so the s4 init is re-proved in the chain
  for an arbitrary prior v cell value (SelectedStepGsCopy194's init is
  stated over the uninitialized declaration `some (.uint64,none)`);
  (b) the gs and igm index ranges overlap in unbounded form — every
  cross-region separation lemma needs its exact index bounds;
  (c) the discharge should mirror the per-cell bystander keep exported by
  `NttInverseMiddleRounds192.source`
  (`∀ q, (∀ x<512, Separate (walk a x stride) q) → ∀ w, Load32 s.heap q w
  → Load32 after.heap q w`, plus writable transport).
- No new assumptions, no independent review started, no push (batch 4
  waits for the owner's signal), do_sign slot items unchanged (exactly
  five). Old110 stays frozen; measured wording unchanged.

## Open (exact order in KEYGEN_STEP_GS_194_NEXT_ROUTE.md)

1. Bystander-load preservation through NttInverseFinalPass192 and
   NttInverseCorrectionSource192 (keep-extended re-proof of the two
   writer loops and keep-threaded re-composition, then the whole-inverse
   keep over NttInverseWhole192's composition).
2. Re-assembly of s0-s3 with the extra gs/igm/fd keeps so the chain's
   stage hypotheses become unconditional (s0 needs two simultaneous
   image keeps, s2 three; the existing keep modules are arity-limited).
3. The unconditional full first-prime assembly s0-s7 and the gd image at
   the s7 output state (free from item 1).
4. Then the outer u++/guard tail, both CRT calls, the additional-prime
   part, the remaining d-levels and the root/certificate/codec path.
   Prospective bound Z>=2^-256 remains NOT established.
