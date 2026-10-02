# B4/3b — AttemptWeights: the four-stage sandwich transport (work state)

Window `notes/PROMPT_ATTEMPT_WEIGHTS.md` (the heavy analytic core). Workspace
`proofs/ft1536/development/T12_1/run2/`. Own files only:
`formal/AttemptWeights.lean` + this note. Recorded 2026-10-02.

## Status

**DONE — `formal/AttemptWeights.lean` builds 0/0** (empty log = 0 errors / 0
warnings, guarded serial compile `tools/original/run_lean_guarded.sh`, exit 0).
Axiom audit: **51/51 declarations (all 39 theorems + all 12 defs) depend only
on `[propext, Classical.choice, Quot.sound]`** (`.build/audit/
AttemptWeightsAudit.lean` + `.log`, scratch under ignored `.build/`). No
unfinished-proof markers. All statements on the pinned MTISIS types
(`FT1536.Law`, `FT1536.Divergence`, `FT1536.PublicSimulation.*`,
`FT1536.SignLayerSupport.*`, `FT1536.AttemptPointwise.*`); the DEFINITION of
the realized attempt weights stays a NAMED PARAMETER (`AttemptShape`
interface, B1/source3 `S.code` binding — in progress), exactly as the window
demands.

Bottom line: the four-stage transport is proved for ANY weights satisfying the
interface; the margins compose kernel-side to `attemptFactor < 1 + 2^-38` and
`layer2_of_stageChain` delivers `second < 1 + 2^-32` from the four stage
statements; the WHOLE tail-region content is formalized and the bulk-only trap
is discharged by kernel counterexamples; the attempt-shape question is settled
(UNCONDITIONED) with the acceptance-conditioned delta proved exactly
(`rejB` moves inside at `1/(1-rejB)`).

## 1. THE exact stage table — proven vs assumed (the split IS the remaining
analytic scope)

| Stage | Sandwich (per point, ALL `z : BoxPair`, tail included) | Exact margin | Numeric status | Status here |
|---|---|---|---|---|
| 1 tower / fiber-tilt | `TowerWhole A c target` = `towerLo * fiberWeight A c ≤ target ≤ towerHi * fiberWeight A c` | `towerHi / towerLo = towerMargin = ((1+2^-46)/(1-2^-46))^2` (`tower_ratio`, CONSUMED) | `towerMargin < 1 + 2^-43` (`stage_tower_lt`, CONSUMED `SignLayerSupport.towerMargin_lt`) | margin **PROVEN**; the per-point sandwich = **ASSUMED stage data** (the exact missing lemma, below) |
| 2 machine (H3) | `MachineStage target mach` = `t5lo * target ≤ mach ≤ t5hi * target` | `t5hi / t5lo = machineMargin` | `machineMargin < 1 + 2^-42` (`stage_machine_lt`, CONSUMED) | margin **PROVEN**; sandwich = **ASSUMED stage data** |
| 3 wrap / centering | `WrapStage mach wrapS` = `(1-tauB) * mach ≤ wrapS ≤ (1+tauB) * mach` | `(1+tauB)/(1-tauB) = wrapFactor` (def) | `wrapFactor < 1 + 1/(2^39 - 1)` (`stage_wrap_lt`, NEW exact-ℚ; `tauB = 2^-40` CONSUMED) | margin **PROVEN**; sandwich = **ASSUMED stage data** |
| 4 box truncation | `BoxStage wrapS w` = `1 * wrapS ≤ w ≤ (1/(1-boxB)) * wrapS` | `1/(1-boxB) = boxFactor` (def) | `boxFactor < 1 + 10^-30` (`stage_box_lt`, NEW exact-ℚ; `boxB = 1e-1000` CONSUMED — the slack bound keeps the recorded `1e-1000` scale) | margin **PROVEN**; sandwich = **ASSUMED stage data** |
| composition | `attemptFactor = machineMargin * towerMargin * wrapFactor * boxFactor` (`attemptFactor_eq`, `rfl` — the exact table identity) | `chainHi / chainLo = attemptFactor` (`chain_ratio`, CONSUMED) | `attemptFactor < 1 + 2^-38` — `attemptFactor_comp_lt`, composed **FROM the stage table** (mul-chains + one exact-ℚ `norm_num` on the product of the four `(1+eps_i)`); independent composite path `attemptFactor_expanded_lt` CONSUMED as cross-check | **PROVEN** |
| Layer 2 | `e2 k = (k^16)^2 - 1 = k^32 - 1` | — | `e2 attemptFactor < 2^-32` (`e2_comp_lt`, CONSUMED `e2_attemptFactor_lt`) | **PROVEN** |

