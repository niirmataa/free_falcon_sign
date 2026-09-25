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

-- dodajemy: exp_sq_even, exp_sq_summable (ℤ), thetaQ_ge_one
namespace Test
open Real

theorem exp_sq_even (c : ℝ) :
    Function.Even (fun n : ℤ => Real.exp (-c * (n:ℝ)^2)) := by
  intro n
  have h : ((-n : ℤ):ℝ)^2 = ((n:ℝ)^2) := by
    push_cast
    ring
  show Real.exp (-(c:ℝ) * ((-n:ℝ)^2)) = Real.exp (-(c:ℝ) * (n:ℝ)^2)
  rw [h]

theorem exp_sq_summable (c : ℝ) (hc : 1 ≤ c) :
    Summable (fun n : ℤ => Real.exp (-(c:ℝ) * (n:ℝ)^2)) := by
  rw [summable_int_iff_summable_nat_and_neg]
  have hn := exp_sq_summable_nat c hc
  constructor
  · exact hn
  · refine hn.congr (fun n => ?_)
    have h : (((-((n:ℕ):ℤ)):ℝ)^2) = (((n:ℕ):ℤ):ℝ)^2 := by
      push_cast
      ring
    rw [h]

noncomputable def thetaQ (c : ℝ) : ℝ := ∑' n : ℤ, Real.exp (-c * (n:ℝ)^2)

theorem thetaQ_ge_one (c : ℝ) (hc : 1 ≤ c) : 1 ≤ thetaQ c := by
  have h0 : Real.exp (-(c:ℝ) * ((0:ℝ)^2)) = 1 := by norm_num
  have h := Summable.le_tsum (exp_sq_summable c hc) 0
    (fun j _ => (Real.exp_pos _).le)
  rw [h0] at h
  exact h

end Test
