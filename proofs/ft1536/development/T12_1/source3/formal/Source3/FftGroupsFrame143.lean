import Source3.FftGroupFrame143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupsFrame143
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)

structure Frame (base : ArrayPointer) (n : Nat) (before after : State) : Prop where
  locals : ∀ name, name≠"u1".toList → name≠"v1".toList → after.locals name=before.locals name
  arrays : after.arrays=before.arrays
  globals : after.globals=before.globals
  tables : after.tables=before.tables
  sizes : after.heap.size=before.heap.size
  writable : after.heap.writable=before.heap.writable
  bytes : ∀ block offset, FftLoopFrame141.Outside base n block offset → after.heap.bytes block offset=before.heap.bytes block offset

theorem refl (base : ArrayPointer) (n : Nat) (s : State) : Frame base n s s :=
  ⟨fun _ _ _ => rfl,rfl,rfl,rfl,rfl,rfl,fun _ _ _ => rfl⟩

theorem trans (base : ArrayPointer) (n : Nat) (s t u : State)
    (first : Frame base n s t) (second : Frame base n t u) : Frame base n s u :=
  ⟨fun name h k => (second.locals name h k).trans (first.locals name h k),second.arrays.trans first.arrays,
    second.globals.trans first.globals,second.tables.trans first.tables,second.sizes.trans first.sizes,
    second.writable.trans first.writable,fun block offset h => (second.bytes block offset h).trans (first.bytes block offset h)⟩

theorem body (base : ArrayPointer) (n : Nat) (s after : State) (frame : FftGroupFrame143.Frame base n s after) :
    Frame base n s after := ⟨fun name _ _ => congrFun frame.locals name,frame.arrays,frame.globals,frame.tables,frame.sizes,frame.writable,frame.bytes⟩

theorem counters (base : ArrayPointer) (n : Nat) (s : State) (u v : BitVec 64) :
    Frame base n s (FftLocalCells140.put (FftLocalCells140.put s "u1".toList u) "v1".toList v) :=
  ⟨fun name hu hv => (FftLocalCells140.outside _ _ name _ hv).trans (FftLocalCells140.outside _ _ name _ hu),
    rfl,rfl,rfl,rfl,rfl,fun _ _ _ => rfl⟩

end FT1536.Source3.FftGroupsFrame143
