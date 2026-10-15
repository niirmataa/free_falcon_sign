import Source3.FftOuterLocal152
import Source3.FftOuterStep144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterValues152
open FftOuterLocal152 (owner)

theorem recurrence (n hn ht m t : Nat) (length : 2*hn≤n) (count start : Nat) (input : Fin n → BitVec 64) :
    FftGroupsInduction143.values n hn ht m t length count start input=
      DisjointVectorPass152.run (fun k => FftGroupSource143.values n hn ht length m k (k*t)) count start input := by
  induction count generalizing start input with
  | zero => rfl
  | succ count ih => exact ih (start+1) _

theorem pointwise (n hn ht m t : Nat) (length : 2*hn≤n) (half : t=ht+ht) (coverage : (m/2)*t≤hn)
    (count start : Nat) (upper : start+count≤m/2) (input : Fin n → BitVec 64) (i : Fin n) :
    FftGroupsInduction143.values n hn ht m t length count start input i=
      if start≤owner hn t i ∧ owner hn t i<start+count then
        FftGroupSource143.values n hn ht length m (owner hn t i) (owner hn t i*t) input i else input i := by
  have span (k : Nat) (bound : k<m/2) : k*t+ht+ht≤hn := by
    have product := Nat.mul_le_mul_right t (show k+1≤m/2 by omega)
    rw [Nat.add_mul,Nat.one_mul] at product
    omega
  rw [recurrence]
  exact BoundedVectorPass152.pointwise (owner hn t)
    (fun k => FftGroupSource143.values n hn ht length m k (k*t)) 0 (m/2)
    (fun k _ bound => FftOuterLocal152.outside n hn ht t m k length half (span k bound))
    (fun k _ bound => FftOuterLocal152.locality n hn ht t m k length half (span k bound))
    count start input i (Nat.zero_le _) upper

def image (n hn t m : Nat) (length : 2*hn≤n) (input : Fin n → BitVec 64) (i : Fin n) : BitVec 64 :=
  if owner hn t i<m/2 then
    FftGroupValues152.image n hn (t/2) length m (owner hn t i) (owner hn t i*t) input i else input i

/-- One entire middle pass is an indexed group followed by one indexed butterfly. -/
theorem source (n hn t m : Nat) (length : 2*hn≤n) (half : t=t/2+t/2) (coverage : (m/2)*t≤hn)
    (input : Fin n → BitVec 64) : FftOuterStep144.values n hn t m length input=image n hn t m length input := by
  funext i
  have result := pointwise n hn (t/2) m t length half coverage (m/2) 0 (by omega) input i
  change FftGroupsInduction143.values n hn (t/2) m t length (m/2) 0 input i=_
  rw [result]
  have test : (0≤owner hn t i ∧ owner hn t i<0+m/2) ↔ owner hn t i<m/2 := by omega
  simp only [test,image]
  by_cases inside : owner hn t i<m/2
  · rw [ite_eq_left inside,ite_eq_left inside]
    have product := Nat.mul_le_mul_right t (show owner hn t i+1≤m/2 by omega)
    rw [Nat.add_mul,Nat.one_mul] at product
    rw [FftGroupValues152.source n hn (t/2) length m (owner hn t i) (owner hn t i*t) input (by omega)]
  · rw [ite_eq_right inside,ite_eq_right inside]

end FT1536.Source3.FftOuterValues152
