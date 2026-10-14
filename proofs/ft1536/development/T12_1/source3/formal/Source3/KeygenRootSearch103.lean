import Source3.KeygenDeepest103

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRootSearch103
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenRootSearch

theorem start (ctx : Context) (before a b : State)
    (first : Start ctx before a) (second : Start ctx before b) : a = b := by
  cases first
  cases second
  grind only [KeygenSearchPointer100.logn, KeygenSearchPointer100.ternary,
    C99ScalarCallsDeterminism089.array_scalar]

theorem call (ctx : Context) (kind : Kind) (before a b : State) (x y : Value)
    (first : Call ctx kind before a x) (second : Call ctx kind before b y) : a = b ∧ x = y := by
  cases kind
  · exact KeygenDeepest103.call_unique ctx before a b x y first second
  · exact KeygenIntermediateCall102.call_unique ctx before a b x y first second
  · exact KeygenDepthZero100.call_unique ctx before a b x y first second

theorem gate (ctx : Context) (kind : Kind) (before : State) (a b : Result)
    (first : Gate ctx kind before a) (second : Gate ctx kind before b) : a = b := by
  cases first <;> cases second
  all_goals grind only [→ call]

theorem post (before a b : State) (x y : Value)
    (first : Post before a x) (second : Post before b y) : a = b ∧ x = y := by
  cases first
  cases second
  grind only [C99ScalarCallsDeterminism089.array_scalar, C99IntegerReference.arithmetic_deterministic,
    C99ScalarDeterminism089.compare_unique]

theorem loop (ctx : Context) (before : State) (a b : Result)
    (first : Loop ctx before a) (second : Loop ctx before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [→ post, gate]

theorem depth (ctx : Context) (before : State) (a b : Result)
    (first : DepthBody ctx before a) (second : DepthBody ctx before b) : a = b := by
  cases first <;> cases second
  all_goals grind only [loop, gate]

theorem dispatch (ctx : Context) (before : State) (a b : Result)
    (first : Dispatch ctx before a) (second : Dispatch ctx before b) : a = b := by
  cases first
  cases second
  grind only [C99ScalarCallsDeterminism089.array_scalar, depth]

theorem execution (ctx : Context) (before : State) (a b : Result)
    (first : Exec ctx before a) (second : Exec ctx before b) : a = b := by
  cases first <;> cases second
  all_goals grind only [start, gate, dispatch]

end FT1536.Source3.KeygenRootSearch103
