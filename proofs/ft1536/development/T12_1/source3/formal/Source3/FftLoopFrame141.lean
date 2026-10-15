import Source3.FftButterflyBuffer140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLoopFrame141
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)

def Outside (base : ArrayPointer) (n block offset : Nat) : Prop :=
  block≠base.block ∨ offset<base.offset ∨ base.offset+8*n≤offset

structure Frame (base : ArrayPointer) (n : Nat) (before after : State) : Prop where
  locals : ∀ name, name≠"v".toList → after.locals name=before.locals name
  arrays : after.arrays=before.arrays
  globals : after.globals=before.globals
  tables : after.tables=before.tables
  sizes : after.heap.size=before.heap.size
  writable : after.heap.writable=before.heap.writable
  bytes : ∀ block offset, Outside base n block offset → after.heap.bytes block offset=before.heap.bytes block offset

theorem refl (base : ArrayPointer) (n : Nat) (s : State) : Frame base n s s :=
  ⟨fun _ _ => rfl,rfl,rfl,rfl,rfl,rfl,fun _ _ _ => rfl⟩

theorem trans (base : ArrayPointer) (n : Nat) (s t u : State)
    (first : Frame base n s t) (second : Frame base n t u) : Frame base n s u :=
  ⟨fun name h => (second.locals name h).trans (first.locals name h),second.arrays.trans first.arrays,
    second.globals.trans first.globals,second.tables.trans first.tables,second.sizes.trans first.sizes,
    second.writable.trans first.writable,fun block offset h => (second.bytes block offset h).trans (first.bytes block offset h)⟩

theorem outside_element {n : Nat} (base : ArrayPointer) (width : base.elementBytes=8)
    (i : Fin n) (block offset : Nat) (outside : Outside base n block offset) :
    block≠(C99WordBuffer140.element base i).block ∨ offset<(C99WordBuffer140.element base i).offset ∨
      (C99WordBuffer140.element base i).offset+8≤offset := by
  have bound := i.isLt
  unfold Outside ArrayPointer.offset at outside
  rw [width] at outside
  change block≠base.block ∨ offset<base.base+base.elementBytes*(base.index+i.val) ∨
    base.base+base.elementBytes*(base.index+i.val)+8≤offset
  rw [width]
  omega

theorem body {n : Nat} (s : State) (base : ArrayPointer) (values : Fin n → BitVec 64)
    (slots : Fin 4 → Fin n) (sr si : BitVec 64) (width : base.elementBytes=8) :
    Frame base n s (FftButterflyBuffer140.nextState s base values slots sr si) := by
  refine ⟨fun _ _ => rfl,rfl,rfl,rfl,rfl,rfl,?_⟩
  intro block offset outside
  exact FftButterflyClosed140.other_byte s (FftButterflyBuffer140.operands values slots)
    (fun i => C99WordBuffer140.element base (slots i)) sr si block offset
    (fun i => outside_element base width (slots i) block offset outside)

theorem counter (base : ArrayPointer) (n : Nat) (s : State) (word : BitVec 64) :
    Frame base n s (FftLocalCells140.put s "v".toList word) :=
  ⟨fun name h => FftLocalCells140.outside s "v".toList name word h,rfl,rfl,rfl,rfl,rfl,fun _ _ _ => rfl⟩

end FT1536.Source3.FftLoopFrame141
