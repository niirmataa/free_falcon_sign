import Source3.NormalizedSmall136
import Source3.ConvertedImages136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NormalizedSmallImages136
open C99CompactState115 (reference)

theorem f_source (i : Fin 1536) : C99MemoryReference.Load64
    (reference NormalizedSmall136.after).heap (ConvertedWords136.fPointer i) (ConvertedWords136.fWord i) := by
  rw [← NormalizedSmall136.reference_equal]
  exact ConvertedImages136.f_source i

theorem g_source (i : Fin 1536) : C99MemoryReference.Load64
    (reference NormalizedSmall136.after).heap (ConvertedWords136.gPointer i) (ConvertedWords136.gWord i) := by
  rw [← NormalizedSmall136.reference_equal]
  exact ConvertedImages136.g_source i

end FT1536.Source3.NormalizedSmallImages136
