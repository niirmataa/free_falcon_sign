import Source3.GeneratedFirstSegment128
import Source3.FirstEventValid128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FirstNormalized128
open C99CompactState115 (reference)

/-- Original first-coefficient source prefix on the full127 input, with
    all logged process calls closed and the complete result normalized. -/
theorem source : KeygenSamplerPrefix128.Prefix SelectedFullSampler128.ctx 1
    (reference SelectedFullSampler128.initial)
    (reference GeneratedFirstSegment128.after) :=
  GeneratedFirstSegment128.normalized FirstEventValid128.obligations

end FT1536.Source3.FirstNormalized128
