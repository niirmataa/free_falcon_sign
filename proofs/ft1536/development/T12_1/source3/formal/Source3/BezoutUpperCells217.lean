import Source3.BezoutUpperSequence217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutUpperCells217
open C99ArrayReference (State Name)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open ExactLengthProgram217 (highest)
open DeepestBezoutEntry217 (Fp Gp)

theorem len_base (s : State) : Cell (BezoutPointerSetup217.after s) "len".toList 335 := BezoutPointerCells217.len s

theorem mlen_base (s : State) : (BezoutPointerSetup217.after s).locals "mlen".toList=some (.uint64,none) := by
  change (BezoutDeclarations217.after (DeepestBezoutEntry217.entry s)).locals "mlen".toList=some (.uint64,none)
  rfl

theorem u_base (s : State) : (BezoutPointerSetup217.after s).arrays "u".toList=some Gp := rfl
theorem v_base (s : State) : (BezoutPointerSetup217.after s).arrays "v".toList=some Fp := rfl

theorem length_frame (s : State) (X Y : Nat → BitVec 32) (name : Name)
    (dx : name≠"xlen".toList) (dy : name≠"ylen".toList) :
    (ExactLengthCalls217.after s X Y).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep _ "ylen".toList .uint64 _ name dy).trans
    (SelectedStepAddPrime195.locals_keep s "xlen".toList .uint64 _ name dx)

theorem more_frame (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (name : Name)
    (da : name≠"alen".toList) (db : name≠"blen".toList) :
    (SelectedBezoutInitMoreCells217.after s nx ny W).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (BezoutInitStore217.withA s nx) "blen".toList .uint64 (.uint64 (word ny)) name db).trans
    (SelectedStepAddPrime195.locals_keep s "alen".toList .uint64 (.uint64 (word nx)) name da)

theorem more_size (s : State) (nx ny : Nat) (W : Nat → BitVec 32) :
    (SelectedBezoutInitMoreCells217.after s nx ny W).heap.size=s.heap.size := rfl
theorem more_writable (s : State) (nx ny : Nat) (W : Nat → BitVec 32) :
    (SelectedBezoutInitMoreCells217.after s nx ny W).heap.writable=s.heap.writable := rfl

end FT1536.Source3.BezoutUpperCells217
