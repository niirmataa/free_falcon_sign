import Source3.ConvertedImage136Part00
import Source3.ConvertedImage136Part01
import Source3.ConvertedImage136Part02
import Source3.ConvertedImage136Part03
import Source3.ConvertedImage136Part04
import Source3.ConvertedImage136Part05
import Source3.ConvertedImage136Part06
import Source3.ConvertedImage136Part07
import Source3.ConvertedImage136Part08
import Source3.ConvertedImage136Part09
import Source3.ConvertedImage136Part10
import Source3.ConvertedImage136Part11
import Source3.ConvertedImage136Part12
import Source3.ConvertedImage136Part13
import Source3.ConvertedImage136Part14
import Source3.ConvertedImage136Part15
import Source3.ConvertedImage136Part16
import Source3.ConvertedImage136Part17
import Source3.ConvertedImage136Part18
import Source3.ConvertedImage136Part19
import Source3.ConvertedImage136Part20
import Source3.ConvertedImage136Part21
import Source3.ConvertedImage136Part22
import Source3.ConvertedImage136Part23

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ConvertedImages136
open ConvertedWords136
open C99CompactState115 (reference)

theorem f_parts (part : Fin 24) : ∀ i : Fin 64,
    C99FiniteRead114.read64 imageHeap (fPointer (index part i))=some (fWord (index part i)) := by
  fin_cases part
  · exact ConvertedImage136Part00.f_checked
  · exact ConvertedImage136Part01.f_checked
  · exact ConvertedImage136Part02.f_checked
  · exact ConvertedImage136Part03.f_checked
  · exact ConvertedImage136Part04.f_checked
  · exact ConvertedImage136Part05.f_checked
  · exact ConvertedImage136Part06.f_checked
  · exact ConvertedImage136Part07.f_checked
  · exact ConvertedImage136Part08.f_checked
  · exact ConvertedImage136Part09.f_checked
  · exact ConvertedImage136Part10.f_checked
  · exact ConvertedImage136Part11.f_checked
  · exact ConvertedImage136Part12.f_checked
  · exact ConvertedImage136Part13.f_checked
  · exact ConvertedImage136Part14.f_checked
  · exact ConvertedImage136Part15.f_checked
  · exact ConvertedImage136Part16.f_checked
  · exact ConvertedImage136Part17.f_checked
  · exact ConvertedImage136Part18.f_checked
  · exact ConvertedImage136Part19.f_checked
  · exact ConvertedImage136Part20.f_checked
  · exact ConvertedImage136Part21.f_checked
  · exact ConvertedImage136Part22.f_checked
  · exact ConvertedImage136Part23.f_checked

theorem f_checked (i : Fin 1536) :
    C99FiniteRead114.read64 imageHeap (fPointer i)=some (fWord i) := by
  let part : Fin 24 := ⟨i.val/64,by omega⟩
  let offset : Fin 64 := ⟨i.val%64,by omega⟩
  have same : index part offset=i := by
    apply Fin.ext
    dsimp [index,part,offset]
    omega
  have checked := f_parts part offset
  rw [same] at checked
  exact checked

theorem f_source (i : Fin 1536) : C99MemoryReference.Load64
    (reference SelectedSmallGComplete136.after).heap (fPointer i) (fWord i) :=
  C99BlockReads136.load64_transfer SelectedSmallGComplete136.after.heap imageHeap (fPointer i) (fWord i)
    (block_same (fPointer i) rfl) (C99FiniteRead114.read64_sound _ _ _ (f_checked i))

theorem g_parts (part : Fin 24) : ∀ i : Fin 64,
    C99FiniteRead114.read64 imageHeap (gPointer (index part i))=some (gWord (index part i)) := by
  fin_cases part
  · exact ConvertedImage136Part00.g_checked
  · exact ConvertedImage136Part01.g_checked
  · exact ConvertedImage136Part02.g_checked
  · exact ConvertedImage136Part03.g_checked
  · exact ConvertedImage136Part04.g_checked
  · exact ConvertedImage136Part05.g_checked
  · exact ConvertedImage136Part06.g_checked
  · exact ConvertedImage136Part07.g_checked
  · exact ConvertedImage136Part08.g_checked
  · exact ConvertedImage136Part09.g_checked
  · exact ConvertedImage136Part10.g_checked
  · exact ConvertedImage136Part11.g_checked
  · exact ConvertedImage136Part12.g_checked
  · exact ConvertedImage136Part13.g_checked
  · exact ConvertedImage136Part14.g_checked
  · exact ConvertedImage136Part15.g_checked
  · exact ConvertedImage136Part16.g_checked
  · exact ConvertedImage136Part17.g_checked
  · exact ConvertedImage136Part18.g_checked
  · exact ConvertedImage136Part19.g_checked
  · exact ConvertedImage136Part20.g_checked
  · exact ConvertedImage136Part21.g_checked
  · exact ConvertedImage136Part22.g_checked
  · exact ConvertedImage136Part23.g_checked

theorem g_checked (i : Fin 1536) :
    C99FiniteRead114.read64 imageHeap (gPointer i)=some (gWord i) := by
  let part : Fin 24 := ⟨i.val/64,by omega⟩
  let offset : Fin 64 := ⟨i.val%64,by omega⟩
  have same : index part offset=i := by
    apply Fin.ext
    dsimp [index,part,offset]
    omega
  have checked := g_parts part offset
  rw [same] at checked
  exact checked

theorem g_source (i : Fin 1536) : C99MemoryReference.Load64
    (reference SelectedSmallGComplete136.after).heap (gPointer i) (gWord i) :=
  C99BlockReads136.load64_transfer SelectedSmallGComplete136.after.heap imageHeap (gPointer i) (gWord i)
    (block_same (gPointer i) rfl) (C99FiniteRead114.read64_sound _ _ _ (g_checked i))

end FT1536.Source3.ConvertedImages136
