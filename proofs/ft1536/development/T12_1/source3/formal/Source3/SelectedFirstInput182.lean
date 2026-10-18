import Source3.NttFirstSetup182
import Source3.SelectedForwardEntry182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFirstInput182
open C99MemoryReference (Load32)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (fs gm)
open SelectedTopInit178 (p p0i)
open SelectedForwardEntry182 (entry before)

theorem entry_heap : entry.heap=before.heap := KeygenLevelCalls.bind_heap before entry _ _ SelectedForwardEntry182.binding

theorem f_read (i : Fin 1536) : Load32 entry.heap (element fs i.val) (SelectedMakeFgConvert176.fImage i) := by
  rw [entry_heap]
  exact SelectedGeneratorFrame181.f_image i

theorem exists_twiddle : ∃ w, Load32 entry.heap (element gm 1) w := by
  rw [entry_heap]
  exact SelectedGeneratorFrame181.g_read 1 (by decide)

noncomputable def twiddle : BitVec 32 := Classical.choose exists_twiddle

theorem twiddle_read : Load32 entry.heap (element gm 1) twiddle := Classical.choose_spec exists_twiddle

theorem input : NttFirstSetup182.Input entry fs gm p p0i twiddle := by
  refine ⟨rfl,rfl,rfl,rfl,rfl,rfl,rfl,by decide,by decide,?_,?_,?_,twiddle_read⟩
  · intro j hj
    exact NttReadFacts182.allocated _ _ _ (f_read ⟨j,hj⟩)
  · rw [entry_heap]
    exact SelectedGeneratorTop181.fixed.gWritable
  · intro j hj
    exact NttReadFacts182.initialized _ _ _ (f_read ⟨j,hj⟩)

end FT1536.Source3.SelectedFirstInput182
