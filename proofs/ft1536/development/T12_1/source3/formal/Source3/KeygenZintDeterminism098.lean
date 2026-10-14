import Source3.KeygenZintLeafDet097

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenZintDeterminism098
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenZintCall

theorem memzero (before : Memory) (p : ArrayPointer) (count : Nat) (a b : Memory)
    (first : Memzero before p count a) (second : Memzero before p count b) : a = b := by
  obtain ⟨_, _, _, sa, wa, ba, fa⟩ := first
  obtain ⟨_, _, _, sb, wb, bb, fb⟩ := second
  exact C99HeapDeterminism089.write_unique before p count (fun _ => 0) a b
    ⟨sa, wa, fun i => ba i.val i.isLt, fa⟩ ⟨sb, wb, fun i => bb i.val i.isLt, fb⟩

theorem receive (dst : CDest) (before a b : State) (v : Option Value)
    (first : ReceiveC dst before v a) (second : ReceiveC dst before v b) : a = b := by
  cases first <;> cases second
  all_goals grind only [C99ScalarCallsDeterminism089.array_pointer, C99HeapDeterminism089.store32]

def checkedCode : Stmt → Bool
  | .word code => KeygenWordArity096.checkedCode code
  | .retSum a b => KeygenWordArity096.checkedExpr a && KeygenWordArity096.checkedExpr b
  | .call _ _ _ | .prime _ _ _ _ | .storePrime _ _ _ _ _ | .bitcastInto _ _ _
  | .static32 _ | .memzero _ _ _ | .breakLoop | .continueLoop | .retVoid => true
  | .callBranch _ _ _ _ a b | .seq a b => checkedCode a && checkedCode b
  | .branch e a b | .loop e a b => KeygenWordArity096.checkedExpr e && checkedCode a && checkedCode b
  | .scope _ _ body => checkedCode body

theorem execution (closed : ∀ kind, checkedCode (calleeBody kind) = true)
    (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec code before a) (second : Exec code before b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [KeygenWordArity096.execution, KeygenWordArity096.expression,
    C99ArrayDeterminism089.parameters, C99ProcedureDeterminism094.returned, receive,
    KeygenLevelReads097.prime, C99ScalarCallsDeterminism089.array_scalar,
    C99ScalarCallsDeterminism089.array_pointer, C99HeapDeterminism089.store32,
    C99ScalarDeterminism089.compare_unique, KeygenWordDeterminism093.binary, memzero]

end FT1536.Source3.KeygenZintDeterminism098
