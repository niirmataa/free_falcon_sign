import Source3.NttForwardPrologue211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardCompose211
open C99ArrayReference (State)
open C99ModularReference (Stmt GenExec CallRelation chainOf)

def append : List Stmt → Stmt → Stmt
  | [],tail => tail
  | code::rest,tail => .seq code (append rest tail)

theorem source (calls : CallRelation) (steps : List Stmt) (tail : Stmt) (s mid : State) (out : C99ProcedureReference.Result)
    (head : GenExec calls (chainOf steps) s ⟨mid,.normal⟩) (rest : GenExec calls tail mid out) :
    GenExec calls (append steps tail) s out := by
  induction steps generalizing s with
  | nil =>
    cases head with | base _ _ _ run => cases run; exact rest
  | cons code codes ih =>
    cases head with
    | seqNormal _ _ _ next _ one more => exact .seqNormal _ _ _ next _ one (ih next more)
    | seqExit _ _ _ _ _ exit => exact False.elim (exit rfl)

end FT1536.Source3.NttForwardCompose211
