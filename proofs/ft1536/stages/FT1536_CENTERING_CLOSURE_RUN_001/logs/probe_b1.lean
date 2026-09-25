import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Topology.Algebra.InfiniteSum.Group
import Mathlib.Analysis.SpecificLimits.Normed

-- inwentarz glue do Fazy B
#check @tsum_int_rec
#check @tsum_even_add_odd
#check @tsum_nat_add_neg
#check @tsum_pnat_eq_tsum_succ
#check @HasSum.comp_injective
#check @Summable.comp_injective
#check @tsum_mul_left
#check @tsum_mul_right
#check @Equiv.addRight
#check @tsum_prod
#check @Summable.prod
#check @HasSum.add_isCompl

-- TEST 1: tsum_int_rec — split Z na nieujemne + ujemne
example (f g : ℕ → ℝ) (hf : Summable f) (hg : Summable g) :
    ∑' n : ℤ, Int.rec f g n = (∑' n : ℕ, f n) + ∑' n : ℕ, g n :=
  tsum_int_rec hf hg

-- TEST 2: even G na Z — rozklad przez tsum_int_rec
example (G : ℤ → ℝ) (hG : Function.Even G) (hs : Summable G) :
    ∑' n : ℤ, G n = (∑' n : ℕ, G n) + ∑' n : ℕ, G (-(n+1)) := by
  have hrec : (fun n : ℤ => G n) = (Int.rec (fun n : ℕ => G n) (fun m : ℕ => G (-(m+1)))) := by
    funext n
    rcases Int.natCast_or_negSucc n with h | h
    · rw [h]; rfl
    · rcases h with ⟨m, rfl⟩; rfl
  rw [hrec]
  exact tsum_int_rec (by exact hs.comp_injective Int.natCast_injective)
    (by exact hs.comp_injective (neg_injective.comp Int.negSucc_injective))
