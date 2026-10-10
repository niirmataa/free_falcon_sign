# Paper v0.3 — statement-to-source map

Current editorial revision: **REDACTION PASS, 2026-10-10** (main-text
editing window PAPER-REDAKCJA; the ADDENDUM 3 form pass below remains
the formal baseline). Evidence status remains the BATCH_048 snapshot
(`915178a1`), with B1.05/B1.06 locally closed and B1.07 partial. There
are **117 selected inputs / 21 claim groups**. The added BATCH_032/048
pairs document already reported stages; the fifth added input is
`sources/DOCUMENT_SNAPSHOT.json`. The two style benchmarks and their
hashes are recorded separately in `notes/BENCHMARK_003.md`; they supply
no new mathematical premise. The redaction window repins two live
inputs after reading their diffs (reconciliation items 18–19) and adds
the theorem-to-export compliance table in Appendix A; the abstract,
main theorem formula and security-accounting summary were not edited.

`tools/document_snapshot.py` verifies the manifest and generates the
full identifiers printed on the first page and in Appendix A. It never
repins. PDF identity and manuscript-source hashes are external receipts,
avoiding a self-referential hash inside the PDF.

Snapshot date: **2026-10-06**; status-ledger revision: **2026-10-10**
(window 2, publication-form pass). Paths below are relative to the repository root.
Formal statements were read from the actual Lean declarations and proof
bodies, not inferred from status headings. This is a drafting/source audit,
not an independent mathematical acceptance or a new Lean replay.

- Initial read HEAD: `29e6372b`; B1's batch-015 evidence then landed at
  `d5ced420`. Paper scaffold: `901f6333`.
- Corrected computational package: `6ff3c8381d73c5059597605880d849f1062b1f4a`.
- Late, explicit evidence update: independent REVIEW_003 and synthesis
  commits `9b12f04e`/`be610737`, delivered during drafting. Previous 97-pin snapshot
  is preserved in paper commit `8b98cd39`; the 106-input revision is preserved
  in paper commit `3333088d`.
- Window-2 status update: B1.05 closed (BATCH_032), B1.06 Acceptance met
  (BATCH_046) and B1.07 in progress are recorded from the pinned source3
  stage ledger and exports (claim C21). Six new inputs; **112** total.
- Window-3 form pass (addendum, 2026-10-10): classical crypto skeleton,
  notation/family/security table floats, boxed KeyGen/Sign/Verify
  algorithms, numbered Definition/Assumption/Theorem/Lemma/Corollary/
  Remark environments with cross-references, and six verified literature
  context entries. No claim content changed; `refs.bib` and
  `sources/EXTERNAL_REFERENCES.md` were rehashed. Still **112** inputs.
- Byte identity is fixed by **SOURCES.sha256**, which lists every input in
  the inventory below. The hash of that manifest and the built PDF are
  recorded in `build/CHECK.json` and the paper handoff.
- Aliases: `R` = `proofs/ft1536/development/T12_1/run2/formal`;
  `N` = `proofs/ft1536/development/T12_1/run2/notes`;
  `S` = `proofs/ft1536/development/T12_1/source3/formal/Source3`;
  `SN` = `proofs/ft1536/development/T12_1/source3/notes/run`.
- Archived dependencies are resolved using the pinned
  `run2/ARCHIVED_DEPENDENCIES.json`; their exact stage paths also occur
  below. No copies of the historical Lean modules are introduced here.

## Claim map

The C-identifiers appear beside all drafted technical claim groups in the
LaTeX. Narrative aims, document navigation, TODO requests and owner decisions
are not represented as proved results. Definitions, conditional theorems,
measurements, diagnostics and reporting conventions retain their distinct scope.

### C01 — target, operational scope and unfinished honest bridge

**Locations:** abstract; sections 1, 3–5, 7–8, 11.

- `proofs/ft1536/development/T12_1/END_TO_END_SCOPE.md`, §§1–4 and 6:
  D1–D3, A1–A5, conditional emitted-key law, source-to-game target.
- `N/B2B5_COMPUTATIONAL_WORK_STATE.md`, E1/open honest interface and E3:
  missing tape-driven honest continuation, fair-tape `Games.runEUF` binding,
  its own test certificate, and B1.10 law instantiation.
- `N/B4_SYNTHESIS.md`, final 2026-10-06 updates: the four-arrow target.
  The paper splits the closed public stream→lazy→MT identification into
  arrows 3 and 4; arrows 1 and 2 visibly retain TODO markers.
- `R/Assembly.lean`, `end_to_end_assembled_theorem_statement` and its body:
  `intro _hkey`, construction of the local certificate, and addition of
  `0 ≤ deltaPRG`. Its theorem does **not** supply a real-Sign computational hop.
  `a1_no_retry_interface` is an interface identity, not a leakage theorem.
- `N/S3_E_PROVENANCE.md`, “Where each conditioning belongs”: e is a Sign-law
  second-moment constant, not a KeyGen-law multiplier or centering probability.
- `N/B5_WORK_STATE.md` and `N/B2_ADVPRG_WORK_STATE.md` are pinned historical
  accounts, superseded as to computational closure by the corrected work-state
  and actual types. Their unqualified closure language is not repeated.

**Status:** target IN-FLIGHT; operational assumptions explicit. Equations about
first-success conditioning are the recorded IID-attempt model, not a claim of
a completed C/PRNG law proof.

### C02 — profile and FG_PROBE measurement

**Locations:** sections 1–3, 11; Annex A.

- `proofs/ft1536/work/FT1536_FG_PROBE_P_ACCEPT_001/out/RECEIPT.json`:
  `flags_profile`, `api_profile`, `seeding`, `transparency_control`,
  `runs[1].result`, `measured_constants`, `scope_reminder`.
  Counts: 8192 successes, 23628 attempts, 15436 rejects, 24 maximum attempts,
  no cap hits; reported 0.34671 and reciprocal 2.884; 256/256 control digests.
  Per-counter rejects 376,392,0,12303,814,1551. Cap 3000000 and Sign cap 16
  are configuration values, not empirical security bounds.
