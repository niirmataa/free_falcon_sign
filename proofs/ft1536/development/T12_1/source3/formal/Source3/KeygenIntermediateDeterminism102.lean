import Source3.KeygenIntermediateCalls102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediateDeterminism102
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenIntermediateExec
open KeygenIntermediateValue102 (checkedExpr checkedArgs)

def checkedCode : Stmt → Bool
  | .assign _ e | .store _ _ e | .ret e => checkedExpr e
  | .call _ args _ => checkedArgs args
  | .seq a b => checkedCode a && checkedCode b
  | .scope _ _ body => checkedCode body
  | .branch e a b | .loop e a b => checkedExpr e && checkedCode a && checkedCode b
  | .skip | .scalar _ | .declarePtr _ | .pointer _ _ | .move _ _ _ | .breakLoop | .continueLoop => true

theorem execution (ctx : Context) (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec ctx code before a) (second : Exec ctx code before b) : a = b := by
  have scalar := C99ScalarDeterminism089.execution_unique FprPrefixCalls.calls C99ScalarCallsDeterminism089.prefix_calls
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [KeygenIntermediatePointer102.pointer, KeygenIntermediateValue102.expression,
    → KeygenIntermediateCalls102.call_unique, KeygenZintDeterminism098.receive,
    KeygenLevelReads097.memmove, C99ScalarCallsDeterminism089.array_scalar,
    C99ScalarCallsDeterminism089.array_pointer, C99HeapDeterminism089.store32]

theorem chain_checked (codes : List Stmt) (checked : ∀ c ∈ codes, checkedCode c = true) : checkedCode (chain codes) = true := by
  induction codes with
  | nil => rfl
  | cons c rest ih => exact Bool.and_eq_true_iff.mpr ⟨checked c (by simp), ih (fun d member => checked d (by simp [member]))⟩

end FT1536.Source3.KeygenIntermediateDeterminism102
