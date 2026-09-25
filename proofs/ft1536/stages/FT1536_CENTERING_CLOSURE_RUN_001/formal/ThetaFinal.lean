import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Topology.Algebra.InfiniteSum.Group
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Analysis.Complex.ExponentialBounds
import ThetaPoisson
import Theta2Split

/-!
# ThetaFinal — Faza D: kanapka Θ₂ i montaż ThetaBounds

`Θ₂(s) = S₀(s)·S₀(3s) + S₁(s)·S₁(3s)` (Faza B), wartości Poissona
z Fazy A dają `S₀(u) = √(π/u)·Θ(π²/u)` z `Θ ∈ [1, 1+4e^{-π²/u}]`,
a `S₁(u) = S₀(u/4) − S₀(u)` (Faza B) daje `S₁(u) = √(π/u)·(1 + male)`.
Wynik docelowy: `Θ₂(s) = (2π/(s√3))·(1 ± male)`.
-/

namespace FT1536.ThetaFinal

open Real FT1536.ThetaPoisson FT1536.Theta2Split

/-- log 4 ≤ 2 (lokalna kopia — w ThetaBox jest w osobnym namespace). -/
theorem log_four_le_two : Real.log 4 <= 2 := by
  have hlt := Real.log_two_lt_d9
  have hlt2 : Real.log (4:ℝ) = 2 * Real.log 2 := by
    rw [show (4:ℝ) = 2 * 2 by norm_num, Real.log_mul (by norm_num) (by norm_num)]
    ring
  rw [hlt2]
  nlinarith

/-! ## Helpery pierwiastkowe -/

theorem sqrt_four_mul (x : ℝ) (hx : 0 ≤ x) :
    Real.sqrt (4 * x) = 2 * Real.sqrt x := by
  have h1 : (4:ℝ) * x = (2 * Real.sqrt x)^2 := by
    rw [mul_pow, sq, sq]
    have h2 : Real.sqrt x * Real.sqrt x = x := Real.mul_self_sqrt hx
    rw [h2]
    norm_num
  have hp : (0:ℝ) ≤ 2 * Real.sqrt x :=
    mul_nonneg (by norm_num) (Real.sqrt_nonneg x)
  rw [h1, Real.sqrt_sq hp]

/-- Kluczowy produkt: √(π/s)·√(π/(3s)) = π/(s·√3). -/
theorem sqrt_prod_id (s : ℝ) (hs : 0 < s) :
    Real.sqrt (Real.pi / s) * Real.sqrt (Real.pi / (3*s))
      = Real.pi / (s * Real.sqrt 3) := by
  have hp1 : 0 ≤ Real.pi / s := by positivity
  have hp2 : 0 ≤ Real.pi / (3*s) := by positivity
  have hmul : Real.sqrt (Real.pi / s) * Real.sqrt (Real.pi / (3*s))
      = Real.sqrt ((Real.pi / s) * (Real.pi / (3*s))) :=
    (Real.sqrt_mul hp1 _).symm
  rw [hmul]
  have hprod : (Real.pi / s) * (Real.pi / (3*s))
      = (Real.pi / (s * Real.sqrt 3))^2 := by
    have h3 : (Real.sqrt 3 : ℝ)^2 = 3 := by
      rw [sq, Real.mul_self_sqrt (by norm_num)]
    rw [sq]
    field_simp [h3]
    exact h3
  rw [hprod, Real.sqrt_sq (by positivity)]

/-! ## Rozwinięcie S₁ = S₀(u/4) − S₀(u) -/

/-- Dolna granica S₁: S₁(u) ≥ √(π/u)·(1 − 4e^{-π²/u}). -/
theorem s1_lower (u : ℝ) (hu : 0 < u) (hu9 : u <= 9) :
    Real.sqrt (Real.pi / u) * (1 - 4 * Real.exp (-(Real.pi^2 / u))) <= S1 u := by
  have hAu : (0:ℝ) < u / 4 := by positivity
  have hAu9 : u / 4 <= 9 := by linarith
  have hA := (S0_bounds (u/4) hAu hAu9).1
  have hB := (S0_bounds u hu hu9).2
  have hsq : Real.sqrt (Real.pi / (u / 4)) = 2 * Real.sqrt (Real.pi / u) := by
    have h : Real.pi / (u / 4) = 4 * (Real.pi / u) := by field_simp
    rw [h, sqrt_four_mul _ (by positivity)]
  have hstep : 2 * Real.sqrt (Real.pi / u)
        - Real.sqrt (Real.pi / u) * (1 + 4 * Real.exp (-(Real.pi^2 / u)))
      <= S0 (u/4) - S0 u := by
    rw [← hsq]
    linarith
  rw [S1_eq u hu]
  have hfin : Real.sqrt (Real.pi / u) * (1 - 4 * Real.exp (-(Real.pi^2 / u)))
      = 2 * Real.sqrt (Real.pi / u)
        - Real.sqrt (Real.pi / u) * (1 + 4 * Real.exp (-(Real.pi^2 / u))) := by
    ring
  rw [hfin]
  exact hstep

