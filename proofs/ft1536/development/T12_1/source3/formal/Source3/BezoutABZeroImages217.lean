import Source3.SelectedBezoutABZero217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutABZeroImages217
open C99ArrayReference (State)
open C99MemoryReference (Allocated Load32)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open BezoutPointerSetup217 (a b)
open ZintNormWalkFlat208 (Data)
open BezoutABZero217 (middle after)

theorem a_high (s : State) (nx ny : Nat) (h : BezoutABZero217.Input s nx ny) :
    Data (after s nx ny) (element a nx) (max nx ny-nx) (fun _ => 0) := by
  intro i bound
  have maxBound : max nx ny≤335 := (Nat.max_le).2 ⟨h.nxBound,h.nyBound⟩
  have extent : 4*71680≤(middle s nx ny).heap.size 31 := h.extent
  have size : (middle s nx ny).heap.size 31<2^64 := h.size
  have alloc : Allocated (middle s nx ny).heap (element (element a nx) i) := by
    change Allocated (middle s nx ny).heap (element ⟨31,0,71680,4,2010+nx⟩ i)
    exact BezoutInitCopies217.allocated_at _ (2010+nx) i extent size (by have q:=Nat.le_max_left nx ny; omega)
  have zero : Load32 (middle s nx ny).heap (elem (element a nx) i) 0 := by
    apply BezoutMemzero217.zero_word s.heap (element a nx) (elem (element a nx) i) (4*(max nx ny-nx)) alloc rfl rfl
    constructor
    · change 0+4*(2010+nx)≤0+4*(2010+nx+i); omega
    · change 0+4*(2010+nx+i)+4≤0+4*(2010+nx)+4*(max nx ny-nx); omega
  apply BezoutMemzero217.outside (middle s nx ny).heap (element b ny) (elem (element a nx) i) (4*(max nx ny-ny)) 0 ?_ zero
  right; left
  change 0+4*(2010+nx+i)+4≤0+4*(2345+ny)
  have q:=Nat.le_max_left nx ny; omega

theorem b_high (s : State) (nx ny : Nat) (h : BezoutABZero217.Input s nx ny) :
    Data (after s nx ny) (element b ny) (max nx ny-ny) (fun _ => 0) := by
  intro i bound
  have extent : 4*71680≤(after s nx ny).heap.size 31 := h.extent
  have size : (after s nx ny).heap.size 31<2^64 := h.size
  have alloc : Allocated (after s nx ny).heap (element (element b ny) i) := by
    change Allocated (after s nx ny).heap (element ⟨31,0,71680,4,2345+ny⟩ i)
    exact BezoutInitCopies217.allocated_at _ (2345+ny) i extent size (by have q:=Nat.le_max_right nx ny; have m : max nx ny≤335 := (Nat.max_le).2 ⟨h.nxBound,h.nyBound⟩; omega)
  apply BezoutMemzero217.zero_word (middle s nx ny).heap (element b ny) (elem (element b ny) i) (4*(max nx ny-ny)) alloc rfl rfl
  constructor
  · change 0+4*(2345+ny)≤0+4*(2345+ny+i); omega
  · change 0+4*(2345+ny+i)+4≤0+4*(2345+ny)+4*(max nx ny-ny); omega

end FT1536.Source3.BezoutABZeroImages217
