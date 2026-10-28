import Source3.BezoutInitCopies217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutLengthCells217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open ExactLengthProgram217 (highest)
open ExactLengthCalls217 (after)

theorem xcell (s : State) (X Y : Nat → BitVec 32) : Cell (after s X Y) "xlen".toList (highest X 335) := by
  have bound : highest X 335<2^64 := lt_of_le_of_lt (ExactLengthProgram217.highest_le X 335) (by decide)
  exact (SelectedStepAddPrime195.locals_keep _ "ylen".toList .uint64 _ "xlen".toList (by decide)).trans
    (KeygenMkgm3RowInit.set64_slot s "xlen" (highest X 335) bound)

theorem ycell (s : State) (X Y : Nat → BitVec 32) : Cell (after s X Y) "ylen".toList (highest Y 335) := by
  have bound : highest Y 335<2^64 := lt_of_le_of_lt (ExactLengthProgram217.highest_le Y 335) (by decide)
  exact KeygenMkgm3RowInit.set64_slot _ "ylen" (highest Y 335) bound

theorem heap (s : State) (X Y : Nat → BitVec 32) : (after s X Y).heap=s.heap := rfl

end FT1536.Source3.BezoutLengthCells217
