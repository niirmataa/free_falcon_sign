import Source3.DisjointVectorPass152

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BoundedVectorPass152
open DisjointVectorPass152 (run)

def mask {ι α : Type} (step : Nat → (ι → α) → (ι → α)) (lo hi k : Nat) (input : ι → α) :=
  if lo≤k ∧ k<hi then step k input else input

theorem run_same {ι α : Type} (step : Nat → (ι → α) → (ι → α)) (lo hi count start : Nat)
    (input : ι → α) (lower : lo≤start) (upper : start+count≤hi) :
    run (mask step lo hi) count start input=run step count start input := by
  induction count generalizing start input with
  | zero => rfl
  | succ count ih =>
    have inside : lo≤start ∧ start<hi := by omega
    simp only [run,mask,ite_eq_left inside]
    exact ih (start+1) _ (by omega) (by omega)

theorem pointwise {ι α : Type} (owner : ι → Nat) (step : Nat → (ι → α) → (ι → α)) (lo hi : Nat)
    (outside : ∀ k, lo≤k → k<hi → ∀ input i, owner i≠k → step k input i=input i)
    (locality : ∀ k, lo≤k → k<hi → ∀ input other i, owner i=k →
      (∀ j, owner j=k → input j=other j) → step k input i=step k other i)
    (count start : Nat) (input : ι → α) (i : ι) (lower : lo≤start) (upper : start+count≤hi) :
    run step count start input i=
      if start≤owner i ∧ owner i<start+count then step (owner i) input i else input i := by
  have maskedOutside : ∀ k input i, owner i≠k → mask step lo hi k input i=input i := by
    intro k v j different
    by_cases inside : lo≤k ∧ k<hi
    · simpa only [mask,ite_eq_left inside] using outside k inside.1 inside.2 v j different
    · simp only [mask,ite_eq_right inside]
  have maskedLocal : ∀ k input other i, owner i=k → (∀ j, owner j=k → input j=other j) →
      mask step lo hi k input i=mask step lo hi k other i := by
    intro k v w j owned agree
    by_cases inside : lo≤k ∧ k<hi
    · simpa only [mask,ite_eq_left inside] using locality k inside.1 inside.2 v w j owned agree
    · simpa only [mask,ite_eq_right inside] using agree j owned
  have result := DisjointVectorPass152.pointwise owner (mask step lo hi) maskedOutside maskedLocal count start input i
  rw [run_same step lo hi count start input lower upper] at result
  by_cases touched : start≤owner i ∧ owner i<start+count
  · have inside : lo≤owner i ∧ owner i<hi := by omega
    simpa only [ite_eq_left touched,mask,ite_eq_left inside] using result
  · simpa only [ite_eq_right touched] using result

end FT1536.Source3.BoundedVectorPass152
