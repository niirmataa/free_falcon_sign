import FT1536.PublicSimulation

/-!
# RejectionBound — norm-reject: dokładna redukcja i krok Chernoffa

`Rejection A c` = masa `none` próby `trial A c` (norm-reject `Q (decode z) ≥ B`
plus abort pustego fibera). Moduł daje:

1. `trial_none_mass` — dokładną tożsamość: `Rejection` to stosunek masy ogona
   normy do masy fibera (albo 1 dla pustego fibera). To jest formalny punkt
   zaczepienia dla transportu MGF na fiberze;
2. `fiberTailMass_le_exp` — krok Markowa-Chernoffa: ogon normy przez moment
   potęgowy (dla dowolnego `λ ≥ 0`);
3. jawny program domknięcia `Rejection ≤ 2^-24` z mianowanymi przesłankami
   analitycznymi (patrz sekcja „Pozostałe przesłanki" na dole).

Kontekst skali (Geometry/PublicSimulation): 1536 bloków A2
(`BoxPair = BoxVec × BoxVec`, `BoxVec = Fin 768 → Fin 131071 × Fin 131071`),
`block x y = x^2 + x*y + y^2`, `Q = Q0 z.1 + Q0 z.2`, `B = 2093922385`,
waga `gaussianWeight z = exp(-Q (decode z)/(2*768^2))`. Waga jest iloczynowa
po slotach, więc MGF rozkłada się na 1536 identycznych czynników blokowych
(ten rozkład to kolejny krok programu, wymaga `Finset.prod_sum` na typach
funkcyjnych).

Cyfry kontrolne (ich `legal_key_bridge_numbers.sage`, odtworzone lustrzanie):
ciągły bound Chernoffa ≈ 4.72e-8, budżet `2^-24` ≈ 5.96e-8 — zapas ~1.26×,
czyli ~1.5e-4 względnej dokładności na blok po kompozycji 1536 czynników.
-/

namespace FT1536.RejectionBound
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry

variable {C : Type*} [DecidableEq C]

/-- Nieznormalizowana masa fibera nad celem c. -/
noncomputable def fiberMass (A : BoxPair → C) (c : C) : ℝ := ∑ z, fiberWeight A c z

/-- Nieznormalizowana masa norm-odrzucenia na fiberze nad c. -/
noncomputable def fiberTailMass (A : BoxPair → C) (c : C) : ℝ :=
  ∑ z, fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1)

/-- Prawdopodobieństwo odrzucenia jednej próby (norm-reject + pusty fiber). -/
noncomputable def Rejection (A : BoxPair → C) (c : C) : ℝ := (trial A c).mass none

theorem rejection_le_one (A : BoxPair → C) (c : C) : Rejection A c ≤ 1 := by
  unfold Rejection
  have htot := (trial A c).total
  have hle : (trial A c).mass none ≤ ∑ x, (trial A c).mass x := by
    apply single_le_sum
    · intro i _; exact (trial A c).nonneg i
    · exact mem_univ none
  simpa [htot] using hle

/-- Postać próby przy niepustym fiberze. -/
theorem trial_of_pos (A : BoxPair → C) (c : C)
    (h : 0 < ∑ z, fiberWeight A c z) :
    trial A c =
      (Law.weighted (fiberWeight A c) (fun z => fiberWeight_nonneg A c z) h).map
        (fun z => if Q (decode z) < B then some z else none) := by
  unfold trial
  split_ifs; rfl

/-- Postać próby przy pustym fiberze (abort). -/
theorem trial_of_empty (A : BoxPair → C) (c : C)
    (h : ¬ 0 < ∑ z, fiberWeight A c z) :
    trial A c = Law.pure none := by
  unfold trial
  split_ifs; rfl

