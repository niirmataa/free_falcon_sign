import Source3.C99ScalarCompute130
import Source3.C99Read16Compute130
import Source3.C99CompactPointer115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ArrayCompute136
open C99CompactState115 (State reference)
open C99ArrayReference (Expr)
open C99CompactPointer115 (noCalls)
open C99ValueBridge (value encode)
open B20.C (Val)

def evaluate (calls : B20.C.Scalar.Calls) (before : State) : Expr → Option Val
  | .scalar expr => C99ScalarCompute130.evaluate before.locals expr
  | .load name index => do
      let pointer ← C99CompactPointer115.pointer noCalls before name index
      (C99FiniteRead114.read64 before.heap pointer).map Val.u64
  | .load16 signed name index => do
      let pointer ← C99CompactPointer115.pointer noCalls before name index
      (C99Read16Compute130.read before.heap pointer).map (fun word =>
        encode (if signed then C99NarrowReads.signedPromotion word else C99NarrowReads.unsignedPromotion word))
  | .call1 name arg => do calls name [← evaluate calls before arg]
  | .call2 name left right => do calls name [← evaluate calls before left,← evaluate calls before right]

theorem sound (calls : B20.C.Scalar.Calls) (callsSound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls)
    (before : State) (expr : Expr) (out : Val) (computed : evaluate calls before expr=some out) :
    C99ArrayReference.Eval (reference before) expr (value out) := by
  induction expr generalizing out with
  | scalar expr =>
      exact .scalar _ _ (C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls before.locals expr out computed)
  | load name index =>
      obtain ⟨pointer,address,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨word,read,same⟩ := Option.map_eq_some_iff.mp rest
      subst out
      exact .load name index pointer word
        (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before name index pointer address)
        (C99FiniteRead114.read64_sound before.heap pointer word read)
  | load16 signed name index =>
      obtain ⟨pointer,address,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨word,read,same⟩ := Option.map_eq_some_iff.mp rest
      subst out
      rw [C99ValueBridge.value_encode]
      exact .load16 signed name index pointer word
        (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before name index pointer address)
        (C99Read16Compute130.read_sound before.heap pointer word read)
  | call1 name arg ih =>
      obtain ⟨x,evaluated,called⟩ := Option.bind_eq_some_iff.mp computed
      exact .call1 _ _ _ _ (ih x evaluated) (callsSound name [x] out called)
  | call2 name left right ihLeft ihRight =>
      obtain ⟨x,first,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨y,second,called⟩ := Option.bind_eq_some_iff.mp rest
      exact .call2 _ _ _ _ _ _ (ihLeft x first) (ihRight y second) (callsSound name [x,y] out called)

end FT1536.Source3.C99ArrayCompute136
