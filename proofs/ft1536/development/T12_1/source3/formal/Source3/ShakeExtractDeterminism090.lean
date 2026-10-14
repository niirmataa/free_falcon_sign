import Source3.C99ArrayDeterminism089
import Source3.ShakeSeedDeterminism089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractDeterminism090
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open ShakeExtractSource (Layout)

theorem encode_execution (code : List ShakeEncode.Instruction) (before a b : State)
    (first : ShakeEncode.Exec code before a) (second : ShakeEncode.Exec code before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [C99ScalarCallsDeterminism089.array_pointer,
    C99ScalarCallsDeterminism089.array_scalar, C99HeapDeterminism089.store8]

theorem encode_invoke (before : State) (p : ArrayPointer) (v : Value) (a b : State)
    (first : ShakeEncode.Invoke before p v a) (second : ShakeEncode.Invoke before p v b) : a = b := by
  cases first
  cases second
  grind only [C99ArrayDeterminism089.execution, encode_execution]

/-- Source extraction is deterministic for a fixed initial state and fixed
    output object. Relocation between different fresh temporary output
    objects is a separate get_rng_u64 obligation. -/
theorem execution (ctx : Layout) (code : ShakeExtractSource.Stmt) (before a b : State)
    (first : ShakeExtractSource.Exec ctx code before a)
    (second : ShakeExtractSource.Exec ctx code before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [ShakeBlockDeterminism089.scalar, ShakeBlockDeterminism089.expression,
    C99ScalarCallsDeterminism089.array_pointer, C99ScalarCallsDeterminism089.array_scalar,
    load64_deterministic, C99HeapDeterminism089.store64, C99HeapDeterminism089.pointer_add,
    memcpy_deterministic, encode_invoke, ShakeBlockDeterminism089.process]

theorem call (ctx : Layout) (before : State) (p : ArrayPointer) (length : Value) (a b : State)
    (first : ShakeExtractFrame.Call ctx before p length a)
    (second : ShakeExtractFrame.Call ctx before p length b) : a = b := by
  cases first
  cases second
  grind only [execution]

end FT1536.Source3.ShakeExtractDeterminism090
