import Source3.BezoutABZeroImages217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutABZeroCombine217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open ZintNormWalkFlat208 (Data)

noncomputable def padded (W : Nat → BitVec 32) (n i : Nat) : BitVec 32 := if i<n then W i else 0

theorem combine (s : State) (root : ArrayPointer) (W : Nat → BitVec 32) (n m : Nat) (le : n≤m)
    (low : Data s root n W) (high : Data s (element root n) (m-n) (fun _ => 0)) :
    Data s root m (padded W n) := by
  intro i inside
  by_cases h : i<n
  · simpa only [padded,h,ite_true] using low i h
  · have hi : i-n<m-n := by omega
    have address : elem root i=elem (element root n) (i-n) := by
      apply congrArg (fun k : Nat => (⟨root.block,root.base,root.count,root.elementBytes,k⟩ : ArrayPointer))
      change root.index+i=root.index+n+(i-n)
      omega
    rw [address]
    simpa only [padded,h,ite_false] using high (i-n) hi

end FT1536.Source3.BezoutABZeroCombine217
