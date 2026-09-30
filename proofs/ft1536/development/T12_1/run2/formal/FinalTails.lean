import ThetaAssembly
import ThetaFinal
import Run2.ChangedTailReduction

/-!
# FinalTails — kernelowe domknięcie wartości ogonowych (pkt 2 planu).

Dowodzimy dwie ostatnie przesłanki liczbowe łańcucha `rawBad`:

  * `coord_tail_9217` : `prob blockLaw (|x| >= 9217) <= tau9217`
    (przez `ChangedTailReduction.hchange_of_tau` daje przesłankę `hchange`);
  * `emit_tail_cap`   : `mean rawLaw (indicator (unsignedHalf z.2)) <= emitCap`
    (przesłanka `htail` z `RadialObligations.enclosure_of_reduced_obligations`).

Łańcuch stałych (pre-check: `sage/check_tail_chain.sage`, PART_II_QQ_PASS,
dokładnie te same literały): sumy po `y` przez `S0_bounds`/`s1_upper` (REUSE),
`blockNormalizer >= Lint` (REUSE `BlockTheta.thetaBounds`), ogony po `x`
geometrycznie, `exp` przez `Real.exp_bound` + `Real.exp_one_gt_d9`,
końcowe porównania QQ przez `norm_num` (jak `hnum_rational`).
-/

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

-- Higiena instancji (jak w modułach Run2).
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.FinalTails

open Finset
open FT1536.MgfProduct (blockSum slotVal slotQ)
open FT1536.BlockTheta (c0 Lint)
open FT1536.ThetaPoisson (S0 S0_bounds)
open FT1536.Theta2Split (S1)
open FT1536.ThetaFinal (s1_upper)
open FT1536.ThetaAssembly (exp_neg_le_inv_pow3)
open FT1536.Run2.RawProductLaw
  (Block blockDecode blockEnergy blockWeight blockNormalizer blockNormalizer_pos blockLaw)

/-! ## 1. Helpery ekspotęgowe -/

/-- `exp (-(1:ℝ)) < 10^9/2718281828` — z `Real.exp_one_gt_d9`. -/
theorem exp_neg_one_lt : Real.exp (-(1:ℝ)) < (10:ℝ)^9 / 2718281828 := by
  have h4 : ((2718281828:ℝ) / 10^9) < Real.exp 1 := by
    have h2 : (2.7182818283:ℝ) < Real.exp 1 := Real.exp_one_gt_d9
    have h3 : (2.718281828:ℝ) < 2.7182818283 := by norm_num
    have h5 : (2.718281828:ℝ) < Real.exp 1 := lt_trans h3 h2
    convert h5 using 1
    norm_num
  have h1 : (0:ℝ) < Real.exp 1 := Real.exp_pos 1
  rw [Real.exp_neg]
  rw [lt_div_iff₀ (by norm_num : (0:ℝ) < 2718281828)]
  rw [inv_mul_lt_iff₀ h1]
  rw [div_lt_iff₀ (by norm_num : (0:ℝ) < 10^9)] at h4
  exact h4

/-- `exp (-k) <= (10^9/2718281828)^k` dla `k : ℕ`. -/
theorem exp_neg_natCast_le (k : ℕ) :
    Real.exp (-(k:ℝ)) <= ((10:ℝ)^9 / 2718281828)^k := by
  have h1 : Real.exp (-(1:ℝ)) <= (10:ℝ)^9 / 2718281828 := exp_neg_one_lt.le
  have h1n : (0:ℝ) <= Real.exp (-(1:ℝ)) := (Real.exp_pos _).le
  have h2 : Real.exp (-(1:ℝ))^k <= ((10:ℝ)^9 / 2718281828)^k :=
    pow_le_pow_left₀ h1n h1 k
  have h3 : Real.exp (-(1:ℝ))^k = Real.exp (-(k:ℝ)) := by
    rw [← Real.exp_nat_mul]
    congr 1
    ring
  rw [← h3]
  exact h2

/-- Wielomian graniczny szeregu dla `exp (-δ)`, `0 <= δ <= 1`. -/
noncomputable def tayl (δ : ℝ) : ℝ := 1 - δ + δ^2/2 - δ^3/6 + δ^4/24 + δ^4/12

theorem tayl_nonneg {δ : ℝ} (h1 : 0 <= δ) (h2 : δ <= 1) : 0 <= tayl δ := by
  unfold tayl
  nlinarith [pow_two δ, pow_nonneg h1 2, pow_nonneg h1 3, pow_nonneg h1 4]

/-- `exp (-δ) <= tayl δ` — `Real.exp_bound` z `n = 4` (reszta `<= 5δ^4/96`). -/
theorem exp_neg_le_taylor4 {δ : ℝ} (h1 : 0 <= δ) (h2 : δ <= 1) :
    Real.exp (-δ) <= tayl δ := by
  have hb := Real.exp_bound (x := -δ) (n := 4)
    (by rw [abs_neg, abs_of_nonneg h1]; exact h2) (by norm_num)
  have hsum : (∑ m ∈ range 4, (-δ)^m / m.factorial) = 1 - δ + δ^2/2 - δ^3/6 := by
    norm_num [Finset.sum_range_succ, Nat.factorial_succ, Nat.factorial,
      pow_succ, pow_zero, div_eq_mul_inv]
    ring
  have habs : (|-δ|:ℝ) = δ := by rw [abs_neg, abs_of_nonneg h1]
  rw [hsum] at hb
  rw [habs] at hb
  have hcoef : ((Nat.succ 4:ℕ):ℝ) / (((Nat.factorial 4:ℕ):ℝ) * (4:ℕ):ℝ) = (5:ℝ)/96 := by
    norm_num
  rw [hcoef] at hb
  have hdpow : (0:ℝ) <= δ^4 := pow_nonneg h1 4
  have hrem : δ^4 * ((5:ℝ)/96) <= δ^4/24 + δ^4/12 := by
    have hdpow : (0:ℝ) <= δ^4 := pow_nonneg h1 4
    have hstep := mul_le_mul_of_nonneg_left
      (by norm_num : ((5:ℝ)/96) <= 1/24 + 1/12) hdpow
    nlinarith
  have htri : Real.exp (-δ) - (1 - δ + δ^2/2 - δ^3/6)
      <= |Real.exp (-δ) - (1 - δ + δ^2/2 - δ^3/6)| := le_abs_self _
  unfold tayl
  nlinarith [hb, hrem, htri]

theorem exp_neg_nat_add_le (k : ℕ) {δ : ℝ} (h1 : 0 <= δ) (h2 : δ <= 1) :
    Real.exp (-(k + δ)) <= ((10:ℝ)^9 / 2718281828)^k * tayl δ := by
  have h3 : (-(k + δ : ℝ)) = -(k:ℝ) + -δ := by ring
  rw [h3, Real.exp_add]
  exact mul_le_mul (exp_neg_natCast_le k) (exp_neg_le_taylor4 h1 h2)
    (Real.exp_pos _).le (pow_nonneg (by norm_num : (0:ℝ) <= 10^9 / 2718281828) k)

/-- Wielomian graniczny 6. stopnia + reszta `exp_bound` (`n = 7`):
    `tayl7 δ = 1 - δ + δ²/2 - δ³/6 + δ⁴/24 - δ⁵/120 + δ⁶/720 + δ⁷/4410`.
    Dla δ = 2/3 przebija `e^{-δ}` tylko o ~0,005% (w odróżnieniu od `tayl`,
    którego przebicie 3,4% wychodziło poza budżet `emitCap`). -/
noncomputable def tayl7 (δ : ℝ) : ℝ :=
  1 - δ + δ^2/2 - δ^3/6 + δ^4/24 - δ^5/120 + δ^6/720 + δ^7/4410

/-- `exp (-δ) <= tayl7 δ` — `Real.exp_bound` z `n = 7` (reszta `<= δ^7/4410`). -/
theorem exp_neg_le_taylor7 {δ : ℝ} (h1 : 0 <= δ) (h2 : δ <= 1) :
    Real.exp (-δ) <= tayl7 δ := by
  have hb := Real.exp_bound (x := -δ) (n := 7)
    (by rw [abs_neg, abs_of_nonneg h1]; exact h2) (by norm_num)
  have hsum : (∑ m ∈ range 7, (-δ)^m / m.factorial)
      = 1 - δ + δ^2/2 - δ^3/6 + δ^4/24 - δ^5/120 + δ^6/720 := by
    norm_num [Finset.sum_range_succ, Nat.factorial_succ, Nat.factorial,
      pow_succ, pow_zero, div_eq_mul_inv]
    ring
  have habs : (|-δ|:ℝ) = δ := by rw [abs_neg, abs_of_nonneg h1]
  rw [hsum] at hb
  rw [habs] at hb
  have hcoef : ((Nat.succ 7:ℕ):ℝ) / (((Nat.factorial 7:ℕ):ℝ) * (7:ℕ):ℝ) = (1:ℝ)/4410 := by
    norm_num
  rw [hcoef] at hb
  have htri : Real.exp (-δ)
      - (1 - δ + δ^2/2 - δ^3/6 + δ^4/24 - δ^5/120 + δ^6/720)
      <= |Real.exp (-δ)
        - (1 - δ + δ^2/2 - δ^3/6 + δ^4/24 - δ^5/120 + δ^6/720)| := le_abs_self _
  unfold tayl7
  nlinarith [hb, htri]

theorem exp_neg_nat_add_le7 (k : ℕ) {δ : ℝ} (h1 : 0 <= δ) (h2 : δ <= 1) :
    Real.exp (-(k + δ)) <= ((10:ℝ)^9 / 2718281828)^k * tayl7 δ := by
  have h3 : (-(k + δ : ℝ)) = -(k:ℝ) + -δ := by ring
  rw [h3, Real.exp_add]
  exact mul_le_mul (exp_neg_natCast_le k) (exp_neg_le_taylor7 h1 h2)
    (Real.exp_pos _).le (pow_nonneg (by norm_num : (0:ℝ) <= 10^9 / 2718281828) k)

/-- `exp (-X) <= 27/X^3` — reuse z ThetaAssembly. -/
theorem exp_neg_inv3 {X : ℝ} (hX : 0 < X) : Real.exp (-X) <= 27 / X^3 :=
  exp_neg_le_inv_pow3 hX

