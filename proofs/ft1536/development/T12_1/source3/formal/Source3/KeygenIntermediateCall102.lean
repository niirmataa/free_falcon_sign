import Source3.KeygenIntermediateArity102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediateCall102
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem body_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenIntermediateExec.Exec ctx KeygenIntermediateSource.code before a)
    (second : KeygenIntermediateExec.Exec ctx KeygenIntermediateSource.code before b) : a = b :=
  KeygenIntermediateDeterminism102.execution ctx _ before a b KeygenIntermediateArity102.body_checked first second

theorem call_unique (ctx : Context) (before a b : State) (x y : Value)
    (first : KeygenIntermediateSource.Call ctx before a x) (second : KeygenIntermediateSource.Call ctx before b y) : a = b ∧ x = y := by
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
  Dom := ∃ result : State × Value, KeygenIntermediateSource.Call ctx before result.1 result.2
  get domain := Classical.choose domain

theorem runCall_spec (ctx : Context) (before : State) (out : State × Value) :
    out ∈ runCall ctx before ↔ KeygenIntermediateSource.Call ctx before out.1 out.2 := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result : State × Value, KeygenIntermediateSource.Call ctx before result.1 result.2 := ⟨out, source⟩
    have same := call_unique ctx before (Classical.choose domain).1 out.1 (Classical.choose domain).2 out.2
      (Classical.choose_spec domain) source
    exact ⟨domain, Prod.ext same.1 same.2⟩

end FT1536.Source3.KeygenIntermediateCall102
