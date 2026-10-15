import Source3.FirstNormalized128
import Source3.GeneratedSampler128F01
import Source3.KeygenPrefixCompose128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.First64Source128
open C99CompactState115 (reference)

/-- First64 coefficients of the actual1536-coefficient source invocation.
    Every process event is closed; this remains a prefix, not a returned key. -/
theorem source : KeygenSamplerPrefix128.Prefix SelectedFullSampler128.ctx 64
    (reference SelectedFullSampler128.initial)
    (reference GeneratedSampler128F01.after) :=
  KeygenPrefixCompose128.append _ 1 63 _ _ _ FirstNormalized128.source GeneratedSampler128F01.closed

end FT1536.Source3.First64Source128
