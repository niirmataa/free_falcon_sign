import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.Real.Pi.Bounds

-- czy 2•x = x+x dla ℝ w kontekście AddCommGroup?
example (x : ℝ) : (2:ℕ) • x = x + x := by
  norm_num [two_nsmul]
  ring

-- czy e⁻¹ ≤ 1/2 z 2 ≤ e przez nlinarith?
example (e : ℝ) (he : 0 < e) (h : (2:ℝ) ≤ e) : e⁻¹ ≤ 1/2 := by
  have hprod : e * e⁻¹ = 1 := mul_inv_cancel he.ne'
  nlinarith [h, he, hprod]

-- inv_eq_of_mul_eq_one alternatywa:
example (a b : ℝ) (ha : 0 < a) (h : a * b = 1) : a⁻¹ = b := by
  rw [inv_eq_one_div, div_eq_iff ha]
  linarith [h]
