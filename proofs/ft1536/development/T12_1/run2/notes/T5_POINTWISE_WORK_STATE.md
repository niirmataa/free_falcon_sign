# T5-pointwise — the pointwise road to the four stage sandwiches (work state)

Window `notes/PROMPT_T5_POINTWISE.md` (new window: T5-pointwise). Workspace
`proofs/ft1536/development/T12_1/run2/`. Own files: `formal/T5Pointwise.lean` +
this note. Recorded 2026-10-02.

## Status

**DONE — `formal/T5Pointwise.lean` builds 0/0** (empty log = 0 errors / 0
warnings, guarded serial compile `tools/original/run_lean_guarded.sh`, exit 0,
24 s). Axiom audit: **56/56 declarations (5 structures + 7 defs + 44 theorems;
breakdown corrected after independent review 2026-10-02, total unchanged)
depend only on `[propext, Classical.choice, Quot.sound]`** (`.build/audit/
T5PointwiseAudit.lean` + `.log`). No unfinished-proof markers. All statements
on the pinned MTISIS types (`FT1536.PublicSimulation.*`,
`FT1536.SignLayerSupport.*`, `FT1536.AttemptPointwise.*`,
`FT1536.AttemptWeights.*`, `FT1536.CenteringClosure.*`, `Run2.T5ScalarMass`);
no realized-weight definition is introduced — the four `*Road` strengthenings
sit over the ABSTRACT `target`/`mach`/`wrapS`/`w` interface.

## 0. PROVENANCE (recorded honestly — the collision of 2026-10-02)

The module body (Parts 1-6 below) was drafted by the PARALLEL window B of the
same prompt; that window overwrote window A's in-flight file mid-compile (the
incident record, snapshots `notes/collision_2026-10-02/T5Pointwise.windowB-2016.lean`
and `...windowB-2029.lean` = the takeover base `sha256 b2b36cad…`, mixed log
`...windowB-mixed.log` — all left untouched). Owner decision: **take over and
finish window B's project** — window A's own version was NOT written to disk;
window A contributed only (i) the mechanical repairs below, (ii) the marked
SUPPLEMENTS (`machineFloor`/`machineFloor_gt`/`machineStage_of_absErr_floor`,
`massSandwich_not_pointwise` + the four stage-margin instances) and (iii) the
toolchain lessons. Repairs applied to the base (all mechanical): parenthesized
`∏`-bodies (`1 ∓ f x` precedence trap, §8), `Finset.prod_mul_distrib.symm`
direction, one binder-shape fix (`h.row_nonneg i z`), two dangling `ring`
tactics, one `nlinarith`-context fix, one invalid `show … at` syntax, one
`exact_mod_cast` literal shape, one `inv_le_inv₀` argument order, and the
`wrapA_pow_inv_1536` hypothesis-order fix (§8, the Rat.cast context trap).

## 1. THE stage table — what is pointwise-PROVEN vs what needs B1 realization

| Stage | Exact strengthening (= the plug) | Re-shape to the `AttemptWeights` interface | Margin (CONSUMED) | State |
|---|---|---|---|---|
| 1 tower / fiber-tilt | `TowerRowRoad A c target rows exactRows realRows budget` — exact fiber support + pointwise row factorization + per-row sandwiches at budgets FITTING `towerLo`/`towerHi` | `towerWhole_of_rowRoad : TowerRowRoad … → TowerWhole A c target` | `towerLo = (1-rowBudget)^2`, `towerHi = (1+rowBudget)^2` (`tower_margin_row2` = the 2-row provenance) | transport **PROVEN**; the per-row PER-POINT realization = **owed** (T5/REFINE owners + B1 `do_sign`) |
| 2 machine (H3) | `MachineEvalRoad target mach multF divF` — 20 mult-class factors in `[1±roundU]` + 11 div-class in `[(1+roundU)⁻¹, (1-roundU)⁻¹]`, pointwise | `machineStage_of_evalRoad` + endpoints `t5lo_factorization`/`t5hi_factorization` | `t5lo = (1-u)^20·(1+u)^-11`, `t5hi = (1+u)^20·(1-u)^-11`; `machineMargin < 1+2^-42` CONSUMED | transport **PROVEN**; per-op binding of the `cmul`/`sErr` recurrence = **owed** (B1 + FPError `FprRefinement`) |
| 2b additive route | absolute channel `|mach z − target z| ≤ E` at floor `fl` (`machineFloor` = the consumed `t5_leaf_floor_gt` kernel floor) | `machineStage_of_absErr_floor` (SUPPLEMENT) | `E ≤ min (1-t5lo) (t5hi-1)·fl` | **PROVEN** conditional on the floor; floor-free version REFUTED (`additiveError_no_machineStage`) |
| 3 wrap / centering | `WrapCoordRoad mach wrapS coordF` — 1536 per-coordinate factors in `[(1+wrapA)⁻¹, 1+wrapA]`, `wrapA = t5a = 6y/(1-y)^2` | `wrapStage_of_coordRoad` (via `wrapA_pow_1536_le`, `wrapA_pow_inv_1536`) | `wrapT = tauB = 2^-40` (`CenteringClosure.tau_budget` envelope); `wrapFactor < 1+1/(2^39-1)` CONSUMED | transport **PROVEN**; per-coordinate wrap/centering realization = **owed** (`hbridge` side + B1) |
| 4 box truncation | `BoxRetentionRoad wrapS w rho` — uniform whole-space retention `rho ∈ [1-boxB, 1]`, bulk AND tail together | `boxStage_of_retention` | `boxFactor = 1/(1-boxB)`, `boxB = 1e-1000`; `boxFactor < 1+1e-30` CONSUMED | transport **PROVEN**; retention realization = **owed** (B1 + `hbridge`) |
| composition | `PointwiseStageRoad` (all four roads) | `stageChain_of_stageRoad`, `attemptWeights_of_stageRoad`, `layer2_of_stageRoad` | `attemptFactor < 1+2^-38`, `e2 < 2^-32` CONSUMED | **PROVEN** from the roads |