- `N/S1_P_ACCEPT_FACTS.md`, acceptance-gate grouping and IID cap model.
  The paper explicitly records that the receipt does not have a separate
  leaf-certificate counter and does not turn digest agreement into universal
  instrumentation transparency.
- `Extra/c/Makefile`, profile flags; `Extra/c/falcon-keygen.c`,
  `falcon_keygen_make` and `ft_keygen_leaf_certificate`.
  Algorithm 1 is source exposition: readiness 7833–7838; cap 7865–7875;
  sampling 7888–7889; resultants 7931–7948; norm/GS gates 7983/8012;
  public computation 8083; solver 8097; leaf 8108–8121; final encoding
  8137–8181. It is not a new whole-KeyGen execution theorem.
- `paper/tools/check_numbers.sage` (under `proofs/ft1536/`), measurement
  arithmetic; `build/numbers/run_001/RECEIPT.json` and `numbers.json`.

**Status:** empirical control only, including synthetic-seed scope. No rigorous
lower bound on p_accept is substituted into a theorem.

### C03 — geometry, exact verifier relation and divergence definitions

**Locations:** abstract; sections 1–3.

- `stages/FT1536_CENTERING_CLOSURE_RUN_001/library/FT1536/Geometry.lean`
  (all `stages/` paths here are under `proofs/ft1536/`): `Vec`, `block`,
  `Q0`, `Q`, `B`, `center`. Values 768 pairs, 1536 coordinates,
  q=18433, B=2093922385, center interval [-9216,9216].
- `stages/FT1536_MATH_EUFCMA_MTISIS_RUN_001/formal/FT1536/Relation.lean`:
  `Rq`, `poly`, `modulus`, `mulRq`, `A`, `extract`, `signed16`, `Verify`,
  `ShortPreimage`, `reduce_center`, `extraction_equation`, `accepted_extracts`.
  The theorem in §3 is the literal accepted_extracts implication.
- `stages/FT1536_CENTERING_CLOSURE_RUN_001/library/FT1536/Divergence.lean`:
  `AC`, `second`, `chi2`, `Density`, `energy_eq_second`, `centered_energy`.
  The AC direction and total-real division convention are retained.

### C04 — conditional reduction, collision loss and event transfer

**Locations:** abstract; sections 1, 3–5, 11.

- `R/Run2/LawBinding.lean`: `LocalJointCertificate` (nonnegative/ac/moment);
  `samplerLaw` and `sample_law`.
- `R/Run2/ConcreteReduction.lean`: `concrete_euf_cma_to_mt_isis`,
  `exists_concrete_reducer`, `concrete_hardness_substitution`,
  `exact_collision_parameter`. The exact result is clipped by min 1;
  q_s−1 uses natural subtraction; target count is q_h+1; denominator 2^320.
- `R/Run2/StoppedComparison.lean`: `signStepComparison`, `programComparison`,
  `stoppedGameComparison`, `stopped_game_event_bound`.
- `R/Run2/LazyEventBinding.lean`: `stopped_euf_to_concrete_mt`.
- `stages/FT1536_MATH_EUFCMA_MTISIS_RUN_001/formal/FT1536/EventTransfer.lean`:
  `event_quadratic`, `phi`, `phi_bound`, `phi_zero_delta`, `phi_at_zero`,
  `phi_ge_b`, `phi_le_one`, `phi_satisfies`.

**Status:** CLOSED conditional theorem about the defined interpreters, with
no machine-resource or source realization silently added.

### C05 — laws, reducer construction and lazy identification

**Locations:** sections 1–5.

- `R/Run2/Games.lean`: `Nonce`, `Program`, `Budget`, `ClassicalAdversary`,
  `Sampler`, `programmedReply`, `signHonest`, `signSim`, `simulate`,
  `finishHonest`, `finishSim`, `runEUF`, `runMT`, `AdvEUF`, `AdvMT`,
  `Reduction.build`; `nonce_card` and `parse_frame`.
  Code contains the 40-byte framing, fixed target vector, freshness gate,
  query-token consumption and public-only S interface.
- `R/Run2/MTBinding.lean`: `runMT_build_exact`, `advantage_is_solver_returns`.
- `R/Run2/LazyEventBinding.lean`: `concrete_lazy_game_binding`.
- `R/Run2/FiniteDist.lean`: `Dist.Same` (expectation equivalence).
- `stages/FT1536_CENTERING_CLOSURE_RUN_001/library/FT1536/PublicSimulation.lean`:
  `BoxVec`, `BoxPair`, `decode`, `full_norm_support_in_box`, `gaussianWeight`,
  `fiberWeight`, `trial`, `emit`, `signBody`, `honestJoint`. Values 131071,
  65535, Gaussian denominator 2·768², cap 16; no Verify test in emit.
- `R/SignLayerSupport.lean`: `geo`, `imageMass`, `signBodyOf_mass_some`,
  `signBodyOf_mass_none` (geometric sum and both failure terms).
- `stages/FT1536_CENTERING_CLOSURE_RUN_001/library/FT1536/MathSign.lean`:
  `cap`, `cap_none`, `cap_some`, `emit`, `positive_reply_not_filtered`;
  norm failure is retried, terminal emission failure is not retried.
  Algorithm 2 restates `PublicSimulation.signBody` at a fixed challenge:
  at most 16 draws of `trial`, followed by exactly one terminal `emit`.
  A failed signed16 emission returns none immediately. It is a law
  specification, not the C sampler algorithm or an efficient exact sampler.

### C06 — one-attempt, cap, second moment and joint decomposition

**Locations:** abstract; sections 1, 4–6.

- `R/AttemptPointwise.lean`: `attemptOf`, `attemptOf_some`, `attemptOf_none`,
  `AttemptShape`, `Sandwich`, `attemptOf_le_of_sandwich`,
  `attemptPointwise_of_sandwich`, `layer2_e2_actual`.
- `R/SignLayerSupport.lean`: `AttemptPointwise` (both fields), `ReplyShape`,
  `cap_le_of_pointwise`, `signBodyOf_le_of_attempt_le`, `e2`,
  `layer2_of_obligations`, `e2_attemptFactor_lt`.
