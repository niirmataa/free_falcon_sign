import Source3.KeygenSmall103

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenOutputGate103
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenOutputGateSource

theorem call (ctx : Context) (args : List Argument) (before a b : State) (x y : Value)
    (first : Call ctx args before a x) (second : Call ctx args before b y) : a = b ∧ x = y := by
  cases first
  cases second
  grind only [C99ArrayDeterminism089.parameters, KeygenSmall103.body_unique]

theorem condition_unique (ctx : Context) (code : Condition) (before a b : State) (x y : Bool)
    (first : Evaluate ctx code before a x) (second : Evaluate ctx code before b y) : a = b ∧ x = y := by
  induction first generalizing b y <;> cases second
  all_goals grind only [→ call]

theorem rejected_checked : KeygenSmall103.checkedCode
    (.scope [] (KeygenSmallSource.chain [KeygenSmallSource.ret 0])) = true := by decide

theorem execution (ctx : Context) (before : State) (a b : Result)
    (first : Exec ctx before a) (second : Exec ctx before b) : a = b := by
  have rejected := KeygenSmall103.execution
    (.scope [] (KeygenSmallSource.chain [KeygenSmallSource.ret 0]))
  cases first <;> cases second
  all_goals grind only [→ condition_unique, rejected_checked]

theorem member (ctx : KeygenSearchContext.Context) (before : State) (a b : Result)
    (first : KeygenDepth0Call.MemberGate ctx before a) (second : KeygenDepth0Call.MemberGate ctx before b) : a = b := by
  obtain ⟨ter1, tmp1, member1, scratch1, source1⟩ := first
  obtain ⟨ter2, tmp2, member2, scratch2, source2⟩ := second
  have ht := KeygenSearchPointer100.ternary ctx before ter1 ter2 member1 member2
  have hp := KeygenSearchPointer100.tmp ctx before tmp1 tmp2 scratch1 scratch2
  subst ter2 tmp2
  exact execution _ before a b source1 source2

end FT1536.Source3.KeygenOutputGate103