/-! ## 2. Sklejenie normalizatora: blockSum c0 = blockNormalizer -/

theorem c0_val : c0 = (1/1179648:ℝ) := by
  unfold c0
  norm_num

theorem slotQ_eq_blockEnergy (d : Fin 131071 × Fin 131071) :
    slotQ d = blockEnergy d := rfl

theorem blockSum_c0_eq : blockSum c0 = blockNormalizer := by
  have h : ∀ d : Fin 131071 × Fin 131071, slotVal c0 d = blockWeight d := by
    intro d
    unfold slotVal blockWeight
    congr 1
    rw [slotQ_eq_blockEnergy, c0_val]
    field_simp
  unfold blockSum blockNormalizer
  exact Finset.sum_congr rfl (fun d _ => h d)

theorem Lint_le_blockNormalizer : Lint <= blockNormalizer := by
  rw [← blockSum_c0_eq]
  exact (FT1536.ThetaAssembly.thetaBounds).lower

theorem Lint_pos' : (0:ℝ) < Lint := BlockTheta.Lint_pos

/-! ## 3. Literały numeryczne (zgodne z sage/check_tail_chain.sage) -/

noncomputable def pi_lo : ℝ := 3.14159265358979323846
noncomputable def pi_hi : ℝ := 3.14159265358979323847
noncomputable def KyR : ℝ := 19251 / 10
/-- Poprawka `4*exp(-pi^2/c0) <= etaQ`; `etaQ = 108*(c0/pi_lo^2)^3` z `27/X^3`. -/
noncomputable def etaQ : ℝ := 108 * ((1 / 1179648) / (pi_lo^2))^3
/-- Górna granica sum po `y`: `Ky = KyR * (1 + etaQ)`. -/
noncomputable def Ky : ℝ := KyR * (1 + etaQ)

theorem pi_lo_lt : pi_lo < Real.pi := by
  unfold pi_lo
  exact Real.pi_gt_d20

theorem pi_lt_hi : Real.pi < pi_hi := by
  unfold pi_hi
  exact Real.pi_lt_d20

theorem pi_lo_sq_le : (pi_lo:ℝ)^2 <= Real.pi^2 :=
  pow_le_pow_left₀ (by unfold pi_lo; norm_num) pi_lo_lt.le (2 : ℕ)

theorem hdiv1179648 (x : ℝ) : x / (1/1179648) = x * 1179648 := by field_simp

theorem pi_lo_div_c0_le : pi_lo^2 / c0 <= Real.pi^2 / c0 := by
  rw [c0_val, hdiv1179648, hdiv1179648]
  exact mul_le_mul_of_nonneg_right pi_lo_sq_le (by norm_num)

theorem exp_four_le_eta :
    (4:ℝ) * Real.exp (-(Real.pi^2 / c0)) <= etaQ := by
  have hX : (0:ℝ) < Real.pi^2 / c0 := by unfold c0; positivity
  have h3 : Real.exp (-(Real.pi^2 / c0)) <= 27 / (Real.pi^2 / c0)^3 :=
    exp_neg_inv3 hX
  have h4 : (4:ℝ) * Real.exp (-(Real.pi^2 / c0))
      <= 4 * (27 / (Real.pi^2 / c0)^3) :=
    mul_le_mul_of_nonneg_left h3 (by norm_num)
  have hA : (0:ℝ) < (Real.pi^2 / c0)^3 := by unfold c0; positivity
  have hB : (0:ℝ) < (pi_lo^2 / c0)^3 := by unfold c0 pi_lo; positivity
  have hBA : (pi_lo^2 / c0)^3 <= (Real.pi^2 / c0)^3 :=
    pow_le_pow_left₀ (by unfold c0; positivity) pi_lo_div_c0_le 3
  have h27 : (27:ℝ) / (Real.pi^2 / c0)^3 <= 27 / (pi_lo^2 / c0)^3 := by
    rw [div_le_div_iff₀ hA hB]
    exact mul_le_mul_of_nonneg_left hBA (by norm_num)
  have h5 : (4:ℝ) * (27 / (Real.pi^2 / c0)^3)
      <= 4 * (27 / (pi_lo^2 / c0)^3) :=
    mul_le_mul_of_nonneg_left h27 (by norm_num)
  have key : (4:ℝ) * (27 / (pi_lo^2 / c0)^3) = etaQ := by
    rw [c0_val]
    unfold etaQ pi_lo
    set_option exponentiation.threshold 4096 in
    norm_num
  exact le_trans (le_trans h4 h5) (le_of_eq key)

theorem exp_eight_le_eta :
    (8:ℝ) * Real.exp (-(4 * Real.pi^2 / c0)) <= etaQ := by
  have hX : (0:ℝ) < 4 * Real.pi^2 / c0 := by unfold c0; positivity
  have h3 : Real.exp (-(4 * Real.pi^2 / c0)) <= 27 / (4 * Real.pi^2 / c0)^3 :=
    exp_neg_inv3 hX
  have h4 : (8:ℝ) * Real.exp (-(4 * Real.pi^2 / c0))
      <= 8 * (27 / (4 * Real.pi^2 / c0)^3) :=
    mul_le_mul_of_nonneg_left h3 (by norm_num)
  have hA : (0:ℝ) < (4 * Real.pi^2 / c0)^3 := by unfold c0; positivity
  have hB : (0:ℝ) < (4 * pi_lo^2 / c0)^3 := by unfold c0 pi_lo; positivity
  have hBA : (4 * pi_lo^2 / c0)^3 <= (4 * Real.pi^2 / c0)^3 := by
    have hmono : (4:ℝ) * pi_lo^2 / c0 <= 4 * Real.pi^2 / c0 := by
      rw [c0_val, hdiv1179648, hdiv1179648]
      exact mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_left pi_lo_sq_le (by norm_num)) (by norm_num)
    exact pow_le_pow_left₀ (by unfold c0 pi_lo; positivity) hmono 3
  have h27 : (27:ℝ) / (4 * Real.pi^2 / c0)^3 <= 27 / (4 * pi_lo^2 / c0)^3 := by
    rw [div_le_div_iff₀ hA hB]
    exact mul_le_mul_of_nonneg_left hBA (by norm_num)
  have h5 : (8:ℝ) * (27 / (4 * Real.pi^2 / c0)^3)
      <= 8 * (27 / (4 * pi_lo^2 / c0)^3) :=
    mul_le_mul_of_nonneg_left h27 (by norm_num)
  have key : (8:ℝ) * (27 / (4 * pi_lo^2 / c0)^3) <= etaQ := by
    rw [c0_val]
    unfold etaQ pi_lo
    set_option exponentiation.threshold 4096 in
    norm_num
  exact le_trans (le_trans h4 h5) key

theorem Ky_bound : S0 c0 <= Ky ∧ S1 c0 <= Ky := by
  have hc0 : (0:ℝ) < c0 := by unfold c0; positivity
  have hc09 : c0 <= 9 := by unfold c0; norm_num
  have hS0 := (S0_bounds c0 hc0 hc09).2
  have hS1 := s1_upper c0 hc0 hc09
  have hsqrt : Real.sqrt (Real.pi / c0) <= KyR := by
    have hle : Real.pi / c0 <= KyR^2 := by
      rw [c0_val, hdiv1179648]
      have hpi : Real.pi * 1179648 <= pi_hi * 1179648 :=
        mul_le_mul_of_nonneg_right pi_lt_hi.le (by norm_num)
      have hnum : (pi_hi * 1179648:ℝ) <= KyR^2 := by
        unfold pi_hi KyR
        set_option exponentiation.threshold 4096 in
        norm_num
      unfold KyR at *
      nlinarith
    have hK : (0:ℝ) <= KyR := by unfold KyR; norm_num
    have hsqrt' := Real.sqrt_le_sqrt hle
    rwa [Real.sqrt_sq hK] at hsqrt'
  refine ⟨?_, ?_⟩
  · have hm : Real.sqrt (Real.pi / c0)
        * (1 + 4 * Real.exp (-(Real.pi^2 / c0))) <= KyR * (1 + etaQ) := by
      have h1 : Real.sqrt (Real.pi / c0) <= KyR := hsqrt
      have h2 : (1:ℝ) + 4 * Real.exp (-(Real.pi^2 / c0)) <= 1 + etaQ := by
        nlinarith [exp_four_le_eta]
      have h1n : (0:ℝ) <= 1 + 4 * Real.exp (-(Real.pi^2 / c0)) := by
        have hp : (0:ℝ) <= Real.exp (-(Real.pi^2 / c0)) :=
          (Real.exp_pos (-(Real.pi^2 / c0))).le
        nlinarith [hp]
      have h2n : (0:ℝ) <= KyR := by unfold KyR; norm_num
      exact mul_le_mul h1 h2 h1n h2n
    unfold Ky
    exact le_trans hS0 hm
  · have hm : Real.sqrt (Real.pi / c0)
        * (1 + 8 * Real.exp (-(4 * Real.pi^2 / c0))) <= KyR * (1 + etaQ) := by
      have h1 : Real.sqrt (Real.pi / c0) <= KyR := hsqrt
      have h2 : (1:ℝ) + 8 * Real.exp (-(4 * Real.pi^2 / c0)) <= 1 + etaQ := by
        nlinarith [exp_eight_le_eta]
      have h1n : (0:ℝ) <= 1 + 8 * Real.exp (-(4 * Real.pi^2 / c0)) := by
        have hp : (0:ℝ) <= Real.exp (-(4 * Real.pi^2 / c0)) :=
          (Real.exp_pos (-(4 * Real.pi^2 / c0))).le
        nlinarith [hp]
      have h2n : (0:ℝ) <= KyR := by unfold KyR; norm_num
      exact mul_le_mul h1 h2 h1n h2n
    unfold Ky
    exact le_trans hS1 hm

end FT1536.FinalTails

namespace FT1536.FinalTails

open Finset
open FT1536.MgfProduct (blockSum slotVal slotQ)
open FT1536.BlockTheta (c0 Lint)
open FT1536.ThetaPoisson (S0 S0_bounds)
open FT1536.Theta2Split (S1 exp_sq_summable_pos)
open FT1536.ThetaFinal (s1_upper)
open FT1536.ThetaAssembly (exp_neg_le_inv_pow3)
open FT1536.Run2.RawProductLaw
  (Block blockDecode blockEnergy blockWeight blockNormalizer blockNormalizer_pos
   blockLaw vectorLaw productLaw rawLaw rawLaw_eq_productLaw)
