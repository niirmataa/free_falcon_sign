import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order

open Real
#check @Equiv.tsum_eq
#check @Equiv.pnatEquivNat
#check @Summable.hasSum_tsum
#check @tsum_int_eq_zero_add_two_mul_tsum_pnat
#check @Summable.le_tsum
#check @tsum_geometric_of_lt_one
