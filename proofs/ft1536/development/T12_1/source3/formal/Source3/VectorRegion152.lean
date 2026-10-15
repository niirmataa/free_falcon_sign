import Source3.DisjointVectorPass152

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.VectorRegion152
open DisjointVectorPass152 (run)

theorem outside {ι α : Type} (region : ι → Prop) (step : Nat → (ι → α) → (ι → α)) (lo hi : Nat)
    (frame : ∀ k, lo≤k → k<hi → ∀ v i, ¬region i → step k v i=v i)
    (count start : Nat) (input : ι → α) (lower : lo≤start) (upper : start+count≤hi)
    (i : ι) (absent : ¬region i) : run step count start input i=input i := by
  induction count generalizing start input with
  | zero => rfl
  | succ count ih =>
    rw [run,ih (start+1) _ (by omega) (by omega)]
    exact frame start lower (by omega) input i absent

theorem locality {ι α : Type} (region : ι → Prop) (step : Nat → (ι → α) → (ι → α)) (lo hi : Nat)
    (localStep : ∀ k, lo≤k → k<hi → ∀ v w, (∀ i, region i → v i=w i) → ∀ i, region i → step k v i=step k w i)
    (count start : Nat) (v w : ι → α) (lower : lo≤start) (upper : start+count≤hi)
    (agree : ∀ i, region i → v i=w i) (i : ι) (inside : region i) : run step count start v i=run step count start w i := by
  induction count generalizing start v w with
  | zero => exact agree i inside
  | succ count ih =>
    simp only [run]
    exact ih (start+1) _ _ (by omega) (by omega) (localStep start lower (by omega) v w agree)

end FT1536.Source3.VectorRegion152
