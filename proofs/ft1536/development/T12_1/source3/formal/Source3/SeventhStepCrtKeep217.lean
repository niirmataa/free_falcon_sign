import Source3.SeventhStepCrt217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Product columns are outside the fs/gs CRT data and gm scratch writes. -/
namespace FT1536.Source3.SeventhStepCrtKeep217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open SeventhStepProduct217 (root)
open SecondStepGeometry203 (scratch)
open SeventhStepLayout217 (fs gs gm)
open StepProductFixed203 (Image)

theorem column {s out : State} (keep : SeventhStepCrt217.Keeps s out) (side : Side) (k : Nat) (kb : k<82)
    (p pi r2 : BitVec 32) (w : Nat → BitVec 32) (before : Image s (root side) k 82 4 p pi r2 w 4) :
    Image out (root side) k 82 4 p pi r2 w 4 := by
  intro i bound
  apply keep (addr (root side) k i.val 82) _
  · intro j jb
    cases side
    · change Separate (scratch (1326+j)) (scratch (670+k+i.val*82))
      exact SeventhStepCrt217.sep_at (by have h:=i.isLt; omega)
    · change Separate (scratch (1326+j)) (scratch (998+k+i.val*82))
      exact SeventhStepCrt217.sep_at (by have h:=i.isLt; omega)
  · intro j jb
    cases side
    · change Separate (scratch (1662+j)) (scratch (670+k+i.val*82))
      exact SeventhStepCrt217.sep_at (by have h:=i.isLt; omega)
    · change Separate (scratch (1662+j)) (scratch (998+k+i.val*82))
      exact SeventhStepCrt217.sep_at (by have h:=i.isLt; omega)
  · intro j jb
    cases side
    · change Separate (scratch (1998+j)) (scratch (670+k+i.val*82))
      exact SeventhStepCrt217.sep_at (by have h:=i.isLt; omega)
    · change Separate (scratch (1998+j)) (scratch (998+k+i.val*82))
      exact SeventhStepCrt217.sep_at (by have h:=i.isLt; omega)
  · exact before i bound

end FT1536.Source3.SeventhStepCrtKeep217
