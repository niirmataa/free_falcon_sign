import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Topology.Algebra.InfiniteSum.Group
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.Real.Pi.Bounds
import ThetaPoisson

/-!
# Theta2Split — Faza B: rozkład Θ₂ = S₀(s)·S₀(3s) + S₁(s)·S₁(3s)

* `S1 u = ∑' n:ℤ, exp(-u·(n+1/2)²)` — theta na siatce półcałkowitej.
* `S1_eq : S1 u = S₀(u/4) - S₀(u)` — tożsamość podwojenia.
* `tsum_int_even_odd` — split parzystości dla funkcji parzystych na ℤ
  (przez `tsum_int_rec` + `tsum_even_add_odd` z Mathliba).
* Sumowalność uogólniona do `0 < c` (Faza A miała `1 ≤ c`; parametry
  `sStar ≈ 7.3e-7`, `c0 ≈ 8.5e-7` wymagają małych c).
-/

namespace FT1536.Theta2Split

open Real FT1536.ThetaPoisson

/-! ## Sumowalność dla 0 < c -/

theorem exp_sq_summable_nat_pos (c : ℝ) (hc : 0 < c) :
    Summable (fun n : ℕ => Real.exp (-(c:ℝ) * (n:ℝ)^2)) := by
  refine summable_of_ratio_norm_eventually_le (r := Real.exp (-(c:ℝ)))
    (by
      have h1 : Real.exp (-(c:ℝ)) < Real.exp 0 := (Real.exp_lt_exp).2 (by linarith)
      rwa [Real.exp_zero] at h1) ?_
  filter_upwards with n
  simp only [Real.norm_eq_abs, abs_of_nonneg (Real.exp_pos _).le,
    Nat.cast_add, Nat.cast_one]
  rw [← Real.exp_add]
  exact (Real.exp_le_exp).2 (by
    have hn : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
    nlinarith [hc, hn])

theorem exp_sq_even_gen (c : ℝ) :
    Function.Even (fun n : ℤ => Real.exp (-c * (n:ℝ)^2)) := by
  intro n
  show Real.exp (-(c:ℝ) * (((-n : ℤ) : ℝ)^2)) = Real.exp (-(c:ℝ) * ((n:ℝ)^2))
  push_cast
  congr 1
  ring

theorem exp_sq_summable_pos (c : ℝ) (hc : 0 < c) :
    Summable (fun n : ℤ => Real.exp (-(c:ℝ) * (n:ℝ)^2)) := by
  rw [summable_int_iff_summable_nat_and_neg]
  have hn := exp_sq_summable_nat_pos c hc
  refine ⟨hn, hn.congr (fun n => ?_)⟩
  push_cast
  congr 1
  ring

/-! ## Split ℤ na część nieujemną i ujemną -/

theorem tsum_int_rec' (F : ℤ → ℝ) (hs : Summable F) :
    ∑' n : ℤ, F n = (∑' n : ℕ, F (n:ℤ)) + ∑' m : ℕ, F (Int.negSucc m) := by
  have hsumNat : Summable fun n : ℕ => F (n:ℤ) :=
    hs.comp_injective Nat.cast_injective
  have hsumNeg : Summable fun m : ℕ => F (Int.negSucc m) :=
    hs.comp_injective (@Int.negSucc.inj)
  have hrec : (fun n : ℤ => F n)
      = Int.rec (fun n : ℕ => F (n:ℤ)) (fun m : ℕ => F (Int.negSucc m)) := by
    funext n
    cases n with
    | ofNat a => rfl
    | negSucc b => rfl
  rw [hrec]
  exact tsum_int_rec hsumNat hsumNeg

/-! ## Split parzystości dla funkcji parzystych na ℤ -/

