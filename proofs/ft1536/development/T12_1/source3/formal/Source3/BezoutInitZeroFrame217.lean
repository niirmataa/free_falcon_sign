import Source3.BezoutInitZero217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutInitZeroFrame217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open StepCopyBody190 (elem)
open ZintNormWalkFlat208 (Data)
open DeepestBezoutEntry217 (Fp)
open BezoutInitZero217 (firstPtr middle after)

theorem keep_data (s : State) (nx ny n : Nat) (root : ArrayPointer) (W : Nat → BitVec 32)
    (data : Data s root n W)
    (apart1 : ∀ i<n, (elem root i).block≠firstPtr.block ∨ (elem root i).offset+4≤firstPtr.offset ∨ firstPtr.offset+4*(ny-1)≤(elem root i).offset)
    (apart2 : ∀ i<n, (elem root i).block≠Fp.block ∨ (elem root i).offset+4≤Fp.offset ∨ Fp.offset+4*nx≤(elem root i).offset) :
    Data (after s nx ny) root n W := by
  intro i bound
  exact BezoutMemzero217.outside (middle s ny).heap Fp (elem root i) (4*nx) (W i) (apart2 i bound)
    (BezoutMemzero217.outside s.heap firstPtr (elem root i) (4*(ny-1)) (W i) (apart1 i bound) (data i bound))

end FT1536.Source3.BezoutInitZeroFrame217
