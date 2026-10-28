import Source3.SelectedBezoutInitZero217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutInitZeroImages217
open C99ArrayReference (State)
open C99MemoryReference (Allocated Load32)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open ZintNormWalkFlat208 (Data)
open DeepestBezoutEntry217 (Fp)
open BezoutInitZero217 (firstPtr middle after)

theorem firstPtr_shape : firstPtr=⟨31,0,71680,4,336⟩ := rfl
theorem Fp_shape : Fp=⟨31,0,71680,4,0⟩ := rfl

theorem first_zero (s : State) (nx ny : Nat) (h : BezoutInitZero217.Input s nx ny) :
    Data (after s nx ny) firstPtr (ny-1) (fun _ => 0) := by
  intro i bound
  have extent : 4*71680≤(middle s ny).heap.size 31 := h.extent
  have size : (middle s ny).heap.size 31<2^64 := h.size
  have alloc : Allocated (middle s ny).heap (element firstPtr i) := by
    rw [firstPtr_shape]
    exact BezoutInitCopies217.allocated_at _ 336 i extent size (by have b:=h.nyBound; omega)
  have zero : Load32 (middle s ny).heap (elem firstPtr i) 0 := by
    apply BezoutMemzero217.zero_word s.heap firstPtr (elem firstPtr i) (4*(ny-1)) alloc rfl rfl
    constructor
    · change 0+4*336≤0+4*(336+i); omega
    · change 0+4*(336+i)+4≤0+4*336+4*(ny-1); omega
  apply BezoutMemzero217.outside (middle s ny).heap Fp (elem firstPtr i) (4*nx) 0 ?_ zero
  right; right
  change 0+4*0+4*nx≤0+4*(336+i)
  have b:=h.nxBound; omega

theorem second_zero (s : State) (nx ny : Nat) (h : BezoutInitZero217.Input s nx ny) :
    Data (after s nx ny) Fp nx (fun _ => 0) := by
  intro i bound
  have extent : 4*71680≤(after s nx ny).heap.size 31 := h.extent
  have size : (after s nx ny).heap.size 31<2^64 := h.size
  have alloc : Allocated (after s nx ny).heap (element Fp i) := by
    rw [Fp_shape]
    exact BezoutInitCopies217.allocated_at _ 0 i extent size (by have b:=h.nxBound; omega)
  apply BezoutMemzero217.zero_word (middle s ny).heap Fp (elem Fp i) (4*nx) alloc rfl rfl
  constructor
  · change 0+4*0≤0+4*(0+i); omega
  · change 0+4*(0+i)+4≤0+4*0+4*nx; omega

end FT1536.Source3.BezoutInitZeroImages217
