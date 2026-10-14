import Source3.ShakeExtractTraceSound128
import Source3.ShakeExtractInvoke120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractTraceCall128
open C99CompactState115 (State reference)
open C99MemoryReference (ArrayPointer)
open ShakeProcessEvents128 (Proposal Result Event All)

def invoke (ctx : ShakeExtractSource.Layout) (propose : Proposal) (fuel : Nat)
    (before : State) (out : ArrayPointer) (length : B20.C.Val) : Option Result :=
  (ShakeExtractTrace128.run ctx propose fuel ShakeExtractSource.code (ShakeExtractInvoke120.entry before out length)).map
    (fun (after,events) => ({before with heap := after.heap},events))

theorem invoke_sound (ctx : ShakeExtractSource.Layout) (propose : Proposal) (fuel : Nat)
    (before after : State) (out : ArrayPointer) (length : B20.C.Val) (events : List Event)
    (computed : invoke ctx propose fuel before out length=some (after,events)) (checked : All ctx events) :
    ShakeExtractFrame.Call ctx (reference before) out (C99ValueBridge.value length) (reference after) := by
  obtain ⟨middleResult,body,result⟩ := Option.map_eq_some_iff.mp computed
  rcases middleResult with ⟨middle,innerEvents⟩
  obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj result
  subst after
  subst events
  rw [C99CompactState115.reference_heap before middle.heap]
  have source := ShakeExtractTraceSound128.run_sound ctx propose fuel ShakeExtractSource.code
    (ShakeExtractInvoke120.entry before out length) middle innerEvents body checked
  rw [ShakeExtractInvoke120.entry_bound] at source
  exact .run (reference middle) source

end FT1536.Source3.ShakeExtractTraceCall128