open FT1536.Run2.RawRadialEvents (indicator mean indicator_nonnegative)
open FT1536.Run2.RawIndependence
  (prob prob_congr prob_exists_le_sum one_coordinate raw_second_cylinder)
open FT1536.Run2.RadialObligations (unsignedHalf)
open FT1536.Run2.ChangedTailReduction (tau9217 prob_mono prob_swap_invariant)
open FT1536.Run2.RawRadialEnclosure (emitCap)
open FT1536.Run2.RadialSymmetry (swapBlock blockDecode_swapBlock)
open FT1536.PublicSimulation (BoxVec BoxPair decodeVec signed16)

/-! ## 4. Pomocnicze: całkowite kwadraty -/

theorem int_sq_ge_self (t : ℤ) : t <= t^2 := by
  have h : (0:ℤ) <= t * (t - 1) := by
    by_cases h1 : t <= 0
    · exact mul_nonneg_of_nonpos_of_nonpos (by nlinarith) (by nlinarith)
    · have h2 : 1 <= t := by
        have h3 := Int.add_one_le_iff.mpr (lt_of_not_ge h1)
        nlinarith
      exact mul_nonneg (by nlinarith) (by nlinarith)
  nlinarith

theorem x_sq_shift (x L : ℤ) (_h : L <= x) :
    (L:ℝ)^2 + (((2 * L + 1 : ℤ):ℝ)) * (((x - L : ℤ):ℝ)) <= (x:ℝ)^2 := by
  have hz : ((x - L : ℤ)) <= ((x - L : ℤ))^2 := int_sq_ge_self (x - L)
  have hz' : ((x:ℝ) - L) <= ((x:ℝ) - L)^2 := by exact_mod_cast hz
  push_cast
  nlinarith [hz']

/-! ## 5. Sumy po `y` (REUSE S0/S1) -/

/-- Sumowalność rodziny półprzesuniętej (dominacja `(n+1/2)^2 >= n^2/2 - 1/4`). -/
theorem half_shift_summable :
    Summable (fun n : ℤ => Real.exp (-(c0:ℝ) * (((n:ℝ) + 1/2)^2))) := by
  have hg : Summable (fun n : ℤ => Real.exp (-(c0 / 2) * ((n:ℝ)^2))
      * Real.exp (c0 / 4)) :=
    (exp_sq_summable_pos (c0 / 2) (by unfold c0; positivity)).mul_right _
  apply Summable.of_nonneg_of_le (fun n => (Real.exp_pos _).le) _ hg
  intro n
  have hp : (0:ℝ) <= c0 * (((n:ℝ) + 1)^2) :=
    mul_nonneg (by unfold c0; norm_num) (sq_nonneg _)
  have h : (-(c0:ℝ) * (((n:ℝ) + 1/2)^2))
      <= (-(c0 / 2) * ((n:ℝ)^2)) + c0 / 4 := by
    nlinarith [hp]
  have h2 := Real.exp_le_exp.2 h
  simpa [Real.exp_add] using h2

theorem ysum_even_le (m : ℤ) :
    (∑ y ∈ Icc (-65535:ℤ) 65535, Real.exp (-(c0:ℝ) * (((y + m:ℤ):ℝ)^2))) <= S0 c0 := by
  have hre : (∑ y ∈ Icc (-65535:ℤ) 65535, Real.exp (-(c0:ℝ) * (((y + m:ℤ):ℝ)^2)))
      = ∑ k ∈ Icc (-65535 + m) (65535 + m), Real.exp (-(c0:ℝ) * ((k:ℝ)^2)) :=
    Finset.sum_nbij (fun y => y + m)
      (fun a ha => by simp only [Finset.mem_Icc] at ha ⊢; omega)
      (fun a₁ _ a₂ _ hh => add_right_cancel hh)
      (fun b hb => ⟨b - m,
        by simp only [Finset.mem_coe, Finset.mem_Icc] at hb ⊢; omega,
        by ring⟩)
      (fun a _ => rfl)
  rw [hre]
  exact Summable.sum_le_tsum (Icc (-65535 + m) (65535 + m))
    (fun i _ => (Real.exp_pos _).le)
    (exp_sq_summable_pos c0 (by unfold c0; positivity))

theorem ysum_odd_le (m : ℤ) :
    (∑ y ∈ Icc (-65535:ℤ) 65535,
        Real.exp (-(c0:ℝ) * ((((y + m:ℤ):ℝ) + 1/2)^2))) <= S1 c0 := by
  have hre : (∑ y ∈ Icc (-65535:ℤ) 65535,
        Real.exp (-(c0:ℝ) * ((((y + m:ℤ):ℝ) + 1/2)^2)))
      = ∑ k ∈ Icc (-65535 + m) (65535 + m),
          Real.exp (-(c0:ℝ) * ((((k:ℤ):ℝ) + 1/2)^2)) :=
    Finset.sum_nbij (fun y => y + m)
      (fun a ha => by simp only [Finset.mem_Icc] at ha ⊢; omega)
      (fun a₁ _ a₂ _ hh => add_right_cancel hh)
      (fun b hb => ⟨b - m,
        by simp only [Finset.mem_coe, Finset.mem_Icc] at hb ⊢; omega,
        by ring⟩)
      (fun a _ => rfl)
  rw [hre]
  exact Summable.sum_le_tsum (Icc (-65535 + m) (65535 + m))
    (fun i _ => (Real.exp_pos _).le) half_shift_summable

/-! ## 6. Ogony po `x` (szereg geometryczny) -/

theorem xtail_pos_le (L : ℕ) (_hL : L <= 65535) :
    (∑ x ∈ Icc (L:ℤ) 65535, Real.exp (-((3:ℝ) * ((x:ℝ)^2) / 4718592)))
      <= Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
          / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592))) := by
  set E0 : ℝ := Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
  set rc : ℝ := (3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592
  set r : ℝ := Real.exp (-rc)
  have hrfl : r = Real.exp (-rc) := rfl
  have hE0fl : E0 = Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592)) := rfl
  have hr1 : (0:ℝ) <= r := (Real.exp_pos _).le
  have hrc : 0 < rc := by unfold rc; positivity
  have hr2 : r < 1 := by
    rw [hrfl, Real.exp_lt_one_iff]
    exact neg_neg_of_pos hrc
  have hkey (x : ℤ) (hx : (L:ℤ) <= x) :
      Real.exp (-((3:ℝ) * ((x:ℝ)^2) / 4718592)) <= E0 * r ^ ((x - L : ℤ).toNat) := by
    have hcast : (((x - L : ℤ).toNat : ℕ):ℝ) = ((x - L : ℤ):ℝ) :=
      by exact_mod_cast Int.toNat_of_nonneg (sub_nonneg.mpr hx)
    have harith : (((L:ℕ):ℝ)^2 + (((2 * L + 1 : ℕ):ℝ)) * ((x - L : ℤ):ℝ)) <= (x:ℝ)^2 := by
      have hz : ((x - L : ℤ)) <= ((x - L : ℤ))^2 := int_sq_ge_self (x - L)
      have hz' : ((x:ℝ) - L) <= ((x:ℝ) - L)^2 := by exact_mod_cast hz
      push_cast
      nlinarith [hz']
    have hpow : r ^ ((x - L : ℤ).toNat)
        = Real.exp (-((((x - L : ℤ).toNat : ℕ):ℝ) * rc)) := by
      rw [hrfl, ← Real.exp_nat_mul]
      congr 1
      ring
    have harg : ((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592)
            + ((((x - L : ℤ).toNat : ℕ):ℝ) * rc)
        = (3:ℝ) * (((L:ℕ):ℝ)^2
            + (((2 * L + 1 : ℕ):ℝ)) * ((x - L : ℤ):ℝ)) / 4718592 := by
      unfold rc
      rw [hcast]
      ring
    have hE : Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2
            + (((2 * L + 1 : ℕ):ℝ)) * ((x - L : ℤ):ℝ)) / 4718592))
        = E0 * r ^ ((x - L : ℤ).toNat) := by
      rw [← harg, neg_add, Real.exp_add, hpow, hE0fl]
    have hex : Real.exp (-((3:ℝ) * ((x:ℝ)^2) / 4718592))
        <= Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2
            + (((2 * L + 1 : ℕ):ℝ)) * ((x - L : ℤ):ℝ)) / 4718592)) := by
      apply Real.exp_le_exp.2
      rw [neg_le_neg_iff]
      have hq : (0:ℝ) < 4718592 := by norm_num
      rw [div_le_div_iff₀ hq hq]
      nlinarith [mul_le_mul_of_nonneg_left harith (by norm_num : (0:ℝ) <= 3)]
    exact le_trans hex (le_of_eq hE)
  have hre : (∑ x ∈ Icc (L:ℤ) 65535, Real.exp (-((3:ℝ) * ((x:ℝ)^2) / 4718592)))
      = ∑ t ∈ range (65535 - L + 1),
          Real.exp (-((3:ℝ) * (((((t + L : ℕ) : ℤ):ℝ))^2) / 4718592)) := by
    apply Finset.sum_nbij (fun x => (x - L : ℤ).toNat)
    · intro a ha
      simp only [Finset.mem_Icc] at ha
      rw [Finset.mem_range]
      omega
    · intro a₁ h₁ a₂ h₂ hh
      simp only [Finset.mem_coe, Finset.mem_Icc] at h₁ h₂
      have hh2 : ((a₁ - L : ℤ).toNat) = ((a₂ - L : ℤ).toNat) := hh
      have h1 : (((a₁ - L : ℤ).toNat : ℕ) : ℤ) = (a₁ - L : ℤ) :=
        Int.toNat_of_nonneg (sub_nonneg.mpr (by omega))
      have h2 : (((a₂ - L : ℤ).toNat : ℕ) : ℤ) = (a₂ - L : ℤ) :=
        Int.toNat_of_nonneg (sub_nonneg.mpr (by omega))
      omega
    · intro b hb
      simp only [Finset.mem_coe, Finset.mem_range] at hb
      refine ⟨((b + L : ℕ) : ℤ), ?_, ?_⟩
      · rw [Finset.mem_coe, Finset.mem_Icc]
        omega
      · change ((((b + L : ℕ) : ℤ) - ((L:ℕ):ℤ)).toNat = b)
        rw [show (((((b + L : ℕ) : ℤ) - ((L:ℕ):ℤ)) : ℤ)) = ((b:ℤ)) by omega]
        omega
    · intro a ha
      simp only [Finset.mem_Icc] at ha
      have hz : (((((a - L : ℤ).toNat + L : ℕ) : ℤ)) = a) := by
        have hsub : (L:ℤ) <= (((a - L : ℤ).toNat + L : ℕ) : ℤ) := by omega
        have h0 := Int.toNat_of_nonneg (sub_nonneg.mpr hsub)
        omega
      change Real.exp (-((3:ℝ) * ((a:ℝ)^2) / 4718592))
          = Real.exp (-((3:ℝ) * ((((((a - L : ℤ).toNat + L : ℕ) : ℤ):ℝ))^2) / 4718592))
      rw [hz]
  rw [hre]
  have hpoint : ∀ t ∈ range (65535 - L + 1),
      Real.exp (-((3:ℝ) * (((((t + L : ℕ) : ℤ):ℝ))^2) / 4718592))
        <= E0 * r ^ t := by
    intro t ht
    have hx : (L:ℤ) <= ((t + L : ℕ) : ℤ) := by omega
    have hk := hkey ((t + L : ℕ) : ℤ) hx
    have hz : (((((t + L : ℕ) : ℤ) - L : ℤ).toNat : ℕ)) = t := by
      have hsub : (L:ℤ) <= ((t + L : ℕ) : ℤ) := hx
      have h0 := Int.toNat_of_nonneg (sub_nonneg.mpr hsub)
      omega
    rw [hz] at hk
    exact hk
  have hstep := Finset.sum_le_sum hpoint
  have hgeoS : Summable (fun t : ℕ => r ^ t) := summable_geometric_of_lt_one hr1 hr2
  have hsum : Summable (fun t : ℕ => E0 * r ^ t) :=
    Summable.congr (hgeoS.mul_right E0) (fun t => (mul_comm _ _).symm)
  have hmul : (∑' t : ℕ, E0 * r ^ t) = E0 * ∑' t : ℕ, r ^ t := by
    have hconv : (∑' t : ℕ, E0 * r ^ t) = (∑' t : ℕ, r ^ t * E0) :=
      tsum_congr (fun t => mul_comm _ _)
    rw [hconv, hgeoS.tsum_mul_right]
    exact mul_comm _ _
  have hgeo := tsum_geometric_of_lt_one hr1 hr2
  have hle := Summable.sum_le_tsum (range (65535 - L + 1))
    (fun i _ => mul_nonneg (Real.exp_pos _).le (pow_nonneg hr1 i)) hsum
  have hfinal : (∑' t : ℕ, E0 * r ^ t) <= E0 / (1 - r) := by
    rw [hmul, hgeo, div_eq_mul_inv]
  exact le_trans (le_trans hstep hle) hfinal

/-! ## 7. Składanie: faktoryzacja wagi i rozdział sum 2D -/

/-- Suma po `Fin 131071` jako suma po pudle `Icc (-65535) 65535`. -/
theorem sum_fin131071_eq {g : ℤ → ℝ} :
    (∑ i : Fin 131071, g ((i.val : ℤ) - 65535)) = ∑ x ∈ Icc (-65535:ℤ) 65535, g x := by
  apply Finset.sum_nbij (fun i : Fin 131071 => (i.val : ℤ) - 65535)
  · intro a _
    simp only [Finset.mem_Icc]
    have := a.isLt
    omega
  · intro a₁ _ a₂ _ hh
    have hh2 : ((a₁.val : ℤ) - 65535) = ((a₂.val : ℤ) - 65535) := hh
    apply Fin.ext
    omega
  · intro b hb
    simp only [Finset.mem_coe, Finset.mem_Icc] at hb
    refine ⟨⟨(b + 65535).toNat, ?bound⟩, ?mem, ?eq⟩
    case bound =>
      have := Int.toNat_of_nonneg (show (0:ℤ) <= b + 65535 by omega)
      omega
    case mem =>
      exact Finset.mem_univ _
    case eq =>
      have hval : ((((b + 65535).toNat : ℕ) : ℤ) - 65535) = b := by
        have := Int.toNat_of_nonneg (show (0:ℤ) <= b + 65535 by omega)
        omega
      exact hval
  · intro a _
    rfl

/-- Algebra pomocnicza: `4*(x^2 + x*y + y^2) = 3*x^2 + (2*y + x)^2`. -/
theorem block_split (x y : ℤ) :
    (4:ℤ) * (x^2 + x*y + y^2) = 3 * x^2 + (2*y + x)^2 := by ring

/-- Faktoryzacja wagi bloku na czynniki osi `x` i przesuniętej osi `y`. -/
theorem blockWeight_factor (b : Block) :
    blockWeight b =
      Real.exp (-((3:ℝ) * (((blockDecode b).1 : ℝ)^2) / 4718592))
        * Real.exp (-(((2 * (blockDecode b).2 + (blockDecode b).1 : ℝ)^2) / 4718592)) := by
  unfold blockWeight
  set X : ℝ := (((blockDecode b).1 : ℝ)^2)
  set Y : ℝ := ((2 * (blockDecode b).2 + (blockDecode b).1 : ℝ)^2)
  have hE : (4:ℝ) * ((blockEnergy b : ℤ):ℝ) = 3 * X + Y := by
    unfold X Y blockEnergy Geometry.block blockDecode
    push_cast
    ring
  have hEd : ((4:ℝ) * ((blockEnergy b : ℤ):ℝ)) / 4 = (3 * X + Y) / 4 :=
    congrArg (fun z : ℝ => z / 4) hE
  have hE' : ((blockEnergy b : ℤ):ℝ) = (3 * X + Y) / 4 := by
    have h4 : ((blockEnergy b : ℤ):ℝ) = ((4:ℝ) * ((blockEnergy b : ℤ):ℝ)) / 4 := by
      field_simp
    rw [h4]
    exact hEd
  have hmain : (-((blockEnergy b : ℝ)) / 1179648)
      = (-((3:ℝ) * X / 4718592)) + (-(Y / 4718592)) := by
    rw [show (1179648:ℝ) = 4718592 / 4 by norm_num, hE']
    field_simp
    ring
  rw [hmain, Real.exp_add]

/-! ## 8. Składanie 2D -/

/-- Czynnik osi `x` w faktoryzacji. -/
noncomputable def FA (x : ℝ) : ℝ := Real.exp (-((3:ℝ) * (x^2) / 4718592))

/-- Czynnik przesuniętej osi `y` (postać surowa). -/
noncomputable def FBr (t : ℝ) : ℝ := Real.exp (-((t^2) / 4718592))

theorem FBr_even_id (k y : ℤ) :
    FBr (((2 * y + 2 * k : ℤ):ℝ)) = Real.exp (-(c0:ℝ) * (((y + k:ℤ):ℝ)^2)) := by
  unfold FBr c0
  push_cast
  congr 1
  ring

theorem FBr_odd_id (k y : ℤ) :
    FBr (((2 * y + (2 * k + 1) : ℤ):ℝ))
      = Real.exp (-(c0:ℝ) * ((((y + k:ℤ):ℝ) + 1/2)^2)) := by
  unfold FBr c0
  push_cast
  congr 1
  ring

/-- Jednolity bound wewnętrznej sumy po `y` dla obu parzystości `x`. -/
theorem ysum_bound (x : ℤ) :
    (∑ y ∈ Icc (-65535:ℤ) 65535, FBr (((2 * y + x : ℤ):ℝ))) <= Ky := by
  rcases Int.even_or_odd x with he | ho
  · obtain ⟨k, hk⟩ := he
    have hk2 : x = 2 * k := by omega
    subst hk2
    have hsum : (∑ y ∈ Icc (-65535:ℤ) 65535, FBr (((2 * y + 2 * k : ℤ):ℝ)))
        = ∑ y ∈ Icc (-65535:ℤ) 65535, Real.exp (-(c0:ℝ) * (((y + k:ℤ):ℝ)^2)) :=
      Finset.sum_congr rfl (fun y _ => FBr_even_id k y)
    rw [hsum]
    exact le_trans (ysum_even_le k) Ky_bound.1
  · obtain ⟨k, rfl⟩ := ho
    have hsum : (∑ y ∈ Icc (-65535:ℤ) 65535, FBr (((2 * y + (2 * k + 1) : ℤ):ℝ)))
        = ∑ y ∈ Icc (-65535:ℤ) 65535,
            Real.exp (-(c0:ℝ) * ((((y + k:ℤ):ℝ) + 1/2)^2)) :=
      Finset.sum_congr rfl (fun y _ => FBr_odd_id k y)
    rw [hsum]
    exact le_trans (ysum_odd_le k) Ky_bound.2

/-- Wersja faktoryzacji na współrzędnych indeksów pudełka. -/
theorem blockWeight_factor' (s t : Fin 131071) :
    blockWeight (s, t) =
      FA ((((blockDecode (s, t)).1 : ℝ)))
        * FBr (((2 * (blockDecode (s, t)).2 + (blockDecode (s, t)).1 : ℝ))) := by
  have h := blockWeight_factor (s, t)
  unfold FA FBr
  exact h
/-- Para ogonów `x`: obie strony pudełka zamykają się tym samym boundem.
    Wymaga `0 < L`: dla `L = 0` zbiory `Icc 0 65535` i `Icc (-65535) 0`
    nachodzą w zerze i tożsamość sum jest fałszywa. -/
theorem xtail_pair_le (L : ℕ) (hL : L <= 65535) (hL1 : 0 < L) :
    (∑ x ∈ Icc (-(65535:ℤ)) 65535, FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|))
      <= 2 * (Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592)))
          / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592))) := by
  have hneg : (∑ x ∈ Icc (-65535:ℤ) (-((L:ℤ))), FA ((x:ℝ)))
      = ∑ x ∈ Icc (L:ℤ) 65535, FA ((x:ℝ)) := by
    apply Finset.sum_nbij (fun x : ℤ => -x)
    · intro a ha
      simp only [Finset.mem_Icc] at ha ⊢
      omega
    · intro a₁ _ a₂ _ hh
      have hh2 : (-a₁ : ℤ) = -a₂ := hh
      omega
    · intro b hb
      simp only [Finset.mem_coe, Finset.mem_Icc] at hb
      refine ⟨-b, ?mem, ?eq⟩
      case mem =>
        simp only [Finset.mem_coe, Finset.mem_Icc]
        omega
      case eq =>
        ring
    · intro a _
      unfold FA
      congr 1
      push_cast
      ring
  have hsumA : (∑ x ∈ Icc (L:ℤ) 65535, FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|))
      = ∑ x ∈ Icc (L:ℤ) 65535, FA ((x:ℝ)) := by
    apply Finset.sum_congr rfl
    intro x hx
    simp only [Finset.mem_Icc] at hx
    have hLz : (0:ℤ) <= ((L:ℕ):ℤ) := by exact_mod_cast Nat.zero_le L
    have hpos : (0:ℤ) <= x := by linarith
    have hxe : |x| = x := abs_of_nonneg hpos
    have hc : (L:ℤ) <= |x| := by rw [hxe]; linarith
    unfold indicator
    simp only [hc, ite_true]
    ring
  have hsumB : (∑ x ∈ Icc (-65535:ℤ) (-((L:ℤ))),
        FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|))
      = ∑ x ∈ Icc (-65535:ℤ) (-((L:ℤ))), FA ((x:ℝ)) := by
    apply Finset.sum_congr rfl
    intro x hx
    simp only [Finset.mem_Icc] at hx
    have hLz : (0:ℤ) <= ((L:ℕ):ℤ) := by exact_mod_cast Nat.zero_le L
    have hneg : x <= (0:ℤ) := by linarith
    have hxe : |x| = -x := abs_of_nonpos hneg
    have hc : (L:ℤ) <= |x| := by rw [hxe]; linarith
    unfold indicator
    simp only [hc, ite_true]
    ring
  have hzero : ∀ x ∈ Icc (-65535:ℤ) 65535,
      x ∉ (Icc (L:ℤ) 65535) ∪ (Icc (-65535:ℤ) (-((L:ℤ))))
        -> FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|) = 0 := by
    intro x hx hn
    have habs : ¬ ((L:ℤ) <= |x|) := by
      intro h
      simp only [Finset.mem_Icc] at hx
      simp only [Finset.mem_union, Finset.mem_Icc, not_or, not_and_or] at hn
      rcases hn with ⟨h1, h2⟩
      rcases h1 with h1 | h1 <;> rcases h2 with h2 | h2
      · omega
      · rcases abs_choice x with ha | ha
        · rw [ha] at h
          linarith
        · rw [ha] at h
          linarith
      · linarith
      · omega
    unfold indicator
    simp only [habs, ite_false]
    ring
  have hsub : (∑ x ∈ (Icc (L:ℤ) 65535) ∪ (Icc (-65535:ℤ) (-((L:ℤ)))),
        FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|))
      = ∑ x ∈ Icc (-65535:ℤ) 65535, FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|) := by
    refine Finset.sum_subset (fun x hx => ?sub) (fun x hx hn => ?zero)
    case sub =>
      simp only [Finset.mem_union, Finset.mem_Icc] at hx
      simp only [Finset.mem_Icc]
      omega
    case zero =>
      exact hzero x hx hn
  have hunion : (∑ x ∈ (Icc (L:ℤ) 65535) ∪ (Icc (-65535:ℤ) (-((L:ℤ)))),
        FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|))
      = (∑ x ∈ Icc (L:ℤ) 65535, FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|))
          + (∑ x ∈ Icc (-65535:ℤ) (-((L:ℤ))),
              FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)) :=
    Finset.sum_union (by
      rw [Finset.disjoint_left]
      intro x hx1 hx2
      simp only [Finset.mem_Icc] at hx1 hx2
      have hLz : (0:ℤ) < ((L:ℕ):ℤ) := by exact_mod_cast hL1
      omega)
  have hsplit : (∑ x ∈ Icc (-(65535:ℤ)) 65535, FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|))
      = (∑ x ∈ Icc (L:ℤ) 65535, FA ((x:ℝ)))
          + (∑ x ∈ Icc (-65535:ℤ) (-((L:ℤ))), FA ((x:ℝ))) := by
    rw [← hsub, hunion, hsumA, hsumB]
  rw [hsplit, hneg]
  have hFA : (∑ x ∈ Icc (L:ℤ) 65535, FA ((x:ℝ)))
      = ∑ x ∈ Icc (L:ℤ) 65535,
          Real.exp (-((3:ℝ) * ((x:ℝ)^2) / 4718592)) :=
    Finset.sum_congr rfl (fun x _ => rfl)
  rw [hFA]
  have h1 := xtail_pos_le L hL
  have hadd : (∑ x ∈ Icc (L:ℤ) 65535,
          Real.exp (-((3:ℝ) * ((x:ℝ)^2) / 4718592)))
        + (∑ x ∈ Icc (L:ℤ) 65535,
          Real.exp (-((3:ℝ) * ((x:ℝ)^2) / 4718592)))
      ≤ Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
          / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592)))
        + Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
          / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592))) :=
    add_le_add h1 h1
  have htwo := two_mul (Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
      / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592))))
  have hmd := mul_div_assoc' (2:ℝ) (Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592)))
      (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592)))
  linarith

