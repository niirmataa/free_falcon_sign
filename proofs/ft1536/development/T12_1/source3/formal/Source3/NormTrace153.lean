import Source3.KeygenNormInduction151
import Source3.FiniteWordVector153

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NormTrace153

def stepImage {n : Nat} (f g : Fin n → BitVec 64) (trace : Nat → BitVec 64) (i : Fin n) : BitVec 64 :=
  KeygenNormBody151.step (trace i.val) (f i) (g i)
def nextImage {n : Nat} (trace : Nat → BitVec 64) (i : Fin n) : BitVec 64 := trace (i.val+1)

/-- Independently checked scalar transitions compose to the exact ordered sum. -/
theorem source {n : Nat} (f g : Fin n → BitVec 64) (trace : Nat → BitVec 64)
    (checked : stepImage f g trace=nextImage trace) (count start : Nat) (range : start+count≤n) :
    KeygenNormInduction151.sum f g count start (trace start)=trace (start+count) := by
  induction count generalizing start with
  | zero => rfl
  | succ count ih =>
    have inside : start<n := by omega
    have step := congrFun checked ⟨start,inside⟩
    change KeygenNormBody151.step (trace start) (f ⟨start,inside⟩) (g ⟨start,inside⟩)=trace (start+1) at step
    rw [KeygenNormInduction151.sum,KeygenNormStep151.advance,dite_eq_left inside,step,ih (start+1) (by omega)]
    have same : start+1+count=start+(count+1) := by omega
    rw [same]

end FT1536.Source3.NormTrace153
