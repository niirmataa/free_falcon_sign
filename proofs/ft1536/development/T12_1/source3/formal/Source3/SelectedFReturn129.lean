import Source3.GeneratedSampler129F24
import Source3.KeygenSamplerComplete129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFReturn129
open C99CompactState115 (State reference)
open SelectedFullSampler128 (ctx prepared bound declared initial)

def sampled := GeneratedSampler129F24.after
def after : State := {prepared with heap := sampled.heap}

theorem ending : KeygenSamplerSource.Outer ctx (reference sampled) (reference sampled) :=
  KeygenPrefixCompose128.done ctx sampled (.i32 0) (by decide +kernel) rfl

/-- This interface is conditional until all f prefixes have been composed.
    The final guard alone is not a completed source sampler. -/
theorem source (steps : KeygenSamplerPrefix128.Prefix ctx 1536 (reference initial) (reference sampled)) :
    KeygenSamplerCalls.Call ctx (reference prepared) (KeygenSamplerCalls.arguments "f") (reference after) :=
  KeygenSamplerComplete129.call ctx 1536 prepared bound declared initial sampled _
    SelectedFullSampler128.binding SelectedFullSampler128.prologue SelectedFullSampler128.initialization steps ending

end FT1536.Source3.SelectedFReturn129
