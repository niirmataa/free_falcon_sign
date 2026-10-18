import Source3.SelectedStepLengths187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgSequence187
open KeygenMakeFgSource (Stmt Exec)
open C99ArrayReference (State)

def append (steps : List Stmt) (tail : Stmt) : Stmt := steps.foldr Stmt.seq tail
inductive Run : List Stmt → State → State → Prop where
  | nil (s : State) : Run [] s s
  | cons (code : Stmt) (rest : List Stmt) (before middle after : State)
      (head : Exec code before ⟨middle,.normal⟩) (tail : Run rest middle after) : Run (code::rest) before after

theorem source (steps : List Stmt) (before after : State) (run : Run steps before after)
    (tail : Stmt) (out : C99ProcedureReference.Result) (rest : Exec tail after out) : Exec (append steps tail) before out := by
  induction run with
  | nil => exact rest
  | cons code codes before middle after head _ ih => exact .seqNormal _ _ before middle out head (ih rest)

end FT1536.Source3.MakeFgSequence187
