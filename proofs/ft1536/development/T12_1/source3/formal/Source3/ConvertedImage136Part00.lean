import Source3.ConvertedWords136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ConvertedImage136Part00
open ConvertedWords136

theorem f_checked : ∀ i : Fin 64,
    C99FiniteRead114.read64 imageHeap (fPointer (index ⟨0,by decide +kernel⟩ i))=some (fWord (index ⟨0,by decide +kernel⟩ i)) := by decide +kernel

theorem g_checked : ∀ i : Fin 64,
    C99FiniteRead114.read64 imageHeap (gPointer (index ⟨0,by decide +kernel⟩ i))=some (gWord (index ⟨0,by decide +kernel⟩ i)) := by decide +kernel

end FT1536.Source3.ConvertedImage136Part00
