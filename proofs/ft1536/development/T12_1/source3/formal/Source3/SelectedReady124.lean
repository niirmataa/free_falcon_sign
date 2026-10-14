import Source3.SelectedInput124

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedReady124
open C99CompactState115 (State reference)
open KeygenCallerData123 (env)

/-- An explicit caller of the actual private rng_ready, retaining precisely
    the public seeding heap. The enclosing make prologue is still separate. -/
def caller := C99CompactState115.bindPointer SelectedInput124.seeded "fk".toList env.args.fk
def result := KeygenPublicInput124.ready env.ctx caller 128 64

theorem same_heap : (reference caller).heap=(reference SelectedInput124.seeded).heap := rfl
theorem defined : result.isSome=true := by decide +kernel
def ready : State := result.get defined
theorem computed : KeygenPublicInput124.ready env.ctx caller 128 64=some ready := SelectedInput124.option_get result defined

theorem source : KeygenRngReference.Call env.ctx (reference caller) [] (reference ready) (.int32 1) :=
  KeygenPublicInput124.ready_sound env.ctx caller ready 128 64 computed

end FT1536.Source3.SelectedReady124