/-- Dokładna tożsamość: `Rejection` = ogon normy na fiberze / masa fibera. -/
theorem trial_none_mass (A : BoxPair → C) (c : C) :
    (trial A c).mass none =
      if 0 < fiberMass A c then fiberTailMass A c / fiberMass A c else 1 := by
  unfold fiberMass fiberTailMass
  by_cases h : 0 < ∑ z, fiberWeight A c z
  · have hif : (if 0 < ∑ z, fiberWeight A c z
        then (∑ z, fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1)) /
          ∑ y, fiberWeight A c y
        else 1)
        = (∑ z, fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1)) /
          ∑ y, fiberWeight A c y := by
      simp [h]
    rw [hif, trial_of_pos A c h]
    show ((Law.weighted (fiberWeight A c) (fun z => fiberWeight_nonneg A c z) h).map
        (fun z => if Q (decode z) < B then some z else none)).mass none = _
    rw [Law.map]
    show (∑ x, (Law.weighted (fiberWeight A c) (fun z => fiberWeight_nonneg A c z) h).mass x *
        (Law.pure (if Q (decode x) < B then some x else none)).mass none) = _
    show (∑ x, (fiberWeight A c x / ∑ y, fiberWeight A c y) *
        (Law.pure (if Q (decode x) < B then some x else none)).mass none) = _
    rw [Finset.sum_div]
    apply Finset.sum_congr rfl
    intro z hz
    show (fiberWeight A c z / ∑ y, fiberWeight A c y) *
        (Law.pure (if Q (decode z) < B then some z else none)).mass none =
      fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1) / ∑ y, fiberWeight A c y
    by_cases hq : Q (decode z) < B <;> simp [Law.pure, hq]
  · have hif : (if 0 < ∑ z, fiberWeight A c z
        then (∑ z, fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1)) /
          ∑ y, fiberWeight A c y
        else 1) = 1 := by
      simp [h]
    rw [hif, trial_of_empty A c h]
    simp [Law.pure]

/-- Krok Markowa-Chernoffa: masa norm-odrzucenia na fiberze przez moment
potęgowy przy dowolnym `λ ≥ 0`. To sprowadza bound `Rejection ≤ 2^-24`
do oszacowania MGF blokowego (2. i 3. przesłanka poniżej). -/
theorem fiberTailMass_le_exp (A : BoxPair → C) (c : C) (lam : ℝ)
    (hlam : 0 ≤ lam) (h : 0 < fiberMass A c) :
    fiberTailMass A c / fiberMass A c ≤
      Real.exp (-lam * (B : ℝ)) *
        (∑ z, fiberWeight A c z * Real.exp (lam * (Q (decode z) : ℝ))) /
        fiberMass A c := by
  have hstep : ∀ z : BoxPair,
      fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1) ≤
        Real.exp (-lam * (B : ℝ)) *
          (fiberWeight A c z * Real.exp (lam * (Q (decode z) : ℝ))) := by
    intro z
    by_cases hq : Q (decode z) < B
    · have hz : fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1) = 0 := by
        simp [hq]
      rw [hz]
      exact mul_nonneg (Real.exp_pos _).le
        (mul_nonneg (fiberWeight_nonneg A c z) (Real.exp_pos _).le)
    · have hz : fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1)
        = fiberWeight A c z := by
        simp [hq]
      have hB : (B : ℝ) ≤ (Q (decode z) : ℝ) := by
        exact_mod_cast le_of_not_gt hq
      have hexp : 1 ≤ Real.exp (lam * ((Q (decode z) : ℝ) - B)) :=
        Real.one_le_exp (mul_nonneg hlam (sub_nonneg.mpr hB))
      have hrew : Real.exp (lam * ((Q (decode z) : ℝ) - B)) =
          Real.exp (-lam * (B : ℝ)) * Real.exp (lam * (Q (decode z) : ℝ)) := by
        rw [← Real.exp_add]
        congr 1
        ring
      have hm : 0 ≤ fiberWeight A c z := fiberWeight_nonneg A c z
      rw [hz]
      calc fiberWeight A c z = fiberWeight A c z * 1 := (mul_one _).symm
        _ ≤ fiberWeight A c z * Real.exp (lam * ((Q (decode z) : ℝ) - B)) :=
            mul_le_mul_of_nonneg_left hexp hm
        _ = Real.exp (-lam * (B : ℝ)) *
            (fiberWeight A c z * Real.exp (lam * (Q (decode z) : ℝ))) := by
              rw [hrew]
              ring
  have hsum : fiberTailMass A c ≤
      Real.exp (-lam * (B : ℝ)) *
        ∑ z, fiberWeight A c z * Real.exp (lam * (Q (decode z) : ℝ)) := by
    unfold fiberTailMass
    calc ∑ z, fiberWeight A c z * (if Q (decode z) < B then (0:ℝ) else 1) ≤
        ∑ z, Real.exp (-lam * (B : ℝ)) *
          (fiberWeight A c z * Real.exp (lam * (Q (decode z) : ℝ))) :=
          sum_le_sum fun z _ => hstep z
      _ = Real.exp (-lam * (B : ℝ)) *
          ∑ z, fiberWeight A c z * Real.exp (lam * (Q (decode z) : ℝ)) := by
            rw [← Finset.mul_sum]
  exact div_le_div_of_nonneg_right hsum (le_of_lt h)