/-- Górna granica S₁: S₁(u) ≤ √(π/u)·(1 + 8e^{-4π²/u}). -/
theorem s1_upper (u : ℝ) (hu : 0 < u) (hu9 : u <= 9) :
    S1 u <= Real.sqrt (Real.pi / u) * (1 + 8 * Real.exp (-(4 * Real.pi^2 / u))) := by
  have hAu : (0:ℝ) < u / 4 := by positivity
  have hAu9 : u / 4 <= 9 := by linarith
  have hA := (S0_bounds (u/4) hAu hAu9).2
  have hB := (S0_bounds u hu hu9).1
  have hsq : Real.sqrt (Real.pi / (u / 4)) = 2 * Real.sqrt (Real.pi / u) := by
    have h : Real.pi / (u / 4) = 4 * (Real.pi / u) := by field_simp
    rw [h, sqrt_four_mul _ (by positivity)]
  have hexpo : Real.pi^2 / (u / 4) = 4 * Real.pi^2 / u := by field_simp
  have hA2 : S0 (u/4) <= 2 * Real.sqrt (Real.pi / u)
      * (1 + 4 * Real.exp (-(4 * Real.pi^2 / u))) := by
    rw [← hsq, ← hexpo]
    exact hA
  have hB2 : Real.sqrt (Real.pi / u) <= S0 u := hB
  rw [S1_eq u hu]
  have hthis : S0 (u/4) - S0 u
      <= 2 * Real.sqrt (Real.pi / u) * (1 + 4 * Real.exp (-(4 * Real.pi^2 / u)))
        - Real.sqrt (Real.pi / u) := by
    linarith
  have hmain : 2 * Real.sqrt (Real.pi / u) * (1 + 4 * Real.exp (-(4 * Real.pi^2 / u)))
        - Real.sqrt (Real.pi / u)
      = Real.sqrt (Real.pi / u) * (1 + 8 * Real.exp (-(4 * Real.pi^2 / u))) := by
    ring
  rw [hmain] at hthis
  exact hthis

/-! ## Kanapka Θ₂ — kierunek dolny -/

/-- M(s) := 4e^{-π²/(3s)} ≤ 1 dla 0 < s ≤ 1. -/
theorem M_le_one (s : ℝ) (hs : 0 < s) (hs1 : s <= 1) :
    (4:ℝ) * Real.exp (-(Real.pi^2 / (3 * s))) <= 1 := by
  have h4 : Real.log 4 <= 2 := log_four_le_two
  have h6 : Real.pi^2 / 3 <= Real.pi^2 / (3 * s) := by
    have h7 : (0:ℝ) < 3 * s := by positivity
    rw [le_div_iff₀ h7]
    have h8 : Real.pi^2 / 3 * (3 * s) = Real.pi^2 * s := by field_simp
    rw [h8]
    nlinarith [Real.pi_pos, hs1]
  have h9 : (2:ℝ) <= Real.pi^2 / 3 := by
    nlinarith [Real.pi_gt_three]
  have hX : Real.log 4 <= Real.pi^2 / (3 * s) := by linarith
  have hexp : Real.exp (-(Real.pi^2 / (3 * s))) <= Real.exp (-Real.log 4) :=
    (Real.exp_le_exp).2 (neg_le_neg hX)
  have hval : Real.exp (-Real.log 4) = (4:ℝ)⁻¹ := by
    rw [Real.exp_neg, Real.exp_log (by norm_num)]
  have h4b : (4:ℝ) * Real.exp (-(Real.pi^2 / (3 * s)))
      <= (4:ℝ) * Real.exp (-Real.log 4) :=
    mul_le_mul_of_nonneg_left hexp (by norm_num)
  rw [hval] at h4b
  have h5 : (4:ℝ) * (4:ℝ)⁻¹ = 1 := by norm_num
  rw [h5] at h4b
  exact h4b