/-- Zewnętrzna suma po `Fin 131071` w czynnikach `FA`/`FBr` jako suma po pudle;
    mostek przez jawne `g` (defeq beta — bez ryzyka unifikacji HO). -/
theorem sum_fin131071_factor (L : ℕ) :
    (∑ s : Fin 131071,
        ∑ t : Fin 131071,
          FA ((((s.val : ℤ) - 65535 : ℤ) : ℝ))
            * FBr ((((2 * ((t.val : ℤ) - 65535) + ((s.val : ℤ) - 65535) : ℤ) : ℝ)))
            * indicator ((L:ℤ) <= |((s.val : ℤ) - 65535 : ℤ)|))
      = ∑ x ∈ Icc (-65535:ℤ) 65535,
          (∑ t : Fin 131071,
            FA ((x:ℝ))
              * FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ) : ℝ)))
              * indicator ((L:ℤ) <= |x|)) :=
  sum_fin131071_eq (g := fun w : ℤ => ∑ t : Fin 131071,
    FA ((w:ℝ))
      * FBr ((((2 * ((t.val : ℤ) - 65535) + w : ℤ) : ℝ)))
      * indicator ((L:ℤ) <= |w|))

/-- Wewnętrzna suma `FBr` po `Fin 131071` jako suma po pudle. -/
theorem sum_fin131071_inner (x : ℤ) :
    (∑ t : Fin 131071, FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ) : ℝ))))
      = ∑ y ∈ Icc (-65535:ℤ) 65535, FBr (((2 * y + x : ℤ):ℝ)) :=
  sum_fin131071_eq (g := fun w : ℤ => FBr ((((2 * w + x : ℤ) : ℝ))))

