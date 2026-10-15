import Source3.C99ProcedureRun138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99Chain139
open C99ProcedureReference (Stmt Exec Result Program)
open C99ProcedureParser (chain)
open C99ArrayReference (State)

theorem append (program : Program) (first rest : List Stmt) (before middle : State) (out : Result)
    (head : Exec program (chain first) before ⟨middle,.normal⟩)
    (tail : Exec program (chain rest) middle out) : Exec program (chain (first++rest)) before out := by
  induction first generalizing before with
  | nil =>
    cases head with
    | base code before after source =>
      cases source
      exact tail
  | cons code codes ih =>
    cases head with
    | seqNormal first second before next out source remaining =>
      exact .seqNormal _ _ _ _ _ source (ih next remaining)
    | seqExit first second before out source exit => exact (exit rfl).elim

end FT1536.Source3.C99Chain139
