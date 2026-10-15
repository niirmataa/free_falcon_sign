import Source3.GeneratedSampler129G19
import Source3.KeygenLazyBinding129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.G19Pointer129
open C99CompactState115 (reference)
open SelectedGStart129 (ctx destination)
open GeneratedSampler129G19 (before after contextBlock coefficientBlock localSnapshot)

theorem after_binding : (reference after).arrays "v".toList=some destination :=
  KeygenLazyBinding129.pointer_after ctx destination before contextBlock coefficientBlock localSnapshot
    GeneratedSampler129G19.pointer_binding

end FT1536.Source3.G19Pointer129
