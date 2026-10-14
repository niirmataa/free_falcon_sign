import Source3.C99CompactBinding115
import Source3.ShakeBlockProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeBlockComputeRead116
open C99ArrayReference (Name)
open C99CompactState115 (State reference)
open B20.C (Val)

def readArray (state : State) (array : Name) : List Val → Option Val
  | [index] => do
      let base ← C99NameMap115.lookup state.arrays array
      let pointer ← C99CompactPointer115.advance base index
      let word ← C99FiniteRead114.read64 state.heap pointer
      pure (.u64 word)
  | _ => none

theorem readArray_sound (state : State) (array : Name) (args : List Val) (value : Val)
    (computed : readArray state array args=some value) :
    ShakeBlock.ReadCall (reference state) (ShakeBlock.readName array)
      (args.map C99ValueBridge.value) (C99ValueBridge.value value) := by
  cases args with
  | nil => cases computed
  | cons index rest =>
      cases rest with
      | nil =>
          obtain ⟨base, found, tail⟩ := Option.bind_eq_some_iff.mp computed
          obtain ⟨pointer, advanced, tail⟩ := Option.bind_eq_some_iff.mp tail
          obtain ⟨word, loaded, result⟩ := Option.bind_eq_some_iff.mp tail
          have same := Option.some.inj result
          subst value
          have address := C99CompactPointer115.advance_sound base pointer index advanced
          exact .read array (C99ValueBridge.value index) base pointer word found address.1 address.2
            (C99FiniteRead114.read64_sound state.heap pointer word loaded)
      | cons head tail => cases computed

/-- These are exactly the two array-read names accepted by the pinned
    process_block grammar, not an abstract Keccak or arbitrary call oracle. -/
def calls (state : State) (name : Name) (args : List Val) : Option Val :=
  if name=ShakeBlock.readName "A".toList then readArray state "A".toList args
  else if name=ShakeBlock.readName "RC".toList then readArray state "RC".toList args
  else none

theorem calls_sound (state : State) :
    C99ExpressionSound.CallsSound (ShakeBlock.ReadCall (reference state)) (calls state) := by
  intro name args value computed
  unfold calls at computed
  split at computed
  next array =>
    subst name
    exact readArray_sound state "A".toList args value computed
  next notArray =>
    split at computed
    next rc =>
      subst name
      exact readArray_sound state "RC".toList args value computed
    next rejected => cases computed

def evaluate (state : State) (expr : CLogic.Expr) : Option Val :=
  C99CompactScalar115.evaluate (calls state) state.locals expr

theorem evaluate_sound (state : State) (expr : CLogic.Expr) (value : Val)
    (computed : evaluate state expr=some value) :
    ShakeBlock.Eval (reference state) expr (C99ValueBridge.value value) :=
  C99CompactScalar115.evaluate_sound (ShakeBlock.ReadCall (reference state)) (calls state)
    (calls_sound state) state.locals expr value computed

end FT1536.Source3.ShakeBlockComputeRead116