- `R/Assembly.lean`: `e2_eq` (e2=k^32−1).
- `R/SecondMoment.lean`: `second_le_of_pointwise`, `ac_of_pointwise`,
  `second_joint_le`; no sharper unexported replacement is used.
- `R/JointDecomp.lean`: `decomposition`, `second_eq_of_decomposition`,
  `freshHonest_eq_joint`, `freshHonest_condOf`,
  `localJointCertificate_of_uniform_challenge`.
- `R/HacGlue.lean`: `UniformChallengeAt`, `ReplyShapeAt`,
  `AttemptPointwiseAt`, `localJointCertificate_of_named_premises_e`.
- `R/ONoneGeometry.lean`: `localJointCertificate_of_attemptFactor`.

**Status:** exact conditional transport, not an instance for the real signer.

### C07 — stage endpoints, computed factor and row-budget limits

**Location:** section 6.

- `R/CenteringClosure.lean`: `u`=2^-48, `t5lo`, `t5hi`, `tauB`=2^-40,
  `boxB`=10^-1000; `R/Run2/T5ScalarMass.lean`: `rowBudget`=2^-46,
  `massBudget`=2^-34, `uniform_shifted_mass_3072` (totals only).
- `R/SignLayerSupport.lean`: `machineMargin`, `towerMargin`, `attemptFactor`,
  their `_one_le`/`_lt` bounds and `e2_attemptFactor_lt`.
- `R/AttemptWeights.lean`: `TowerWhole`, `MachineStage`, `WrapStage`,
  `BoxStage`, `wrapFactor`, `boxFactor`, `attemptFactor_eq`,
  `stage_tower_lt`, `stage_machine_lt`, `stage_wrap_lt`, `stage_box_lt`,
  `attemptFactor_comp_lt`, `e2_comp_lt`, `layer2_of_stageChain`.
  Exact margins: <1+2^-43, <1+2^-42, <1+1/(2^39−1), <1+10^-30;
  composite <1+2^-38 and e2<2^-32.
- `R/T5Pointwise.lean`: `TowerRowRoad`, `MachineEvalRoad`, `WrapCoordRoad`,
  `BoxRetentionRoad`, `PointwiseStageRoad`, `tower_margin_row2`,
  `road_fit_3072_rows`, `rowwise_fullBudget_busts`, `t5lo_factorization`,
  `t5hi_factorization`, `attemptWeights_of_stageRoad`, `layer2_of_stageRoad`.
  Counts 2 rows, 3072 rows, 20/11 factors, 1536 coordinates; 2^-58 row budget.
- `N/B4_ATTEMPT_WEIGHTS_WORK_STATE.md` and `N/T5_POINTWISE_WORK_STATE.md`:
  provenance and the explicit abstract-versus-realized boundary.

### C08 — acceptance-conditioned shape

**Locations:** abstract; sections 4, 6, 11.

- `R/AttemptWeights.lean`: `attemptCondWeights`, `attemptCondWeights_tailMass`,
  `rejComp`, `conditioned_ratio_le`, `conditioned_attemptOf_le`,
  `conditionedFactor`, `conditionedFactor_one_le`, `conditionedFactor_lt`,
  `e2_conditionedFactor_lt`, `attemptPointwise_of_conditionedChain`,
  `layer2_e2_conditioned`.
- `R/CenteringClosure.lean`: `rejB`=2^-24.

The exact normalization multiplier is 1/(1−rejB); the resulting bounds
<1+2^-23 and e2<2^-17 retain positive-bulk and reference-miss premises.
The selected source shape is not inferred from the arithmetic.

### C09 — three negative sampler results

**Locations:** abstract; sections 1, 6, Annex A.

- `R/AttemptWeights.lean`: `bulkOnly_tail_uncontrolled`,
  `bulkOnly_normalized_tail_uncontrolled`, `towerBulkOnly_tail_uncontrolled`.
  Exact hypotheses lo≤1≤hi; exact witnesses g=indicator(Q<B), w=1.
- `R/T5Pointwise.lean`: `massSandwich_not_pointwise`, and
  `towerMass_not_pointwise`, `machineMass_not_pointwise`,
  `wrapMass_not_pointwise`, `boxMass_not_pointwise`.
  Exact hypotheses 0<lo≤hi; weights at zeroPair/liftPair zeroPair.
- Same module: `additiveError_no_machineStage`, explicit constant witnesses
  target=10^-6, mach=1+10^-6, additive error≤1.

No claim that these witnesses occur in C, or of an unexported arbitrary-ratio
theorem, is made.

### C10 — statistical route and generator dimensions

**Locations:** sections 6, 8–9.

- `R/AdvPrg.lean`: `FrngState`, `frngTapeLaw`, `card_frngState`,
  `card_tapeSpace`, `route_a_closed`, `chacha20PRFBound_delta_ge`,
  `chacha20PRFBound_iff_advPRG_le`, `blockBytes`, `bufferBytes`,
  `bufferBlocks_eq`, `tapeBitsTotal_eq`, `tapeBytesTotal`,
  `chachaBlocksTotal`, `nonceBitsPerQuery_eq`.
- `R/Assembly.lean`: `TV`, `AdvPRG`.
- `Extra/c/frng.c` and `Extra/c/internal.h`, source transcription context.

The bound 1−2^448/2^n is for one deterministic modeled state-to-tape map.
64-byte blocks, 4096-byte buffer and the 320-bit nonce are distinct accounts.
The unrestricted historical PRF-named predicate is statistical in its type.

### C11 — source-binding method, power checks and REV10

**Location:** section 7.

- `S/KeygenMkgm3Program.lean`: `source_bound` (region 2945 91).
- `S/KeygenNttFirstLoop.lean`, `S/KeygenNttTripleLoop.lean`,
  `S/KeygenNttMiddleLoops.lean`, `S/KeygenNttForwardExec.lean`:
  respectively `first_result`/`loop_trace`, `triple_result`/`loop_trace`,
  `v_result`/`u1_inner_result`, and `prologue_result`: executed
  loop/count/position interfaces.