/-! ## Pozostałe przesłanki (program domknięcia `Rejection ≤ 2^-24`)

Po `trial_none_mass` + `fiberTailMass_le_exp` domknięcie wymaga trzech
elementów analitycznych; to są jedyne nierozstrzygnięte punkty i mają
odpowiedniki w otwartych przesłankach RUN_002 („norm and coordinate MGF
transport", „Poisson pointwise all-center coset mass comparison"):

1. **Rozkład MGF na bloki** (`mgf_product`): waga `gaussianWeight` jest
   iloczynowa po 1536 slotach A2, więc
   `∑ z, gaussianWeight z * exp(λ * Q (decode z)) = (S (s))^1536`,
   gdzie `S s = ∑_{(x,y)} exp(-s * block x y)` po `Fin 131071 × Fin 131071`
   (dla `fiberWeight` waga jest dodatkowo przycięta równaniem `A z = c` —
   patrz punkt 3). Dowód: `Real.exp_sum` + `Finset.prod_sum` na
   `Fin 768 → ...` (Fubini dla iloczynów).

2. **Porównanie sumy Gaussa A2 z całką** (`block_theta_bound`):
   `S s ≤ 2π/(s * √3) * (1 + K * s)` i symetryczny dolny — z marginesem
   ~1.5e-4 na blok po podstawieniu do `fiberTailMass_le_exp` (cyfry:
   ich `chernoff ≈ 4.72e-8` vs budżet `2^-24 ≈ 5.96e-8`). Stopień 2
   Euler-Maclaurina (błąd trapezów dla log-wklęsłego `exp(-s * block)`)
   wystarcza; pierwszy stopień (monotoniczność) jest za słaby (~8e-4/blok).

3. **Transport kosetowy fiber↔full** (`fiber_transport`): ogon na fiberze
   `A z = c` (afiniczna coseta) przez ogon pełny — z błędem poniżej marginesu.
   To jest ich „Poisson all-center coset mass comparison" + „MGF transport";
   wymaga oszacowań sum Gaussa po skończonych grupach (odpowiednik podwójnej
   thety T5, ich `kappa * 991 > 65 * log 2`). Bez tego bound dotyczy pełnej
   wagi, nie `Rejection`.

Po tych trzech: `Rejection A c ≤ 2^-24` dla niepustych fiberów (pusty fiber
to abort `= 1` — w boundzie dla wszystkich kluczy wchodzi przez cap16
i `hbridge` z `CenteringClosure.all_keys_bridge_closure`).
-/

end FT1536.RejectionBound
