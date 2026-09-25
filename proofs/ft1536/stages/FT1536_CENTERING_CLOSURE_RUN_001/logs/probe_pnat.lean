import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order

-- czy istnieje gotowy lemat: ∑' n:ℕ+, f n = ∑' k:ℕ, f (k+1)?
#check @tsum_pnat_eq_tsum_nat_succ
#check @tsum_int_eq_zero_add_two_mul_tsum_pnat
-- czy pnatEquivNat.symm k redukuje się do k+1 definicjonalnie?
example (k : ℕ) : ((Equiv.pnatEquivNat.symm k : ℕ+) : ℕ) = k + 1 := by rfl
