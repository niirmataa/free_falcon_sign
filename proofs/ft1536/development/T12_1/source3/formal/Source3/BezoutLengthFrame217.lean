import Source3.ExactLengthFrame217
import Source3.BezoutPointerCells217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutLengthFrame217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open NinthStepLayout217 (fd gd)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open ExactLengthCalls217 (after)

theorem source (rebuilt : State) (X Y : Nat → BitVec 32)
    (xf : Data (BezoutPointerSetup217.after rebuilt) fd 335 X)
    (yf : Data (BezoutPointerSetup217.after rebuilt) gd 335 Y) :
    KeygenZintCall.Exec (KeygenZintCall.bezoutPart 2) (BezoutPointerSetup217.after rebuilt)
      ⟨after (BezoutPointerSetup217.after rebuilt) X Y,.normal⟩ ∧
    Cell (after (BezoutPointerSetup217.after rebuilt) X Y) "xlen".toList (highest X 335) ∧
    Cell (after (BezoutPointerSetup217.after rebuilt) X Y) "ylen".toList (highest Y 335) ∧
    Data (after (BezoutPointerSetup217.after rebuilt) X Y) fd 335 X ∧
    Data (after (BezoutPointerSetup217.after rebuilt) X Y) gd 335 Y := by
  exact ExactLengthFrame217.source (BezoutPointerSetup217.after rebuilt) fd gd X Y
    (BezoutPointerSetup217.x_binding rebuilt) (BezoutPointerSetup217.y_binding rebuilt)
    (BezoutPointerCells217.len rebuilt) (by decide) (by decide) xf yf
    (BezoutPointerCells217.xdecl rebuilt) (BezoutPointerCells217.ydecl rebuilt)

end FT1536.Source3.BezoutLengthFrame217
