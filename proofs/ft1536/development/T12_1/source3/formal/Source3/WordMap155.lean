import Source3.C99WordBuffer140
import Source3.DisjointVectorPass152

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.WordMap155

def step {n : Nat} (f : BitVec 64 → BitVec 64) (u : Nat) (input : Fin n → BitVec 64) : Fin n → BitVec 64 :=
  if inside : u<n then C99WordBuffer140.updated input ⟨u,inside⟩ (f (input ⟨u,inside⟩)) else input

theorem outside {n : Nat} (f : BitVec 64 → BitVec 64) (u : Nat) (input : Fin n → BitVec 64) (i : Fin n)
    (different : i.val≠u) : step f u input i=input i := by
  unfold step
  split
  · rename_i inside
    have differentFin : i≠⟨u,inside⟩ := fun same => different (congrArg Fin.val same)
    exact ite_eq_right differentFin
  · rfl

theorem locality {n : Nat} (f : BitVec 64 → BitVec 64) (u : Nat) (input other : Fin n → BitVec 64) (i : Fin n)
    (same : i.val=u) (agree : ∀ j, j.val=u → input j=other j) : step f u input i=step f u other i := by
  have inside : u<n := by have h:=i.isLt; omega
  have sameFin : i=⟨u,inside⟩ := Fin.ext same
  rw [step,step,dite_eq_left inside,dite_eq_left inside]
  simp only [C99WordBuffer140.updated,ite_eq_left sameFin]
  rw [agree ⟨u,inside⟩ rfl]

theorem pointwise {n : Nat} (f : BitVec 64 → BitVec 64) (count start : Nat) (input : Fin n → BitVec 64) (i : Fin n) :
    DisjointVectorPass152.run (step f) count start input i=
      if start ≤ i.val ∧ i.val<start+count then f (input i) else input i := by
  rw [DisjointVectorPass152.pointwise Fin.val (step f) (outside f) (locality f)]
  by_cases touched : start ≤ i.val ∧ i.val<start+count
  · rw [ite_eq_left touched,ite_eq_left touched,step,dite_eq_left i.isLt]
    simp only [C99WordBuffer140.updated,ite_true]
  · rw [ite_eq_right touched,ite_eq_right touched]

end FT1536.Source3.WordMap155