theorem pair_num_le (L : ℕ) (hL : L <= 65535) (hL1 : 0 < L) :
    (∑ b : Block, blockWeight b * indicator ((L:ℤ) <= |(blockDecode b).1|))
      <= Ky * (2 * Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
          / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592)))) := by
  have hsplit : (∑ b : Block, blockWeight b * indicator ((L:ℤ) <= |(blockDecode b).1|))
      = ∑ s : Fin 131071, ∑ t : Fin 131071,
          blockWeight (s, t) * indicator ((L:ℤ) <= |(blockDecode (s, t)).1|) :=
    Fintype.sum_prod_type _
  rw [hsplit]
  have hfac : ∀ s t : Fin 131071,
      blockWeight (s, t) * indicator ((L:ℤ) <= |(blockDecode (s, t)).1|)
        = FA ((((s.val : ℤ) - 65535 : ℤ) : ℝ))
            * FBr ((((2 * ((t.val : ℤ) - 65535) + ((s.val : ℤ) - 65535) : ℤ) : ℝ)))
            * indicator ((L:ℤ) <= |((s.val : ℤ) - 65535 : ℤ)|) := by
    intro s t
    rw [blockWeight_factor' s t]
    have harg : ((2 * (blockDecode (s, t)).2 + (blockDecode (s, t)).1 : ℝ))
        = (((2 * ((t.val : ℤ) - 65535) + ((s.val : ℤ) - 65535) : ℤ) : ℝ)) := by
      simp only [blockDecode]
      push_cast
      rfl
    rw [harg]
    rfl
  simp_rw [hfac]
  have hre : (∑ s : Fin 131071,
        ∑ t : Fin 131071,
          FA ((((s.val : ℤ) - 65535 : ℤ) : ℝ))
            * FBr ((((2 * ((t.val : ℤ) - 65535) + ((s.val : ℤ) - 65535) : ℤ) : ℝ)))
            * indicator ((L:ℤ) <= |((s.val : ℤ) - 65535 : ℤ)|))
      = ∑ x ∈ Icc (-65535:ℤ) 65535,
          FA ((x:ℝ)) * (indicator ((L:ℤ) <= |x|))
            * (∑ y ∈ Icc (-65535:ℤ) 65535,
                FBr (((2 * y + x : ℤ):ℝ))) := by
    rw [sum_fin131071_factor L]
    apply Finset.sum_congr rfl
    intro x _hx
    have hin := sum_fin131071_inner x
    have hswap : ∀ t : Fin 131071,
        FA ((x:ℝ)) * FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ):ℝ)))
            * indicator ((L:ℤ) <= |x|)
          = FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ):ℝ)))
              * (FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)) := by
      intro t
      ring
    have hpeel : (∑ t : Fin 131071,
          FA ((x:ℝ)) * FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ):ℝ)))
            * indicator ((L:ℤ) <= |x|))
        = FA ((x:ℝ)) * (indicator ((L:ℤ) <= |x|))
            * (∑ y ∈ Icc (-65535:ℤ) 65535,
                FBr (((2 * y + x : ℤ):ℝ))) := by
      have step1 : (∑ t : Fin 131071,
            FA ((x:ℝ)) * FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ):ℝ)))
              * indicator ((L:ℤ) <= |x|))
          = ∑ t : Fin 131071,
            FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ):ℝ)))
              * (FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)) :=
        Finset.sum_congr rfl (fun t _ => hswap t)
      have step2 : (∑ t : Fin 131071,
            FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ):ℝ)))
              * (FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)))
          = (∑ t : Fin 131071, FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ):ℝ))))
              * (FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)) :=
        (Finset.sum_mul (Finset.univ)
          (fun t : Fin 131071 => FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ):ℝ))))
          (FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|))).symm
      have step3 : ((∑ t : Fin 131071, FBr ((((2 * ((t.val : ℤ) - 65535) + x : ℤ):ℝ))))
              * (FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)))
          = (∑ y ∈ Icc (-65535:ℤ) 65535, FBr (((2 * y + x : ℤ):ℝ)))
              * (FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)) := by
        rw [hin]
      rw [step1, step2, step3]
      ring
    rw [hpeel]
  rw [hre]
  have hy : ∀ x ∈ Icc (-65535:ℤ) 65535,
      FA ((x:ℝ)) * (indicator ((L:ℤ) <= |x|))
          * (∑ y ∈ Icc (-65535:ℤ) 65535, FBr (((2 * y + x : ℤ):ℝ)))
      <= FA ((x:ℝ)) * ((indicator ((L:ℤ) <= |x|)) * Ky) := by
    intro x hx
    have h1 : FA ((x:ℝ)) * (indicator ((L:ℤ) <= |x|))
          * (∑ y ∈ Icc (-65535:ℤ) 65535, FBr (((2 * y + x : ℤ):ℝ)))
        = FA ((x:ℝ))
            * ((indicator ((L:ℤ) <= |x|))
                * (∑ y ∈ Icc (-65535:ℤ) 65535, FBr (((2 * y + x : ℤ):ℝ)))) := by
      ring
    rw [h1]
    exact mul_le_mul_of_nonneg_left
      (mul_le_mul_of_nonneg_left (ysum_bound x) (indicator_nonnegative _))
      (by unfold FA; exact (Real.exp_pos _).le)
  have hK : (∑ x ∈ Icc (-65535:ℤ) 65535,
        FA ((x:ℝ)) * (indicator ((L:ℤ) <= |x|))
          * (∑ y ∈ Icc (-65535:ℤ) 65535, FBr (((2 * y + x : ℤ):ℝ))))
      <= (∑ x ∈ Icc (-65535:ℤ) 65535,
          FA ((x:ℝ)) * ((indicator ((L:ℤ) <= |x|)) * Ky)) :=
    Finset.sum_le_sum hy
  have hper : ∀ x ∈ Icc (-65535:ℤ) 65535,
      FA ((x:ℝ)) * ((indicator ((L:ℤ) <= |x|)) * Ky)
        = Ky * (FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)) := by
    intro x _
    ring
  have hA : (∑ x ∈ Icc (-65535:ℤ) 65535,
        FA ((x:ℝ)) * ((indicator ((L:ℤ) <= |x|)) * Ky))
      = ∑ x ∈ Icc (-65535:ℤ) 65535,
          Ky * (FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)) :=
    Finset.sum_congr rfl hper
  have hfac2 : (∑ x ∈ Icc (-65535:ℤ) 65535,
        FA ((x:ℝ)) * ((indicator ((L:ℤ) <= |x|)) * Ky))
      = Ky * (∑ x ∈ Icc (-65535:ℤ) 65535, FA ((x:ℝ)) * indicator ((L:ℤ) <= |x|)) := by
    rw [hA, Finset.mul_sum]
  rw [hfac2] at hK
  have hpair := xtail_pair_le L hL hL1
  exact le_trans hK (mul_le_mul_of_nonneg_left hpair
    (by unfold Ky KyR etaQ pi_lo; positivity))

