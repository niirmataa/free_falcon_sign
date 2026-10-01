import Source3.C99AliasSequence
import Source3.C99ProcedureScalars

namespace FT1536.Source3.C99AliasHeap
open C99ArrayReference (State)
open C99ProcedureReference (Exec Result Program)

theorem unchanged (program : Program) (aliases : List C99AliasSequence.Alias) (before : State) (result : Result)
    (source : Exec program (C99AliasSequence.thenCode aliases (.base .skip)) before result) : result.state.heap=before.heap := by
  induction aliases generalizing before with
  | nil =>
      have h := C99ProcedureScalars.skip_result program before result source
      rw [h]
  | cons aliasStep rest ih =>
      obtain ⟨middle,head,tail⟩ := C99ProcedureSequence.base_before_tail program
        (.bindPtr aliasStep.target aliasStep.source (C99AliasSequence.index aliasStep.next)) _ before result source
      cases head with
      | bindPtr _ _ _ _ p _ => exact ih (C99ArrayReference.bindPointer before aliasStep.target p) tail

end FT1536.Source3.C99AliasHeap
