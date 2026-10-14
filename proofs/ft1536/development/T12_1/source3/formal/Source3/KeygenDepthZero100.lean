import Source3.KeygenSearchDeterminism100

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDepthZero100
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem parsed (i : Fin 5) : KeygenDepth0Source.parsed i = some (KeygenDepth0Source.part i) :=
  KeygenDepth0Source.parsed_part i

theorem body_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenSearchExec.Exec ctx KeygenDepth0Source.code before a)
    (second : KeygenSearchExec.Exec ctx KeygenDepth0Source.code before b) : a = b :=
  KeygenSearchDeterminism100.execution ctx _ before a b first second

theorem call_unique (ctx : Context) (before a b : State) (x y : Value)
    (first : KeygenDepth0Call.Call ctx before a x) (second : KeygenDepth0Call.Call ctx before b y) : a = b ∧ x = y := by
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
  Dom := ∃ result : State × Value, KeygenDepth0Call.Call ctx before result.1 result.2
  get domain := Classical.choose domain

theorem runCall_spec (ctx : Context) (before : State) (out : State × Value) :
    out ∈ runCall ctx before ↔ KeygenDepth0Call.Call ctx before out.1 out.2 := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result : State × Value, KeygenDepth0Call.Call ctx before result.1 result.2 := ⟨out, source⟩
    have same := call_unique ctx before (Classical.choose domain).1 out.1 (Classical.choose domain).2 out.2
      (Classical.choose_spec domain) source
    exact ⟨domain, Prod.ext same.1 same.2⟩

end FT1536.Source3.KeygenDepthZero100
