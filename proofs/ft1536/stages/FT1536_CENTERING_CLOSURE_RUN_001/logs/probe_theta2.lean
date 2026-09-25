import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.Real.Pi.Bounds

#check @inv_mul_cancel₀
#check @Real.exp_mul
#check @Real.rpow_natCast
#check @Real.exp_lt_exp
#check @Summable.mul_left
#check @tsum_mul_left
#check @pow_succ

-- TEST 1: hexpc z inv_mul_cancel₀ (GroupWithZero!)
example (e : ℝ) (he : 0 < e) (h2e : (2:ℝ) ≤ e) : e⁻¹ ≤ 1/2 := by
  have hp : 0 ≤ e⁻¹ := by positivity
  have hprod : e⁻¹ * e = 1 := inv_mul_cancel₀ (ne_of_gt he)
  have hle : e⁻¹ * 2 ≤ e⁻¹ * e := mul_le_mul_of_nonneg_left h2e hp
  rw [hprod] at hle
  rw [le_div_iff₀ (by norm_num : (0:ℝ) < 2)]
  nlinarith

-- TEST 2: show-defeq z jawnymi castami + push_cast
example (k : ℕ) (c : ℝ) :
    Real.exp (-(c:ℝ) * (((((Equiv.pnatEquivNat.symm k : ℕ+) : ℕ) : ℤ) : ℝ)^2))
      = Real.exp (-(c:ℝ) * ((k:ℝ) + 1)^2) := by
  show Real.exp (-(c:ℝ) * (Int.cast (Nat.cast (k + 1)))^2)
     = Real.exp (-(c:ℝ) * ((k:ℝ) + 1)^2)
  push_cast
  first | rfl | (congr 1; ring)

-- TEST 3: thetaQ_ge_one fix — h0 z castem ↑0
example (c : ℝ) (hc : 1 ≤ c) (f : ℤ → ℝ) (hf : Summable f)
    (hpos : ∀ j, 0 ≤ f j) (h0f : f 0 = 1) : (1:ℝ) ≤ ∑' n : ℤ, f n := by
  have h := Summable.le_tsum hf 0 (fun j _ => hpos j)
  rw [h0f] at h
  exact h
