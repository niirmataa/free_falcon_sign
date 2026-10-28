import Source3.BezoutLoopGuard217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Small scalar frames through final initialization and loop-local r. -/
namespace FT1536.Source3.BezoutLoopCells217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)

def declareR (s : State) := C99DeclarationStatements.effect .i32 ["r".toList] s

theorem declare_keep (s : State) (name : List Char) (different : name≠"r".toList) :
    (declareR s).locals name=s.locals name := by
  have distinct : name≠['r'] := by simpa using different
  simp [declareR,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set,distinct]

theorem alen (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (x y : BitVec 32) (bound : nx<2^64) :
    Cell (declareR (BezoutNormalNinv217.after (BezoutABZero217.after (BezoutUpperSequence217.after
      (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny) x y)) "alen".toList nx := by
  have mid := SelectedBezoutInitMoreCells217.alen s nx ny W bound
  have upper : Cell (BezoutUpperSequence217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) "alen".toList nx :=
    (SelectedStepAddPrime195.locals_keep _ "mlen".toList .uint64 (.uint64 (word (max nx ny))) "alen".toList (by decide)).trans mid
  have afterAB : Cell (BezoutABZero217.after (BezoutUpperSequence217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny) "alen".toList nx := upper
  have afterX := (SelectedStepAddPrime195.locals_keep _ "x0i".toList .uint32 (.uint32 (KeygenNinv31.word x)) "alen".toList (by decide)).trans afterAB
  have afterY := (SelectedStepAddPrime195.locals_keep _ "y0i".toList .uint32 (.uint32 (KeygenNinv31.word y)) "alen".toList (by decide)).trans afterX
  exact (declare_keep _ "alen".toList (by decide)).trans afterY

theorem blen (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (x y : BitVec 32) (bound : ny<2^64) :
    Cell (declareR (BezoutNormalNinv217.after (BezoutABZero217.after (BezoutUpperSequence217.after
      (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny) x y)) "blen".toList ny := by
  have mid := SelectedBezoutInitMoreCells217.blen s nx ny W bound
  have upper : Cell (BezoutUpperSequence217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) "blen".toList ny :=
    (SelectedStepAddPrime195.locals_keep _ "mlen".toList .uint64 (.uint64 (word (max nx ny))) "blen".toList (by decide)).trans mid
  have afterAB : Cell (BezoutABZero217.after (BezoutUpperSequence217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny) "blen".toList ny := upper
  have afterX := (SelectedStepAddPrime195.locals_keep _ "x0i".toList .uint32 (.uint32 (KeygenNinv31.word x)) "blen".toList (by decide)).trans afterAB
  have afterY := (SelectedStepAddPrime195.locals_keep _ "y0i".toList .uint32 (.uint32 (KeygenNinv31.word y)) "blen".toList (by decide)).trans afterX
  exact (declare_keep _ "blen".toList (by decide)).trans afterY

theorem declaration (s : State) : KeygenZintCall.Exec (ZintNormWord194.wordScalar (.declare .i32 ["r".toList])) s ⟨declareR s,.normal⟩ :=
  ZintNormWord194.word_declare .i32 ["r".toList] s

end FT1536.Source3.BezoutLoopCells217
