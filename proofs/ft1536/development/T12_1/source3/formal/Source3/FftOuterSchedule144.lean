import Source3.FftOuterStep144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterSchedule144

def Ready (hn t m : Nat) : Prop :=
  t<2^64 ∧ m<2^64 ∧ t=t/2+t/2 ∧ (m/2)*t≤hn ∧ m+m/2≤1024

def Plan (hn stop : Nat) : Nat → Nat → Nat → Prop
  | 0,t,_ => t≤stop ∧ t<2^64
  | count+1,t,m => stop<t ∧ Ready hn t m ∧ Plan hn stop count (t/2) (m*2)

theorem valid (hn t m : Nat) (ready : Ready hn t m) : FftOuterInvariant144.Valid hn t m :=
  ⟨ready.1,ready.2.1,ready.2.2.1,ready.2.2.2.1,ready.2.2.2.2⟩

def finalT : Nat → Nat → Nat | 0,t => t | count+1,t => finalT count (t/2)
def finalM : Nat → Nat → Nat | 0,m => m | count+1,m => finalM count (m*2)

def values (n hn : Nat) (length : 2*hn≤n) : Nat → Nat → Nat → (Fin n → BitVec 64) → (Fin n → BitVec 64)
  | 0,_,_,input => input
  | count+1,t,m,input => values n hn length count (t/2) (m*2) (FftOuterStep144.values n hn t m length input)

/-- All numerical side conditions for the actual remaining seven passes. -/
theorem remaining : Plan 768 3 7 384 4 := by
  simp only [Plan,Ready]
  decide +kernel

theorem end_t : finalT 7 384=3 := by decide +kernel
theorem end_m : finalM 7 4=512 := by decide +kernel

end FT1536.Source3.FftOuterSchedule144
