import Source3.SelectedBezoutUpper217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutUpperZeroImages217
open C99ArrayReference (State)
open C99MemoryReference (Allocated Load32)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)
open BezoutUpperZero217 (middle after)

theorem u_high (s : State) (nx ny : Nat) (h : BezoutUpperZero217.Input s nx ny) :
    Data (after s nx ny) (element Gp ny) (335-ny) (fun _ => 0) := by
  intro i bound
  have extent : 4*71680≤(middle s ny).heap.size 31 := h.extent
  have size : (middle s ny).heap.size 31<2^64 := h.size
  have alloc : Allocated (middle s ny).heap (element (element Gp ny) i) := by
    change Allocated (middle s ny).heap (element ⟨31,0,71680,4,335+ny⟩ i)
    exact BezoutInitCopies217.allocated_at _ (335+ny) i extent size (by have q:=h.nyBound; omega)
  have zero : Load32 (middle s ny).heap (elem (element Gp ny) i) 0 := by
    apply BezoutMemzero217.zero_word s.heap (element Gp ny) (elem (element Gp ny) i) (4*(335-ny)) alloc rfl rfl
    constructor
    · change 0+4*(335+ny)≤0+4*(335+ny+i); omega
    · change 0+4*(335+ny+i)+4≤0+4*(335+ny)+4*(335-ny); omega
  apply BezoutMemzero217.outside (middle s ny).heap (element Fp nx) (elem (element Gp ny) i) (4*(335-nx)) 0 ?_ zero
  right; right
  change 0+4*(0+nx)+4*(335-nx)≤0+4*(335+ny+i)
  have q:=h.nxBound; omega

theorem v_high (s : State) (nx ny : Nat) (h : BezoutUpperZero217.Input s nx ny) :
    Data (after s nx ny) (element Fp nx) (335-nx) (fun _ => 0) := by
  intro i bound
  have extent : 4*71680≤(after s nx ny).heap.size 31 := h.extent
  have size : (after s nx ny).heap.size 31<2^64 := h.size
  have alloc : Allocated (after s nx ny).heap (element (element Fp nx) i) := by
    change Allocated (after s nx ny).heap (element ⟨31,0,71680,4,0+nx⟩ i)
    exact BezoutInitCopies217.allocated_at _ (0+nx) i extent size (by have q:=h.nxBound; omega)
  apply BezoutMemzero217.zero_word (middle s ny).heap (element Fp nx) (elem (element Fp nx) i) (4*(335-nx)) alloc rfl rfl
  constructor
  · change 0+4*(0+nx)≤0+4*(0+nx+i); omega
  · change 0+4*(0+nx+i)+4≤0+4*(0+nx)+4*(335-nx); omega

end FT1536.Source3.BezoutUpperZeroImages217
