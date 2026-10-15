import Source3.DisjointVectorPass152
import Source3.FftTripleLocal152
import Source3.FftTriplingInduction148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTriplingValues152
open FftTripleIndices146 (realSlot imagSlot)

def owner (i : Fin 1536) : Nat := (if i.val<768 then i.val else i.val-768)/3

theorem owner_bound (i : Fin 1536) : owner i<256 := by
  have bound := i.isLt
  unfold owner
  split_ifs <;> omega

theorem real_owner (k : Nat) (range : k<256) (j : Fin 3) : owner (realSlot 1536 768 (3*k) (by omega) (by decide) j)=k := by
  have bound := j.isLt
  change (if 3*k+j.val<768 then 3*k+j.val else 3*k+j.val-768)/3=k
  split_ifs <;> omega
theorem imag_owner (k : Nat) (range : k<256) (j : Fin 3) : owner (imagSlot 1536 768 (3*k) (by omega) (by decide) j)=k := by
  have bound := j.isLt
  change (if 3*k+j.val+768<768 then 3*k+j.val+768 else 3*k+j.val+768-768)/3=k
  split_ifs <;> omega
theorem load_owner (k : Nat) (range : k<256) (j : Fin 6) :
    owner (FftTripleLoadShape147.slot 1536 768 (3*k) (by omega) (by decide) j)=k := by
  fin_cases j
  · exact real_owner k range 0
  · exact imag_owner k range 0
  · exact real_owner k range 1
  · exact imag_owner k range 1
  · exact real_owner k range 2
  · exact imag_owner k range 2

theorem outside (c : FftTripleBody147.Constants) (k : Nat) (input : Fin 1536 → BitVec 64) (i : Fin 1536) (different : owner i≠k) :
    FftTriplingStep148.advance c k input i=input i := by
  by_cases range : k<256
  · rw [FftTriplingStep148.advance,dite_eq_left range]
    apply FftTripleLocal152.writes_outside 1536 768 (3*k) _ _ _ input i
    · intro j same
      exact different (same ▸ real_owner k range j)
    · intro j same
      exact different (same ▸ imag_owner k range j)
  · rw [FftTriplingStep148.advance,dite_eq_right range]

theorem locality (c : FftTripleBody147.Constants) (k : Nat) (input other : Fin 1536 → BitVec 64) (i : Fin 1536)
    (owned : owner i=k) (agree : ∀ j, owner j=k → input j=other j) :
    FftTriplingStep148.advance c k input i=FftTriplingStep148.advance c k other i := by
  by_cases range : k<256
  · rw [FftTriplingStep148.advance,dite_eq_left range,FftTriplingStep148.advance,dite_eq_left range]
    exact FftTripleLocal152.locality 1536 768 (3*k) (512+k) _ _ input other c i (agree i owned)
      (fun j => agree _ (load_owner k range j))
  · rw [FftTriplingStep148.advance,dite_eq_right range,FftTriplingStep148.advance,dite_eq_right range]
    exact agree i owned

theorem recurrence (c : FftTripleBody147.Constants) (count start : Nat) (input : Fin 1536 → BitVec 64) :
    FftTriplingInduction148.values c count start input=DisjointVectorPass152.run (FftTriplingStep148.advance c) count start input := by
  induction count generalizing start input with
  | zero => rfl
  | succ count ih => exact ih (start+1) _

def image (c : FftTripleBody147.Constants) (input : Fin 1536 → BitVec 64) (i : Fin 1536) :=
  FftTriplingStep148.advance c (owner i) input i

theorem source (c : FftTripleBody147.Constants) (input : Fin 1536 → BitVec 64) :
    FftTriplingInduction148.values c 256 0 input=image c input := by
  funext i
  rw [recurrence]
  have result := DisjointVectorPass152.pointwise owner (FftTriplingStep148.advance c) (outside c) (locality c) 256 0 input i
  have inside : 0≤owner i ∧ owner i<0+256 := by have bound := owner_bound i; omega
  simpa only [ite_eq_left inside,image] using result

end FT1536.Source3.FftTriplingValues152
