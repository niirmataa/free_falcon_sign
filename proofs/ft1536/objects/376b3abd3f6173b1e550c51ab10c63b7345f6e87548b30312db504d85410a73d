import Source3.C99ProcedureReference

namespace FT1536.Source3.C99SequenceInversion
open C99ArrayReference (State)
open C99ProcedureReference

theorem continuation (program : Program) (first tail : Stmt) (before middle : State) (result : Result)
    (unique : ∀ out, Exec program first before out → out=⟨middle,.normal⟩)
    (source : Exec program (.seq first tail) before result) : Exec program tail middle result := by
  cases source with
  | seqNormal _ _ _ actual _ head rest =>
      have he : actual=middle := congrArg Result.state (unique ⟨actual,.normal⟩ head)
      subst actual
      exact rest
  | seqExit _ _ _ _ head exit =>
      exact False.elim (exit (congrArg Result.flow (unique result head)))

end FT1536.Source3.C99SequenceInversion
