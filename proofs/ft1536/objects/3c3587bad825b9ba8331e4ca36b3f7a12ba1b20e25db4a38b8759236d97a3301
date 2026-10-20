import Mathlib.Analysis.SpecialFunctions.Gaussian.PoissonSummation
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Topology.Algebra.InfiniteSum.Group
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.Real.Pi.Bounds
import FT1536.Geometry
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

open Real FT1536.ThetaPoisson FT1536.Geometry

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
  have ho1 : Summable fun k : ℕ => G ((((2*k+1:ℕ)+1:ℕ):ℤ)) :=
    hsumShift.comp_injective ((add_left_injective 1).comp
      (mul_right_injective₀ (two_ne_zero' ℕ)))
  have hpar : ((∑' k : ℕ, G (((2*k+1:ℕ):ℤ)))
        + (∑' k : ℕ, G ((((2*k+1:ℕ)+1:ℕ):ℤ))))
      = ∑' n : ℕ, G (((n+1:ℕ):ℤ)) :=
    tsum_even_add_odd (f := fun n : ℕ => G (((n+1:ℕ):ℤ))) he1 ho1
  -- mostki do postaci kanonicznych
  have hb1 : (∑' k : ℕ, G (((2*k+1:ℕ):ℤ))) = ∑' k : ℕ, G (2 * ((k:ℕ):ℤ) + 1) :=
    tsum_congr (fun k => by norm_num)
  have hb2 : (∑' k : ℕ, G ((((2*k+1:ℕ)+1:ℕ):ℤ))) = ∑' k : ℕ, G (2 * (((k+1:ℕ):ℤ))) :=
    tsum_congr (fun k => by congr 1)
  have hz0 : G (2 * ((0:ℕ):ℤ)) = G ((0:ℕ):ℤ) := by
    norm_num
  -- równość atomowa — domyka linarith
  rw [hb1, hb2] at hpar
  have hC' : (∑' k : ℤ, G (2*k+1))
      = (∑' n : ℕ, G (2 * ((n:ℕ):ℤ) + 1))
        + (∑' n : ℕ, G (2 * ((n:ℕ):ℤ) + 1)) := hC
  linarith [hA, hB, hC', hz1, hz2, hpar, hz0]

/-! ## S₁ — theta na siatce półcałkowitej -/

noncomputable def S1 (u : ℝ) : ℝ := ∑' n : ℤ, Real.exp (-u * ((n:ℝ) + 1/2)^2)

theorem S1_eq (u : ℝ) (hu : 0 < u) : S1 u = S0 (u/4) - S0 u := by
  have hG : Function.Even (fun n : ℤ => Real.exp (-(u/4) * (n:ℝ)^2)) :=
    exp_sq_even_gen (u/4)
  have hs : Summable (fun n : ℤ => Real.exp (-(u/4) * (n:ℝ)^2)) :=
    exp_sq_summable_pos (u/4) (by positivity)
  have hsplit := tsum_int_even_odd
    (fun n : ℤ => Real.exp (-(u/4) * (n:ℝ)^2)) hG hs
  -- konwersje punktowe składników
  have hp1 : (∑' k : ℤ, Real.exp (-(u/4) * ((2*k:ℤ):ℝ)^2))
      = ∑' k : ℤ, Real.exp (-u * (k:ℝ)^2) :=
    tsum_congr (fun k => by
      congr 1
      push_cast
      field_simp
      ring)
  have hp2 : (∑' k : ℤ, Real.exp (-(u/4) * ((2*k+1:ℤ):ℝ)^2))
      = ∑' k : ℤ, Real.exp (-u * ((k:ℝ) + 1/2)^2) :=
    tsum_congr (fun k => by
      congr 1
      push_cast
      field_simp
      ring)
  rw [hp1, hp2] at hsplit
  -- hsplit : S0 (u/4) = S0 u + S1 u (definicyjnie)
  have hfin : S0 (u/4) = S0 u + S1 u := hsplit
  linarith [hfin]

/-! ## Θ₂ — theta A2 na ℤ² (postać iterowana) -/

noncomputable def Theta2 (s : ℝ) : ℝ :=
  ∑' j : ℤ, ∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))

/-- Wiersz parzysty: `block i (2k) = (i+k)² + 3k²`, przesunięcie i ↦ i+k. -/
theorem row_even (s : ℝ) (k : ℤ) :
    (∑' i : ℤ, Real.exp (-s * ((block i (2*k) : ℤ) : ℝ)))
      = Real.exp (-s * (3 * (k:ℝ)^2)) * S0 s := by
  have hsplit : ∀ i : ℤ, Real.exp (-s * ((block i (2*k) : ℤ) : ℝ))
      = Real.exp (-s * (((i + k:ℤ):ℝ)^2))
          * Real.exp (-s * (3 * ((k:ℤ):ℝ)^2)) := by
    intro i
    rw [show (block i (2*k) : ℝ)
        = (((i:ℤ)^2 + i * (2*k) + (2*k)^2 : ℤ) : ℝ) from rfl,
      show (((i:ℤ)^2 + i * (2*k) + (2*k)^2 : ℤ) : ℝ)
        = (((i + k:ℤ):ℝ)^2) + 3 * ((k:ℤ):ℝ)^2 by
        push_cast; ring]
    rw [mul_add, Real.exp_add]
  rw [tsum_congr hsplit, tsum_mul_right]
  have hreindex : (∑' i : ℤ, Real.exp (-s * (((i + k:ℤ):ℝ)^2))) = S0 s :=
    Equiv.tsum_eq (Equiv.addRight k)
      (fun i : ℤ => Real.exp (-s * ((i:ℤ):ℝ)^2))
  rw [hreindex]
  exact mul_comm _ _

/-- Wiersz nieparzysty: `block i (2k+1) = (i+k+½)² + 3(k+½)²`. -/
theorem row_odd (s : ℝ) (k : ℤ) :
    (∑' i : ℤ, Real.exp (-s * ((block i (2*k+1) : ℤ) : ℝ)))
      = Real.exp (-s * (3 * (((k:ℝ) + 1/2)^2))) * S1 s := by
  have hsplit : ∀ i : ℤ, Real.exp (-s * ((block i (2*k+1) : ℤ) : ℝ))
      = Real.exp (-s * (((i + k:ℤ):ℝ) + 1/2)^2)
          * Real.exp (-s * (3 * (((k:ℝ) + 1/2)^2))) := by
    intro i
    rw [show (block i (2*k+1) : ℝ)
        = (((i:ℤ)^2 + i * (2*k+1) + (2*k+1)^2 : ℤ) : ℝ) from rfl,
      show (((i:ℤ)^2 + i * (2*k+1) + (2*k+1)^2 : ℤ) : ℝ)
        = ((((i + k:ℤ):ℝ) + 1/2)^2) + 3 * (((k:ℝ) + 1/2)^2) by
        push_cast; ring]
    rw [mul_add, Real.exp_add]
  rw [tsum_congr hsplit, tsum_mul_right]
  have hreindex : (∑' i : ℤ, Real.exp (-s * (((i + k:ℤ):ℝ) + 1/2)^2)) = S1 s :=
    Equiv.tsum_eq (Equiv.addRight k)
      (fun i : ℤ => Real.exp (-s * (((i:ℤ):ℝ) + 1/2)^2))
  rw [hreindex]
  exact mul_comm _ _

/-- Wiersz jest funkcją parzystą: `block i (-j) = block (-i) j`. -/
theorem row_neg (s : ℝ) : Function.Even
    (fun j : ℤ => ∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) := by
  intro j
  show (∑' i : ℤ, Real.exp (-s * ((block i (-j) : ℤ) : ℝ)))
      = (∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ)))
  have h : ∀ i : ℤ, (block i (-j) : ℝ) = ((block (-i) j : ℤ) : ℝ) := by
    intro i
    show (((i:ℤ)^2 + i * (-j) + (-j)^2 : ℤ) : ℝ)
        = ((((-i:ℤ)^2 + (-i) * j + j^2 : ℤ)) : ℝ)
    push_cast
    ring
  have hfun : (fun i : ℤ => Real.exp (-s * ((block i (-j) : ℤ) : ℝ)))
      = fun i : ℤ => Real.exp (-s * ((block (-i) j : ℤ) : ℝ)) := by
    funext i
    rw [h]
  rw [hfun]
  exact Equiv.tsum_eq
    (⟨fun i => -i, fun i => -i, fun _ => by ring, fun _ => by ring⟩ : ℤ ≃ ℤ)
    (fun i : ℤ => Real.exp (-s * ((block i j : ℤ) : ℝ)))

/-- Sumowalność wierszy: `block i j ≥ (i²+j²)/2`, więc rozkład gaussowski dominuje. -/
theorem row_summable (s : ℝ) (hs : 0 < s) :
    Summable (fun j : ℤ => ∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))) := by
  have hblock2 : ∀ i j : ℤ,
      (((i:ℝ)^2 + (j:ℝ)^2) / 2) ≤ ((block i j : ℤ) : ℝ) := by
    intro i j
    show (((i:ℝ)^2 + (j:ℝ)^2) / 2) ≤ (((i:ℤ)^2 + i * j + j^2 : ℤ) : ℝ)
    push_cast
    nlinarith [sq_nonneg ((i:ℝ) + (j:ℝ)), sq_nonneg (j:ℝ)]
  have hmaj : ∀ i j : ℤ,
      Real.exp (-s * ((block i j : ℤ) : ℝ))
        ≤ Real.exp (-(s/2) * ((i:ℤ):ℝ)^2) * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
    intro i j
    have h1 : -s * ((block i j : ℤ) : ℝ)
        ≤ -(s/2) * (((i:ℤ):ℝ)^2 + ((j:ℤ):ℝ)^2) := by
      have hsmul : s * ((((i:ℤ):ℝ)^2 + ((j:ℤ):ℝ)^2) / 2)
          ≤ s * ((block i j : ℤ) : ℝ) :=
        mul_le_mul_of_nonneg_left (hblock2 i j) (le_of_lt hs)
      nlinarith [hsmul]
    have h2 := (Real.exp_le_exp).2 h1
    rw [mul_add, Real.exp_add] at h2
    exact h2
  have hrow : ∀ j : ℤ, Summable (fun i : ℤ => Real.exp (-s * ((block i j : ℤ) : ℝ))) := by
    intro j
    refine Summable.of_nonneg_of_le
      (fun i => (Real.exp_pos _).le) (fun i => hmaj i j) ?_
    exact Summable.mul_right (Real.exp (-(s/2) * ((j:ℤ):ℝ)^2))
      (exp_sq_summable_pos (s/2) (by positivity))
  have hrowle : ∀ j : ℤ,
      (∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ)))
        ≤ (∑' i : ℤ, Real.exp (-(s/2) * ((i:ℤ):ℝ)^2))
            * Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) := by
    intro j
    have h1 := Summable.tsum_le_tsum (fun i => hmaj i j) (hrow j)
      (Summable.mul_right (Real.exp (-(s/2) * ((j:ℤ):ℝ)^2))
        (exp_sq_summable_pos (s/2) (by positivity)))
    rw [tsum_mul_right] at h1
    exact h1
  have hbase : Summable fun j : ℤ => Real.exp (-(s/2) * ((j:ℤ):ℝ)^2) :=
    exp_sq_summable_pos (s/2) (by positivity)
  refine Summable.of_nonneg_of_le
    (fun j => tsum_nonneg (fun i => (Real.exp_pos _).le)) (fun j => hrowle j) ?_
  rw [show (∑' i : ℤ, Real.exp (-(s/2) * ((i:ℤ):ℝ)^2)) = S0 (s/2) from rfl]
  exact Summable.mul_left (S0 (s/2)) hbase

/-- Główny rozkład Fazy B: Θ₂(s) = S₀(s)·S₀(3s) + S₁(s)·S₁(3s). -/
theorem theta2_split (s : ℝ) (hs : 0 < s) :
    Theta2 s = S0 s * S0 (3*s) + S1 s * S1 (3*s) := by
  show (∑' j : ℤ, ∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ)))
      = S0 s * S0 (3*s) + S1 s * S1 (3*s)
  have hsplit := tsum_int_even_odd
    (fun j : ℤ => ∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ)))
    (row_neg s) (row_summable s hs)
  calc ∑' j : ℤ, ∑' i : ℤ, Real.exp (-s * ((block i j : ℤ) : ℝ))
      = (∑' k : ℤ, ∑' i : ℤ, Real.exp (-s * ((block i (2*k) : ℤ) : ℝ)))
        + (∑' k : ℤ, ∑' i : ℤ, Real.exp (-s * ((block i (2*k+1) : ℤ) : ℝ))) := hsplit
    _ = S0 s * S0 (3*s) + S1 s * S1 (3*s) := by
      rw [tsum_congr (fun k => row_even s k), tsum_mul_right,
        tsum_congr (fun k => row_odd s k), tsum_mul_right,
        show (∑' k : ℤ, Real.exp (-s * (3 * (k:ℝ)^2))) = S0 (3*s) from
          tsum_congr (fun k => by congr 1; ring),
        show (∑' k : ℤ, Real.exp (-s * (3 * (((k:ℝ) + 1/2)^2)))) = S1 (3*s) from
          tsum_congr (fun k => by congr 1; ring)]
      ring

end FT1536.Theta2Split
