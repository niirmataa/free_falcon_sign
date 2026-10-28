import Source3.BezoutUnitX217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Initialization only alters alen, blen and mlen scalar slots. -/
namespace FT1536.Source3.BezoutUnitCells217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)

theorem xlen (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (h : Cell s "xlen".toList nx) :
    Cell (BezoutABZero217.after (BezoutUpperSequence217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny) "xlen".toList nx := by
  change Cell (BezoutMlen217.after (BezoutUpperZero217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny) "xlen".toList nx
  exact (SelectedStepAddPrime195.locals_keep _ "mlen".toList .uint64 (.uint64 (word (max nx ny))) "xlen".toList (by decide)).trans
    (SelectedBezoutInitMoreCells217.xlen s nx ny W h)

theorem ylen (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (h : Cell s "ylen".toList ny) :
    Cell (BezoutABZero217.after (BezoutUpperSequence217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny) "ylen".toList ny := by
  change Cell (BezoutMlen217.after (BezoutUpperZero217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny) "ylen".toList ny
  exact (SelectedStepAddPrime195.locals_keep _ "mlen".toList .uint64 (.uint64 (word (max nx ny))) "ylen".toList (by decide)).trans
    (SelectedBezoutInitMoreCells217.ylen s nx ny W h)

end FT1536.Source3.BezoutUnitCells217