Deliverable form: `layer2_of_stageChain` — the four stage statements +
`ReplyShape` + `AttemptShape` give `Divergence.AC` and
`Divergence.second j (signBody A c) < 1 + 2^-32` (via `layer2_e2_actual` +
`attemptWeights_of_stages`). Generic mechanism: `sandwich_comp4` (four-fold
margin multiplication).

### THE exact missing lemma (input for the T5/REFINE material owners + B1/source3)

Intended type (already pinned in the module as `TowerWhole`):

    TowerWhole A c target
      = ∀ z : BoxPair, towerLo * fiberWeight A c z ≤ target z
          ∧ target z ≤ towerHi * fiberWeight A c z

with `target : BoxPair → ℝ` the sampler's realized target weights of ONE
`to_sign` attempt (definition from the `do_sign` kernel, B1/source3), over the
WHOLE candidate space INCLUDING the tail region `¬ Q (decode z) < B`.
Analogously `MachineStage`/`WrapStage`/`BoxStage` onto the realized
`mach`/`wrapS`/`w`. Honest analysis of the toolkit: the analytic kernel
bounds (`TriangularGaussian.triangular_mass_bounds`,
`ConvStruct.a2Tower_mass_bounds`, `Run2.ShiftedGaussian.shifted_mass_bounds`,
`Run2.T5ScalarMass.uniform_shifted_mass_3072`,
`PerKeyTransport.perKey_mass_bounds`) are **TOTAL-mass statements**
(whole-space sums — bulk and tail together). They do NOT by themselves give
per-point or per-region sandwiches; the per-point transport of stage 1 is the
missing material. Never assumed here.

## 2. The WHOLE tail-region transport (the named heavy item) — proved here

- Small defs (`SecondMoment` style): `regionMass u R = ∑ z, u z * (if R z then
  1 else 0)`, `bulkMass u` (in-box region), `RegionSandwich lo hi g w R` (the
  stage sandwich restricted to a region).
- **`sandwich_regionMass`** — the global tail-region statement of the
  transport: any region sandwich composes to the region masses at the SAME
  margins, for EVERY region predicate — hence for the whole tail region. With
  `tailMass_eq_regionMass`/`bulkMass_eq_regionMass`/`bulk_add_tail` this gives
  `sandwich_tailMass`, `sandwich_bulkMass` and the normalized miss comparison
  `tail_ratio_le` (`tailMass w / ∑ w ≤ (hi/lo) * tailMass g / ∑ g`).
- **THE trap, discharged as kernel counterexamples** (the claim of
  `notes/B4_ATTEMPT_WORK_STATE.md` §3 case (ii) is now a theorem): `bulkOnly_tail_uncontrolled`
  and `bulkOnly_normalized_tail_uncontrolled` — there exist weight systems
  with an exact BULK sandwich at any margins `lo ≤ 1 ≤ hi` whose tail masses
  violate BOTH the unnormalized (`tailMass w ≤ hi * tailMass g`) and the
  normalized miss comparison. Witnesses are concrete: `zeroPair` in-box
  (`FT1536.PublicSimulation.zero_norm`), `ONoneGeometry.liftPair zeroPair`
  out-of-box (`liftPair_out_of_box`). `towerBulkOnly_tail_uncontrolled` pins
  the trap at the EXACT stage-1 margins. Conclusion: the whole-tail-region
  sandwich is a NON-OPTIONAL part of the `AttemptWeights` premise.

## 3. Which attempt shape the transport proves — and the delta

**VERDICT: the transport proves the UNCONDITIONED sample-then-check shape** —
`AttemptShape jT w hw` over the FULL realized target `w` (`attemptOf w`, miss
= out-of-box), so `CenteringClosure.rejB = 2^-24` stays OUTSIDE the
multiplicative factor (`layer2_of_stageChain`).

**THE delta (kernel-checked), for the acceptance-conditioned shape** (draw-
until-short WITHIN one attempt = `attemptCondWeights w`, the in-box truncation
of `w`):