**THE final interface types (= the last plug for `hattempt`):**

    PointwiseStageRoad A c target mach wrapS w            -- the four roads
    attemptWeights_of_stageRoad : PointwiseStageRoad … → AttemptWeights A c w
    layer2_of_stageRoad : ReplyShape → AttemptShape → PointwiseStageRoad …
        → Divergence.AC j (signBody A c)
          ∧ Divergence.second j (signBody A c) < 1 + 2^-32

With B1's `AttemptShape` + `ReplyShape` (the `S.code`/`do_sign` binding) and
the four roads realized on the `do_sign` weights, `hattempt` closes with **no
new mathematics**.

## 2. The row road and its margin arithmetic (kernel)

- `RowFactors`/`RowSandwichOn` (defs first) + `rowProduct_sandwich_at` /
  `rowProduct_sandwich`: per-row pointwise sandwiches compose by PRODUCTS to
  per-point sandwiches at the product margins — one point, no mass, no
  division, no averaging. This is the precise statement of "per-ROW
  multiplicative ratios compose to per-POINT factors".
- `towerWhole_iff` (kernel): the stage-1 pointwise shape FORCES exact fiber
  support of the realized target (`target z = 0` off the fiber) — real content
  a total-mass bound never carries.
- `tower_margin_row2`: the recorded margins are EXACTLY the 2-row product at
  full `rowBudget` (the `ConvStruct.a2Tower_mass_bounds` n = 2 shape).
- `road_fit_3072_rows`: a 3072-row product fits the recorded margins at
  per-row `2^-58`-class budgets (the B1 envelope if row-factorized over all
  scalar rows).
- `rowwise_fullBudget_busts` (HONEST FINDING): full `rowBudget` per row over
  3072 rows BUSTS the whole composite budget (`> 1+2^-38` from this factor
  alone) — the recorded `1+2^-43`-class pointwise bound is NOT what a
  full-`rowBudget` row product gives (`2^-34`-class,
  `Run2.T5ScalarMass.scalar_power_margins`).

## 3. The kernel counterexamples (nothing pointwise comes from masses or additives)

- `additiveError_no_machineStage` (window B): additive accuracy `|mach−target|
  ≤ 1` is compatible with arbitrarily bad pointwise ratios — the additive
  `cmul`/`sErr` chains restate multiplicatively ONLY with a mass floor.
- `machineFloor`/`machineFloor_gt` (SUPPLEMENT): the recorded floor IS kernel
  (`CenteringClosure.t5_leaf_floor_gt`, `991 < machineFloor`).
- `machineStage_of_absErr_floor` (SUPPLEMENT): with the floor, the additive
  route DOES re-shape into `MachineStage` (`E ≤ min (1-t5lo) (t5hi-1)·fl`) —
  the floor gap closed conditionally, floor never assumed.
