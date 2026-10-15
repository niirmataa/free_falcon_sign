import Source3.SamplerFPrefix129
import Source3.SelectedFReturn129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SamplerFComplete129
open C99CompactState115 (reference)

/-- Complete actual f invocation, including the final guard and caller return. -/
theorem source : KeygenSamplerCalls.Call SelectedFullSampler128.ctx
    (reference SelectedFullSampler128.prepared) (KeygenSamplerCalls.arguments "f")
    (reference SelectedFReturn129.after) :=
  SelectedFReturn129.source SamplerFPrefix129.through24

end FT1536.Source3.SamplerFComplete129