- `attemptCondWeights_tailMass` — the truncated weights have ZERO tail mass,
  so the whole-tail-region sandwich CANNOT transport (exactly the trap of §2);
  the BULK sandwich suffices.
- `conditioned_ratio_le` + `conditioned_attemptOf_le` — the some-side
  comparison picks up EXACTLY `1/(1-rejB)` from the honest miss budget
  (`tailMass g ≤ rejB * ∑ g`, named premise): the pointwise factor becomes
  `(hi/lo) / rejComp` with `rejComp = 1 - rejB`.
- Numeric delta: `conditionedFactor = attemptFactor / rejComp` satisfies
  `1 ≤ conditionedFactor` and `conditionedFactor < 1 + 2^-23`
  (`conditionedFactor_one_le`, `conditionedFactor_lt`); `e2
  conditionedFactor < 2^-17` (`e2_conditionedFactor_lt`; the analytic scale is
  `~ 2^-19`, the `1+2na` budget step of `pow_succ_le_real` keeps the slack).
- Packaging: `attemptPointwise_of_conditionedChain` (from the four-stage chain
  through its BULK part + the miss budget) and `layer2_e2_conditioned`:
  `Divergence.second j (signBody A c) < 1 + 2^-17` for this shape. So `rejB`
  moves INSIDE the multiplicative accounting exactly as the recorded trap
  predicted — and the delta is now a theorem, not a warning.

## 4. Honest boundaries (unchanged + this window's)

- The realized-weight DEFINITION (`w`/`target`/`mach`/`wrapS`) and the
  `S.code` binding remain the `AttemptShape` interface (B1/source3) — taken as
  named parameters; this window proves the TRANSPORT only.
- Additive errors (`Adv_PRG`, byte bridges) stay OUT of the multiplicative
  shape (mass-floor caveat of `notes/B4_SYNTHESIS.md`, unchanged).
- The conditioned-shape packaging uses `AttemptWeights` through its bulk part;
  its own tail-region content is vacuous (`tailMass = 0`) — recorded, not
  papered over.
- `rejComp` is a naming wrapper (`ℝ`) around `1 - (↑rejB : ℝ)` for toolchain
  reasons (see lessons); no numeric content is hidden in it.

## 5. Compile receipt

- Source: `formal/AttemptWeights.lean` (781 lines); module `AttemptWeights`;
  command `bash tools/original/run_lean_guarded.sh formal/AttemptWeights.lean
  .build/check_lib/AttemptWeights.olean 900 3600` — exit 0.
- Log `.build/check_lib/AttemptWeights.log`: **empty** = 0 errors / 0 warnings
  (no linter warnings; `set_option maxRecDepth 8192` in the module header).
- Axiom audit `.build/audit/AttemptWeightsAudit.lean` + `.log`: **51/51
  declarations (all 39 theorems + all 12 defs), axioms `[propext,
  Classical.choice, Quot.sound]` only**.
- Marker check: no `sorry`/`admit`/`native_decide`/`hypothesis`/placeholders.
- Dependencies (REUSE, unmodified): `AttemptPointwise` (`AttemptShape`,
  `AttemptWeights`, `Sandwich`, `sandwich_comp`/`sandwich_sum`,
  `attemptOf`/`attemptOf_some`/`attemptOf_none`, `tailMass`, `towerLo`/
  `towerHi`/`tower_ratio`, `chainLo`/`chainHi`/`chain_ratio`/`chain_pos`/
  `chain_le`, `attemptWeights_sandwich`/`attemptWeights_nonneg`,
  `trial_eq_attemptOf`, `layer2_e2_actual`), `SignLayerSupport` (`ReplyShape`,
  `AttemptPointwise` structure, `layer2_of_obligations`, `attemptFactor`,
  `machineMargin`/`towerMargin` + `_lt`/`_one_le`, `attemptFactor_lt`,
  `attemptFactor_one_le`, `e2`, `e2_attemptFactor_lt`, `pow_succ_le_real`),
  `CenteringClosure` (`t5lo`/`t5hi`, `tauB`, `boxB`, `rejB`),
  `Run2.T5ScalarMass` (`rowBudget`), `ONoneGeometry` (`liftPair`,
  `liftPair_out_of_box`), `FT1536.PublicSimulation` (`zeroPair`, `zero_norm`,
  `fiberWeight`, `fiberWeight_nonneg`), pinned `FT1536.*` model types.

