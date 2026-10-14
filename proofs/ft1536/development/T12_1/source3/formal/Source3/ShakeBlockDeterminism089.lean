import Source3.C99ScalarCallsDeterminism089
import Source3.C99HeapDeterminism089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeBlockDeterminism089
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99MemoryReference
open C99ScalarDeterminism089

theorem read_name (a b : Name) : ShakeBlock.readName a = ShakeBlock.readName b ↔ a = b := by
  constructor
  · exact List.append_cancel_left
  · intro equal
    exact congrArg ShakeBlock.readName equal

theorem read_calls (s : State) : Deterministic (ShakeBlock.ReadCall s) := by
  intro name args a b first second
  cases first
  cases second
  grind only [read_name, C99HeapDeterminism089.pointer_add, load64_deterministic]

theorem expression (s : State) (e : CLogic.Expr) (a b : Value)
    (first : ShakeBlock.Eval s e a) (second : ShakeBlock.Eval s e b) : a = b :=
  expression_unique (ShakeBlock.ReadCall s) (read_calls s) s.locals (C99Frontend.expression e) a b first second

theorem scalar (s : State) (code : CLogic.Stmt) (a b : C99ScalarReference.Env)
    (first : C99ScalarReference.Exec (ShakeBlock.ReadCall s) s.locals (C99Frontend.scalar code) (.normal a))
    (second : C99ScalarReference.Exec (ShakeBlock.ReadCall s) s.locals (C99Frontend.scalar code) (.normal b)) : a = b := by
  have same := execution_unique (ShakeBlock.ReadCall s) (read_calls s) s.locals
    (C99Frontend.scalar code) (.normal a) (.normal b) first second
  cases same
  rfl

/-- Completed executions of the actual word-array semantics are unique.
    No ideal permutation, randomness or process_block specification is
    substituted for the pinned source body. -/
theorem execution (code : ShakeBlock.Stmt) (before a b : State)
    (first : ShakeBlock.Exec code before a) (second : ShakeBlock.Exec code before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [scalar, expression, C99ScalarCallsDeterminism089.array_pointer,
    C99HeapDeterminism089.store64]

theorem process (before : State) (ptr : ArrayPointer) (a b : State)
    (first : ShakeExtractSource.Process before ptr a) (second : ShakeExtractSource.Process before ptr b) :
    a = b := by
  cases first with
  | run table after binding static body =>
      cases second with
      | run table' after' binding' static' body' =>
          have tables := Option.some.inj (binding.symm.trans binding')
          subst table'
          have states := execution ShakeBlockProgram.code (ShakeExtractSource.blockEntry before ptr table)
            after after' body body'
          cases states
          rfl

end FT1536.Source3.ShakeBlockDeterminism089
