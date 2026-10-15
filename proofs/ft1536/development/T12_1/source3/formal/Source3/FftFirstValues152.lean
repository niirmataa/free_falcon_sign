import Source3.DisjointVectorPass152
import Source3.FftFirstInduction149

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstValues152
open C99WordBuffer140 (updated)

def owner {n : Nat} (hn : Nat) (i : Fin n) : Nat := if i.val<hn then i.val else i.val-hn

theorem real_owner (n hn u : Nat) (length : 2*hn≤n) (range : u<hn) : owner hn (⟨u,by omega⟩ : Fin n)=u := by
  simp only [owner,range,ite_true]
theorem imag_owner (n hn u : Nat) (length : 2*hn≤n) (range : u<hn) : owner hn (⟨u+hn,by omega⟩ : Fin n)=u := by
  have other : ¬u+hn<hn := by omega
  simp only [owner,other,ite_false,Nat.add_sub_cancel]

theorem effect (n hn u : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (input : Fin n → BitVec 64)
    (range : u<hn) (i : Fin n) :
    FftFirstStep149.advance n hn u length wr wi input i=
      if i=⟨u+hn,by omega⟩ then FftFirstBody149.imag (input ⟨u+hn,by omega⟩) wi
      else if i=⟨u,by omega⟩ then FftFirstBody149.real (input ⟨u,by omega⟩) (input ⟨u+hn,by omega⟩) wr
      else input i := by
  rw [FftFirstStep149.advance,dite_eq_left range]
  rfl

theorem outside (n hn : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (u : Nat)
    (input : Fin n → BitVec 64) (i : Fin n) (different : owner hn i≠u) :
    FftFirstStep149.advance n hn u length wr wi input i=input i := by
  by_cases range : u<hn
  · have notReal : i≠⟨u,by omega⟩ := by
      intro same
      exact different (same ▸ real_owner n hn u length range)
    have notImag : i≠⟨u+hn,by omega⟩ := by
      intro same
      exact different (same ▸ imag_owner n hn u length range)
    rw [effect n hn u length wr wi input range i,ite_eq_right notImag,ite_eq_right notReal]
  · rw [FftFirstStep149.advance,dite_eq_right range]

theorem locality (n hn : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (u : Nat)
    (input other : Fin n → BitVec 64) (i : Fin n) (owned : owner hn i=u)
    (agree : ∀ j, owner hn j=u → input j=other j) :
    FftFirstStep149.advance n hn u length wr wi input i=FftFirstStep149.advance n hn u length wr wi other i := by
  by_cases range : u<hn
  · rw [effect n hn u length wr wi input range i,effect n hn u length wr wi other range i,
      agree ⟨u,by omega⟩ (real_owner n hn u length range),
      agree ⟨u+hn,by omega⟩ (imag_owner n hn u length range),agree i owned]
  · rw [FftFirstStep149.advance,dite_eq_right range,FftFirstStep149.advance,dite_eq_right range]
    exact agree i owned

theorem recurrence (n hn : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (count start : Nat) (input : Fin n → BitVec 64) :
    FftFirstInduction149.values n hn length wr wi count start input=
      DisjointVectorPass152.run (fun u => FftFirstStep149.advance n hn u length wr wi) count start input := by
  induction count generalizing start input with
  | zero => rfl
  | succ count ih => exact ih (start+1) _

theorem pointwise (n hn : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (count start : Nat)
    (input : Fin n → BitVec 64) (i : Fin n) :
    FftFirstInduction149.values n hn length wr wi count start input i=
      if start≤owner hn i ∧ owner hn i<start+count then
        FftFirstStep149.advance n hn (owner hn i) length wr wi input i else input i := by
  rw [recurrence]
  exact DisjointVectorPass152.pointwise (owner hn) (fun u => FftFirstStep149.advance n hn u length wr wi)
    (outside n hn length wr wi) (locality n hn length wr wi) count start input i

end FT1536.Source3.FftFirstValues152