- `massSandwich_not_pointwise` (SUPPLEMENT): a TOTAL-mass sandwich at ANY
  `0 < lo ≤ hi` never implies the pointwise sandwich at the same margins —
  witnesses `zeroPair` (bulk) / `ONoneGeometry.liftPair zeroPair` (tail), so
  the failure hits BOTH regions. Instantiated at the exact recorded margins:
  `towerMass_not_pointwise`, `machineMass_not_pointwise`,
  `wrapMass_not_pointwise`, `boxMass_not_pointwise`. Hence the T5/REFINE
  totals (`Run2.TriangularGaussian.triangular_mass_bounds`,
  `Run2.ShiftedGaussian.shifted_mass_bounds`,
  `Run2.T5ScalarMass.uniform_shifted_mass_3072`,
  `ConvStruct.a2Tower_mass_bounds`, `PerKeyTransport.perKey_mass_bounds`) are
  NOT restatable pointwise as-is; every pointwise step arrives through Parts
  1-2's per-point structures.

## 4. Compile receipt

- Source: `formal/T5Pointwise.lean` (1003 lines); module `T5Pointwise`;
  command `bash tools/original/run_lean_guarded.sh formal/T5Pointwise.lean
  .build/check_lib/T5Pointwise.olean 900 3600` — exit 0, 24 s.
- Log `.build/check_lib/T5Pointwise.log`: **empty** = 0 errors / 0 warnings.
  (Per owner instruction the earlier tangled log was cleared before this
  compile; its preserved copy is
  `notes/collision_2026-10-02/T5Pointwise.windowB-mixed.log`.)
- Axiom audit `.build/audit/T5PointwiseAudit.lean` + `.log`: **56/56
  declarations, axioms `[propext, Classical.choice, Quot.sound]` only**.
- Marker check: no `sorry`/`admit`/`native_decide`/placeholders.
- Dependencies (REUSE, unmodified): `AttemptWeights` (`TowerWhole`,
  `MachineStage`, `WrapStage`, `BoxStage`, `attemptWeights_of_stages`,
  `layer2_of_stageChain`, `bulkOnly_tail_uncontrolled`, `stage_box_lt`),
  `AttemptPointwise` (`Sandwich`, `towerLo`/`towerHi`, `AttemptWeights`,
  `AttemptShape`, `fiberWeight_nonneg`, `chain_tower_nonneg`,
  `chain_machine_lo_nonneg`, `chain_wrap_lo_nonneg`),
  `SignLayerSupport` (`ReplyShape`, `machineMargin_lt`, `attemptFactor_lt`,
  `pow_succ_le_real`), `CenteringClosure` (`u`, `t5lo`/`t5hi`,
  `t5minus`/`t5plus`, `t5y`/`t5a`, `t5_leaf_floor_gt`, `machine`, `tau_budget`,
  `tauB`, `boxB`), `Run2.T5ScalarMass` (`rowBudget`),
  `ONoneGeometry` (`liftPair`, `liftPair_norm_ge`), `PublicSimulation`
  (`fiberWeight`, `gaussianWeight`, `zeroPair`, `zero_norm`), `Geometry` (`Q`,
  `B`, `decode`).

## 5. Handoff (PL) — które etapy są punktowo dowiedzione

**Wszystkie cztery „transporty" (re-shapingi) są DOWIEDZIONE kernelowo** —
razem z kompozycją do `attemptFactor < 1+2^-38` i `second < 1+2^-32`
(`layer2_of_stageRoad`). To, czego brakuje do zamknięcia `hattempt`, to
WYŁĄCZNIE realizacja czterech dróg na rzeczywistych wagach `do_sign`
(B1/source3) — żadnej nowej matematyki:

1. **TowerWhole** — realizacja `TowerRowRoad`: dokładne wsparcie fibry +
   faktoryzacja punktowa na wiersze wieży A2 (`GramLDL.gaussian_tower_atom`,
   `ConvStruct.a2Tower_atom`) + **per-ROW per-POINT ratio** w granicach
   mieszczących się w `towerLo`/`towerHi`. To jest dokładny punktowy
   odpowiednik `ShiftedGaussian.shifted_mass_bounds` (który jest tylko o masie
   wiersza). Uwaga uczciwa: przy 3072 wierszach budżet wiersza musi być
   `2^-58`-klasy (`road_fit_3072_rows`); pełny `rowBudget` na wiersz ROZBUDZA
   cały budżet (`rowwise_fullBudget_busts`).