- `S/KeygenNttButterflyCalls.lean`: `first_calls`, `triple_calls`,
  `binary_calls` (call conclusions under explicit execution contracts).
- `S/KeygenGeneratorOrder.lean`: `p`, `g`, `order_power`,
  `order_exact_half`, `order_exact_third`, `order_divides`,
  `square_order_power`, `square_order_exact_half`, `square_order_exact_third`,
  `square_order_divides`. Paper quotes these literal Nat power tests,
  not a new general orderOf or NTT correctness theorem.
- `S/KeygenRev10Cert.lean`: `rawTable_exact`.
- `SN/KEYGEN_SOURCE_TO_FIBER_001_BATCH_015.json`, `rev10_certificate`, `jobs`;
  `SN/KEYGEN_RESIDUE_CHECKPOINT.md`, §5 (carried REV10 facts in the updated
  stage-(b) checkpoint; its new R2 results are not additional paper theorems);
  source3 `.build/jobs/keygen_rev10_cert_004/RECEIPTS.json`.
  1024 entries, eleven parse slices, at most eight lines per slice;
  the eight-line observation is experiment-specific.

### C12 — defects actually found

**Locations:** sections 1, 7, Annex A.

- `proofs/ft1536/documents/FT1536_C_CODE_FINDINGS_2026-10-02.md`, F-001:
  cursor/prefix defect, LATENT status, seven-copy census and examined
  reachability. Exact code at `Extra/c/frng.c:342–363`; all six additional
  vendored frng.c files are individually pinned below.
  The paper does not repeat the ledger's overly broad claim that every
  refill-spanning request is wrong, nor extend the census to later upstream.
- `SN/KEYGEN_SOURCE_TO_FIBER_001_BATCH_014_NOTES.md`, §§2–3:
  duplicated outer XOR in divSelect, dead REV10 parser layer, false call on
  parenthesized `((size_t)1 << k) - 1`; named retained probe/binding jobs.
- `SN/KEYGEN_SOURCE_TO_FIBER_001_BATCH_014.json`;
  `S/C99ModularReference.lean` (`divSelect`),
  `S/C99ModularParser.lean` (`revSplit`, guarded call pattern),
  `S/KeygenMkgm3Callees.lean` (`div_source_bound`).

These are one latent C defect and distinct formal-model/parser defects.

### C13 — local B3 codecs and factual padded-format comparison

**Locations:** sections 2, 10–11.

- `R/VerifyBind/StaticCodec.lean`: `static_decode_encode`, `encodeStatic_inj`,
  `static_alias_zero`, `static_alias_wrap`.
- `R/VerifyBind/ByteCodec.lean`: `none_decode_encode`,
  `encodeSig_consumed_static`, `encodeSig_consumed_none`,
  `encodeSig_inj_static`, `encodeSig_inj_none`, `decodeSig_length`.
  Domains: 1536 coefficients, int16 versus [-9216,9216]; alias at −32768.
- `R/VerifyBind/Verdict.lean`: `verdict_valid_iff`, with parameterized
  keyDecoder and hashTo; no global source-security inference.
- `N/VERIFY_BIND_WORK_STATE.md` and `N/VERIFY_BIND_SIGN_SIDE_NOTES.md`,
  exact-consumption, shared norm predicate, caller output-buffer failure.
- `stages/FT_FAMILY_SEC_ESTIMATE_REVIEW_RUN_001/inputs/campaign/inputs/falcon/`
  `falcon-specification.pdf` (v1.2) and `falcon-round3.zip` (under proofs/ft1536).
  ZIP member `falcon-round3/Extra/c/falcon.h`, pinned member hash and exact
  line locations in `paper/sources/EXTERNAL_REFERENCES.md`.
- `paper/tools/check_numbers.sage`: member check and 666-byte macro evaluation.

The format comparison is source analysis, not a new kernel theorem about
Falcon's size-conditioned distribution or a security defect in padding.

### C14 — S06 lattice diagnostics and family status

**Locations:** sections 2, 8, 10–11.

- `proofs/ft1536/validation/2026-09-22-family-estimator-independent/README.md`.
- `proofs/ft1536/stages/FT_FAMILY_SEC_ESTIMATE_REVIEW_RUN_001/REVIEW.md`,
  §§3–7: P1/P2 rows 462/455, 1077/1082, 2409/2445; Falcon anchors
  458/411 and 936/952; cost slopes 0.292/0.265; FT1536 minimum P1;
  CHANGES_REQUIRED, ALTERNATIVE_PROPOSAL, model/unit/status/subfield issues
  and the rejected any-target multiplication rule.
- `paper/tools/check_numbers.sage`: extracts the rows from that review and
  computes same-model minima and exact decimal displays. Receipt and result
  under `paper/build/numbers/run_001/` are pinned below.

Table uses fixed-width P2 (not the separate sigma∝sqrt(N) family variants).
It does not overwrite the Falcon specification's own categories or assert
certified system levels. All costs remain model-dependent diagnostics.

### C15 — computational class, whole-run tape, cost and actual law transport

**Locations:** sections 4, 6, 8–9, 11.

- `R/CompPrg.lean`: `CompTest`, `compTestAdv`, `CompPRGBound`,
  `CompWinCert`, `winFun`, `comp_game_hop_abs`, `tapeWidth_eq`,
  `windowOf`, `windowsOf`, `flattenWindows`, `windowsOf_flattenWindows`,
  `flattenWindows_windowsOf`, `draw_uniform_windowsOf`, `signSimAt`,
  `simulateStream_uniform`, `streamCont`, `AdvPublicSimStream`,
  `streamWinTest`, `streamGame_uniform`, `streamGame_uniform_eq_advMT`,
  `stream_game_hop_abs`, `stream_game_hop`.
- `R/AssemblyComp.lean`: `KeyLawBinding`, `public_sim_stream_bound`,
  `public_sim_stream_hardness_substitution`,
  `advMT_ge_of_public_sim_stream_win`, `public_sim_stream_phi_weakening`.
- `R/AdvPrg.lean`: exact consumption definitions (also C10).
- `N/B2B5_COMPUTATIONAL_WORK_STATE.md`, E1–E3 and generator-binding limitation.

