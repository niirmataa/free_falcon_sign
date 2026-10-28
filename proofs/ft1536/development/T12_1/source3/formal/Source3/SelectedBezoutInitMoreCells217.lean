import Source3.SelectedBezoutInitMore217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedBezoutInitMoreCells217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)

noncomputable def after (s : State) (nx ny : Nat) (W : Nat → BitVec 32) :=
  BezoutInitMore217.after (BezoutInitZero217.after (BezoutInitStore217.after s nx ny) nx ny) nx ny W

theorem alen (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (bound : nx<2^64) :
    Cell (after s nx ny W) "alen".toList nx := by
  change Cell (BezoutInitStore217.withB s nx ny) "alen".toList nx
  exact (SelectedStepAddPrime195.locals_keep (BezoutInitStore217.withA s nx) "blen".toList .uint64 (.uint64 (word ny)) "alen".toList (by decide)).trans
    (KeygenMkgm3RowInit.set64_slot s "alen" nx bound)

theorem blen (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (bound : ny<2^64) :
    Cell (after s nx ny W) "blen".toList ny := by
  change Cell (BezoutInitStore217.withB s nx ny) "blen".toList ny
  exact KeygenMkgm3RowInit.set64_slot (BezoutInitStore217.withA s nx) "blen" ny bound

theorem xlen (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (cell : Cell s "xlen".toList nx) :
    Cell (after s nx ny W) "xlen".toList nx := BezoutInitStoreFrame217.xlen s nx ny cell

theorem ylen (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (cell : Cell s "ylen".toList ny) :
    Cell (after s nx ny W) "ylen".toList ny := BezoutInitStoreFrame217.ylen s nx ny cell

end FT1536.Source3.SelectedBezoutInitMoreCells217
