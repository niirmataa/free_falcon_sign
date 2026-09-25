import MgfProduct
import RejectionBound
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

/-!
# BlockTheta — lemat 2: theta A2 vs całka + kompozycja Chernoffa

Struktura lematu 2 dla boundu `Rejection ≤ 2^-24`:

1. **Premisa analityczna** (`ThetaBounds`): porównanie sumy Gaussa A2 z całką
   `2π/(s·√3)` z luzem `eps = 2^-20` na kierunek (Euler-Maclaurin 2. st.);
   realna korekta ≈ s/12 ≈ 6e-8 ≪ eps = 2^-20.
2. **Certyfikat numeryczny** (`hnum`): ciągły Chernoff
   `exp(-lam·B)·R^1536 = e^{-16.8709…} ≤ 2^-24·0.9` (Sage/Arb).
3. **Kompozycja kernelowa** (`full_rejection_bound`): z (1)+(2) wynika
   kernelowo `Rejection (fun _ => ()) () ≤ 2^-24`.

Inżynieria: higiena instancji powtórzona lokalnie (nie przenosi się przez
olean); mostki `bridge_on_off` przez `Finset.sum_congr` + `Finset.ext`
spajają świat ON (olean `RejectionBound`) z OFF. `rw` wymaga zgodności
syntaktycznej — dlatego punkty styku z `mgf_weighted` (literal
`1/(2*768^2)`) mają własne wersje literałowe; `calc`/`exact` widzą
definitional-unfolding `c0`.

Stałe (certyfikat Sage): `lam = 281983057/2470091353620480`,
`lam·B = 281983057/1179648 = 239.03999…`, `sStar = 1536/2093922385`,
`R = 2093922385/1811939328 = 1.155625…`,
eksponent ciągły `-16.8709…`, budżet `ln(2^-24) = -16.6355…`,
margines `0.2354…`.
-/

namespace FT1536.BlockTheta
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry FT1536.MgfProduct
  FT1536.RejectionBound

-- Higiena instancji (jak w MgfProduct; NIE przenosi się przez olean):
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

set_option maxHeartbeats 600000
set_option maxRecDepth 200000

/-- Optymalne λ ciągłego Chernoffa: (B − dσ²)/(B·2σ²), d = 3072, σ² = 589824. -/
noncomputable def lam : ℝ := 281983057 / 2470091353620480

/-- Parametr bazowy wagi: 1/(2·768²) (syntaktycznie jak w `mgf_weighted`). -/
noncomputable def c0 : ℝ := 1 / (2 * 768^2)

/-- Parametr po przesunięciu: c0 − lam. -/
noncomputable def sStar : ℝ := 1536 / 2093922385

/-- Iloraz parametrów (ciągły MGF jednego bloku A2). -/
noncomputable def Rrat : ℝ := 2093922385 / 1811939328

/-- Luz analityczny na kierunek porównania theta–całka. -/
noncomputable def eps : ℝ := 1 / 2^20

/-- Górna całka porównawcza przy sStar. -/
noncomputable def Uint : ℝ := (2 * Real.pi / (sStar * Real.sqrt 3)) * (1 + eps)

/-- Dolna całka porównawcza przy c0. -/
noncomputable def Lint : ℝ := (2 * Real.pi / (c0 * Real.sqrt 3)) * (1 - eps)

theorem lam_nonneg : 0 ≤ lam := by norm_num [lam]

theorem c0_pos : (0:ℝ) < c0 := by norm_num [c0]

theorem sStar_pos : (0:ℝ) < sStar := by norm_num [sStar]

theorem Rrat_pos : (0:ℝ) < Rrat := by norm_num [Rrat]

theorem lit_sub_lam : 1 / (2 * 768^2) - lam = sStar := by norm_num [lam, sStar]

theorem c0_div_sStar : c0 / sStar = Rrat := by norm_num [c0, sStar, Rrat]

theorem eps_pos : (0:ℝ) < eps := by norm_num [eps]

theorem eps_small : eps < 1 / 2 := by norm_num [eps]

theorem eps_3072 : 2 * 1536 * eps ≤ 1 := by norm_num [eps]

theorem Uint_pos : (0:ℝ) < Uint :=
  mul_pos (div_pos (mul_pos (by norm_num) Real.pi_pos)
    (mul_pos sStar_pos (by positivity)))
    (by linarith [eps_pos])

theorem Lint_pos : (0:ℝ) < Lint :=
  mul_pos (div_pos (mul_pos (by norm_num) Real.pi_pos)
    (mul_pos c0_pos (by positivity)))
    (by linarith [eps_pos, eps_small])