/-- Korekta δ₀ = 4e^{-π²/s} nie przekracza M = 4e^{-π²/(3s)}. -/
theorem corr_le_M (s : ℝ) (hs : 0 < s) :
    (4:ℝ) * Real.exp (-(Real.pi^2 / s))
      <= 4 * Real.exp (-(Real.pi^2 / (3 * s))) := by
  have hsplit : Real.pi^2 / s = 3 * (Real.pi^2 / (3 * s)) := by field_simp
  rw [hsplit]
  have h : Real.pi^2 / (3 * s) <= 3 * (Real.pi^2 / (3 * s)) := by
    have hpos : (0:ℝ) <= Real.pi^2 / (3 * s) := by positivity
    nlinarith
  exact mul_le_mul_of_nonneg_left ((Real.exp_le_exp).2 (neg_le_neg h)) (by norm_num)

/-- Dolna kanapka: 2π/(s√3)·(1 − M) ≤ Θ₂(s), M = 4e^{-π²/(3s)}, 0 < s ≤ 1. -/
theorem theta2_lower (s : ℝ) (hs : 0 < s) (hs1 : s <= 1) :
    2 * (Real.pi / (s * Real.sqrt 3))
        * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))
      <= Theta2 s := by
  have h3s : (0:ℝ) < 3 * s := by positivity
  have h3s9 : 3 * s <= 9 := by linarith
  have hs9 : s <= 9 := by linarith
  have hA1 : Real.sqrt (Real.pi / s) <= S0 s := (S0_bounds s hs hs9).1
  have hB1 : Real.sqrt (Real.pi / (3*s)) <= S0 (3*s) := (S0_bounds (3*s) h3s h3s9).1
  have hA2 := s1_lower s hs hs9
  have hB2 := s1_lower (3*s) h3s h3s9
  have hM0 : (0:ℝ) <= 4 * Real.exp (-(Real.pi^2 / (3 * s))) := by positivity
  have hMle : (4:ℝ) * Real.exp (-(Real.pi^2 / (3 * s))) <= 1 := M_le_one s hs hs1
  have hca := corr_le_M s hs
  -- wzmocnienie s1_lower do postaci (1 − M)
  have hA3 : Real.sqrt (Real.pi / s) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))
      <= S1 s := by
    have h : (1:ℝ) - 4 * Real.exp (-(Real.pi^2 / s))
        >= 1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))) := by linarith
    have h2 : Real.sqrt (Real.pi / s) * (1 - 4 * Real.exp (-(Real.pi^2 / s)))
        >= Real.sqrt (Real.pi / s) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))) :=
      mul_le_mul_of_nonneg_left h (by positivity)
    exact le_trans h2 hA2
  have hS1pos : (0:ℝ) <= S1 s :=
    le_trans (mul_nonneg (Real.sqrt_nonneg _) (by nlinarith [hMle, hM0])) hA3
  have hprod0 : Real.sqrt (Real.pi / s) * Real.sqrt (Real.pi / (3*s))
      <= S0 s * S0 (3*s) :=
    mul_le_mul hA1 hB1 (Real.sqrt_nonneg _)
      (tsum_nonneg (fun i => (Real.exp_pos _).le))
  have hprod1 : Real.sqrt (Real.pi / s) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))
        * (Real.sqrt (Real.pi / (3*s)) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
      <= S1 s * S1 (3*s) :=
    mul_le_mul hA3 hB2
      (mul_nonneg (Real.sqrt_nonneg _) (by nlinarith [hMle, hM0]))
      hS1pos
  have hS1alg : Real.sqrt (Real.pi / s) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))
        * (Real.sqrt (Real.pi / (3*s)) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
      = (Real.pi / (s * Real.sqrt 3))
          * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2 := by
    have hmul : Real.sqrt (Real.pi / s) * Real.sqrt (Real.pi / (3*s))
        = Real.pi / (s * Real.sqrt 3) := sqrt_prod_id s hs
    have h2 : Real.sqrt (Real.pi / s) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))
          * (Real.sqrt (Real.pi / (3*s)) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
        = (Real.sqrt (Real.pi / s) * Real.sqrt (Real.pi / (3*s)))
            * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2 := by
      ring
    rw [h2, hmul]
  rw [theta2_split s hs]
  have hkey : Real.pi / (s * Real.sqrt 3)
        * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
      <= S1 s * S1 (3*s) := by
    rw [← hS1alg]
    exact hprod1
  have hsquare : (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
      >= 1 - 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))) := by
    nlinarith [hM0, hMle]
  have hfinal : Real.pi / (s * Real.sqrt 3)
        + Real.pi / (s * Real.sqrt 3) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
      >= 2 * (Real.pi / (s * Real.sqrt 3))
          * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))) := by
    have h3 : (0:ℝ) <= Real.pi / (s * Real.sqrt 3) := by positivity
    have h4 : (1:ℝ) + (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
        >= 2 * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))) := by
      nlinarith [hsquare]
    have h5 : Real.pi / (s * Real.sqrt 3)
          * (2 * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
        <= Real.pi / (s * Real.sqrt 3)
          * (1 + (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2) :=
      mul_le_mul_of_nonneg_left h4 h3
    have h6 : Real.pi / (s * Real.sqrt 3)
          * (2 * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
        = 2 * (Real.pi / (s * Real.sqrt 3))
            * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))) := by ring
    have h7 : Real.pi / (s * Real.sqrt 3)
          * (1 + (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2)
        = Real.pi / (s * Real.sqrt 3)
            + Real.pi / (s * Real.sqrt 3) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2 := by
      ring
    rw [h6, h7] at h5
    exact h5
  have hchain : 2 * (Real.pi / (s * Real.sqrt 3))
        * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))
      <= Real.pi / (s * Real.sqrt 3)
        + Real.pi / (s * Real.sqrt 3) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2 := by
    linarith [hfinal]
  have hsum : Real.pi / (s * Real.sqrt 3)
        + Real.pi / (s * Real.sqrt 3) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
      <= S0 s * S0 (3*s) + S1 s * S1 (3*s) := by
    have h4 : Real.pi / (s * Real.sqrt 3)
        = Real.sqrt (Real.pi / s) * Real.sqrt (Real.pi / (3*s)) := (sqrt_prod_id s hs).symm
    rw [h4]
    have h5 : Real.sqrt (Real.pi / s) * Real.sqrt (Real.pi / (3*s))
          * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
        = Real.sqrt (Real.pi / s) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))
          * (Real.sqrt (Real.pi / (3*s)) * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s))))) := by
      ring
    rw [h5]
    exact add_le_add hprod0 hprod1
  linarith

