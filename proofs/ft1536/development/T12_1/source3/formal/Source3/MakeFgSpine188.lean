import Source3.SelectedStepReady187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgSpine188
open KeygenMakeFgSource (Stmt)
open MakeFgSequence187 (append)

def drop : Nat → Stmt → Stmt
  | 0,code => code
  | n+1,.seq _ tail => drop n tail
  | _+1,code => code

def take : Nat → Stmt → List Stmt
  | 0,_ => []
  | n+1,.seq head tail => head::take n tail
  | _+1,_ => []

theorem partition (n : Nat) (code : Stmt) : code=append (take n code) (drop n code) := by
  induction n generalizing code with
  | zero => rfl
  | succ n ih =>
    cases code with
    | seq head tail =>
      change Stmt.seq head tail=Stmt.seq head (append (take n tail) (drop n tail))
      exact congrArg (Stmt.seq head) (ih tail)
    | _ => rfl

end FT1536.Source3.MakeFgSpine188