2. **MachineStage** — realizacja `MachineEvalRoad` (31 czynników/warstwa
   20+11, wiązanie kroków rekurencji `cmul`/`sErr` z FPError
   `FprRefinement`) ALBO ścieżka addytywna z podłogą: `machineFloor`
   (już policzony kernelowo z `t5_leaf_floor_gt`) + `E ≤ min (1-t5lo)
   (t5hi-1)·fl` (`machineStage_of_absErr_floor` — gotowe, warunkowe tylko na
   podłodze i budżecie E).
3. **WrapStage** — realizacja `WrapCoordRoad`: 1536 zniekształceń
   współrzędnych w `[(1+t5a)⁻¹, 1+t5a]` przez mapę wrap/centering
   (strona `hbridge` + B1). Transport i koperty liczbowe gotowe.
4. **BoxStage** — realizacja `BoxRetentionRoad`: jednorodne przeskalowanie
   `rho ∈ [1-1e-1000, 1]` na CAŁEJ przestrzeni (bulk i ogon razem —
   kontrprzykłady `bulkOnly_*` zabraniają ucinania ogona). Transport gotowy.

Przestrogi (kernelowe, nie do obejścia): masa całkowita NIGDY nie daje
nierówności punktowej (`massSandwich_not_pointwise` + instancje przy
dokładnych marginesach wszystkich czterech etapów); błąd addytywny bez
podłogi nie przepisuje się multiplikatywnie (`additiveError_no_machineStage`).

## 6. Lessons (toolchain — dla następnej partii)

- **`∏ x : α, body` — pułapka wiążącości ciała (NOWA, kosztowna!)**: notacja
  z typowanym binderem wiąże ciało o ograniczonej wiążącości (~`term:67`).
  Ciało niebędące aplikacją/iloczynem WYCIEKA poza produkt:
  `∏ i : Fin n, 1 - b i` parsuje się jak `(∏ i : Fin n, 1) - b i` z `i`
  auto-bound — objawy: „Variable name `i` is not explicitly referenced" na
  binderze, `Unknown identifier i` w taktykach, `b ?m.18` w błędach, ciche
  rozjazdy unifikacji. **ZAWSZE nawiasować**: `∏ i : Fin n, (1 - b i)`.
  Ciała typu `f i`, `f i * g i`, `(1 + a)⁻¹` są OK (`*` = prec. 70).
- **Rat.cast — rozszerzenie pułapki z B4**: nie tylko unifikacja term-mode.
  `nlinarith`/`simpa` przechodzą CAŁY kontekst lokalny — obecność ciężkich
  hipotez z `(1 + ↑t5a)^1536`-potęgami/literałami `Rat.cast` w kontekście
  wywala `isDefEq` nawet przy banalnym celu (`nlinarith [sq_nonneg (wrapT:ℝ)]`
  timeout). Fix: drobne fakty arytmetyczne udowadniać NAJPIERW w czystym
  kontekście (kolejność `have`), albo `clear` ciężkich hipotez przed małymi
  krokami.
- `Finset.prod_le_prod` w tym Mathlib ma **jedno jawne `h : ∀ i ∈ s, f i ≤ g i`**
  (wymaga `MulLeftMono` — dla `ℝ` niedostępne w praktyce) — stąd własny
  `prod_le_prod_nonneg` (indukcja po `Finset`).
- `exact_mod_cast` na `CenteringClosure.tau_budget` działa **tylko** z
  rzutowanym literałem po prawej: `((1:ℚ) / 1099511627776 : ℝ)`; postać
  `(1:ℝ) / 1099511627776` zawija cel w `↑(…)` i psuje dopasowanie (sprawdzone
  w 3 wariantach). Bezpieczniej: koperta liczbowo przez
  `pow_succ_le_real` + `norm_num` na nazwanych def-ach `wrapA`/`wrapT`.
- `convert hh using 1` potrafi domknąć WSZYSTKIE cele — wiszący potem `ring`
  daje „No goals to be solved".
- `show T at h` to niepoprawna składnia — zamiast tego `have h : T := (…)`.
- `inv_le_inv₀ (h₁ : 0 < a) (h₂ : 0 < b) : a⁻¹ ≤ b⁻¹ ↔ b ≤ a` — kolejność
  argumentów idzie za STRONAMI celu, nie za uproszczeniem `w`.
- Tryb taktyk > term-mode przy def-ach ℝ-owych (jak w B4); `rw [le_div_iff₀ h]`
  + `exact` zamiast `.mpr`.
- Warsztat probe-first: scratch w `.build/scratch/` kompiluje się w ~2 s przy
  ~70-260 s pełnego modułu — hipotezy poprawek izolować tam (Q1-Q14), potem
  dopiero tnie się plik główny.
