import Source3.C99ProcedureNormalize138
import Source3.C99ProcedureSegments138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ProcedureCapture138
open C99CompactState115 (State reference)
open C99MemoryReference (ArrayPointer)
open C99FiniteMemory114 (Block)

/-- One checked computation captures only the changed block and local cells.
    Source frames below identify every other component of the actual state. -/
def capture (result : Option State) (block : Nat) : Option (Block × C99CompactCells115.Locals) := do
  let after ← result
  let data ← C99FiniteMap114.lookup after.heap.blocks block
  pure (data,after.locals)

theorem source (program : C99ProcedureReference.Program) (calls : B20.C.Scalar.Calls)
    (callsSound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls)
    (fuel : Nat) (condition : CLogic.Expr) (body increment : C99ProcedureReference.Stmt) (count : Nat)
    (before : State) (name : C99ArrayReference.Name) (pointer : ArrayPointer) (data : Block)
    (locals : C99CompactCells115.Locals)
    (bodyChecked : C99ProcedureFrame138.only [name] body=true)
    (incrementChecked : C99ProcedureFrame138.only [name] increment=true)
    (bodyArrays : KeygenAttemptSlots.procedureOnly body=true)
    (incrementArrays : KeygenAttemptSlots.procedureOnly increment=true)
    (binding : (reference before).arrays name=some pointer)
    (computed : capture (C99ProcedureSegments138.run calls fuel condition body increment count before) pointer.block=some (data,locals)) :
    C99ProcedureSegments136.Prefix program condition body increment count (reference before)
      (reference (C99ProcedureNormalize138.normalize before pointer.block data locals)) := by
  obtain ⟨after,run,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨block,found,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Prod.mk.inj (Option.some.inj result)
  rw [same.1] at found
  exact C99ProcedureNormalize138.source_normalized program condition body increment count before after name pointer data locals
    (C99ProcedureSegments138.run_source program calls callsSound fuel condition body increment count before after run)
    bodyChecked incrementChecked bodyArrays incrementArrays binding found same.2

end FT1536.Source3.C99ProcedureCapture138
