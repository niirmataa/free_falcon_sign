import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Analysis.SpecificLimits.Normed

open Real

-- TEST: sumowalnosc dla 0 < c (male c!) — ratio r = exp(-c)
theorem exp_sq_summable_nat_pos (c : ℝ) (hc : 0 < c) :
    Summable (fun n : ℕ => Real.exp (-(c:ℝ) * (n:ℝ)^2)) := by
  have hsplit : ∀ n : ℕ,
      Real.exp (-(c:ℝ) * (n:ℝ)^2)
        = Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2)
          * Real.exp (c * (2 * (n:ℝ) + 1)) := by
    intro n
    rw [← Real.exp_add]
    congr 1
    have hexp : ((n:ℝ) + 1)^2 = (n:ℝ)^2 + 2*(n:ℝ) + 1 := by ring
    rw [hexp]
    ring
  refine summable_of_ratio_norm_eventually_le (r := Real.exp (-(c:ℝ)))
    (by
      have h1 : Real.exp (-(c:ℝ)) < Real.exp 0 := (Real.exp_lt_exp).2 (by linarith)
      rw [Real.exp_zero] at h1
      exact h1) ?_
  filter_upwards with n
  have hpos : 0 < Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) := Real.exp_pos _
  have hmono : Real.exp (-(c:ℝ)) ≤ Real.exp (-(c:ℝ) * (2*(n:ℝ) + 1)) := by
    have h2 : (c:ℝ) * (2*(n:ℝ) + 1) ≥ c := by
      have := Nat.cast_nonneg (n:ℕ)
      nlinarith
    have := (Real.exp_le_exp).2 (neg_le_neg h2)
    exact this
  have hkey : Real.exp (-(c:ℝ)) * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2)
      ≤ Real.exp (-(c:ℝ) * (n:ℝ)^2) := by
    rw [hsplit n, ← Real.exp_add]
    congr 1
    have hexp : ((n:ℝ) + 1)^2 = (n:ℝ)^2 + 2*(n:ℝ) + 1 := by ring
    rw [hexp]
    have h3 : -(c:ℝ) * (2*(n:ℝ) + 1) + c * (2*(n:ℝ) + 1) = 0 := by ring
    nlinarith
  simp only [Real.norm_eq_abs, abs_of_nonneg (Real.exp_pos _).le,
    Nat.cast_add, Nat.cast_one]
  nlinarith [hkey]
