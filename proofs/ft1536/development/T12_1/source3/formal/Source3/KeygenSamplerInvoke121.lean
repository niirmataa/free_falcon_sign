import Source3.KeygenSamplerLoops121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerInvoke121
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeExtractSource (Layout)

def invoke (ctx : Layout) (rngFuel block innerFuel outerFuel : Nat) (before : State)
    (args : List C99ArrayReference.Arg) : Option State := do
  let entry ← C99CompactBinding115.bind noCalls before KeygenSamplerCalls.params args
  let after ← KeygenSamplerLoops121.run ctx rngFuel block innerFuel outerFuel entry
  pure {before with heap := after.heap}

theorem invoke_sound (ctx : Layout) (rngFuel block innerFuel outerFuel : Nat) (before after : State)
    (args : List C99ArrayReference.Arg) (computed : invoke ctx rngFuel block innerFuel outerFuel before args=some after) :
    KeygenSamplerCalls.Call ctx (reference before) args (reference after) := by
  obtain ⟨entry,binding,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨middle,body,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_heap before middle.heap]
  exact .run (reference entry) (reference middle)
    (C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) before entry KeygenSamplerCalls.params args binding)
    (KeygenSamplerLoops121.run_sound ctx rngFuel block innerFuel outerFuel entry middle body)

end FT1536.Source3.KeygenSamplerInvoke121
