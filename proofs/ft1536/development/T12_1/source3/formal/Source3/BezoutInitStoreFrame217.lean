import Source3.BezoutInitZeroFrame217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutInitStoreFrame217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open DeepestBezoutEntry217 (Fp Gp)
open BezoutInitStore217 (withA withB after)

theorem xlen (s : State) (nx ny : Nat) (cell : Cell s "xlen".toList nx) : Cell (after s nx ny) "xlen".toList nx :=
  (SelectedStepAddPrime195.locals_keep (withA s nx) "blen".toList .uint64 (.uint64 (word ny)) "xlen".toList (by decide)).trans
    ((SelectedStepAddPrime195.locals_keep s "alen".toList .uint64 (.uint64 (word nx)) "xlen".toList (by decide)).trans cell)

theorem ylen (s : State) (nx ny : Nat) (cell : Cell s "ylen".toList ny) : Cell (after s nx ny) "ylen".toList ny :=
  (SelectedStepAddPrime195.locals_keep (withA s nx) "blen".toList .uint64 (.uint64 (word ny)) "ylen".toList (by decide)).trans
    ((SelectedStepAddPrime195.locals_keep s "alen".toList .uint64 (.uint64 (word nx)) "ylen".toList (by decide)).trans cell)

theorem u0 (s : State) (nx ny : Nat) (h : s.arrays "u0".toList=some Gp) : (after s nx ny).arrays "u0".toList=some Gp := h
theorem v0 (s : State) (nx ny : Nat) (h : s.arrays "v0".toList=some Fp) : (after s nx ny).arrays "v0".toList=some Fp := h

theorem size (s : State) (nx ny : Nat) : (after s nx ny).heap.size=s.heap.size := rfl
theorem writable (s : State) (nx ny : Nat) : (after s nx ny).heap.writable=s.heap.writable := rfl

end FT1536.Source3.BezoutInitStoreFrame217
