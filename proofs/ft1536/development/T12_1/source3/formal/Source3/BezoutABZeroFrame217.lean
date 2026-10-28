import Source3.BezoutABZero217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutABZeroFrame217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open BezoutPointerSetup217 (a b)
open ZintNormWalkFlat208 (Data)
open BezoutABZero217 (middle after)

theorem keep_data (s : State) (nx ny n : Nat) (root : ArrayPointer) (W : Nat → BitVec 32)
    (data : Data s root n W)
    (apartA : ∀ i<n, (elem root i).block≠a.block ∨ (elem root i).offset+4≤(element a nx).offset ∨
      (element a nx).offset+4*(max nx ny-nx)≤(elem root i).offset)
    (apartB : ∀ i<n, (elem root i).block≠b.block ∨ (elem root i).offset+4≤(element b ny).offset ∨
      (element b ny).offset+4*(max nx ny-ny)≤(elem root i).offset) : Data (after s nx ny) root n W := by
  intro i bound
  exact BezoutMemzero217.outside (middle s nx ny).heap (element b ny) (elem root i) (4*(max nx ny-ny)) (W i) (apartB i bound)
    (BezoutMemzero217.outside s.heap (element a nx) (elem root i) (4*(max nx ny-nx)) (W i) (apartA i bound) (data i bound))

end FT1536.Source3.BezoutABZeroFrame217
