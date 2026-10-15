import Source3.FftFirstBuffer149

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstFrame149
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)

structure Frame (base : ArrayPointer) (n : Nat) (before after : State) : Prop where
  locals : ∀ name, name≠"u".toList → after.locals name=before.locals name
  arrays : after.arrays=before.arrays
  globals : after.globals=before.globals
  tables : after.tables=before.tables
  sizes : after.heap.size=before.heap.size
  writable : after.heap.writable=before.heap.writable
  bytes : ∀ block offset, FftLoopFrame141.Outside base n block offset → after.heap.bytes block offset=before.heap.bytes block offset

theorem refl (base : ArrayPointer) (n : Nat) (s : State) : Frame base n s s :=
  ⟨fun _ _ => rfl,rfl,rfl,rfl,rfl,rfl,fun _ _ _ => rfl⟩

theorem trans (base : ArrayPointer) (n : Nat) (s t u : State) (first : Frame base n s t) (second : Frame base n t u) :
    Frame base n s u :=
  ⟨fun key outside => (second.locals key outside).trans (first.locals key outside),second.arrays.trans first.arrays,
    second.globals.trans first.globals,second.tables.trans first.tables,second.sizes.trans first.sizes,
    second.writable.trans first.writable,fun block offset outside => (second.bytes block offset outside).trans (first.bytes block offset outside)⟩

theorem body (base : ArrayPointer) (n : Nat) (s t : State) (frame : FftGroupFrame143.Frame base n s t) : Frame base n s t :=
  ⟨fun key _ => congrFun frame.locals key,frame.arrays,frame.globals,frame.tables,frame.sizes,frame.writable,frame.bytes⟩

theorem counter (base : ArrayPointer) (n : Nat) (s : State) (value : BitVec 64) : Frame base n s (FftLocalCells140.put s "u".toList value) :=
  ⟨fun key outside => FftLocalCells140.outside s "u".toList key value outside,rfl,rfl,rfl,rfl,rfl,fun _ _ _ => rfl⟩

end FT1536.Source3.FftFirstFrame149
