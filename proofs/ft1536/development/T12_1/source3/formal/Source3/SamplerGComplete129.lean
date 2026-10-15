import Source3.SamplerGPrefix129
import Source3.KeygenSamplerComplete129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SamplerGComplete129
open C99CompactState115 (State reference)
open SelectedGStart129 (ctx caller bound declared initial)

def sampled := GeneratedSampler129G24.after
def after : State := {caller with heap := sampled.heap}

theorem ending : KeygenSamplerSource.Outer ctx (reference sampled) (reference sampled) :=
  KeygenPrefixCompose128.done ctx sampled (.i32 0) (by decide +kernel) rfl

/-- Complete actual g call after the same f heap and the source bit reset. -/
theorem source : KeygenSamplerCalls.Call ctx (reference caller)
    (KeygenSamplerCalls.arguments "g") (reference after) :=
  KeygenSamplerComplete129.call ctx 1536 caller bound declared initial sampled _
    SelectedGStart129.binding SelectedGStart129.prologue SelectedGStart129.initialization
    SamplerGPrefix129.through24 ending

end FT1536.Source3.SamplerGComplete129