The same actual winning test appears in membership and cost; q is exactly
chachaBlocksTotal. Key equality is used through binding.identify hkey.
The direct bound has no D/e argument and refers to public simulation only.

### C16 — exact inverse and clipped dominance

**Locations:** sections 4, 9.

- `R/AssemblyComp.lean`: `phiInv`, `phi_inv_le`, `phiInv_at_phi`,
  `phiInv_at_phi_zero`, `phiInv_piecewise`, `phiInv_le_clipped_direct`,
  `advMT_ge_of_public_sim_stream_win_phi_weakening`.
- REVIEW_002 `SUPPLEMENT_K1_E4.md` and `checks/KOneAndPsi.lean`.
- `EventTransfer.lean`: `phi_zero_delta`.

Domain D≥0, a≤1, b∈[0,1]; lower branch includes negative a. No inverse for
a>1. Direct dominance requires the clipped max(0,epsilon−delta) and
nonnegative epsColl. The k=1/D=0 test does not consume LocalJointCertificate.

### C17 — evidence, review independence and reproducibility scope

**Locations:** sections 3, 9; Annex A (and scope test in section 4).

- `work/FT1536_B2B5_COMPUTATIONAL_REVIEW_001/REVIEW.md` (under proofs/ft1536):
  independent fresh-context CHANGES_REQUIRED for the earlier source version,
  70/70 recorded steps, Lean 4.34.0 and exact Lean/Mathlib revisions.
- `work/FT1536_B2B5_COMPUTATIONAL_REVIEW_002/REVIEW.md`: technical PASS_SCOPED,
  explicitly AUTHOR_RECHECK, independent_of_author=false, fresh_context=false;
  70/70 base steps, 79 API names (63+16), standard axiom subsets.
- Same W: `SUPPLEMENT_K1_E4.md`, `REVIEW_RESULT_FINAL.json` (71 final selected
  steps including supplement), `checks/KOneAndPsi.lean`,
  `receipts/clean_001/RECEIPT.json`, `receipts/controls_002/RECEIPT.json`,
  `receipts/k1_002/RECEIPT.json`.
- `run2/.build/b2b5_e1e5_001/inputs/ENVIRONMENT.json`;
  its two final complete-API audit logs and final evidence selection.
- `work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/REVIEW.md`,
  `REVIEW_RESULT.json`, `OUTPUTS.sha256`, `inputs/PREPARE_REPORT.json`,
  `receipts/clean_indep_001/RECEIPT.json`, `receipts/checks_r3/RECEIPT.json`,
  and the three `checks/Indep*.lean` modules: independent fresh-context
  PASS_SCOPED on exactly the same 6ff3c838 source pins; 66 closure modules
  plus two API audits = 68 successful selected steps; 21 final kernel
  control declarations. Initial failed controls are recorded separately.
  The paper uses the precise count in REVIEW §6, not the ambiguous earlier
  phrasing suggesting two additional module builds.
- `N/B4_SYNTHESIS.md`, older and latest review updates: the historical
  pre-correction “third review” is distinct from the now pinned REVIEW_003.
  Its newest heading says 2026-10-07, while REVIEW_003 and commit 9b12f04e
  are dated 2026-10-06; the drafting log preserves this date discrepancy
  without editing the source record.
- `run2/ARCHIVED_DEPENDENCIES.json`; repository `.gitignore` for work/runtime
  availability boundary. The paper does not claim to reproduce the full proof
  closure or that ignored evidence is recoverable from a public clone.

### C18 — classical-only / no fictitious QROM bound

**Locations:** sections 3, 10–11.

- `proofs/ft1536/stages/FT1536_POST_M0_FREEZE_RUN_001/inputs/proofs/ft1536/documents/FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md`:
  Section 3.4 explicitly excludes
  a fictitious QROM number and lists quantum resource/oracle/channel and
  reprogramming obligations. Classical q_h+1 indexing does not lift to
  superposition queries.
- `R/Run2/Games.lean`: `ClassicalAdversary` and classical Program interface.

### C19 — none support, byte-support risk and the conditional floor

**Locations:** sections 6, 11.

- `R/ONoneGeometry.lean`: `liftFin_decode_ge`, `liftPair_norm_ge`,
  `onone_syndrome`, `hone`, `signBody_none_pos_syndrome`.
  Values: residue 18433, decoded coordinate 47103, block 4437385218>B.
- `R/SignLayerSupport.lean`: `emitted_reply_supported`,
  `wrap_channel_in_support`, `chi2_top_of_out_of_support`.
- `R/T5Pointwise.lean`: `machineFloor`, `machineFloor_gt` (>991),
  `machineStage_of_absErr_floor` (pointwise hfl and both E-budget premises).
- `R/CenteringClosure.lean`: `t5_leaf_floor_gt` is a scalar-leaf bound,
  not proof of a floor for every realized Gaussian/fiber weight.

### C20 — numerical display and symmetric ceiling convention

**Locations:** abstract; sections 1, 8, 10–11; Annex A.

- Binding outline §8: explicitly requested 256 classical /128 quantum
  symmetric reporting convention for ChaCha20/SHAKE, applied consistently
  to all rows. This is a ceiling convention, not a kernel security result.
- `paper/sources/EXTERNAL_REFERENCES.md` and `paper/refs.bib`: versioned
  Grover reference, metadata checked 2026-10-06. Generic O(sqrt(N)) query
  search is distinct from a hardware gate count or a QROM signature proof.
  The same files carry the section-10 literature context entries
  (`falcon2018`, `hps1998`, `gpv2008`, `lyu2012`, `dilithium2018`,
  `fktwy2020`), each verified against public bibliographic metadata on
  2026-10-10 before being cited. They are cited as design/attack context
  only, not as compared guarantees; `falcon2018` is the NIST submission
  document, and no peer-reviewed 2018 proceedings paper by that exact
  title/author list was identified. Uncertain items remain TODO.
- `paper/tools/check_numbers.sage`: QQ arithmetic for 0.292β and 0.265β,
  minima, decimal rounding, and 256/2=128. `paper/build/numbers/run_001/`
  `RECEIPT.json` binds the script, argv, exit status and result bytes.

