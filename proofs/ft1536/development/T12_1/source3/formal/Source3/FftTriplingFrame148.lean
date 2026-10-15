import Source3.FftTripleBody147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTriplingFrame148
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)

structure Frame (base : ArrayPointer) (before after : State) : Prop where
  locals : ∀ name, name≠"u".toList → name≠"v".toList → after.locals name=before.locals name
  arrays : after.arrays=before.arrays
  globals : after.globals=before.globals
  tables : after.tables=before.tables
  sizes : after.heap.size=before.heap.size
  writable : after.heap.writable=before.heap.writable
  bytes : ∀ block offset, FftLoopFrame141.Outside base 1536 block offset → after.heap.bytes block offset=before.heap.bytes block offset

theorem refl (base : ArrayPointer) (s : State) : Frame base s s := ⟨fun _ _ _ => rfl,rfl,rfl,rfl,rfl,rfl,fun _ _ _ => rfl⟩

theorem trans (base : ArrayPointer) (s t after : State) (first : Frame base s t) (second : Frame base t after) : Frame base s after :=
  ⟨fun name hu hv => (second.locals name hu hv).trans (first.locals name hu hv),second.arrays.trans first.arrays,
    second.globals.trans first.globals,second.tables.trans first.tables,second.sizes.trans first.sizes,
    second.writable.trans first.writable,fun block offset outside => (second.bytes block offset outside).trans (first.bytes block offset outside)⟩

theorem body (base : ArrayPointer) (s after : State) (frame : FftGroupFrame143.Frame base 1536 s after) : Frame base s after :=
  ⟨fun name _ _ => congrFun frame.locals name,frame.arrays,frame.globals,frame.tables,frame.sizes,frame.writable,frame.bytes⟩

theorem counters (base : ArrayPointer) (s : State) (u v : BitVec 64) :
    Frame base s (FftLocalCells140.put (FftLocalCells140.put s "u".toList u) "v".toList v) :=
  ⟨fun name hu hv => (FftLocalCells140.outside _ _ name _ hv).trans (FftLocalCells140.outside _ _ name _ hu),
    rfl,rfl,rfl,rfl,rfl,fun _ _ _ => rfl⟩

end FT1536.Source3.FftTriplingFrame148
