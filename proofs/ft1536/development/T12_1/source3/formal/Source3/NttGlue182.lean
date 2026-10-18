import Source3.SelectedForwardEntry182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttGlue182
open C99ArrayReference (State)
open C99ModularReference (Stmt Exec)

theorem source (head : Stmt) (before middle : State) (run : Exec head before ⟨middle,.normal⟩)
    (tail : Stmt) (out : C99ProcedureReference.Result) (rest : Exec tail middle out) :
    Exec (KeygenNttForwardPrograms.glue head tail) before out := by
  induction head generalizing before middle with
  | seq a b _ ih =>
    cases run with
    | seqNormal _ _ _ mid _ first second => exact .seqNormal _ _ before mid out first (ih mid middle second rest)
    | seqExit _ _ _ _ _ exit => exact (exit rfl).elim
  | base code =>
    cases code with
    | skip =>
      cases run with
      | base _ _ _ source => cases source; exact rest
    | _ => exact .seqNormal _ _ before middle out run rest
  | _ => exact .seqNormal _ _ before middle out run rest

end FT1536.Source3.NttGlue182
