import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.Real.Pi.Bounds

example (e : ℝ) (he : 0 < e) (h : (2:ℝ) ≤ e) : e⁻¹ ≤ 1/2 := by
  have hprod : e * e⁻¹ = 1 := mul_inv_cancel (ne_of_gt he)
  nlinarith [h, he, hprod]

example (a b : ℝ) (ha : 0 < a) (h : a * b = 1) : a⁻¹ = b := by
  rw [inv_eq_one_div, div_eq_iff (ne_of_gt ha)]
  linarith [h]
