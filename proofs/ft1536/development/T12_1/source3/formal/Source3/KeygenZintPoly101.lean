import Source3.KeygenZintScaled101

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenZintPoly101
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenZintPoly

def checkedCode : Stmt → Bool
  | .base code => KeygenZintTop101.checkedCode code
  | .scaledStore _ _ _ e => KeygenWordArity096.checkedExpr e
  | .seq a b => checkedCode a && checkedCode b
  | .scope _ _ body => checkedCode body
  | .branch e a b | .loop e a b => KeygenWordArity096.checkedExpr e && checkedCode a && checkedCode b

theorem execution (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec code before a) (second : Exec code before b) : a = b := by
  have calls := C99ScalarCallsDeterminism089.prefix_calls
  unfold C99ScalarDeterminism089.Deterministic at calls
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [KeygenZintTop101.execution, → KeygenZintTop101.call_unique,
    KeygenWordArity096.expression,
    C99ScalarCallsDeterminism089.array_pointer, C99HeapDeterminism089.store64]

theorem maxBitlength0 : checkedCode (part .maxBitlength 0) = true := by decide +kernel
theorem maxBitlength1 : checkedCode (part .maxBitlength 1) = true := by decide +kernel
theorem maxBitlength2 : checkedCode (part .maxBitlength 2) = true := by decide +kernel
theorem maxBitlength3 : checkedCode (part .maxBitlength 3) = true := by decide +kernel
theorem bigToFp0 : checkedCode (part .bigToFp 0) = true := by decide +kernel
theorem bigToFp1 : checkedCode (part .bigToFp 1) = true := by decide +kernel
theorem bigToFp2 : checkedCode (part .bigToFp 2) = true := by decide +kernel

theorem chain_checked (codes : List Stmt) (checked : ∀ c ∈ codes, checkedCode c = true) : checkedCode (chain codes) = true := by
  induction codes with
  | nil => rfl
  | cons c rest ih => exact Bool.and_eq_true_iff.mpr ⟨checked c (by simp), ih (fun d member => checked d (by simp [member]))⟩

theorem body_checked (kind : Kind) : checkedCode (code kind) = true := by
  cases kind
  case maxBitlength =>
    apply chain_checked
    intro c member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl | rfl
    · exact maxBitlength0
    · exact maxBitlength1
    · exact maxBitlength2
    · exact maxBitlength3
  case bigToFp =>
    apply chain_checked
    intro c member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl | rfl
    · exact bigToFp0
    · exact bigToFp1
    · exact bigToFp2

theorem max_parsed (i : Fin 4) : parsed .maxBitlength i = some (part .maxBitlength i) := by
  fin_cases i
  · exact parsed_part .maxBitlength 0 max_audit0
  · exact parsed_part .maxBitlength 1 max_audit1
  · exact parsed_part .maxBitlength 2 max_audit2
  · exact parsed_part .maxBitlength 3 max_audit3

theorem fp_parsed (i : Fin 3) : parsed .bigToFp i = some (part .bigToFp i) := by
  fin_cases i
  · exact parsed_part .bigToFp 0 fp_audit0
  · exact parsed_part .bigToFp 1 fp_audit1
  · exact parsed_part .bigToFp 2 fp_audit2

theorem body_unique (kind : Kind) (before : State) (a b : Result)
    (first : Exec (code kind) before a) (second : Exec (code kind) before b) : a = b :=
  execution _ before a b (body_checked kind) first second

theorem call_unique (kind : Kind) (before a b : State) (args : List C99ArrayReference.Arg) (x y : Option Value)
    (first : Call kind before args a x) (second : Call kind before args b y) : a = b ∧ x = y := by
  obtain ⟨entry1, out1, binding1, source1, returned1, state1⟩ := first
  obtain ⟨entry2, out2, binding2, source2, returned2, state2⟩ := second
  have entries := C99ArrayDeterminism089.parameters before _ args entry1 entry2 binding1 binding2
  subst entry2
  have outcomes := body_unique kind entry1 out1 out2 source1 source2
  subst out2
  exact ⟨state1.trans state2.symm, C99ProcedureDeterminism094.returned _ _ x y returned1 returned2⟩

end FT1536.Source3.KeygenZintPoly101
