import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Topology.Algebra.InfiniteSum.Defs
open Real Filter
#check @Summable.tendsto_atTop_nhds_zero
#check @Summable.tendsto_zero
#check @tendsto_coe_nat_atTop_nhds
#check @tendsto_natCast_atTop_atTop
example (r : ℝ) (hr : 0 < r) (hr1 : r < 1) :
    Tendsto (fun n : ℕ => r^(n:ℕ)) atTop (𝓝 0) := by
  exact tendsto_pow_atTop_nhds_zero_of_lt_1 hr hr1
