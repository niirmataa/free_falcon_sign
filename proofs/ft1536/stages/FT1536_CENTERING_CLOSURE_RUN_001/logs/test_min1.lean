import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Analysis.SpecificLimits.Normed

namespace Test
open Real

theorem two_le_exp_one : (2:ℝ) ≤ Real.exp 1 := by
  have h := Real.add_one_le_exp 1
  linarith

theorem exp_sq_summable_nat (c : ℝ) (hc : 1 ≤ c) :
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
  refine summable_of_ratio_norm_eventually_le (r := 1/2) (by norm_num) ?_
  filter_upwards with n
  have hnc : (1:ℝ) ≤ c * (2*(n:ℝ) + 1) := by
    have hc1 : (1:ℝ) ≤ (c:ℝ) := by exact_mod_cast hc
    have hn0 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
    have hn1 : (1:ℝ) ≤ 2*(n:ℝ) + 1 := by linarith
    nlinarith
  have hmono : Real.exp 1 ≤ Real.exp (c * (2*(n:ℝ) + 1)) :=
    (Real.exp_le_exp).2 hnc
  have hpos : 0 < Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) := Real.exp_pos _
  have hkey : 2 * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2)
      ≤ Real.exp (-(c:ℝ) * (n:ℝ)^2) := by
    rw [hsplit n]
    calc 2 * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2)
        ≤ Real.exp 1 * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) :=
            mul_le_mul_of_nonneg_right two_le_exp_one hpos.le
      _ = Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) * Real.exp 1 := by ring
      _ ≤ Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) * Real.exp (c * (2*(n:ℝ) + 1)) :=
            mul_le_mul_of_nonneg_left hmono hpos.le
  simp only [Real.norm_eq_abs, abs_of_nonneg (Real.exp_pos _).le,
    Nat.cast_add, Nat.cast_one]
  nlinarith [hkey]

end Test
