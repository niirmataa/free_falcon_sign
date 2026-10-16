import Source3.KeygenPublicInputProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicAppendSource157
open C99ArrayReference (State Name)
open KeygenPublicExec (Program Stmt Exec)
open KeygenPublicInputProgram (append)

theorem source (program : Program) (signed : List Name) (first tail : Stmt) (before middle : State) (out : C99ProcedureReference.Result)
    (head : Exec program signed first before ⟨middle,.normal⟩) (rest : Exec program signed tail middle out) :
    Exec program signed (append first tail) before out := by
  induction first generalizing before with
  | skip => cases head; exact rest
  | seq a b _ ih =>
    cases head with
    | seqNormal _ _ _ next _ first second => exact .seqNormal _ _ _ _ _ first (ih next second)
    | seqExit _ _ _ _ _ exit => exact (exit rfl).elim
  | _ => exact .seqNormal _ _ _ _ _ head rest

end FT1536.Source3.PublicAppendSource157