### C21 — B1 stage ledger status (B1.05 / B1.06 / B1.07)

**Locations:** abstract; sections 1–3, 7, 11; Annex A.

- `S/KeygenCallerSuccess.lean`: `exact_integer_ntru` (with `success`,
  `Solved`, `Exec`, `RootGate`, `nonzero_one`, `call_boolean`).
  B1.05 closed at BATCH_032 scope: bounds 1/1/2047/2047,
  `multiply f G - multiply g F = constantCoeffs (18433 : Int)`, and the
  four output-slot representations. The module header states this is not
  the whole KeyGen loop, an emitted-key theorem, or a security claim.
- `S/KeygenPublicAccepted.lean`: `source_same_material` and `Material`
  (`KeygenPublicNormalizePolynomial.Represents` for canonical `h`,
  `Nonzero fv`, `mulRq hv (reduceVec fv) = reduceVec gv`,
  `mulRq fInv (reduceVec fv) = constantCoeffs 1`). B1.06 Acceptance MET
  at BATCH_046 scope: both equations, retained f/g bytes, mathematical
  `fInv`; no correctness, invertibility or round-trip premise introduced.
  `Nonzero fv` means nonzero evaluations in the public field, not an
  assumed vector inequality `f != 0`. Entry profile, legal memory,
  bounds, material, table lifetime and output separation are hypotheses.
- `SN/KEYGEN_SOURCE_TO_FIBER_001_BATCH_032.json` and `..._032_NOTES.md`:
  B1.05 Acceptance pair (added explicitly in this editorial revision).
- `SN/KEYGEN_SOURCE_TO_FIBER_001_BATCH_046.json` and `..._046_NOTES.md`:
  the sealed B1.06 Acceptance pair; `..._047.json` and `..._047_NOTES.md`:
  the sealed B1.07 enclosing-entry/first-sampling midpoint pair.
- `SN/KEYGEN_SOURCE_TO_FIBER_001_BATCH_048.json` and `..._048_NOTES.md`:
  the complete-readiness midpoint already described by the pinned cumulative
  checkpoint. Acceptance NOT MET / NOT_REVIEWED. Pair hashes were compared
  with the checkpoint's external pins before inclusion.
- `SN/KEYGEN_RESIDUE_CHECKPOINT.md`: the cumulative stage ledger. The
  paper cites sections 12/12.1 (B1.05 exact boundary), 26/26.1 (B1.06
  Acceptance type) and the top B1.07 status blocks. The B1.07 statements
  in the paper are status-only (partial proof, Acceptance not met, not
  reviewed, named remaining obligations).

**Status:** kernel-scoped stage records, NOT_REVIEWED at every listed
stage. Nothing here extends to whole KeyGen, termination, key or emitted
laws, probabilities, PRG/security; B1.07 Acceptance is not met and its
deterministic traces license no IID, p_accept or availability formula.

## Reconciliation decisions made in the draft

1. The prompt's scope-file path was stale: the actual file is at the T12_1 root.
2. CLOSED means the stated conditional component; it is not REVIEWED or a
   full C-security claim. The abstract does not copy the aspirational outline.
3. AUTHOR_RECHECK is not independent review. Reported review counts do not
   substitute for the pinned role flags and exact versions.
4. The generator module's literal Nat power checks are quoted; the paper
   does not invent a stronger named order theorem.
5. The F-001 discussion states the actual nonzero-cursor defect and scoped
   census, avoiding a blanket failure claim for every refill-spanning call.
6. B3-local codec facts and output-buffer exclusions do not discharge A3/A4.
7. The updated REV10 checkpoint is included; B1.03 row/value closure is not.
8. S06 status remains CHANGES_REQUIRED, including the Falcon-anchor model
   conventions. No part of the table is a certified system-security level.
9. A post-build pin check detected the concurrent synthesis update 9b12f04e.
   The new independent REVIEW_003 was read and pinned explicitly. Section 9
   and Annex A now record its scoped verdict while preserving REVIEW_002's
   author-recheck status. This is an evidence update, not a stronger theorem.
10. The late pin diff also contains the source3 stage-(b) checkpoint and
    be610737's clarification of the one-time final archive import. Both diffs
    were read explicitly. The former preserves the quoted REV10 facts in §5
    and keeps row/layout laws open; the latter changes release sequencing,
    not a theorem. Their earlier bytes remain in the previous paper snapshot.
11. Window-2 status ledger (2026-10-10): the paper reports B1.05 closed,
    B1.06 Acceptance met and B1.07 in progress exactly as scoped by their
    Acceptance blocks and the pinned exports (C21). No ledger statement
    extends to whole KeyGen, termination, key laws or security, and no
    stage is described as independently reviewed. The paper quotes only
    `exact_integer_ntru` and `source_same_material`; no new mathematical
    claim is introduced by the status update.
12. The pinned `KEYGEN_RESIDUE_CHECKPOINT.md` is a live file of the
    parallel B1 lane. At this revision's pin time it contained the
    BATCH_048 close (the lane's closing commit `915178a1` landed during
    this window with byte-identical content; all 112 pins were re-verified
    after that commit). The paper cites only the cumulative closed sections
    (12, 26) and status lines, which persist across later prepends. Any
    later window must read the checkpoint diff before repinning, as in
    item 9. The 2026-10-06 bytes of this file remain in paper commit
    `3333088d`.
13. The other Batch-3 pin drift, `N/B4_SYNTHESIS.md`, was read at this
    revision (commits `0a72596b`, `30359d3b`, `da0cbf5f`, `98a4abf6`,
    `a2c5e304`): B1.03/B1.04 Acceptance records, the B1.05 chain
    `fG - gF = 18433` with bounds 1/2047, and the state-review
    do-not-reopen map. None of these changes the four-arrow target, the
    review chronology or any claim quoted from that file; the paper's
    B1.05 statement matches its recorded equation. The superseded bytes
    remain in paper commit `3333088d`.
