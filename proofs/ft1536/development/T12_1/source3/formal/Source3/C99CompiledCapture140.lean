import Source3.C99ProcedureCapture138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99CompiledCapture140
open C99CompactState115 (State reference)
open C99MemoryReference (ArrayPointer)
open C99FiniteMemory114 (Block)

/-- Complete-state normalization consumes the checker source proof explicitly. -/
theorem source (program : C99ProcedureReference.Program)
    (condition : CLogic.Expr) (body increment : C99ProcedureReference.Stmt) (count : Nat)
    (before : State) (result : Option State)
    (checkedSource : ∀ after, result=some after →
      C99ProcedureSegments136.Prefix program condition body increment count (reference before) (reference after))
    (name : C99ArrayReference.Name) (pointer : ArrayPointer) (data : Block)
    (locals : C99CompactCells115.Locals)
    (bodyChecked : C99ProcedureFrame138.only [name] body=true)
    (incrementChecked : C99ProcedureFrame138.only [name] increment=true)
    (bodyArrays : KeygenAttemptSlots.procedureOnly body=true)
    (incrementArrays : KeygenAttemptSlots.procedureOnly increment=true)
    (binding : (reference before).arrays name=some pointer)
    (computed : C99ProcedureCapture138.capture result pointer.block=some (data,locals)) :
    C99ProcedureSegments136.Prefix program condition body increment count (reference before)
      (reference (C99ProcedureNormalize138.normalize before pointer.block data locals)) := by
  obtain ⟨after,run,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨block,found,outcome⟩ := Option.bind_eq_some_iff.mp rest
  have same := Prod.mk.inj (Option.some.inj outcome)
  rw [same.1] at found
  exact C99ProcedureNormalize138.source_normalized program condition body increment count before after name pointer data locals
    (checkedSource after run) bodyChecked incrementChecked bodyArrays incrementArrays binding found same.2

end FT1536.Source3.C99CompiledCapture140