/-- Główna kanapka: `prob` na jednej współrzędnej przez `Ky`, ogon x i `Lint`. -/
theorem prob_abs_x_bound (L : ℕ) (hL : L <= 65535) (hL1 : 0 < L) :
    prob blockLaw (fun b => (L:ℤ) <= |(blockDecode b).1|)
      <= Ky * (2 * Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
          / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592)))) / Lint := by
  have hprob : prob blockLaw (fun b => (L:ℤ) <= |(blockDecode b).1|)
      = (∑ b : Block, blockWeight b * indicator ((L:ℤ) <= |(blockDecode b).1|))
          / blockNormalizer := by
    unfold prob mean
    have hmass : ∀ b : Block, blockLaw.mass b = blockWeight b / blockNormalizer := by
      intro b
      rfl
    have hconv : (∑ b : Block, blockLaw.mass b
          * indicator ((L:ℤ) <= |(blockDecode b).1|))
        = (∑ b : Block, (blockWeight b / blockNormalizer)
            * indicator ((L:ℤ) <= |(blockDecode b).1|)) :=
      Finset.sum_congr rfl (fun b _ => by rw [hmass b])
    rw [hconv]
    have hdiv : (∑ b : Block, (blockWeight b / blockNormalizer)
          * indicator ((L:ℤ) <= |(blockDecode b).1|))
        = (∑ b : Block, blockWeight b * indicator ((L:ℤ) <= |(blockDecode b).1|))
            / blockNormalizer := by
      rw [Finset.sum_div]
      apply Finset.sum_congr rfl
      intro b _
      ring
    exact hdiv
  rw [hprob]
  have hnum := pair_num_le L hL hL1
  have hmono : (∑ b : Block, blockWeight b * indicator ((L:ℤ) <= |(blockDecode b).1|))
      / blockNormalizer
      <= (Ky * (2 * Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
          / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592)))))
          / blockNormalizer := by
    have hpos : (0:ℝ) <= blockNormalizer := le_of_lt blockNormalizer_pos
    exact div_le_div_of_nonneg_right hnum hpos
  have hden : (Ky * (2 * Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
        / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592)))))
      / blockNormalizer
    <= (Ky * (2 * Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
        / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592))))) / Lint := by
    rw [div_le_div_iff₀ blockNormalizer_pos Lint_pos']
    exact mul_le_mul_of_nonneg_left Lint_le_blockNormalizer (by
      have h1 : (0:ℝ) <= Ky := by unfold Ky KyR etaQ pi_lo; positivity
      have h2 : (0:ℝ) <= 2 * Real.exp (-((3:ℝ) * (((L:ℕ):ℝ)^2) / 4718592))
          / (1 - Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592))) := by
        apply div_nonneg
        · exact mul_nonneg (by norm_num) (Real.exp_pos _).le
        · have : Real.exp (-((3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592)) < 1 := by
            rw [Real.exp_lt_one_iff]
            have : (0:ℝ) < (3:ℝ) * (((2 * L + 1 : ℕ):ℝ)) / 4718592 := by positivity
            linarith
          linarith
      exact mul_nonneg h1 h2)
  exact le_trans (le_trans hmono hden) (le_of_eq rfl)

/-! ## 9. Emit: unia 1536 slotów (`unsignedHalf`) -/

/-- Wybór współrzędnej bloku: `false` → oś x, `true` → oś y. -/
def coordPick (b : Block) (bb : Bool) : ℤ :=
  match bb with
  | false => (blockDecode b).1
  | true => (blockDecode b).2

/-- Przekroczenie 16-bitowego zakresu na wybranej współrzędnej bloku. -/
def coordBig (b : Block) (bb : Bool) : Prop :=
  (32768:ℤ) ≤ |coordPick b bb|

/-- Predykat slotu na parze pudełek — STAŁA (bez projekcji w ciałach sum:
    notacja `∑ x : T` w tym forku nie typuje bindera, WORK_STATE/Faza C). -/
def P0 : Fin 768 × Bool → BoxPair → Prop :=
  fun ib z => coordBig (Prod.snd z (Prod.fst ib)) (Prod.snd ib)

/-- Predykat jednoblokowy osi — STAŁA. -/
def PB1 : Fin 768 × Bool → Block → Prop :=
  fun ib b => coordBig b (Prod.snd ib)

/-- `¬(-32768 ≤ x ∧ x ≤ 32767)` implikuje `32768 ≤ |x|`. -/
theorem abs_ge_of_not_signed (x : ℤ) (h : ¬(-32768 ≤ x ∧ x ≤ 32767)) :
    (32768:ℤ) ≤ |x| := by
  rcases not_and_or.mp h with h1 | h1
  · have hxe : |x| = -x := abs_of_nonpos (by omega)
    rw [hxe]
    omega
  · have hxe : |x| = x := abs_of_nonneg (by omega)
    rw [hxe]
    omega

theorem decodeVec_fst (v : BoxVec) (i : Fin 768) :
    (decodeVec v i).1 = (blockDecode (v i)).1 := rfl

theorem decodeVec_snd (v : BoxVec) (i : Fin 768) :
    (decodeVec v i).2 = (blockDecode (v i)).2 := rfl

/-- `unsignedHalf` = ∃ slot poza zakresem 16 bitów (4 przypadki `abs`). -/
theorem unsignedHalf_exists (v : BoxVec) (h : unsignedHalf v) :
    ∃ ib : Fin 768 × Bool,
      coordBig (v (Prod.fst ib)) (Prod.snd ib) := by
  have h' : ¬(∀ i : Fin 768,
      -32768 ≤ (decodeVec v i).1 ∧ (decodeVec v i).1 ≤ 32767 ∧
        -32768 ≤ (decodeVec v i).2 ∧ (decodeVec v i).2 ≤ 32767) := h
  have hex : ∃ i : Fin 768,
      ¬(-32768 ≤ (decodeVec v i).1 ∧ (decodeVec v i).1 ≤ 32767 ∧
        -32768 ≤ (decodeVec v i).2 ∧ (decodeVec v i).2 ≤ 32767) := by
    by_contra hc
    exact h' (fun i => by
      by_contra hi
      exact hc ⟨i, hi⟩)
  obtain ⟨i, hi⟩ := hex
  simp only [not_and_or] at hi
  rcases hi with h1 | h1 | h1 | h1
  · refine ⟨(i, false), ?_⟩
    have hg : (32768:ℤ) ≤ |(decodeVec v i).1| :=
      abs_ge_of_not_signed _ (fun hx => h1 hx.1)
    rw [decodeVec_fst] at hg
    exact hg
  · refine ⟨(i, false), ?_⟩
    have hg : (32768:ℤ) ≤ |(decodeVec v i).1| :=
      abs_ge_of_not_signed _ (fun hx => h1 hx.2)
    rw [decodeVec_fst] at hg
    exact hg
  · refine ⟨(i, true), ?_⟩
    have hg : (32768:ℤ) ≤ |(decodeVec v i).2| :=
      abs_ge_of_not_signed _ (fun hx => h1 hx.1)
    rw [decodeVec_snd] at hg
    exact hg
  · refine ⟨(i, true), ?_⟩
    have hg : (32768:ℤ) ≤ |(decodeVec v i).2| :=
      abs_ge_of_not_signed _ (fun hx => h1 hx.2)
    rw [decodeVec_snd] at hg
    exact hg