theorem tsum_int_even_odd (G : ℤ → ℝ) (hG : Function.Even G) (hs : Summable G) :
    ∑' n : ℤ, G n = (∑' k : ℤ, G (2*k)) + (∑' k : ℤ, G (2*k+1)) := by
  -- strona negSucc przez parzystość — postacie pośrednie ↑m+1
  have hnegG' : ∀ m : ℕ, G (Int.negSucc m) = G ((m:ℤ) + 1) := by
    intro m
    have h1 : (Int.negSucc m : ℤ) = -((m:ℤ) + 1) := by rfl
    rw [h1, hG]
  have hnegG2' : ∀ m : ℕ, G (2 * (Int.negSucc m)) = G (2 * (((m+1:ℕ):ℤ))) := by
    intro m
    have h1 : (Int.negSucc m : ℤ) = -((m:ℤ) + 1) := by rfl
    rw [h1, show (2:ℤ) * (-((m:ℤ) + 1)) = -((2:ℤ) * (((m+1:ℕ):ℤ))) by
      push_cast; ring, hG]
  have hnegG3' : ∀ m : ℕ, G (2 * (Int.negSucc m) + 1) = G (2 * (m:ℤ) + 1) := by
    intro m
    have h1 : (Int.negSucc m : ℤ) = -((m:ℤ) + 1) := by rfl
    rw [h1, show (2:ℤ) * (-((m:ℤ) + 1)) + 1 = -((2:ℤ) * (m:ℤ) + 1) by ring, hG]
  -- sumowalności restrykcji
  have hsumNat : Summable fun n : ℕ => G ((n:ℕ):ℤ) :=
    hs.comp_injective Nat.cast_injective
  have hs2 : Summable fun k : ℤ => G (2*k) :=
    hs.comp_injective (mul_right_injective₀ (two_ne_zero' ℤ))
  have hs3 : Summable fun k : ℤ => G (2*k+1) :=
    hs.comp_injective ((add_left_injective 1).comp
      (mul_right_injective₀ (two_ne_zero' ℤ)))
  have hsumNat2 : Summable fun n : ℕ => G (2 * ((n:ℕ):ℤ)) :=
    hs2.comp_injective Nat.cast_injective
  -- splity przez rec
  have hA := tsum_int_rec' G hs
  have hB := tsum_int_rec' (fun k : ℤ => G (2*k)) hs2
  have hC := tsum_int_rec' (fun k : ℤ => G (2*k+1)) hs3
  rw [show (fun m : ℕ => G (Int.negSucc m))
      = (fun m : ℕ => G (((m+1:ℕ):ℤ))) from
      (funext hnegG').trans (funext (fun m => rfl))] at hA
  rw [show (fun m : ℕ => G (2 * (Int.negSucc m)))
      = (fun m : ℕ => G (2 * (((m+1:ℕ):ℤ)))) from funext hnegG2'] at hB
  rw [show (fun m : ℕ => G (2 * (Int.negSucc m) + 1))
      = (fun m : ℕ => G (2 * (((m:ℕ):ℤ)) + 1)) from funext hnegG3'] at hC
  -- zero + przesunięcie
  have hz1 : (∑' n : ℕ, G ((n:ℕ):ℤ))
      = G ((0:ℕ):ℤ) + ∑' n : ℕ, G (((n+1:ℕ):ℤ)) :=
    tsum_eq_zero_add' ((summable_nat_add_iff 1).mpr hsumNat)
  have hz2 : (∑' n : ℕ, G (2 * ((n:ℕ):ℤ)))
      = G (2 * ((0:ℕ):ℤ)) + ∑' n : ℕ, G (2 * (((n+1:ℕ):ℤ))) :=
    tsum_eq_zero_add' ((summable_nat_add_iff 1).mpr hsumNat2)
  -- parzystość ℕ dla przesuniętej
  have hsumShift : Summable fun n : ℕ => G (((n+1:ℕ):ℤ)) :=
    (summable_nat_add_iff 1).mpr hsumNat
  have he1 : Summable fun k : ℕ => G (((2*k+1:ℕ):ℤ)) :=
    hsumShift.comp_injective (mul_right_injective₀ (two_ne_zero' ℕ))
  have ho1 : Summable fun k : ℕ => G (((2*k+2:ℕ):ℤ)) :=
    hsumShift.comp_injective ((add_left_injective 1).comp
      (mul_right_injective₀ (two_ne_zero' ℕ)))
  have hpar : (∑' k : ℕ, G (((2*k+1:ℕ):ℤ)))