14. Form pass (addendum, window 3, 2026-10-10): the section order now
    follows the classical crypto skeleton (preliminaries/notation,
    scheme with boxed algorithms, main theorem, reduction, sampler,
    binding, security levels, computational seam, related work,
    conclusion; references before appendices). The algorithm boxes
    restate pinned interfaces only (C02/C03/C05) and carry scope
    pointers to the B1 stage ledger; the family table reports dashes for
    quantities not pinned (FT byte sizes are not invented). The
    tape-length symbol was renamed $n\to N$ so that $n$ is the ring
    dimension; the quantity is unchanged. Theorem/definition/assumption
    numbering and cross-references are editorial; every statement keeps
    its original scope, and the end-to-end thesis remains a target
    statement, not a theorem. Bibliography additions are limited to the
    verified entries recorded in C20 and `sources/EXTERNAL_REFERENCES.md`.

15. ADDENDUM 3: comparison with the owner's specification and CANDIDATE_R2
    exposed presentation errors in revision 4ac46f50. The abstract's
    assertion that every mathematical statement was already code-bound
    was too strong; it now states the conditional reduction and local
    source results separately. Algorithm 1 now preserves the actual order
    (public computation before solver and leaf certificate); Algorithm 2
    returns terminal emission failure instead of suggesting a retry.
    The statistical tape theorem's partially renamed `n` is consistently
    `N` throughout. These are corrections of the manuscript against
    existing pins, not new mathematical results or changes to C.
16. In-PDF identity and evidence classes now follow the benchmark format.
    The source map and manifest have full SHA-256 identifiers, with selected
    exact artifacts and base/closure commit IDs. Benchmark contents were
    not imported as theorem sources. Existing B1 scopes, S06 diagnostics,
    attempt-shape dependence, A3/A4 and classical-only scope are retained.
17. The earlier notes' blanket statement that all bibliography primary
    sources had been inspected exceeded the recorded metadata-search work.
    Section 10 now describes bibliographic context and keeps the primary
    literature scan explicitly open. No new reference was added here.

18. Redaction-window pin drift (2026-10-10): `KEYGEN_RESIDUE_CHECKPOINT.md`
    and `N/B4_SYNTHESIS.md` changed on disk since the ADDENDUM 3 pins; both
    diffs were read before repinning. The checkpoint gained the BATCH_049/
    BATCH_050 close blocks (whole-caller syntax and failure-lifetime
    midpoint; chronological five-gate source-prefix midpoint) and still
    records B1.07 as PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED,
    so the paper's stage-status statements remain valid and are not
    promoted to the later midpoint records. `B4_SYNTHESIS.md` gained the
    2026-10-10 state review and the owner-chosen reviewer's editorial map
    for ePrint; no fact quoted by the paper changed (four-arrow target,
    review chronology and the B1.05 equation are unchanged). Superseded
    bytes remain in the previous paper commits.
19. Redaction pass (main text): the narrative now runs source execution
    -> material and law -> security experiment -> reduction; the B1.05/
    B1.06 results are stated as ordinary propositions with their exact
    premises and conclusions (restating `exact_integer_ntru` and
    `source_same_material`, nothing stronger); batch identifiers, export
    names and hashes live in the theorem-to-export compliance table of
    Appendix A; the closed reduction is written out without the proof
    assistant (second-moment direction, adaptive induction, collision
    loss, extraction to MT-ISIS); retry limits, re-sampling, emission
    failure and buffer-capacity error are described in the experiment
    text rather than scope footnotes. Abstract, main theorem formula and
    the security-accounting summary were deliberately left for the final
    composition. Related Work remains the declared stub of the separate
    literature phase. No new mathematical claim, replay or review.

## Pinned input files

This inventory is machine-read by `tools/pin_sources.py` and checked against
`SOURCES.sha256` by `tools/check_paper.py`. Pins identify the drafting snapshot;
ordinary checks never refresh them. Paths in this block are literal.

