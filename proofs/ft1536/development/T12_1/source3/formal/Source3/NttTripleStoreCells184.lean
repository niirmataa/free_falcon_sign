import Source3.NttTripleCells184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleStoreCells184
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenModpR2Exec (Slot)
open NttTripleStates184

theorem first_slot (s : State) (a : ArrayPointer) (i : Nat) (z : Words) (name : String) (word : BitVec 32)
    (cell : Slot (state11 s z) name word) : Slot (first s a i z) name word := by
  simpa only [Slot,first] using cell

theorem second_slot (s : State) (a : ArrayPointer) (i : Nat) (z : Words) (name : String) (word : BitVec 32)
    (cell : Slot (state11 s z) name word) : Slot (second s a i z) name word := by
  simpa only [Slot,second,first] using cell

end FT1536.Source3.NttTripleStoreCells184
