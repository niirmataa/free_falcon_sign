import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Topology.Algebra.InfiniteSum.Group
import Mathlib.Analysis.SpecificLimits.Normed

#check @tsum_eq_zero_add'
#check @tsum_congr
#check @tsum_even_add_odd
#check @Nat.cast_injective
#check @Int.negSucc.inj
#check @tsum_int_eq_zero_add_two_mul_tsum_pnat

-- TEST A: zero + przesuniecie (kluczowe dla splitu)
example (f : ℕ → ℝ) (hs : Summable f) (hs1 : Summable fun n => f (n+1)) :
    ∑' n : ℕ, f n = f 0 + ∑' n : ℕ, f (n+1) :=
  tsum_eq_zero_add' hs1

-- TEST B: Int.rec punktowo = G dla even G (strona negSucc)
example (G : ℤ → ℝ) (hG : Function.Even G) (m : ℕ) :
    G (Int.negSucc m) = G (m+1) := by
  have h1 : (Int.negSucc m : ℤ) = -((m:ℤ) + 1) := by rfl
  rw [h1, hG]
  push_cast

-- TEST C: split Z dla even G przez tsum_int_rec + evenness
example (G : ℤ → ℝ) (hG : Function.Even G) (hs : Summable G) :
    ∑' n : ℤ, G n = (∑' n : ℕ, G n) + ∑' n : ℕ, G (n+1) := by
  have hrec : (fun n : ℤ => G n)
      = Int.rec (fun n : ℕ => G n) (fun m : ℕ => G (-(m+1))) := by
    funext n
