import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt

open Real

#check @Real.tsum_exp_neg_mul_int_sq
#check @tsum_int_eq_zero_add_two_mul_tsum_pnat
#check @summable_int_iff_summable_nat_and_neg
#check @tsum_geometric_of_lt_one
#check @Real.sqrt_eq_rpow
-- kandydaci na le_tsum/tsum_le_tsum dla ℝ:
#check @tsum_le_tsum
#check @le_tsum
-- reindex Equiv:
#check @Equiv.tsum_eq
#check @Equiv.hasSum_iff
#check @HasSum.tsum
-- summability exp(-c*n^2):
example (c : ℝ) (hc : 0 < c) : Summable (fun n : ℤ => Real.exp (-c * (n:ℝ)^2)) := by
  positivity