/-! ## Kanapka Θ₂ — kierunek górny -/

/-- Korekta ε = 8e^{-4π²/u} dla u = s nie przekracza 2M = 8e^{-π²/(3s)}. -/
theorem eps_le_twoM (s : ℝ) (hs : 0 < s) :
    (8:ℝ) * Real.exp (-(4 * Real.pi^2 / s))
      <= 8 * Real.exp (-(Real.pi^2 / (3 * s))) := by
  have hcmp : Real.pi^2 / (3 * s) <= 4 * Real.pi^2 / s := by
    rw [le_div_iff₀ hs]
    have h2 : Real.pi^2 / (3 * s) * s = Real.pi^2 / 3 := by
      rw [div_mul_eq_div_div, div_mul_cancel₀ _ (ne_of_gt hs)]
    rw [h2]
    nlinarith [sq_nonneg Real.pi]
  exact mul_le_mul_of_nonneg_left ((Real.exp_le_exp).2 (neg_le_neg hcmp)) (by norm_num)

/-- Korekta ε = 8e^{-4π²/u} dla u = 3s nie przekracza 2M = 8e^{-π²/(3s)}. -/
theorem eps3_le_twoM (s : ℝ) (hs : 0 < s) :
    (8:ℝ) * Real.exp (-(4 * Real.pi^2 / (3 * s)))
      <= 8 * Real.exp (-(Real.pi^2 / (3 * s))) := by
  have hcmp : Real.pi^2 / (3 * s) <= 4 * Real.pi^2 / (3 * s) := by
    have hpos : (0:ℝ) <= Real.pi^2 / (3 * s) := by positivity
    have h4 : (4:ℝ) * (Real.pi^2 / (3 * s)) = 4 * Real.pi^2 / (3 * s) := by ring
    rw [← h4]
    nlinarith
  exact mul_le_mul_of_nonneg_left ((Real.exp_le_exp).2 (neg_le_neg hcmp)) (by norm_num)