<!-- PINNED_INPUTS -->
```text
.gitignore
proofs/ft1536/development/T12_1/run2/notes/PROMPT_PAPER.md
proofs/ft1536/documents/FT1536_PAPER_OUTLINE_2026-10-06.md
proofs/ft1536/development/T12_1/END_TO_END_SCOPE.md
proofs/ft1536/development/T12_1/run2/ARCHIVED_DEPENDENCIES.json
proofs/ft1536/development/T12_1/run2/formal/Assembly.lean
proofs/ft1536/development/T12_1/run2/formal/AssemblyComp.lean
proofs/ft1536/development/T12_1/run2/formal/CompPrg.lean
proofs/ft1536/development/T12_1/run2/formal/AdvPrg.lean
proofs/ft1536/development/T12_1/run2/formal/SignLayerSupport.lean
proofs/ft1536/development/T12_1/run2/formal/AttemptPointwise.lean
proofs/ft1536/development/T12_1/run2/formal/AttemptWeights.lean
proofs/ft1536/development/T12_1/run2/formal/T5Pointwise.lean
proofs/ft1536/development/T12_1/run2/formal/SecondMoment.lean
proofs/ft1536/development/T12_1/run2/formal/JointDecomp.lean
proofs/ft1536/development/T12_1/run2/formal/HacGlue.lean
proofs/ft1536/development/T12_1/run2/formal/ONoneGeometry.lean
proofs/ft1536/development/T12_1/run2/formal/CenteringClosure.lean
proofs/ft1536/development/T12_1/run2/formal/Run2/T5ScalarMass.lean
proofs/ft1536/development/T12_1/run2/formal/Run2/LawBinding.lean
proofs/ft1536/development/T12_1/run2/formal/Run2/Games.lean
proofs/ft1536/development/T12_1/run2/formal/Run2/FiniteDist.lean
proofs/ft1536/development/T12_1/run2/formal/Run2/MTBinding.lean
proofs/ft1536/development/T12_1/run2/formal/Run2/LazyEventBinding.lean
proofs/ft1536/development/T12_1/run2/formal/Run2/StoppedComparison.lean
proofs/ft1536/development/T12_1/run2/formal/Run2/ConcreteReduction.lean
proofs/ft1536/stages/FT1536_MATH_EUFCMA_MTISIS_RUN_001/formal/FT1536/EventTransfer.lean
proofs/ft1536/stages/FT1536_MATH_EUFCMA_MTISIS_RUN_001/formal/FT1536/Relation.lean
proofs/ft1536/stages/FT1536_CENTERING_CLOSURE_RUN_001/library/FT1536/Geometry.lean
proofs/ft1536/stages/FT1536_CENTERING_CLOSURE_RUN_001/library/FT1536/PublicSimulation.lean
proofs/ft1536/stages/FT1536_CENTERING_CLOSURE_RUN_001/library/FT1536/MathSign.lean
proofs/ft1536/stages/FT1536_CENTERING_CLOSURE_RUN_001/library/FT1536/Divergence.lean
proofs/ft1536/development/T12_1/run2/formal/VerifyBind/HashTo.lean
proofs/ft1536/development/T12_1/run2/formal/VerifyBind/StaticCodec.lean
proofs/ft1536/development/T12_1/run2/formal/VerifyBind/ByteCodec.lean
proofs/ft1536/development/T12_1/run2/formal/VerifyBind/Verdict.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenGeneratorOrder.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenMkgm3Program.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenRev10Cert.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenNttFirstLoop.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenNttTripleLoop.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenNttMiddleLoops.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenNttForwardExec.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenNttButterflyCalls.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/C99ModularReference.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/C99ModularParser.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenMkgm3Callees.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenCallerSuccess.lean
proofs/ft1536/development/T12_1/source3/formal/Source3/KeygenPublicAccepted.lean
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_014_NOTES.md
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_014.json
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_015.json
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_032.json
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_032_NOTES.md
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_046.json
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_046_NOTES.md
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_047.json
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_047_NOTES.md
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_048.json
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_048_NOTES.md
proofs/ft1536/development/T12_1/source3/notes/run/KEYGEN_RESIDUE_CHECKPOINT.md
proofs/ft1536/development/T12_1/source3/.build/jobs/keygen_rev10_cert_004/RECEIPTS.json
proofs/ft1536/documents/FT1536_C_CODE_FINDINGS_2026-10-02.md
Extra/c/Makefile
Extra/c/frng.c
Extra/c/falcon-keygen.c
Extra/c/falcon-sign.c
Extra/c/internal.h
Reference_Implemention/falcon512/frng.c
Reference_Implemention/falcon768/frng.c
Reference_Implemention/falcon1024/frng.c
Optimized_Implemention/falcon512/frng.c
Optimized_Implemention/falcon768/frng.c
Optimized_Implemention/falcon1024/frng.c
proofs/ft1536/work/FT1536_FG_PROBE_P_ACCEPT_001/out/RECEIPT.json
proofs/ft1536/development/T12_1/run2/notes/B4_SYNTHESIS.md
proofs/ft1536/development/T12_1/run2/notes/B5_WORK_STATE.md
proofs/ft1536/development/T12_1/run2/notes/B2_ADVPRG_WORK_STATE.md
proofs/ft1536/development/T12_1/run2/notes/B2B5_COMPUTATIONAL_WORK_STATE.md
proofs/ft1536/development/T12_1/run2/notes/B4_ATTEMPT_WEIGHTS_WORK_STATE.md
proofs/ft1536/development/T12_1/run2/notes/T5_POINTWISE_WORK_STATE.md
proofs/ft1536/development/T12_1/run2/notes/S1_P_ACCEPT_FACTS.md
proofs/ft1536/development/T12_1/run2/notes/S3_E_PROVENANCE.md
proofs/ft1536/development/T12_1/run2/notes/VERIFY_BIND_WORK_STATE.md
proofs/ft1536/development/T12_1/run2/notes/VERIFY_BIND_SIGN_SIDE_NOTES.md
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_001/REVIEW.md
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_002/REVIEW.md
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_002/SUPPLEMENT_K1_E4.md
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_002/REVIEW_RESULT_FINAL.json
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_002/checks/KOneAndPsi.lean
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_002/receipts/clean_001/RECEIPT.json
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_002/receipts/controls_002/RECEIPT.json
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_002/receipts/k1_002/RECEIPT.json
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/REVIEW.md
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/REVIEW_RESULT.json
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/OUTPUTS.sha256
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/inputs/PREPARE_REPORT.json
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/receipts/clean_indep_001/RECEIPT.json
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/receipts/checks_r3/RECEIPT.json
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/checks/IndepContract.lean
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/checks/IndepInverse.lean
proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/checks/IndepKOne.lean
proofs/ft1536/development/T12_1/run2/.build/b2b5_e1e5_001/inputs/ENVIRONMENT.json
proofs/ft1536/development/T12_1/run2/.build/b2b5_e1e5_001/receipts/audits_002/001_CompPrgCompleteAudit.log
proofs/ft1536/development/T12_1/run2/.build/b2b5_e1e5_001/receipts/audits_002/002_AssemblyCompCompleteAudit.log
proofs/ft1536/development/T12_1/run2/.build/b2b5_e1e5_001/FINAL_EVIDENCE_002.json
proofs/ft1536/validation/2026-09-22-family-estimator-independent/README.md
proofs/ft1536/stages/FT_FAMILY_SEC_ESTIMATE_REVIEW_RUN_001/REVIEW.md
proofs/ft1536/stages/FT_FAMILY_SEC_ESTIMATE_REVIEW_RUN_001/inputs/campaign/inputs/falcon/falcon-specification.pdf
proofs/ft1536/stages/FT_FAMILY_SEC_ESTIMATE_REVIEW_RUN_001/inputs/campaign/inputs/falcon/falcon-round3.zip
proofs/ft1536/stages/FT1536_POST_M0_FREEZE_RUN_001/inputs/proofs/ft1536/documents/FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md
proofs/ft1536/paper/sources/EXTERNAL_REFERENCES.md
proofs/ft1536/paper/sources/DOCUMENT_SNAPSHOT.json
proofs/ft1536/paper/refs.bib
proofs/ft1536/paper/tools/check_numbers.sage
proofs/ft1536/paper/build/numbers/run_001/RECEIPT.json
proofs/ft1536/paper/build/numbers/run_001/numbers.json
```
<!-- END_PINNED_INPUTS -->