/-- Marginał: `prob rawLaw` slotu = `prob blockLaw` osi (niezależność
    połówek + rodzina iloczynowa — REUSE `raw_second_cylinder`,
    `one_coordinate`). -/
theorem prob_coordBig (ib : Fin 768 × Bool) :
    prob rawLaw (P0 ib) = prob blockLaw (PB1 ib) := by
  have h1 : prob rawLaw (P0 ib)
      = prob vectorLaw (fun v : BoxVec => coordBig (v (Prod.fst ib)) (Prod.snd ib)) :=
    raw_second_cylinder (fun v => coordBig (v (Prod.fst ib)) (Prod.snd ib))
  have h2 : prob vectorLaw (fun v : BoxVec => coordBig (v (Prod.fst ib)) (Prod.snd ib))
      = prob blockLaw (PB1 ib) :=
    one_coordinate (Prod.fst ib) (fun b => coordBig b (Prod.snd ib))
  rw [h1, h2]

/-- Symetria osi: masa `coordBig` na y = masa na x (`swapBlock`). -/
theorem prob_coordBig_true :
    prob blockLaw (fun b => coordBig b true)
      = prob blockLaw (fun b => coordBig b false) := by
  have hA : prob blockLaw (fun b => coordBig b true)
      = prob blockLaw (fun b => (32768:ℤ) ≤ |(blockDecode b).2|) :=
    prob_congr blockLaw _ _ (fun _ => Iff.rfl)
  have hB : prob blockLaw (fun b => (32768:ℤ) ≤ |(blockDecode b).2|)
      = prob blockLaw (fun b => (32768:ℤ) ≤ |(blockDecode b).1|) := by
    have h1 := prob_swap_invariant (fun b => (32768:ℤ) ≤ |(blockDecode b).1|)
    have h2 : (fun b => (32768:ℤ) ≤ |(blockDecode (swapBlock b)).1|)
        = (fun b => (32768:ℤ) ≤ |(blockDecode b).2|) := by
      funext b
      simp only [blockDecode_swapBlock]
    rw [← h2]
    exact h1
  have hC : prob blockLaw (fun b => (32768:ℤ) ≤ |(blockDecode b).1|)
      = prob blockLaw (fun b => coordBig b false) :=
    (prob_congr blockLaw _ _ (fun _ => Iff.rfl)).symm
  rw [hA, hB, hC]

/-- Granica unii: `mean` po `unsignedHalf` ≤ suma 1536 marginałów
    (REUSE `prob_mono` + `prob_exists_le_sum`). -/
theorem emit_le_sum :
    mean rawLaw (fun z => indicator (unsignedHalf z.2))
      ≤ ∑ i, prob blockLaw (PB1 i) := by
  have hm : mean rawLaw (fun z => indicator (unsignedHalf z.2))
      = prob rawLaw (fun z => unsignedHalf z.2) := rfl
  have hmono : prob rawLaw (fun z => unsignedHalf z.2)
      ≤ prob rawLaw (fun z => ∃ i, P0 i z) :=
    prob_mono rawLaw _ _
      (fun z hz => unsignedHalf_exists (Prod.snd z) hz)
  have hex : prob rawLaw (fun x => ∃ i, P0 i x) ≤ ∑ i, prob rawLaw (P0 i) :=
    prob_exists_le_sum rawLaw P0
  have hsum : (∑ i, prob rawLaw (P0 i)) = ∑ i, prob blockLaw (PB1 i) :=
    Finset.sum_congr rfl (fun i _ => prob_coordBig i)
  rw [hm]
  exact le_trans hmono (le_trans hex (le_of_eq hsum))

/-- Stała suma: 2 · 768 = 1536 slotów. -/
theorem sum_const_1536 (PB : ℝ) : (∑ _ib : Fin 768 × Bool, PB) = (1536:ℝ) * PB := by
  have hcard : Fintype.card (Fin 768 × Bool) = 1536 := by
    rw [Fintype.card_prod, Fintype.card_fin, Fintype.card_bool]
  have h1 : (∑ _ib : Fin 768 × Bool, PB) = ((1536:ℕ):ℝ) * PB := by
    rw [Finset.sum_const, Finset.card_univ, hcard, nsmul_eq_mul]
  have h2 : ((1536:ℕ):ℝ) * PB = (1536:ℝ) * PB := by norm_num
  rw [h1, h2]

theorem sum_prob_le_1536 (PB : ℝ)
    (h : ∀ bb : Bool, prob blockLaw (fun b => coordBig b bb) ≤ PB) :
    (∑ i, prob blockLaw (PB1 i)) ≤ (1536:ℝ) * PB := by
  have hle : (∑ i, prob blockLaw (PB1 i)) ≤ (∑ _i : Fin 768 × Bool, PB) :=
    Finset.sum_le_sum (fun i _ => h (Prod.snd i))
  have hconst : (∑ _i : Fin 768 × Bool, PB) = (1536:ℝ) * PB := sum_const_1536 PB
  exact le_trans hle (le_of_eq hconst)

/-- Wartość graniczna marginału (oba łuki przez symetrię `swapBlock`). -/
theorem prob_coordBig_le (bb : Bool) :
    prob blockLaw (fun b => coordBig b bb)
      ≤ Ky * (2 * Real.exp (-((3:ℝ) * (((32768:ℕ):ℝ)^2) / 4718592))
          / (1 - Real.exp (-((3:ℝ) * (((2 * 32768 + 1 : ℕ):ℝ)) / 4718592)))) / Lint := by
  cases bb with
  | false =>
    have h := prob_abs_x_bound 32768 (by norm_num) (by norm_num)
    have hc : prob blockLaw (fun b => coordBig b false)
        = prob blockLaw (fun b => ((32768:ℕ):ℤ) ≤ |(blockDecode b).1|) :=
      prob_congr blockLaw _ _ (fun _ => Iff.rfl)
    rw [hc]
    exact h
  | true =>
    have hs : prob blockLaw (fun b => coordBig b true)
        = prob blockLaw (fun b => coordBig b false) := prob_coordBig_true
    rw [hs]
    have h := prob_abs_x_bound 32768 (by norm_num) (by norm_num)
    have hc : prob blockLaw (fun b => coordBig b false)
        = prob blockLaw (fun b => ((32768:ℕ):ℤ) ≤ |(blockDecode b).1|) :=
      prob_congr blockLaw _ _ (fun _ => Iff.rfl)
    rw [hc]
    exact h

/-- Emit surowej połowy ograniczony 1536 × boundem ogonowym `L = 32768`. -/
theorem emit_prob_le_bound :
    mean rawLaw (fun z => indicator (unsignedHalf z.2))
      ≤ (1536:ℝ) * (Ky * (2 * Real.exp (-((3:ℝ) * (((32768:ℕ):ℝ)^2) / 4718592))
          / (1 - Real.exp (-((3:ℝ) * (((2 * 32768 + 1 : ℕ):ℝ)) / 4718592)))) / Lint) :=
  le_trans emit_le_sum (sum_prob_le_1536 _ prob_coordBig_le)

/-! ## 10. Warstwa QQ: `coord_tail_9217` i `emit_tail_cap` -/

/-- Górna granica `√3` (sprawdzona kwadratem: `sq3_hi^2 ≥ 3`). -/
noncomputable def sq3_hi : ℝ := 173205080756887729354 / 10^20

/-- Dolna granica `Lint` z `pi_lo`, `sq3_hi` (dokładnie jak
    `check_tail_chain.sage`, PART_II_QQ_PASS). -/
noncomputable def Lint_lo : ℝ := (2 * pi_lo / (c0 * sq3_hi)) * (1 - 1/2^20)

/-- QQ-rozkład `E0(9217)` = `E1inv^54 · tayl(55299/4718592)`. -/
noncomputable def EQ9217 : ℝ := ((10:ℝ)^9 / 2718281828)^54 * tayl (55299/4718592)
/-- QQ-rozkład `q(9217)` = `E1inv^0 · tayl(55305/4718592)`. -/
noncomputable def qQ9217 : ℝ := ((10:ℝ)^9 / 2718281828)^0 * tayl (55305/4718592)
/-- QQ-rozkład `E0(32768)` = `E1inv^682 · tayl7(2/3)` — dla δ = 2/3 granica
    `tayl` (rząd 4) przebija `e^{-2/3}` o 3,4% i wychodzi poza `emitCap`
    (przebicie zmierzone w `check_fml_cmp.sage`); `tayl7` przebija o ~0,005%,
    co mieści się w budżecie (potwierdzone: `check_fml_cmp2.sage`). -/
noncomputable def EQ32768 : ℝ := ((10:ℝ)^9 / 2718281828)^682 * tayl7 (2/3)
/-- QQ-rozkład `q(32768)` = `E1inv^0 · tayl7(196611/4718592)`. -/
noncomputable def qQ32768 : ℝ := ((10:ℝ)^9 / 2718281828)^0 * tayl7 (196611/4718592)

/-- Rozkłady wykładników (dokładne QQ — te same literały co Sage). -/
theorem split_E9217 : ((3:ℝ) * (((9217:ℕ):ℝ)^2) / 4718592)
    = ((54:ℕ):ℝ) + (55299/4718592) := by norm_num

theorem split_q9217 : ((3:ℝ) * (((2 * 9217 + 1 : ℕ):ℝ)) / 4718592)
    = ((0:ℕ):ℝ) + (55305/4718592) := by norm_num

theorem split_E32768 : ((3:ℝ) * (((32768:ℕ):ℝ)^2) / 4718592)
    = ((682:ℕ):ℝ) + (2/3) := by norm_num

theorem split_q32768 : ((3:ℝ) * (((2 * 32768 + 1 : ℕ):ℝ)) / 4718592)
    = ((0:ℕ):ℝ) + (196611/4718592) := by norm_num

