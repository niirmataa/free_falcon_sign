import Source3.PublicConvertBody158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicConvertFrame158
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open Word16Memory158 (element)

def Outside (base : ArrayPointer) (n block offset : Nat) : Prop := block≠base.block ∨ offset<base.offset ∨ base.offset+2*n ≤ offset
structure Frame (t h : ArrayPointer) (n : Nat) (before after : State) : Prop where
  locals : ∀ name, name≠"u".toList → after.locals name=before.locals name
  arrays : after.arrays=before.arrays
  globals : after.globals=before.globals
  tables : after.tables=before.tables
  sizes : after.heap.size=before.heap.size
  writable : after.heap.writable=before.heap.writable
  bytes : ∀ block offset, Outside t n block offset → Outside h n block offset → after.heap.bytes block offset=before.heap.bytes block offset

theorem refl (t h : ArrayPointer) (n : Nat) (s : State) : Frame t h n s s :=
  ⟨fun _ _ => rfl,rfl,rfl,rfl,rfl,rfl,fun _ _ _ _ => rfl⟩
theorem trans (t h : ArrayPointer) (n : Nat) (a b c : State) (first : Frame t h n a b) (second : Frame t h n b c) : Frame t h n a c :=
  ⟨fun key outside => (second.locals key outside).trans (first.locals key outside),second.arrays.trans first.arrays,
    second.globals.trans first.globals,second.tables.trans first.tables,second.sizes.trans first.sizes,
    second.writable.trans first.writable,fun block offset a b => (second.bytes block offset a b).trans (first.bytes block offset a b)⟩
theorem counter (t h : ArrayPointer) (n : Nat) (s : State) (word : BitVec 64) : Frame t h n s (FftLocalCells140.put s "u".toList word) :=
  ⟨fun key outside => FftLocalCells140.outside s "u".toList key word outside,rfl,rfl,rfl,rfl,rfl,fun _ _ _ _ => rfl⟩

theorem element_outside {n : Nat} (base : ArrayPointer) (width : base.elementBytes=2) (i : Fin n) (block offset : Nat)
    (outside : Outside base n block offset) :
    ¬(block=(element base i).block ∧ (element base i).offset ≤ offset ∧ offset<(element base i).offset+2) := by
  have bound:=i.isLt
  unfold Outside ArrayPointer.offset at outside
  rw [width] at outside
  change ¬(block=base.block ∧ base.base+base.elementBytes*(base.index+i.val) ≤ offset ∧ offset<base.base+base.elementBytes*(base.index+i.val)+2)
  rw [width]
  omega
theorem body {n : Nat} (s : State) (t h : ArrayPointer) (i : Fin n) (x y : BitVec 16)
    (tWidth : t.elementBytes=2) (hWidth : h.elementBytes=2) :
    Frame t h n s (PublicConvertBody158.output s (element t i) (element h i) x y) := by
  refine ⟨fun _ _ => rfl,rfl,rfl,rfl,rfl,rfl,?_⟩
  intro block offset ot oh
  simp only [PublicConvertBody158.output,Word16Memory158.write,
    dite_eq_right (element_outside h hWidth i block offset oh),dite_eq_right (element_outside t tWidth i block offset ot)]

end FT1536.Source3.PublicConvertFrame158
