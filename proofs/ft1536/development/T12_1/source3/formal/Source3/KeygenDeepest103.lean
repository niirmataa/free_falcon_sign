import Source3.KeygenIntermediateCall102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDeepest103
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenDeepestSource

def checkedCode : Stmt → Bool
  | .base code => KeygenMakeFgDeterminism099.checkedCode code
  | .ternary a b | .seq a b => checkedCode a && checkedCode b
  | .logn _ | .tmp _ | .make => true

theorem execution (ctx : Context) (code : Stmt) (before : State) (a b : Result) (checked : checkedCode code = true)
    (first : Exec ctx code before a) (second : Exec ctx code before b) : a = b := by
  have base := KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step)
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [KeygenMakeFgCall099.body_unique, C99ArrayDeterminism089.parameters,
    KeygenSearchPointer100.logn, KeygenSearchPointer100.tmp, KeygenSearchPointer100.ternary]

theorem check0 : checkedCode (part 0) = true := by decide +kernel
theorem check1 : checkedCode (part 1) = true := by decide +kernel
theorem check2 : checkedCode (part 2) = true := by decide +kernel
theorem check3 : checkedCode (part 3) = true := by decide +kernel
theorem check4 : checkedCode (part 4) = true := by decide +kernel

theorem chain_checked (codes : List Stmt) (checked : ∀ c ∈ codes, checkedCode c = true) : checkedCode (chain codes) = true := by
  induction codes with
  | nil => rfl
  | cons c rest ih => exact Bool.and_eq_true_iff.mpr ⟨checked c (by simp), ih (fun d member => checked d (by simp [member]))⟩

theorem body_checked : checkedCode code = true := by
  apply chain_checked
  intro c member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl
  · exact check0
  · exact check1
  · exact check2
  · exact check3
  · exact check4

theorem parsed (i : Fin 5) : KeygenDeepestSource.parsed i = some (part i) := by
  fin_cases i
  · exact parsed_part 0 audit0
  · exact parsed_part 1 audit1
  · exact parsed_part 2 audit2
  · exact parsed_part 3 audit3
  · exact parsed_part 4 audit4

theorem body_unique (ctx : Context) (before : State) (a b : Result)
    (first : Exec ctx code before a) (second : Exec ctx code before b) : a = b :=
  execution ctx _ before a b body_checked first second

theorem call_unique (ctx : Context) (before a b : State) (x y : Value)
    (first : KeygenDeepestSource.Call ctx before a x) (second : KeygenDeepestSource.Call ctx before b y) : a = b ∧ x = y := by
  cases first with
  | run entry1 out1 x binding1 source1 returned1 =>
      cases second with
      | run entry2 out2 y binding2 source2 returned2 =>
          have entries := C99ArrayDeterminism089.parameters before _ _ entry1 entry2 binding1 binding2
          subst entry2
          have outcomes := body_unique ctx entry1 out1 out2 source1 source2
          cases outcomes
          exact ⟨rfl, Option.some.inj (C99ProcedureDeterminism094.returned _ _ _ _ returned1 returned2)⟩

noncomputable def runCall (ctx : Context) (before : State) : Part (State × Value) where
  Dom := ∃ result : State × Value, KeygenDeepestSource.Call ctx before result.1 result.2
  get domain := Classical.choose domain

theorem runCall_spec (ctx : Context) (before : State) (out : State × Value) :
    out ∈ runCall ctx before ↔ KeygenDeepestSource.Call ctx before out.1 out.2 := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result : State × Value, KeygenDeepestSource.Call ctx before result.1 result.2 := ⟨out, source⟩
    have same := call_unique ctx before (Classical.choose domain).1 out.1 (Classical.choose domain).2 out.2
      (Classical.choose_spec domain) source
    exact ⟨domain, Prod.ext same.1 same.2⟩

end FT1536.Source3.KeygenDeepest103
