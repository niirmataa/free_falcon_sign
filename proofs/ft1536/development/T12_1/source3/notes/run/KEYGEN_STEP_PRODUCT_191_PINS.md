# Checkpoint191 pins — first-prime pair-product loop s2

- Source commits: da249223, fcaa3480, 1801f7db, 786ac16e, 81d574f3,
  b2efc769 (plus the sealing commit of this record).
- Receipt KEYGEN_STEP_PRODUCT_191.json SHA256:
  cd2798f1139e5eb05d0724f11a4ebc8128cb8311ddd326d3220ddd9b5cb997ae.
- Postseal .build/stepproduct191/POSTSEAL_191.json SHA256:
  97d24fdeeb2bd7e443b1ec1a2982163e10b650926ff5002523235ca86f201087.
- 71052 pinned paths; 5 mathematical modules / 89 declarations /
  5 sequential audits; accepted logs 0/0.
- Audit collection SHA256:
  cdc1d4adaeefccaeae022a2974d872c15cfe14955c26511a5978e2971b086f5b.
- ENTRY191 SHA256:
  2587ef18827960f3a8d300d3a891af73ec3ad3eb93e58735f738d5599d7e4873
  (all 70613 inherited paths re-verified before new proof work; a second
  read-only recheck after the owner freed disk space reported 0 missing
  and 0 changed).
- Report SHA256:
  3f4a88af72946bc62b9211719baec5599f56328afb64ad9444314f2e8ce68eb4.
- Next-route SHA256:
  615e6deeb520daa681e0c6313fd461c1e82b469c85184b85d89f05e2ada94c2b.
- Failure ledger SHA256:
  9131e7cf9d40a18affd8d85e2d927f391343727952ac6ffc97684981003a3efe.
- Plan SHA256:
  51de04935a7251c30c9bddbbd895b755978907f052b3f2356695aa6bc1034c60.
- Closed: MakeFgProductShape191 (the full original s2 transcription checked
  by decide against the parser projection), StepProductBody191
  (body_state/body_source/inc_source: one product iteration with the two
  source loads, the nested Montgomery product through the walked x pointer,
  and the two-clause increment), StepProductFixed191 (Fixed, Image,
  output_fixed/output_prefix, next_fixed/next_prefix),
  StepProductLoop191.remaining/source (256 iterations),
  SelectedStepProduct191.source (the s2 loop at the actual seed9
  first-prime copy output with v=256, x=fd+512 and the written product
  image as executed words).
- Jobs363-376 retained: 6 clean accepted jobs (363, 368, 370, 371, 375,
  376), 7 failed/mixed jobs with causes (364, 366, 367, 369, 372, 373,
  374) and one receipt-less setup abort (365, ENOSPC before any Lean
  process; STOP_AND_REPORT raised), all recorded in
  KEYGEN_STEP_PRODUCT_191_FAILURES.json. No controlled cancellation.
  Audit376 ended normally with five clean processes.
- Exact continuation: the active modp_iNTT3_ext inverse call s3 on fs+u at
  the product output, split into prologue/passes/correction like the
  forward 182-185; next unused proof job suffix 377.
- PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
- Whole goal ACTIVE / NOT_COMPLETE. Full emitted witness134, unconditional
  Z>0, numeric p_accept and coding/p_K bounds remain open. Paper stays
  measured; exactly five do_sign items.
- Local commits only; no push, independent review, new worker or reminder.