## 6. Lessons (toolchain, for the next batch)

- **`Rat.cast` unification depth**: a type mentioning `(↑(1/16777216) : ℝ)`
  (the `CenteringClosure.rejB` literal under a coercion) blows `maxRecDepth`
  when two such types meet in TERM-MODE unification (`mul_le_mul_of_nonneg_left`,
  `calc` step alignment) — tactic-mode proofs of the same statements are fine.
  Fix: route the term through a named `ℝ` def (`rejComp`) so unification stays
  shallow; keep `norm_num [rejComp, CenteringClosure.rejB]` for the numeric
  checks. `set_option maxRecDepth 8192` is a useful belt.
- `Finset.sum_add_distrib` in this Mathlib takes NO explicit args (its type is
  the bare equation) — `sum_add_distrib _ _` errors "Function expected"; use
  the bare term when the expected type is concrete.
- `Finset.mul_sum` fold direction in `sandwich`-style proofs: with
  `hfold : ∑ z, hi * F z = hi * ∑ z, F z`, the upper branch of the composition
  needs `rw [← hfold]` (the lower branch with `lo` likewise) — flipping the
  direction gives "Did not find an occurrence of the pattern".
- `Finset.sum_pos'` wants `(∀ x ∈ s, 0 ≤ f x)` — pass `fun z _ => ...`; a
  plain `∀ z, ...` fails to apply.
- The `le_refl 1` numeral trap again: gives `(1:ℕ) ≤ 1`; use `zero_le_one`
  for ℝ goals `0 ≤ (fun _ => 1) z` (beta-defeq is accepted).
- After `rw [hwb]` rewriting the goal, a `calc` must start from the REWRITTEN
  LHS (`w z / ...`, not `attemptCondWeights w z / ...`) — otherwise "invalid
  'calc' step".
- `rw [zero_div, div_zero]` in one call fails when only one shape is present
  (`div_zero` finds `?a / 0` nowhere); collapse with `simp` after the
  `key`-rewrites instead.
- `bulkMass_eq_regionMass` is closed by `simp only [bulkMass, regionMass]`
  ALONE (both sides beta-reduce to the same `ite`); a follow-up
  `apply sum_congr rfl` then errors "No goals to be solved".
- Rewriting a law's `mass none` (`rw [... attemptOf_none g hg]`) leaves the
  `if 0 < ∑ z, g z then ... else 1` expression; to reuse
  `(attemptOf g hg).nonneg none` bridge INSIDE a `have` with
  `rw [← attemptOf_none g hg]` (the direct `exact` is a type mismatch).

## 7. Handoff (PL) — stage table w skrócie

Złożony czynnik to **`attemptFactor = machineMargin * towerMargin *
wrapFactor * boxFactor < 1 + 2^-38`** (`attemptFactor_eq` to `rfl` — tabela
dokładna), dalej `e2 = k^32 - 1 < 2^-32`. Rozkład marż: wieża/fiber-tilt
`towerMargin < 1 + 2^-43` i maszyna `machineMargin < 1 + 2^-42` — obie
**liczbowo domknięte** (konsumowane z `SignLayerSupport`), wrap
`wrapFactor < 1 + 1/(2^39-1)` i box `boxFactor < 1 + 10^-30` — **nowe
dokładne-ℚ**, plus kompozycja **wyliczona z tabeli**, nie z rozwinięcia.
**Założone** (dane etapowe o dokładnych typach `TowerWhole`/`MachineStage`/
`WrapStage`/`BoxStage`) są cztery kanapki punktowe na zrealizowanych wagach
sampler-a — to jest dokładnie brakujący lemma dla materiału T5/REFINE +
jądra `do_sign` (B1/source3). Udowodniono ponadto, że kanapka musi obejmować
CAŁY region ogona (kontrprzykłady kernelowe: sama kanapka na „bulk" nie
steruje punktem `none`), oraz że transport rozstrzyga kształt próby
NIEWARUNKOWANY (`rejB` poza czynnikiem); wariant conditioned ma delta
dokładnie `1/(1-rejB)` (`conditionedFactor < 1 + 2^-23`, `e2 < 2^-17`).
