import Source3.ShakeExtractBasic120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractCalls120
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeExtractSource (Layout)

def process (fuel : Nat) (before : State) (src : C99ArrayReference.Name) : Option State := do
  let pointer ← C99CompactPointer115.pointer noCalls before src ShakeExtractSource.zero
  ShakeProcessCompute116.process fuel before pointer

theorem process_sound (ctx : Layout) (fuel : Nat) (before after : State) (src : C99ArrayReference.Name)
    (computed : process fuel before src=some after) :
    ShakeExtractSource.Exec ctx (.process src) (reference before) (reference after) := by
  obtain ⟨pointer,address,body⟩ := Option.bind_eq_some_iff.mp computed
  exact .process src (reference before) (reference after) pointer
    (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before src _ pointer address)
    (ShakeProcessCompute116.process_sound fuel before after pointer body)

def encode (before : State) (dst : C99ArrayReference.Name) (index expression : CLogic.Expr) : Option State := do
  let pointer ← C99CompactPointer115.pointer noCalls before dst index
  let value ← ShakeBlockComputeRead116.evaluate before expression
  ShakeEncodeCompute117.invoke before pointer value

theorem encode_sound (ctx : Layout) (before after : State) (dst : C99ArrayReference.Name) (index expression : CLogic.Expr)
    (computed : encode before dst index expression=some after) :
    ShakeExtractSource.Exec ctx (.encode dst index expression) (reference before) (reference after) := by
  obtain ⟨pointer,address,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value,evaluated,body⟩ := Option.bind_eq_some_iff.mp rest
  exact .encode dst index expression (reference before) (reference after) pointer (C99ValueBridge.value value)
    (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before dst index pointer address)
    (ShakeBlockComputeRead116.evaluate_sound before expression value evaluated)
    (ShakeEncodeCompute117.invoke_sound before after pointer value body)

end FT1536.Source3.ShakeExtractCalls120
