import Source3.SixthStepCrt217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Product columns are outside the fs/gs CRT data and gm scratch writes. -/
namespace FT1536.Source3.SixthStepCrtKeep217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open SixthStepProduct217 (root)
open SecondStepGeometry203 (scratch)
open SixthStepLayout217 (fs gs gm)
open StepProductFixed203 (Image)

theorem column {s out : State} (keep : SixthStepCrt217.Keeps s out) (side : Side) (k : Nat) (kb : k<42)
    (p pi r2 : BitVec 32) (w : Nat → BitVec 32) (before : Image s (root side) k 42 8 p pi r2 w 8) :
    Image out (root side) k 42 8 p pi r2 w 8 := by
  intro i bound
  apply keep (addr (root side) k i.val 42) _
  · intro j jb
    cases side
    · change Separate (scratch (1342+j)) (scratch (670+k+i.val*42))
      exact SixthStepCrt217.sep_at (by have h:=i.isLt; omega)
    · change Separate (scratch (1342+j)) (scratch (1006+k+i.val*42))
      exact SixthStepCrt217.sep_at (by have h:=i.isLt; omega)
  · intro j jb
    cases side
    · change Separate (scratch (1694+j)) (scratch (670+k+i.val*42))
      exact SixthStepCrt217.sep_at (by have h:=i.isLt; omega)
    · change Separate (scratch (1694+j)) (scratch (1006+k+i.val*42))
      exact SixthStepCrt217.sep_at (by have h:=i.isLt; omega)
  · intro j jb
    cases side
    · change Separate (scratch (2046+j)) (scratch (670+k+i.val*42))
      exact SixthStepCrt217.sep_at (by have h:=i.isLt; omega)
    · change Separate (scratch (2046+j)) (scratch (1006+k+i.val*42))
      exact SixthStepCrt217.sep_at (by have h:=i.isLt; omega)
  · exact before i bound

end FT1536.Source3.SixthStepCrtKeep217