/-! ## Bernoulli elementarne (indukcja, bez analizy) -/

/-- Monotoniczność potęg dla nieujemnych podstaw (elementarnie). -/
theorem pow_mono_nonneg (a b : ℝ) (ha : 0 ≤ a) (hab : a ≤ b) :
    ∀ n : ℕ, a ^ n ≤ b ^ n := by
  intro n
  induction n with
  | zero => norm_num
  | succ n ih =>
    rw [pow_succ, pow_succ]
    exact mul_le_mul ih hab ha (pow_nonneg (by linarith) n)

theorem one_add_pow_le (x : ℝ) (hx : 0 ≤ x) :
    ∀ n : ℕ, 2 * (n:ℝ) * x ≤ 1 → (1 + x)^n ≤ 1 + 2 * (n:ℝ) * x := by
  intro n
  induction n with
  | zero => intro _; norm_num
  | succ n ih =>
    intro h
    have hc : ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 := by norm_num
    have hstep : 2 * (n:ℝ) * x ≤ 1 := by nlinarith
    have hih := ih hstep
    have hx2 : 2 * (n:ℝ) * x^2 ≤ x := by nlinarith
    have hcalc : (1 + 2 * (n:ℝ) * x) * (1 + x)
        ≤ 1 + 2 * ((n + 1 : ℕ) : ℝ) * x := by
      rw [hc]
      nlinarith [hx2]
    calc (1 + x)^(n + 1) = (1 + x)^n * (1 + x) := by rw [pow_succ]
      _ ≤ (1 + 2 * (n:ℝ) * x) * (1 + x) :=
          mul_le_mul_of_nonneg_right hih (by nlinarith)
      _ ≤ 1 + 2 * ((n + 1 : ℕ) : ℝ) * x := hcalc

theorem one_sub_pow_ge (x : ℝ) (hx : 0 ≤ x) (hx1 : x ≤ 1) (n : ℕ) :
    1 - (n:ℝ) * x ≤ (1 - x)^n := by
  induction n with
  | zero => norm_num
  | succ n ih =>
    have hx1x : 0 ≤ 1 - x := by linarith
    have hpx : (1 - x)^n ≤ 1 :=
      (pow_mono_nonneg (1 - x) 1 hx1x (by linarith) n).trans_eq (one_pow n)
    have hxle : x * (1 - x)^n ≤ x := by
      calc x * (1 - x)^n ≤ x * 1 := mul_le_mul_of_nonneg_left hpx hx
        _ = x := by ring
    calc 1 - ((n + 1 : ℕ) : ℝ) * x = (1 - (n:ℝ) * x) - x := by
          have hc : ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 := by norm_num
          rw [hc]
          ring
      _ ≤ (1 - x)^n - x := by nlinarith [ih]
      _ ≤ (1 - x)^n - x * (1 - x)^n := by nlinarith [hxle]
      _ = (1 - x)^n * (1 - x) := by ring
      _ = (1 - x)^(n + 1) := by rw [pow_succ]

/-! ## Mostki instancji ON→OFF -/

set_option maxRecDepth 20000 in
/-- Mostek: suma po `univ` z instancją `boxPairFintype` (świat ON, olean
`RejectionBound`) równa sumie w świecie strukturalnym (OFF). -/
theorem bridge_on_off (g : BoxPair → ℝ) :
    Finset.sum (@Finset.univ BoxPair FT1536.PublicSimulation.boxPairFintype) g
      = ∑ z, g z := by
  refine Finset.sum_congr (Finset.ext fun a => by simp [Finset.mem_univ]) ?_
  intro a _
  rfl

/-- Tożsamość wagowa dla stałego celu: fiber = pełna waga. -/
theorem fiber_eq (z : BoxPair) :
    fiberWeight (fun _ : BoxPair => ()) () z = gaussianWeight z := rfl

/-- Masa fibera (stały cel) w świecie OFF. -/
theorem fiberMass_off :
    fiberMass (fun _ : BoxPair => ()) ()
      = ∑ z, fiberWeight (fun _ : BoxPair => ()) () z := by
  unfold fiberMass
  exact bridge_on_off _

/-- Ogon norm-reject (stały cel) w świecie OFF. -/
theorem fiberTailMass_off :
    fiberTailMass (fun _ : BoxPair => ()) ()
      = ∑ z, fiberWeight (fun _ : BoxPair => ()) () z
          * (if Q (decode z) < B then (0:ℝ) else 1) := by
  unfold fiberTailMass
  exact bridge_on_off _

