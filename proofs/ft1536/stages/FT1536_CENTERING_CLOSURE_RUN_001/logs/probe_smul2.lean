import Mathlib.Topology.Algebra.InfiniteSum.Ring
-- co daje tsum_int_eq_zero_add_two_mul_tsum_pnat dokładnie?
#check @tsum_int_eq_zero_add_two_mul_tsum_pnat
-- czy 2•x = x+x?
example (x : ℝ) : (2:ℕ) • x = x + x := rfl
-- czy e⁻¹ ≤ 1/2 z 2 ≤ e?
example (e : ℝ) (he : 0 < e) (h : (2:ℝ) ≤ e) : e⁻¹ ≤ 1/2 := by
  have hprod : e * e⁻¹ = 1 := mul_inv_cancel he.ne'
  nlinarith [h, he, hprod]
