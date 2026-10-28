import Source3.ThirdStepExtra215

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ThirdStepExtraFrame216
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open SecondStepCopy203 (Side)
open SecondStepProduct203 (root)
open StepCopyBody190 (addr)
open StepProductFixed203 (Image)
open ThirdStepExtraInner215 (Earlier)

def ThreeKeep (s out : State) : Prop :=
  ∀ q old, Earlier 3 q → Earlier 4 q → Earlier 5 q → Load32 s.heap q old → Load32 out.heap q old

theorem earlier_column {s out : State} (keep : ThreeKeep s out) (side : Side) (k : Nat) (kb : k<3)
    (p pi r2 : BitVec 32) (w : Nat → BitVec 32) (image : Image s (root side) k 6 64 p pi r2 w 64) :
    Image out (root side) k 6 64 p pi r2 w 64 := by
  intro i bound
  exact keep (addr (root side) k i.val 6) _
    (ThirdStepExtra215.earlier_col side 3 k (by decide) (by omega) (by omega) i.val i.isLt)
    (ThirdStepExtra215.earlier_col side 4 k (by decide) (by omega) (by omega) i.val i.isLt)
    (ThirdStepExtra215.earlier_col side 5 k (by decide) (by omega) (by omega) i.val i.isLt) (image i bound)

end FT1536.Source3.ThirdStepExtraFrame216
