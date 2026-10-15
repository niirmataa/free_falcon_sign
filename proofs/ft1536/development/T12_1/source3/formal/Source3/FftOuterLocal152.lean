import Source3.VectorRegion152
import Source3.FftGroupValues152

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterLocal152

def halfIndex {n : Nat} (hn : Nat) (i : Fin n) : Nat := if i.val<hn then i.val else i.val-hn
def owner {n : Nat} (hn t : Nat) (i : Fin n) : Nat := halfIndex hn i/t

theorem folded_slot (n hn ht v : Nat) (length : 2*hn≤n) (inside : v+ht<hn) (j : Fin 4) :
    halfIndex hn (FftLoopIndices141.slots n hn ht v inside length j)=if j.val<2 then v else v+ht := by
  fin_cases j
  all_goals dsimp only [halfIndex,FftLoopIndices141.slots]
  all_goals split_ifs <;> omega

theorem slot_owner (n hn ht t k v : Nat) (length : 2*hn≤n) (half : t=ht+ht)
    (span : k*t+ht+ht≤hn) (lower : k*t≤v) (upper : v<k*t+ht) (j : Fin 4) :
    owner hn t (FftLoopIndices141.slots n hn ht v (by omega) length j)=k := by
  have quotient0 : v/t=k := Nat.div_eq_of_lt_le lower (by rw [Nat.add_mul,Nat.one_mul]; omega)
  have quotient1 : (v+ht)/t=k := Nat.div_eq_of_lt_le (by omega) (by rw [Nat.add_mul,Nat.one_mul]; omega)
  unfold owner
  rw [folded_slot]
  split_ifs <;> assumption

theorem step_outside (n hn ht t k : Nat) (length : 2*hn≤n) (half : t=ht+ht) (sr si : BitVec 64)
    (span : k*t+ht+ht≤hn) (v : Nat) (lower : k*t≤v) (upper : v<k*t+ht)
    (input : Fin n → BitVec 64) (i : Fin n) (different : owner hn t i≠k) :
    FftLoopStep141.advance n hn ht v length sr si input i=input i := by
  have inside : v+ht<hn := by omega
  rw [FftLoopStep141.advance,dite_eq_left inside]
  apply FftButterflyLocal152.outside input _ sr si i
  intro j same
  exact different (same ▸ slot_owner n hn ht t k v length half span lower upper j)

theorem step_locality (n hn ht t k : Nat) (length : 2*hn≤n) (half : t=ht+ht) (sr si : BitVec 64)
    (span : k*t+ht+ht≤hn) (v : Nat) (lower : k*t≤v) (upper : v<k*t+ht)
    (input other : Fin n → BitVec 64) (agree : ∀ i, owner hn t i=k → input i=other i)
    (i : Fin n) (owned : owner hn t i=k) :
    FftLoopStep141.advance n hn ht v length sr si input i=FftLoopStep141.advance n hn ht v length sr si other i := by
  have inside : v+ht<hn := by omega
  rw [FftLoopStep141.advance,dite_eq_left inside,FftLoopStep141.advance,dite_eq_left inside]
  exact FftButterflyLocal152.locality input other _ sr si i
    (fun j => agree _ (slot_owner n hn ht t k v length half span lower upper j)) (agree i owned)

theorem outside (n hn ht t m k : Nat) (length : 2*hn≤n) (half : t=ht+ht) (span : k*t+ht+ht≤hn)
    (input : Fin n → BitVec 64) (i : Fin n) (different : owner hn t i≠k) :
    FftGroupSource143.values n hn ht length m k (k*t) input i=input i := by
  unfold FftGroupSource143.values
  rw [FftGroupValues152.recurrence]
  exact VectorRegion152.outside (fun i => owner hn t i=k) _ (k*t) (k*t+ht)
    (step_outside n hn ht t k length half _ _ span) ht (k*t) input (Nat.le_refl _) (Nat.le_refl _) i different

theorem locality (n hn ht t m k : Nat) (length : 2*hn≤n) (half : t=ht+ht) (span : k*t+ht+ht≤hn)
    (input other : Fin n → BitVec 64) (i : Fin n) (owned : owner hn t i=k)
    (agree : ∀ j, owner hn t j=k → input j=other j) :
    FftGroupSource143.values n hn ht length m k (k*t) input i=FftGroupSource143.values n hn ht length m k (k*t) other i := by
  unfold FftGroupSource143.values
  rw [FftGroupValues152.recurrence,FftGroupValues152.recurrence]
  exact VectorRegion152.locality (fun i => owner hn t i=k) _ (k*t) (k*t+ht)
    (step_locality n hn ht t k length half _ _ span) ht (k*t) input other (Nat.le_refl _) (Nat.le_refl _) agree i owned

end FT1536.Source3.FftOuterLocal152
