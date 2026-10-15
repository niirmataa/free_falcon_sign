import Source3.SamplerFComplete129
import Source3.SamplerGComplete129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSamples129
open C99CompactState115 (reference)

theorem first : KeygenSamplerContext.Call KeygenFullData127.env.ctx
    (reference SelectedFullSampler128.prepared) "f" (reference SelectedFReturn129.after) :=
  .run _ SelectedFullSampler128.context SamplerFComplete129.source

theorem second : KeygenSamplerContext.Call KeygenFullData127.env.ctx
    (reference SelectedFReturn129.after) "g" (reference SamplerGComplete129.after) :=
  .run _ SelectedGStart129.context SamplerGComplete129.source

end FT1536.Source3.SelectedSamples129
