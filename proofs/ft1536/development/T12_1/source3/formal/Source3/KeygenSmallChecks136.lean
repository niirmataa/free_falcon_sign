import Source3.KeygenSmallShape136
import Source3.C99ProcedureNormalize136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSmallChecks136

theorem body_writes : C99ProcedureFrame136.only ["x".toList] KeygenSmallShape136.iteration=true := by decide +kernel
theorem increment_writes : C99ProcedureFrame136.only ["x".toList] SmallintsProgram.increment=true := by decide +kernel
theorem body_arrays : KeygenAttemptSlots.procedureOnly KeygenSmallShape136.iteration=true := by decide +kernel
theorem increment_arrays : KeygenAttemptSlots.procedureOnly SmallintsProgram.increment=true := by decide +kernel

theorem pointer_after (before : C99CompactState115.State) (name : C99ArrayReference.Name)
    (pointer : C99MemoryReference.ArrayPointer) (data : C99FiniteMemory114.Block)
    (locals : C99CompactCells115.Locals)
    (binding : (C99CompactState115.reference before).arrays name=some pointer) :
    (C99CompactState115.reference (C99ProcedureNormalize136.normalize before pointer.block data locals)).arrays name=some pointer := binding

end FT1536.Source3.KeygenSmallChecks136
