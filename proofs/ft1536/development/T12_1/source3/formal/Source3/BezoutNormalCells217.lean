import Source3.BezoutNormalNinv217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Declarations of x0i and y0i survive previous source initialization. -/
namespace FT1536.Source3.BezoutNormalCells217
open C99ArrayReference (State Name)
open C99NatWord141 (word)

theorem base (s : State) : (BezoutPointerSetup217.after s).locals "x0i".toList=some (.uint32,none) ∧
    (BezoutPointerSetup217.after s).locals "y0i".toList=some (.uint32,none) := by
  constructor <;> rfl

theorem frame (s : State) (nx ny : Nat) (W : Nat → BitVec 32) (name : Name)
    (da : name≠"alen".toList) (db : name≠"blen".toList) (dm : name≠"mlen".toList) :
    (BezoutABZero217.after (BezoutUpperSequence217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny).locals name=s.locals name := by
  change (BezoutMlen217.after (BezoutUpperZero217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny).locals name=s.locals name
  exact (SelectedStepAddPrime195.locals_keep _ "mlen".toList .uint64 (.uint64 (word (max nx ny))) name dm).trans
    (BezoutUpperCells217.more_frame s nx ny W name da db)

theorem x_decl (s : State) (nx ny : Nat) (W : Nat → BitVec 32)
    (declared : s.locals "x0i".toList=some (.uint32,none)) :
    (BezoutABZero217.after (BezoutUpperSequence217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny).locals "x0i".toList=some (.uint32,none) :=
  (frame s nx ny W "x0i".toList (by decide) (by decide) (by decide)).trans declared

theorem y_decl (s : State) (nx ny : Nat) (W : Nat → BitVec 32)
    (declared : s.locals "y0i".toList=some (.uint32,none)) :
    (BezoutABZero217.after (BezoutUpperSequence217.after (SelectedBezoutInitMoreCells217.after s nx ny W) nx ny) nx ny).locals "y0i".toList=some (.uint32,none) :=
  (frame s nx ny W "y0i".toList (by decide) (by decide) (by decide)).trans declared

end FT1536.Source3.BezoutNormalCells217
