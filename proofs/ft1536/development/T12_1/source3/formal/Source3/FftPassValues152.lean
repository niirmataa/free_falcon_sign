import Source3.FftOuterValues152
import Source3.FftOuterSchedule144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftPassValues152

def middle (n hn : Nat) (length : 2*hn≤n) : Nat → Nat → Nat → (Fin n → BitVec 64) → (Fin n → BitVec 64)
  | 0,_,_,input => input
  | count+1,t,m,input => middle n hn length count (t/2) (m*2) (FftOuterValues152.image n hn t m length input)

theorem source (n hn stop count t m : Nat) (length : 2*hn≤n) (plan : FftOuterSchedule144.Plan hn stop count t m)
    (input : Fin n → BitVec 64) : FftOuterSchedule144.values n hn length count t m input=middle n hn length count t m input := by
  induction count generalizing t m input with
  | zero => rfl
  | succ count ih =>
    obtain ⟨_,ready,tail⟩ := plan
    rw [FftOuterSchedule144.values,middle,FftOuterValues152.source n hn t m length ready.2.2.1 ready.2.2.2.1]
    exact ih (t/2) (m*2) tail _

end FT1536.Source3.FftPassValues152