/-- `exp(-E0arg(9217)) ≤ EQ9217` — `exp_neg_nat_add_le` + split. -/
theorem E_le_9217 :
    Real.exp (-((3:ℝ) * (((9217:ℕ):ℝ)^2) / 4718592)) ≤ EQ9217 := by
  have h1 : (0:ℝ) ≤ 55299/4718592 := by norm_num
  have h2 : (55299/4718592:ℝ) ≤ 1 := by norm_num
  rw [split_E9217]
  exact exp_neg_nat_add_le 54 h1 h2

theorem q_le_9217 :
    Real.exp (-((3:ℝ) * (((2 * 9217 + 1 : ℕ):ℝ)) / 4718592)) ≤ qQ9217 := by
  have h1 : (0:ℝ) ≤ 55305/4718592 := by norm_num
  have h2 : (55305/4718592:ℝ) ≤ 1 := by norm_num
  rw [split_q9217]
  exact exp_neg_nat_add_le 0 h1 h2

theorem E_le_32768 :
    Real.exp (-((3:ℝ) * (((32768:ℕ):ℝ)^2) / 4718592)) ≤ EQ32768 := by
  have h1 : (0:ℝ) ≤ 2/3 := by norm_num
  have h2 : (2/3:ℝ) ≤ 1 := by norm_num
  rw [split_E32768]
  exact exp_neg_nat_add_le7 682 h1 h2

theorem q_le_32768 :
    Real.exp (-((3:ℝ) * (((2 * 32768 + 1 : ℕ):ℝ)) / 4718592)) ≤ qQ32768 := by
  have h1 : (0:ℝ) ≤ 196611/4718592 := by norm_num
  have h2 : (196611/4718592:ℝ) ≤ 1 := by norm_num
  rw [split_q32768]
  exact exp_neg_nat_add_le7 0 h1 h2

theorem qQ9217_lt_one : qQ9217 < 1 := by
  unfold qQ9217 tayl
  norm_num

theorem qQ32768_lt_one : qQ32768 < 1 := by
  unfold qQ32768 tayl7
  norm_num

/-- Monotoniczność pary `(2E)/(1-q)` w obu argumentach. -/
theorem xtpair_le {E0 q EQ qQ : ℝ} (hE : 0 ≤ EQ) (hEE : E0 ≤ EQ)
    (hq : q ≤ qQ) (hqQ : qQ < 1) :
    (2 * E0) / (1 - q) ≤ (2 * EQ) / (1 - qQ) := by
  have hq1 : q < 1 := lt_of_le_of_lt hq hqQ
  have hd : 0 < 1 - q := by linarith
  have hdQ : 0 < 1 - qQ := by linarith
  have hdd : 1 - qQ ≤ 1 - q := by linarith
  have hn : (2:ℝ) * E0 ≤ 2 * EQ := mul_le_mul_of_nonneg_left hEE (by norm_num)
  have step1 : (2 * E0) * (1 - qQ) ≤ (2 * EQ) * (1 - qQ) :=
    mul_le_mul_of_nonneg_right hn (le_of_lt hdQ)
  have step2 : (2 * EQ) * (1 - qQ) ≤ (2 * EQ) * (1 - q) :=
    mul_le_mul_of_nonneg_left hdd (mul_nonneg (by norm_num) hE)
  rw [div_le_div_iff₀ hd hdQ]
  exact le_trans step1 step2

theorem XT9217_le :
    (2 * Real.exp (-((3:ℝ) * (((9217:ℕ):ℝ)^2) / 4718592)))
        / (1 - Real.exp (-((3:ℝ) * (((2 * 9217 + 1 : ℕ):ℝ)) / 4718592)))
      ≤ (2 * EQ9217) / (1 - qQ9217) :=
  xtpair_le (by unfold EQ9217 tayl; norm_num) E_le_9217 q_le_9217 qQ9217_lt_one

theorem XT32768_le :
    (2 * Real.exp (-((3:ℝ) * (((32768:ℕ):ℝ)^2) / 4718592)))
        / (1 - Real.exp (-((3:ℝ) * (((2 * 32768 + 1 : ℕ):ℝ)) / 4718592)))
      ≤ (2 * EQ32768) / (1 - qQ32768) :=
  xtpair_le (by unfold EQ32768 tayl7; norm_num) E_le_32768 q_le_32768 qQ32768_lt_one

theorem sq3_hi_sq : (3:ℝ) ≤ sq3_hi^2 := by
  unfold sq3_hi
  norm_num

theorem sqrt3_le_sq3_hi : Real.sqrt 3 ≤ sq3_hi := by
  have h := Real.sqrt_le_sqrt sq3_hi_sq
  have h0 : (0:ℝ) ≤ sq3_hi := by unfold sq3_hi; norm_num
  rwa [Real.sqrt_sq h0] at h

theorem Lint_lo_pos : (0:ℝ) < Lint_lo := by
  unfold Lint_lo sq3_hi pi_lo c0
  norm_num

theorem Lint_lo_le : Lint_lo ≤ Lint := by
  have hsq := sqrt3_le_sq3_hi
  have hpi : (2:ℝ) * pi_lo ≤ 2 * Real.pi :=
    mul_le_mul_of_nonneg_left pi_lo_lt.le (by norm_num)
  have hden1 : (0:ℝ) < c0 * sq3_hi :=
    mul_pos BlockTheta.c0_pos (by unfold sq3_hi; norm_num)
  have hden2 : (0:ℝ) < c0 * Real.sqrt 3 :=
    mul_pos BlockTheta.c0_pos (by positivity)
  have hmain : 2 * pi_lo / (c0 * sq3_hi) ≤ 2 * Real.pi / (c0 * Real.sqrt 3) := by
    rw [div_le_div_iff₀ hden1 hden2]
    have hdle : c0 * Real.sqrt 3 ≤ c0 * sq3_hi :=
      mul_le_mul_of_nonneg_left hsq (le_of_lt BlockTheta.c0_pos)
    exact mul_le_mul hpi hdle
      (mul_nonneg (le_of_lt BlockTheta.c0_pos) (Real.sqrt_nonneg _))
      (mul_nonneg (by norm_num) (le_of_lt Real.pi_pos))
  have hL : (2 * Real.pi / (c0 * Real.sqrt 3)) * (1 - (1/2^20:ℝ)) = Lint := rfl
  have hmul : Lint_lo ≤ (2 * Real.pi / (c0 * Real.sqrt 3)) * (1 - (1/2^20:ℝ)) :=
    mul_le_mul_of_nonneg_right hmain (by norm_num)
  exact le_trans hmul (le_of_eq hL)

/-- Transport `Ky·X/Lint` na warstwę QQ przez `Lint ≥ Lint_lo`. -/
theorem Ky_div_le (X XQ : ℝ) (hX : X ≤ XQ) (hXQ : 0 ≤ XQ) :
    Ky * X / Lint ≤ Ky * XQ / Lint_lo := by
  have hKy : (0:ℝ) ≤ Ky := by unfold Ky KyR etaQ pi_lo; positivity
  have h1 : Ky * X ≤ Ky * XQ := mul_le_mul_of_nonneg_left hX hKy
  have h2 : Ky * X / Lint ≤ Ky * XQ / Lint :=
    div_le_div_of_nonneg_right h1 (le_of_lt Lint_pos')
  have h3 : Ky * XQ / Lint ≤ Ky * XQ / Lint_lo := by
    rw [div_le_div_iff₀ Lint_pos' Lint_lo_pos]
    exact mul_le_mul_of_nonneg_left Lint_lo_le (mul_nonneg hKy hXQ)
  exact le_trans h2 h3

-- Próg potęgowy podniesiony — parametr obliczeniowy `norm_num`
-- ((10^9/2718281828)^682 ma ~6800 cyfr; nie wyciszenie ostrzeżeń).
set_option exponentiation.threshold 8192 in
/-- Porównanie QQ numer/demianator dla `L = 9217` ≤ `tau9217`
    (dokładnie `p1_qq` z `check_tail_chain.sage`). -/
theorem coord_qq_num :
    Ky * ((2 * EQ9217) / (1 - qQ9217)) / Lint_lo ≤ (tau9217:ℝ) := by
  norm_num [Ky, KyR, etaQ, pi_lo, Lint_lo, sq3_hi, EQ9217, qQ9217, tayl, c0, tau9217]

set_option exponentiation.threshold 8192 in
/-- Porównanie QQ dla emitu ≤ `emitCap` (dokładnie `p2_qq`). -/
theorem emit_qq_num :
    (1536:ℝ) * (Ky * ((2 * EQ32768) / (1 - qQ32768)) / Lint_lo) ≤ (emitCap:ℝ) := by
  norm_num [Ky, KyR, etaQ, pi_lo, Lint_lo, sq3_hi, EQ32768, qQ32768, tayl7, c0, emitCap]

/-- **`coord_tail_9217`** — przesłanka `hchange` dla
    `ChangedTailReduction.hchange_of_tau`. -/
theorem coord_tail_9217 :
    prob blockLaw (fun b => 9217 ≤ |(blockDecode b).1|) ≤ (tau9217:ℝ) := by
  have hp := prob_abs_x_bound 9217 (by norm_num) (by norm_num)
  have hc : prob blockLaw (fun b => 9217 ≤ |(blockDecode b).1|)
      = prob blockLaw (fun b => ((9217:ℕ):ℤ) ≤ |(blockDecode b).1|) :=
    prob_congr blockLaw _ _ (fun _ => Iff.rfl)
  rw [hc]
  have hXT := XT9217_le
  have hXQ : (0:ℝ) ≤ (2 * EQ9217) / (1 - qQ9217) := by
    set_option exponentiation.threshold 32768 in
    norm_num [EQ9217, qQ9217, tayl]
  exact le_trans hp (le_trans (Ky_div_le _ _ hXT hXQ) coord_qq_num)

/-- **`emit_tail_cap`** — przesłanka `htail` dla
    `RadialObligations.emitPenalty_of_tailCap`. -/
theorem emit_tail_cap :
    mean rawLaw (fun z => indicator (unsignedHalf z.2)) ≤ (emitCap:ℝ) := by
  have hXT := XT32768_le
  have hXQ : (0:ℝ) ≤ (2 * EQ32768) / (1 - qQ32768) := by
    set_option exponentiation.threshold 32768 in
    norm_num [EQ32768, qQ32768, tayl7]
  exact le_trans emit_prob_le_bound
    (le_trans (mul_le_mul_of_nonneg_left (Ky_div_le _ _ hXT hXQ) (by norm_num)) emit_qq_num)

end FT1536.FinalTails
