import Source3.KeygenIntermediateValue102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediateCalls102
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open KeygenIntermediateCalls

theorem binary (kind : KeygenBinaryNtt.Kind) (before : State) (a b : Result)
    (first : KeygenBinaryNtt.Exec (KeygenBinaryNtt.code kind) before a)
    (second : KeygenBinaryNtt.Exec (KeygenBinaryNtt.code kind) before b) : a = b :=
  KeygenBinaryDeterminism097.execution _ before a b (KeygenBinaryDeterminism097.body_checked kind) first second

theorem ternary (kind : KeygenLevelCalls.Kind) (before : State) (a b : Result)
    (first : C99ModularReference.Exec (KeygenLevelCalls.body kind) before a)
    (second : C99ModularReference.Exec (KeygenLevelCalls.body kind) before b) : a = b :=
  C99ModularArity096.execution_unique _ before a b (KeygenLevelArity097.body kind) first second

theorem body_unique (kind : Kind) (before : State) (a b : Result)
    (first : Body kind before a) (second : Body kind before b) : a = b := by
  cases first <;> cases second
  all_goals grind only [KeygenZintCall098.body_unique, KeygenMakeFgCall099.body_unique,
    KeygenZintPoly101.body_unique, KeygenPolyScaled101.body_unique, KeygenPolyNtt101.body_unique,
    binary, ternary, C99ProcedureDeterminism094.execution]

theorem call_unique (ctx : Context) (kind : Kind) (before a b : State) (args : List Arg) (x y : Option Value)
    (checked : KeygenIntermediateValue102.checkedArgs args = true)
    (first : Call ctx kind before args a x) (second : Call ctx kind before args b y) : a = b ∧ x = y := by
  cases first with
  | run entry1 out1 x binding1 source1 returned1 =>
      cases second with
      | run entry2 out2 y binding2 source2 returned2 =>
          have entries := KeygenIntermediateValue102.binding ctx before _ args entry1 entry2 checked binding1 binding2
          subst entry2
          have outcomes := body_unique kind entry1 out1 out2 source1 source2
          cases outcomes
          exact ⟨rfl, C99ProcedureDeterminism094.returned _ _ x y returned1 returned2⟩

end FT1536.Source3.KeygenIntermediateCalls102
