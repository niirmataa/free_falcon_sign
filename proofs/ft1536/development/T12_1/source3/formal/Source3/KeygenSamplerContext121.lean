import Source3.KeygenSamplerInvoke121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerContext121
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open KeygenSearchContext (Context)

def Guard (ctx : Context) (before : State) : Prop :=
  C99CompactPointer115.pointer noCalls before "fk".toList C99ProcedureParser.zero=some ctx.object ∧
  KeygenSearchContext.ObjectLegal (C99FiniteMemory114.memory before.heap) ctx

instance guardDecidable (ctx : Context) (before : State) : Decidable (Guard ctx before) := by
  unfold Guard KeygenSearchContext.ObjectLegal
  infer_instance

theorem guard_sound (ctx : Context) (before : State) (checked : Guard ctx before) :
    KeygenSamplerContext.Resolve ctx (reference before) :=
  .address (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _)
    before "fk".toList C99ProcedureParser.zero ctx.object checked.1) checked.2

def invoke (ctx : Context) (rngFuel block innerFuel outerFuel : Nat) (before : State) (name : String) : Option State :=
  if Guard ctx before then
    KeygenSamplerInvoke121.invoke (KeygenSamplerContext.rng ctx) rngFuel block innerFuel outerFuel before
      (KeygenSamplerCalls.arguments name)
  else none

theorem invoke_sound (ctx : Context) (rngFuel block innerFuel outerFuel : Nat) (before after : State) (name : String)
    (computed : invoke ctx rngFuel block innerFuel outerFuel before name=some after) :
    KeygenSamplerContext.Call ctx (reference before) name (reference after) := by
  unfold invoke at computed
  split at computed
  next checked =>
    exact .run (reference after) (guard_sound ctx before checked)
      (KeygenSamplerInvoke121.invoke_sound (KeygenSamplerContext.rng ctx) rngFuel block innerFuel outerFuel before after
        (KeygenSamplerCalls.arguments name) computed)
  next rejected => cases computed

end FT1536.Source3.KeygenSamplerContext121
