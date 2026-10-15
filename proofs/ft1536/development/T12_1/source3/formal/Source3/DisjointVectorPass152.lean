import Mathlib.Tactic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.DisjointVectorPass152

def run {ι α : Type} (step : Nat → (ι → α) → (ι → α)) : Nat → Nat → (ι → α) → (ι → α)
  | 0,_,input => input
  | count+1,start,input => run step count (start+1) (step start input)

/-- Independent indexed updates can be read directly from the original vector. -/
theorem pointwise {ι α : Type} (owner : ι → Nat) (step : Nat → (ι → α) → (ι → α))
    (outside : ∀ k input i, owner i≠k → step k input i=input i)
    (locality : ∀ k input other i, owner i=k →
      (∀ j, owner j=k → input j=other j) → step k input i=step k other i)
    (count start : Nat) (input : ι → α) (i : ι) :
    run step count start input i=
      if start≤owner i ∧ owner i<start+count then step (owner i) input i else input i := by
  induction count generalizing start input with
  | zero =>
    have absent : ¬(start≤owner i ∧ owner i<start) := by omega
    simp only [run,Nat.add_zero,ite_eq_right absent]
  | succ count ih =>
    rw [run,ih]
    by_cases later : start+1≤owner i ∧ owner i<start+1+count
    · have inside : start≤owner i ∧ owner i<start+(count+1) := by omega
      rw [ite_eq_left later,ite_eq_left inside]
      apply locality (owner i) (step start input) input i rfl
      intro j same
      exact outside start input j (by omega)
    · rw [ite_eq_right later]
      by_cases current : owner i=start
      · have inside : start≤owner i ∧ owner i<start+(count+1) := by omega
        rw [ite_eq_left inside,current]
      · have absent : ¬(start≤owner i ∧ owner i<start+(count+1)) := by omega
        rw [ite_eq_right absent]
        exact outside start input i current

end FT1536.Source3.DisjointVectorPass152
