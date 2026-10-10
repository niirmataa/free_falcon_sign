import BitTapes016
import Mathlib.Data.Nat.Periodic
import Mathlib.Order.Interval.Finset.Nat

namespace FT1536.S05.ModuloCounts017
open Finset

def intervalMod (S a b k : ℕ) : Prop := a≤k%S ∧ k%S<b
instance (S a b : ℕ) : DecidablePred (intervalMod S a b) := fun k =>
  inferInstanceAs (Decidable (a≤k%S ∧ k%S<b))

theorem count_congr (p q : ℕ → Prop) [DecidablePred p] [DecidablePred q]
    (n : ℕ) (h : ∀ k,k<n → (p k↔q k)) : Nat.count p n=Nat.count q n :=
  le_antisymm (Nat.count_mono_left (fun k hk => (h k hk).1))
    (Nat.count_mono_left (fun k hk => (h k hk).2))

theorem short_count (S a b n : ℕ) (hn : n≤S) :
    Nat.count (intervalMod S a b) n=min (b-a) (n-a) := by
  rw [Nat.count_eq_card_filter_range]
  have he : (range n).filter (intervalMod S a b)=Ico a (min b n) := by
    ext k
    simp only [mem_filter,mem_range,mem_Ico,lt_min_iff]
    constructor
    · rintro ⟨hk,hk'⟩
      have hm : k%S=k := Nat.mod_eq_of_lt (hk.trans_le hn)
      change a≤k%S ∧ k%S<b at hk'
      rw [hm] at hk'
      exact ⟨hk'.1,hk'.2,hk⟩
    · rintro ⟨ha,hb,hk⟩
      refine ⟨hk,?_⟩
      change a≤k%S ∧ k%S<b
      rw [Nat.mod_eq_of_lt (hk.trans_le hn)]
      exact ⟨ha,hb⟩
  rw [he,Nat.card_Ico]
  omega

theorem full_block_count (S a b q : ℕ) :
    Nat.count (intervalMod S a b) (q*S)=q*Nat.count (intervalMod S a b) S := by
  induction q with
  | zero => simp
  | succ q ih =>
    have he : (q+1)*S=q*S+S := by ring
    rw [he,Nat.count_add,ih]
    have hh : Nat.count (fun k => intervalMod S a b (q*S+k)) S=
        Nat.count (intervalMod S a b) S := by
      apply count_congr
      intro k _
      simp only [intervalMod,Nat.add_mod,Nat.mul_mod,Nat.mod_self,mul_zero,Nat.zero_mod,zero_add,Nat.mod_mod]
    rw [hh]
    ring

theorem interval_mod_count (N S a b : ℕ) (hS : 0<S) (hb : b≤S) :
    Nat.count (intervalMod S a b) N=(N/S)*(b-a)+min (b-a) (N%S-a) := by
  have he : N=(N/S)*S+N%S := by
    rw [Nat.mul_comm (N/S) S]
    exact (Nat.div_add_mod N S).symm
  conv_lhs => rw [he]
  rw [Nat.count_add,full_block_count,short_count S a b S le_rfl]
  have hs : min (b-a) (S-a)=b-a := by omega
  rw [hs]
  have hh : Nat.count (fun k => intervalMod S a b ((N/S)*S+k)) (N%S)=
      Nat.count (intervalMod S a b) (N%S) := by
    apply count_congr
    intro k _
    simp only [intervalMod,Nat.add_mod,Nat.mul_mod,Nat.mod_self,mul_zero,Nat.zero_mod,zero_add,Nat.mod_mod]
  rw [hh,short_count S a b (N%S) (Nat.mod_lt N hS).le]

/-- Exact quotient/remainder bias; no uniformly distributed residue is assumed. -/
theorem interval_count_bounds (N S a b : ℕ) (hS : 0<S) (hb : b≤S) :
    (N/S)*(b-a)≤Nat.count (intervalMod S a b) N ∧
    Nat.count (intervalMod S a b) N≤(N/S+1)*(b-a) := by
  rw [interval_mod_count N S a b hS hb]
  have hm : min (b-a) (N%S-a)≤b-a := min_le_left _ _
  constructor
  · omega
  · rw [add_mul,one_mul]
    omega

#print axioms count_congr
#print axioms short_count
#print axioms full_block_count
#print axioms interval_mod_count
#print axioms interval_count_bounds
end FT1536.S05.ModuloCounts017