/-- MGF stałego celu w świecie ON (z `RejectionBound`), sprowadzony do
`blockSum sStar^1536` (lemat 1). -/
theorem mgf_on_off :
    Finset.sum (@Finset.univ BoxPair FT1536.PublicSimulation.boxPairFintype)
        (fun z => fiberWeight (fun _ : BoxPair => ()) () z
          * Real.exp (lam * (Q (decode z) : ℝ)))
      = blockSum sStar ^ 1536 := by
  have h1 := bridge_on_off (fun z => fiberWeight (fun _ : BoxPair => ()) () z
    * Real.exp (lam * (Q (decode z) : ℝ)))
  have h2 : (∑ z, fiberWeight (fun _ : BoxPair => ()) () z
        * Real.exp (lam * (Q (decode z) : ℝ)))
      = ∑ z, gaussianWeight z * Real.exp (lam * (Q (decode z) : ℝ)) :=
    Finset.sum_congr rfl fun z _ => by rw [fiber_eq]
  rw [h1, h2, mgf_weighted lam, lit_sub_lam]

/-- Masa stałego celu (OFF) przez `blockSum c0` (forma literałowa
dla zgodności syntaktycznej z `mgf_weighted`). -/
theorem mass_off :
    (∑ z, fiberWeight (fun _ : BoxPair => ()) () z)
      = blockSum (1 / (2 * 768^2)) ^ 1536 := by
  have h2 : (∑ z, fiberWeight (fun _ : BoxPair => ()) () z)
      = ∑ z, gaussianWeight z * Real.exp ((0:ℝ) * (Q (decode z) : ℝ)) :=
    Finset.sum_congr rfl fun z _ => by
      rw [fiber_eq, zero_mul, Real.exp_zero, mul_one]
  rw [h2, mgf_weighted (0:ℝ), sub_zero]

/-! ## Premisa analityczna i kompozycja (postać schodkowa) -/

/-- Premisa analityczna lematu 2: theta A2 vs całka z luzem eps na kierunek. -/
structure ThetaBounds where
  upper : blockSum sStar ≤ Uint
  lower : Lint ≤ blockSum c0

/-- Dodatnia masa fibera stałego celu (świadkiem zeroPair). -/
theorem fiberMass_pos : 0 < fiberMass (fun _ : BoxPair => ()) () := by
  rw [fiberMass_off]
  refine Finset.sum_pos' (fun z _ => fiberWeight_nonneg _ () z)
    ⟨zeroPair, Finset.mem_univ _, ?_⟩
  have hz : Q (decode zeroPair) = 0 := zero_norm
  have hfe : fiberWeight (fun _ : BoxPair => ()) () zeroPair
      = gaussianWeight zeroPair := rfl
  rw [hfe, gaussianWeight, hz]
  norm_num

/-- Rozgałęzienie `Rejection` na niepustym fiberze: ogon/masa. -/
theorem rejection_split : Rejection (fun _ : BoxPair => ()) ()
    = fiberTailMass (fun _ : BoxPair => ()) ()
      / fiberMass (fun _ : BoxPair => ()) () := by
  unfold Rejection
  rw [trial_none_mass]
  split_ifs
  · rfl
  · exact absurd fiberMass_pos (by assumption)

/-- Korekty potęgowe luzu eps, elementarnie (Bernoulli przez indukcję). -/
theorem corrections_le : ((1 + eps) / (1 - eps))^1536 ≤ 10 / 9 := by
  have h1 : (1 + eps)^1536 ≤ 1 + 2 * 1536 * eps :=
    one_add_pow_le eps (le_of_lt eps_pos) 1536 eps_3072
  have h2 : 1 - 1536 * eps ≤ (1 - eps)^1536 :=
    one_sub_pow_ge eps (le_of_lt eps_pos) (by linarith [eps_small]) 1536
  have hp2 : (0:ℝ) < (1 - eps)^1536 :=
    pow_pos (by norm_num [eps]) 1536
  rw [div_pow]
  calc (1 + eps)^1536 / (1 - eps)^1536
      ≤ (1 + 2 * 1536 * eps) / (1 - eps)^1536 :=
          div_le_div_of_nonneg_right h1 (le_of_lt hp2)
    _ ≤ (1 + 2 * 1536 * eps) / (1 - 1536 * eps) := by
          exact div_le_div_of_nonneg_left h2
            (le_of_lt (show (0:ℝ) < 1 + 2 * 1536 * eps by norm_num [eps]))
    _ ≤ 10 / 9 := by norm_num [eps]
end FT1536.BlockTheta
