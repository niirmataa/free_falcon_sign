import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.Real.Pi.Bounds

-- sygnatury do thetaQ_le
#check @summable_geometric_of_lt_one
#check @tsum_geometric_of_lt_one
#check @Real.exp_lt_one
#check @Equiv.tsum_eq
#check @two_nsmul
#check @le_div_iff₀
#check @Real.exp_neg
#check @Summable.tsum_le_tsum

-- TEST 1: hexpc technika (inv_mul_cancel z jawnym argumentem)
example (e : ℝ) (he : 0 < e) (h2e : (2:ℝ) ≤ e) : e⁻¹ ≤ 1/2 := by
  have hp : 0 ≤ e⁻¹ := by positivity
  have hprod : e⁻¹ * e = 1 := inv_mul_cancel e
  have hle : e⁻¹ * 2 ≤ e⁻¹ * e := mul_le_mul_of_nonneg_left h2e hp
  rw [hprod] at hle
  rw [le_div_iff₀ (by norm_num : (0:ℝ) < 2)]
  nlinarith

-- TEST 2: show-defeq przeskakuje pnatEquivNat.symm k → k+1, potem push_cast
example (k : ℕ) (c : ℝ) :
    Real.exp (-(c:ℝ) * (((((((Equiv.pnatEquivNat.symm k : ℕ+) : ℕ) : ℤ) : ℝ)^2)))
      = Real.exp (-(c:ℝ) * ((k:ℝ) + 1)^2) := by
  show Real.exp (-(c:ℝ) * (((((k + 1 : ℕ) : ℤ) : ℝ)^2)))
     = Real.exp (-(c:ℝ) * ((k:ℝ) + 1)^2)
  push_cast
  first | rfl | (congr 1; ring)

-- TEST 3: thetaQ_ge_one fix — push_cast at h normalizuje ↑0
example (c : ℝ) (hc : 1 ≤ c) : (1:ℝ) ≤ ∑' n : ℤ, Real.exp (-(c:ℝ) * (n:ℝ)^2) := by
  have h0 : Real.exp (-(c:ℝ) * 0^2) = 1 := by norm_num
  have h := Summable.le_tsum (f := fun n : ℤ => Real.exp (-(c:ℝ) * (n:ℝ)^2))
    (by
      rw [summable_int_iff_summable_nat_and_neg]
      have hn : Summable fun n : ℕ => Real.exp (-(c:ℝ) * (n:ℝ)^2) := by
        refine summable_of_ratio_norm_eventually_le (r := 1/2) (by norm_num) ?_
        filter_upwards with n
        simp only [Real.norm_eq_abs, abs_of_nonneg (Real.exp_pos _).le,
          Nat.cast_add, Nat.cast_one]
        have hpos : 0 < Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) := Real.exp_pos _
        have hkey : 2 * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) ≤ Real.exp (-(c:ℝ) * (n:ℝ)^2) := by
          have h3 : (1:ℝ) ≤ c * (2*(n:ℝ) + 1) := by
            have := Nat.cast_nonneg (n:ℕ)
            have := le_of_lt (Real.exp_pos ((c:ℝ) * (2*(n:ℝ) + 1)))
            exact_mod_cast hc
            nlinarith
          have h4 : Real.exp 1 ≤ Real.exp (c * (2*(n:ℝ) + 1)) := (Real.exp_le_exp).2 h3
          rw [show Real.exp (-(c:ℝ) * (n:ℝ)^2) = Real.exp (-(c:ℝ) * ((n:ℝ)+1)^2) * Real.exp (c * (2*(n:ℝ)+1)) by
            rw [← Real.exp_add]; congr 1; have : ((n:ℝ)+1)^2 = (n:ℝ)^2 + 2*(n:ℝ) + 1 := by ring
            rw [this]; ring]
          calc 2 * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2)
              ≤ Real.exp 1 * Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) := by
                exact mul_le_mul_of_nonneg_right (by
                  have := Real.add_one_le_exp 1; linarith) (Real.exp_pos _).le
            _ = Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) * Real.exp 1 := by ring
            _ ≤ Real.exp (-(c:ℝ) * ((n:ℝ) + 1)^2) * Real.exp (c * (2*(n:ℝ) + 1)) :=
              mul_le_mul_of_nonneg_left h4 (Real.exp_pos _).le
        nlinarith [hkey])
    0 (fun j _ => (Real.exp_pos _).le)
  push_cast at h
  rw [h0] at h
  exact h
