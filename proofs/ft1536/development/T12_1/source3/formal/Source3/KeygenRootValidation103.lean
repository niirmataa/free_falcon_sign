import Source3.KeygenOutputGate103

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRootValidation103
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenRootValidationSource

theorem alias_checked : C99ModularArity096.checkedCode KeygenMkgm3Layout.aliasCode = true := by decide +kernel

theorem args_checked : KeygenLevelReads097.checkedArgs genArgs = true := by decide +kernel

theorem conversion_checked : C99ModularArity096.checkedCode KeygenResidueProgram.code = true := by decide +kernel

theorem target_checked : C99ModularArity096.checkedCode KeygenSolverTarget.code = true := by decide +kernel

theorem inverse (word : BitVec 32) (a b : Value)
    (first : KeygenNinv31.SourceExec word a) (second : KeygenNinv31.SourceExec word b) : a = b :=
  (KeygenNinv31.source_exact word a first).trans (KeygenNinv31.source_exact word b second).symm

theorem prepare (ctx : Context) (before a b : State)
    (first : Prepare ctx before a) (second : Prepare ctx before b) : a = b := by
  have aliasUnique := C99ModularArity096.execution_unique KeygenMkgm3Layout.aliasCode
  cases first
  cases second
  grind only [KeygenSearchPointer100.tmp, alias_checked, KeygenLevelReads097.prime, inverse]

theorem transforms (code : C99ProcedureReference.Stmt) (before a b : State)
    (first : KeygenSolverNttCalls.Exec code before a) (second : KeygenSolverNttCalls.Exec code before b) : a = b := by
  have forward := C99ModularArity096.execution_unique KeygenNttForwardPrograms.forwardBody
  induction first generalizing b <;> cases second
  all_goals grind only [C99ArrayDeterminism089.parameters, KeygenLevelArity097.forward]

theorem execution (ctx : Context) (before : State) (a b : Result)
    (first : Exec ctx before a) (second : Exec ctx before b) : a = b := by
  have generation := C99ModularArity096.execution_unique KeygenMkgm3Program.code
  have conversion := C99ModularArity096.execution_unique KeygenResidueProgram.code
  have validation := C99ModularArity096.execution_unique KeygenSolverTarget.code
  cases first
  cases second
  grind (ematch := 8) only [prepare, KeygenLevelReads097.parameters, args_checked, KeygenLevelArity097.generate,
    conversion_checked, KeygenRootValidation103.transforms, target_checked]

end FT1536.Source3.KeygenRootValidation103
