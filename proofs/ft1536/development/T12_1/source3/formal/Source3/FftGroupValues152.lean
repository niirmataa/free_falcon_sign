import Source3.BoundedVectorPass152
import Source3.FftButterflyLocal152
import Source3.FftGroupSource143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupValues152

def owner {n : Nat} (hn ht start : Nat) (i : Fin n) : Nat :=
  let r := if i.val<hn then i.val else i.val-hn
  if start≤r ∧ r<start+ht then r
  else if start+ht≤r ∧ r<start+ht+ht then r-ht else n

theorem slot_owner (n hn ht start v : Nat) (length : 2*hn≤n) (span : start+ht+ht≤hn)
    (lower : start≤v) (upper : v<start+ht) (j : Fin 4) :
    owner hn ht start (FftLoopIndices141.slots n hn ht v (by omega) length j)=v := by
  fin_cases j
  all_goals dsimp only [owner,FftLoopIndices141.slots]
  all_goals split_ifs <;> omega

theorem outside (n hn ht start : Nat) (length : 2*hn≤n) (sr si : BitVec 64) (span : start+ht+ht≤hn)
    (v : Nat) (lower : start≤v) (upper : v<start+ht) (input : Fin n → BitVec 64) (i : Fin n)
    (different : owner hn ht start i≠v) : FftLoopStep141.advance n hn ht v length sr si input i=input i := by
  have inside : v+ht<hn := by omega
  rw [FftLoopStep141.advance,dite_eq_left inside]
  apply FftButterflyLocal152.outside input _ sr si i
  intro j same
  exact different (same ▸ slot_owner n hn ht start v length span lower upper j)

theorem locality (n hn ht start : Nat) (length : 2*hn≤n) (sr si : BitVec 64) (span : start+ht+ht≤hn)
    (v : Nat) (lower : start≤v) (upper : v<start+ht) (input other : Fin n → BitVec 64) (i : Fin n)
    (owned : owner hn ht start i=v) (agree : ∀ j, owner hn ht start j=v → input j=other j) :
    FftLoopStep141.advance n hn ht v length sr si input i=FftLoopStep141.advance n hn ht v length sr si other i := by
  have inside : v+ht<hn := by omega
  rw [FftLoopStep141.advance,dite_eq_left inside,FftLoopStep141.advance,dite_eq_left inside]
  apply FftButterflyLocal152.locality input other _ sr si i
  · intro j
    exact agree _ (slot_owner n hn ht start v length span lower upper j)
  · exact agree i owned

theorem recurrence (n hn ht : Nat) (length : 2*hn≤n) (sr si : BitVec 64) (count start : Nat) (input : Fin n → BitVec 64) :
    FftLoopInduction141.values n hn ht length sr si count start input=
      DisjointVectorPass152.run (fun v => FftLoopStep141.advance n hn ht v length sr si) count start input := by
  induction count generalizing start input with
  | zero => rfl
  | succ count ih => exact ih (start+1) _

/-- A whole or partial source butterfly group needs only one indexed butterfly. -/
theorem pointwise (n hn ht start : Nat) (length : 2*hn≤n) (sr si : BitVec 64) (span : start+ht+ht≤hn)
    (count first : Nat) (lower : start≤first) (upper : first+count≤start+ht) (input : Fin n → BitVec 64) (i : Fin n) :
    FftLoopInduction141.values n hn ht length sr si count first input i=
      if first≤owner hn ht start i ∧ owner hn ht start i<first+count then
        FftLoopStep141.advance n hn ht (owner hn ht start i) length sr si input i else input i := by
  rw [recurrence]
  exact BoundedVectorPass152.pointwise (owner hn ht start) (fun v => FftLoopStep141.advance n hn ht v length sr si)
    start (start+ht) (outside n hn ht start length sr si span) (locality n hn ht start length sr si span)
    count first input i lower upper

def image (n hn ht : Nat) (length : 2*hn≤n) (m u start : Nat) (input : Fin n → BitVec 64) (i : Fin n) : BitVec 64 :=
  if start≤owner hn ht start i ∧ owner hn ht start i<start+ht then
    FftLoopStep141.advance n hn ht (owner hn ht start i) length
      (FftGroupTwiddle143.pair (m+u)).1 (FftGroupTwiddle143.pair (m+u)).2 input i else input i

theorem source (n hn ht : Nat) (length : 2*hn≤n) (m u start : Nat) (input : Fin n → BitVec 64) (span : start+ht+ht≤hn) :
    FftGroupSource143.values n hn ht length m u start input=image n hn ht length m u start input := by
  funext i
  exact pointwise n hn ht start length (FftGroupTwiddle143.pair (m+u)).1 (FftGroupTwiddle143.pair (m+u)).2 span
    ht start (Nat.le_refl _) (Nat.le_refl _) input i

end FT1536.Source3.FftGroupValues152
