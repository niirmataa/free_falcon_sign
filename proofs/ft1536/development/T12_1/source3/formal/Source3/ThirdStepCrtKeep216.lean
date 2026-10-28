import Source3.ThirdStepCrt215

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Product columns are outside the fs/gs CRT data and gm scratch writes. -/
namespace FT1536.Source3.ThirdStepCrtKeep216
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open SecondStepProduct203 (root)
open SecondStepGeometry203 (scratch)
open ThirdStepLayout215 (fs gs gm)
open StepProductFixed203 (Image)

theorem column {s out : State} (keep : ThirdStepCrt215.Keeps s out) (side : Side) (k : Nat) (kb : k<6)
    (p pi r2 : BitVec 32) (w : Nat → BitVec 32) (before : Image s (root side) k 6 64 p pi r2 w 64) :
    Image out (root side) k 6 64 p pi r2 w 64 := by
  intro i bound
  apply keep (addr (root side) k i.val 6) _
  · intro j jb
    cases side
    · change Separate (scratch (1438+j)) (scratch (670+k+i.val*6))
      exact ThirdStepCrt215.sep_at (by have h:=i.isLt; omega)
    · change Separate (scratch (1438+j)) (scratch (1054+k+i.val*6))
      exact ThirdStepCrt215.sep_at (by have h:=i.isLt; omega)
  · intro j jb
    cases side
    · change Separate (scratch (1822+j)) (scratch (670+k+i.val*6))
      exact ThirdStepCrt215.sep_at (by have h:=i.isLt; omega)
    · change Separate (scratch (1822+j)) (scratch (1054+k+i.val*6))
      exact ThirdStepCrt215.sep_at (by have h:=i.isLt; omega)
  · intro j jb
    cases side
    · change Separate (scratch (2206+j)) (scratch (670+k+i.val*6))
      exact ThirdStepCrt215.sep_at (by have h:=i.isLt; omega)
    · change Separate (scratch (2206+j)) (scratch (1054+k+i.val*6))
      exact ThirdStepCrt215.sep_at (by have h:=i.isLt; omega)
  · exact before i bound

end FT1536.Source3.ThirdStepCrtKeep216
