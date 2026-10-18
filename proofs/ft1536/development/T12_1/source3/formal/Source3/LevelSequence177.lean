import Source3.SelectedMakeFgTopEntry176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.LevelSequence177
open KeygenLevelExec (Stmt Exec)
open C99ArrayReference (State)

def append (steps : List Stmt) (tail : Stmt) : Stmt := steps.foldr Stmt.seq tail
inductive Run : List Stmt → State → State → Prop where
  | nil (s : State) : Run [] s s
  | cons (code : Stmt) (rest : List Stmt) (before middle after : State)
      (head : Exec code before ⟨middle,.normal⟩) (tail : Run rest middle after) :
      Run (code::rest) before after

theorem source (steps : List Stmt) (before after : State) (run : Run steps before after)
    (tail : Stmt) (out : C99ProcedureReference.Result) (rest : Exec tail after out) :
    Exec (append steps tail) before out := by
  induction run with
  | nil => exact rest
  | cons code codes before middle after head _ ih =>
    exact .seqNormal _ _ before middle out head (ih rest)

def drop : Nat → Stmt → Stmt
  | 0,code => code
  | n+1,.seq _ tail => drop n tail
  | _+1,code => code

def arrayCode (code : C99ArrayReference.Stmt) : Stmt := .modular (.base code)
theorem array_source (code : C99ArrayReference.Stmt) (before after : State)
    (source : C99ArrayReference.Exec FftLeafPrograms.program code before after) :
    Exec (arrayCode code) before ⟨after,.normal⟩ := .modular _ _ _ (.base _ _ _ source)

end FT1536.Source3.LevelSequence177
