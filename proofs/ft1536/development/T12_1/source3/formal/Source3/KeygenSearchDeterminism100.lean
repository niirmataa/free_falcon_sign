import Source3.KeygenSearchValue100

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSearchDeterminism100
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenSearchExec

/-- All fixed source callees of this language have been discharged.
    No read-footprint, arithmetic postcondition or callee oracle is a premise. -/
theorem execution (ctx : Context) (code : Stmt) (before : State) (a b : Result)
    (first : Exec ctx code before a) (second : Exec ctx code before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [C99ProcedureDeterminism094.execution, KeygenSearchPointer100.logn,
    KeygenSearchPointer100.pointer, KeygenSearchValue100.expression, KeygenNormLanguage094.small_call,
    KeygenLevelReads097.memmove, C99HeapDeterminism089.store32, C99HeapDeterminism089.store64,
    C99ScalarCallsDeterminism089.array_scalar, C99ScalarCallsDeterminism089.array_pointer]

end FT1536.Source3.KeygenSearchDeterminism100
