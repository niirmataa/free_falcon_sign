import Source3.GsAutoBody155
import Source3.FftFirstValues152

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsAutoValues155
open FftFirstValues152 (owner real_owner imag_owner)

def advance (n hn : Nat) (length : 2*hn ≤ n) (multiplier : Fin hn → BitVec 64) (u : Nat)
    (input : Fin n → BitVec 64) : Fin n → BitVec 64 :=
  if inside : u<hn then C99TwoWordBuffer146.values input ⟨u,by omega⟩ ⟨u+hn,by omega⟩
    (FprMulFast137.word (input ⟨u,by omega⟩) (multiplier ⟨u,inside⟩))
    (FprMulFast137.word (input ⟨u+hn,by omega⟩) (multiplier ⟨u,inside⟩)) else input

theorem effect (n hn : Nat) (length : 2*hn ≤ n) (multiplier : Fin hn → BitVec 64) (u : Nat)
    (input : Fin n → BitVec 64) (inside : u<hn) (i : Fin n) : advance n hn length multiplier u input i=
    if i=⟨u+hn,by omega⟩ then FprMulFast137.word (input ⟨u+hn,by omega⟩) (multiplier ⟨u,inside⟩)
    else if i=⟨u,by omega⟩ then FprMulFast137.word (input ⟨u,by omega⟩) (multiplier ⟨u,inside⟩) else input i := by
  rw [advance,dite_eq_left inside]
  rfl

theorem outside (n hn : Nat) (length : 2*hn ≤ n) (multiplier : Fin hn → BitVec 64) (u : Nat)
    (input : Fin n → BitVec 64) (i : Fin n) (different : owner hn i≠u) : advance n hn length multiplier u input i=input i := by
  by_cases inside : u<hn
  · have notReal : i≠⟨u,by omega⟩ := fun same => different (same ▸ real_owner n hn u length inside)
    have notImag : i≠⟨u+hn,by omega⟩ := fun same => different (same ▸ imag_owner n hn u length inside)
    rw [effect n hn length multiplier u input inside i,ite_eq_right notImag,ite_eq_right notReal]
  · rw [advance,dite_eq_right inside]

theorem locality (n hn : Nat) (length : 2*hn ≤ n) (multiplier : Fin hn → BitVec 64) (u : Nat)
    (input other : Fin n → BitVec 64) (i : Fin n) (owned : owner hn i=u)
    (agree : ∀ j, owner hn j=u → input j=other j) :
    advance n hn length multiplier u input i=advance n hn length multiplier u other i := by
  by_cases inside : u<hn
  · rw [effect n hn length multiplier u input inside i,effect n hn length multiplier u other inside i,
      agree ⟨u,by omega⟩ (real_owner n hn u length inside),agree ⟨u+hn,by omega⟩ (imag_owner n hn u length inside),agree i owned]
  · rw [advance,dite_eq_right inside,advance,dite_eq_right inside]
    exact agree i owned

def image (n hn : Nat) (length : 2*hn ≤ n) (multiplier : Fin hn → BitVec 64) (count start : Nat)
    (input : Fin n → BitVec 64) : Fin n → BitVec 64 := fun i =>
  if start ≤ owner hn i ∧ owner hn i<start+count then advance n hn length multiplier (owner hn i) input i else input i

theorem pointwise (n hn : Nat) (length : 2*hn ≤ n) (multiplier : Fin hn → BitVec 64) (count start : Nat)
    (input : Fin n → BitVec 64) :
    DisjointVectorPass152.run (advance n hn length multiplier) count start input=image n hn length multiplier count start input := by
  funext i
  exact DisjointVectorPass152.pointwise (owner hn) (advance n hn length multiplier)
    (outside n hn length multiplier) (locality n hn length multiplier) count start input i

end FT1536.Source3.GsAutoValues155