/-- Górna kanapka: Θ₂(s) ≤ 2π/(s√3)·(1 + 24e^{-π²/(3s)}), 0 < s ≤ 1. -/
theorem theta2_upper (s : ℝ) (hs : 0 < s) (hs1 : s <= 1) :
    Theta2 s <= 2 * (Real.pi / (s * Real.sqrt 3))
      * (1 + 24 * Real.exp (-(Real.pi^2 / (3 * s)))) := by
  have h3s : (0:ℝ) < 3 * s := by positivity
  have h3s9 : 3 * s <= 9 := by linarith
  have hs9 : s <= 9 := by linarith
  have hM0 : (0:ℝ) <= 4 * Real.exp (-(Real.pi^2 / (3 * s))) := by positivity
  have hMle : (4:ℝ) * Real.exp (-(Real.pi^2 / (3 * s))) <= 1 := M_le_one s hs hs1
  have hca := corr_le_M s hs
  -- górne ograniczenia S₀: S₀(u) ≤ √(π/u)·(1 + M)
  have hA0 : S0 s <= Real.sqrt (Real.pi / s)
      * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s)))) := by
    have hA := (S0_bounds s hs hs9).2
    have hstep : Real.sqrt (Real.pi / s) * (1 + 4 * Real.exp (-(Real.pi^2 / s)))
        <= Real.sqrt (Real.pi / s) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s)))) :=
      mul_le_mul_of_nonneg_left (by linarith [hca]) (Real.sqrt_nonneg _)
    exact le_trans hA hstep
  have hB0 : S0 (3*s) <= Real.sqrt (Real.pi / (3*s))
      * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s)))) := (S0_bounds (3*s) h3s h3s9).2
  -- nieujemność S₁ (z s1_lower) — wymagana przez mul_le_mul
  have hS1pos : (0:ℝ) <= S1 s := by
    have h1 := s1_lower s hs hs9
    have hnn : (0:ℝ) <= Real.sqrt (Real.pi / s)
        * (1 - 4 * Real.exp (-(Real.pi^2 / s))) :=
      mul_nonneg (Real.sqrt_nonneg _) (by linarith [hca, hMle])
    exact le_trans hnn h1
  have hS13pos : (0:ℝ) <= S1 (3*s) := by
    have h1 := s1_lower (3*s) h3s h3s9
    have hnn : (0:ℝ) <= Real.sqrt (Real.pi / (3*s))
        * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * s)))) :=
      mul_nonneg (Real.sqrt_nonneg _) (by linarith [hMle])
    exact le_trans hnn h1
  -- górne ograniczenia S₁: S₁(u) ≤ √(π/u)·(1 + 2M)
  have hA1 : S1 s <= Real.sqrt (Real.pi / s)
      * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))) := by
    have h1 := s1_upper s hs hs9
    have he := eps_le_twoM s hs
    have hstep : Real.sqrt (Real.pi / s) * (1 + 8 * Real.exp (-(4 * Real.pi^2 / s)))
        <= Real.sqrt (Real.pi / s) * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))) :=
      mul_le_mul_of_nonneg_left (by linarith [he]) (Real.sqrt_nonneg _)
    exact le_trans h1 hstep
  have hB1 : S1 (3*s) <= Real.sqrt (Real.pi / (3*s))
      * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))) := by
    have h1 := s1_upper (3*s) h3s h3s9
    have he := eps3_le_twoM s hs
    have hstep : Real.sqrt (Real.pi / (3*s))
          * (1 + 8 * Real.exp (-(4 * Real.pi^2 / (3 * s))))
        <= Real.sqrt (Real.pi / (3*s))
          * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))) :=
      mul_le_mul_of_nonneg_left (by linarith [he]) (Real.sqrt_nonneg _)
    exact le_trans h1 hstep
  -- produkty
  have hprod0 : S0 s * S0 (3*s)
      <= (Real.sqrt (Real.pi / s) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
        * (Real.sqrt (Real.pi / (3*s)) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s))))) := by
    have hnnB : (0:ℝ) <= Real.sqrt (Real.pi / s)
        * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s)))) :=
      mul_nonneg (Real.sqrt_nonneg _) (by linarith [hM0])
    exact mul_le_mul hA0 hB0 (tsum_nonneg (fun i => (Real.exp_pos _).le)) hnnB
  have hprod1 : S1 s * S1 (3*s)
      <= (Real.sqrt (Real.pi / s) * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))))
        * (Real.sqrt (Real.pi / (3*s)) * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))) := by
    have hnnB : (0:ℝ) <= Real.sqrt (Real.pi / s)
        * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))) :=
      mul_nonneg (Real.sqrt_nonneg _) (by linarith [hM0])
    exact mul_le_mul hA1 hB1 hS13pos hnnB
  -- algebra: √(π/s)·√(π/3s) = π/(s√3)
  have hS0alg : (Real.sqrt (Real.pi / s) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
        * (Real.sqrt (Real.pi / (3*s)) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
      = (Real.pi / (s * Real.sqrt 3)) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2 := by
    have hmul := sqrt_prod_id s hs
    have h2 : (Real.sqrt (Real.pi / s) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
          * (Real.sqrt (Real.pi / (3*s)) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s)))))
        = (Real.sqrt (Real.pi / s) * Real.sqrt (Real.pi / (3*s)))
          * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2 := by
      ring
    rw [h2, hmul]
  have hS1alg : (Real.sqrt (Real.pi / s) * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))))
        * (Real.sqrt (Real.pi / (3*s)) * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))))
      = (Real.pi / (s * Real.sqrt 3)) * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))^2 := by
    have hmul := sqrt_prod_id s hs
    have h2 : (Real.sqrt (Real.pi / s) * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))))
          * (Real.sqrt (Real.pi / (3*s)) * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))))
        = (Real.sqrt (Real.pi / s) * Real.sqrt (Real.pi / (3*s)))
          * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))^2 := by
      ring
    rw [h2, hmul]
  -- montaż: Θ₂ = S₀·S₀ + S₁·S₁ ≤ π/(s√3)·[(1+M)² + (1+2M)²] ≤ 2π/(s√3)·(1+24e)
  rw [theta2_split s hs]
  have hsum : S0 s * S0 (3*s) + S1 s * S1 (3*s)
      <= (Real.pi / (s * Real.sqrt 3)) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
        + (Real.pi / (s * Real.sqrt 3))
          * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))^2 := by
    rw [← hS0alg, ← hS1alg]
    exact add_le_add hprod0 hprod1
  have hM2 : (4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
      <= 4 * Real.exp (-(Real.pi^2 / (3 * s))) := by nlinarith [hM0, hMle]
  have hpoly : (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
        + (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))^2
      <= 2 + 11 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))) := by
    nlinarith [hM0, hMle, hM2]
  have hKpos : (0:ℝ) <= Real.pi / (s * Real.sqrt 3) := by positivity
  have hmid : (Real.pi / (s * Real.sqrt 3)) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
        + (Real.pi / (s * Real.sqrt 3))
          * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))^2
      <= (Real.pi / (s * Real.sqrt 3))
        * (2 + 11 * (4 * Real.exp (-(Real.pi^2 / (3 * s))))) := by
    have hdist : (Real.pi / (s * Real.sqrt 3))
          * ((1 + 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
            + (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))^2)
        = (Real.pi / (s * Real.sqrt 3)) * (1 + 4 * Real.exp (-(Real.pi^2 / (3 * s))))^2
          + (Real.pi / (s * Real.sqrt 3))
            * (1 + 2 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))^2 := by
      ring
    rw [← hdist]
    exact mul_le_mul_of_nonneg_left hpoly hKpos
  have hfin : (Real.pi / (s * Real.sqrt 3))
        * (2 + 11 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))
      <= 2 * (Real.pi / (s * Real.sqrt 3))
        * (1 + 24 * Real.exp (-(Real.pi^2 / (3 * s)))) := by
    have h1 : (2 + 11 * (4 * Real.exp (-(Real.pi^2 / (3 * s)))))
        <= 2 * (1 + 24 * Real.exp (-(Real.pi^2 / (3 * s)))) := by
      nlinarith [hM0]
    have h2 := mul_le_mul_of_nonneg_left h1 hKpos
    have h3 : Real.pi / (s * Real.sqrt 3)
          * (2 * (1 + 24 * Real.exp (-(Real.pi^2 / (3 * s)))))
        = 2 * (Real.pi / (s * Real.sqrt 3))
          * (1 + 24 * Real.exp (-(Real.pi^2 / (3 * s)))) := by
      ring
    rw [h3] at h2
    exact h2
  exact le_trans hsum (le_trans hmid hfin)

end FT1536.ThetaFinal
