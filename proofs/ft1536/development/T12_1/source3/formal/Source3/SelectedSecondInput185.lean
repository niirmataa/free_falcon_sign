import Source3.NttWholeSource185
import Source3.SelectedSecondEntry185

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSecondInput185
open C99MemoryReference (Load32)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (gs gm)
open SelectedTopInit178 (p p0i)
open SelectedSecondEntry185 (entry before)

theorem entry_heap : entry.heap=before.heap := KeygenLevelCalls.bind_heap before entry _ _ SelectedSecondEntry185.binding

theorem g_read (i : Fin 1536) : Load32 entry.heap (element gs i.val) (SelectedMakeFgConvert176.gImage i) := by
  rw [entry_heap]
  exact SelectedForwardFrame184.g_image i

theorem table_reads : NttMiddleTable183.Reads entry.heap gm := by
  intro i hi
  rw [entry_heap]
  obtain ⟨w,read,_⟩ := SelectedForwardFrame184.gm_table i hi
  exact ⟨w,read⟩

theorem exists_twiddle : ∃ w, Load32 entry.heap (element gm 1) w := table_reads 1 (by decide)

noncomputable def twiddle : BitVec 32 := Classical.choose exists_twiddle

theorem twiddle_read : Load32 entry.heap (element gm 1) twiddle := Classical.choose_spec exists_twiddle

theorem separate : NttMiddleTable183.Separate gs gm := by
  intro i hi byte
  right; right
  change 0+4*3230+4*1536≤0+4*(4766+i)+byte.val
  omega

theorem input : NttFirstSetup182.Input entry gs gm p p0i twiddle := by
  refine ⟨rfl,rfl,rfl,rfl,rfl,rfl,rfl,by decide,by decide,?_,?_,?_,twiddle_read⟩
  · intro j hj
    exact NttReadFacts182.allocated _ _ _ (g_read ⟨j,hj⟩)
  · rw [entry_heap]
    exact SelectedNttTriple184.fixed.writable
  · intro j hj
    exact NttReadFacts182.initialized _ _ _ (g_read ⟨j,hj⟩)

end FT1536.Source3.SelectedSecondInput185
