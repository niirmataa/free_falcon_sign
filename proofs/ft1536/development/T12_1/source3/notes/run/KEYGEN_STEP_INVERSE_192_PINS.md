# Checkpoint192 pins — make_fg_step first-prime inverse call s3

- Source commits: 6389b969 (frame), c65e39f9 (generalized correction
  u-init), 0a002392 (word bridges), cfdc26cd (whole inverse call),
  3a4769ab (s3 stage statement), plus the sealing commit of this
  record.
- Receipt KEYGEN_STEP_INVERSE_192.json SHA256:
  4a7edbb50b35b1a059670bf9eab5adc5ae4695d8c56328a6f14358cda38bb9f2.
- Postseal .build/stepinverse192/POSTSEAL_192.json SHA256:
  3c31e4610a48d95190d68952998c4a00962d5e896381f1372ed6aecf7582141a.
- 73379 pinned paths; 20 mathematical modules / 471 declarations /
  20 sequential audits; accepted logs 0/0.
- Audit collection SHA256:
  348c254fd5559619a112bb0efd5b51c02af0a9ffb7c9ceccbd19b6fdd27ba1c9.
- ENTRY192 SHA256:
  9842d9ffedece50b7b19787b8c77cafe9629edbaa7d245c5439e661bf44cc60d
  (all 71052 inherited paths re-verified before new proof work in both
  windows of checkpoint192; 0 missing, 0 changed).
- Report SHA256:
  c8d17cdc2c540263c87cf2f7e4acf22d34de9d0d57b5bd69fbff80bbc754f832.
- Next-route SHA256:
  c585464ad5dec40c2b1c4503759af8dc4a5b4be2895d36f8ecea081dc3289273.
- Failure ledger SHA256:
  a283fdfe3d69880b0f648b879aa553d554c4b75c97eb2cbd2b42b5f45ed1ebf1.
- Closed: MakeFgInverseShape192 (s3 statement naming by decide),
  NttInversePrograms192 (the pinned modp_iNTT3_ext corpus split),
  NttInversePrologue192/NttInverseTriple192 (prologue and the full=0
  skip), NttInverseCorrection192/CorrectionLoop192/CorrectionSource192
  (the modp_R/modp_div words and the scaling loop),
  NttInverseFinalBody192/FinalExec192/FinalLoop192/FinalPass192 (the
  degree-1 final pass), NttInverseMiddleBody192/MiddleVLoop192/
  MiddleU1Loop192/MiddleRounds192 (the eight intermediate rounds),
  NttInverseFrame192 (locals/arrays frame extended to the pointer
  binds), NttInverseCorrectionInit192 (correction u-init over the old
  cell some (u64 256)), NttInverseWholeBridges192 (fvAt8 -> finalWord
  -> scale word bridges), NttInverseWhole192 (`Exec
  KeygenLevelNtt.inverse`), SelectedStepInverse192 (the s3 stage
  statement `KeygenMakeFgSource.Exec MakeFgTailShape190.s3 productOut`
  with the transformed fs words as executed modp_add/modp_sub/
  modp_montymul/modp_R/modp_div terms over the copied fs image).
- Jobs 377-458 retained: 25 clean accepted jobs (377, 381, 384, 388,
  389, 390, 401, 405, 412, 415, 420, 422, 425, 427, 433, 436, 438,
  441, 443, 446, 447, 449, 453, 457, 458), 57 failed/mixed jobs with
  recorded causes, and one accepted DIAGNOSTIC syntax probe (381,
  NttInverseShapeProbe192, environment evidence only), all recorded in
  KEYGEN_STEP_INVERSE_192_FAILURES.json (58 entries, including the
  record-hygiene correction of the omitted job 411). No controlled
  cancellation.
