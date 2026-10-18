import Source3.SelectedNttMiddle183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMiddleFrame183
open C99MemoryReference (Load32)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (fs gs gm)
open SelectedNttMiddle183 (before after frame fixed)

theorem combined_frame : NttWriteFrame182.Frame fs 1536 SelectedForwardEntry182.entry.heap after.heap :=
  NttWriteFrame182.trans fs 1536 _ _ _ SelectedNttFirst182.frame frame

theorem bytes (block offset : Nat) (outside : block≠31 ∨ offset<6776 ∨ 12920≤offset) :
    after.heap.bytes block offset=SelectedForwardEntry182.entry.heap.bytes block offset := combined_frame.bytes block offset outside

theorem a_read (i : Nat) (bound : i<1536) : ∃ word, Load32 after.heap (element fs i) word :=
  Word32Initialized180.load after.heap (element fs i) (fixed.allocated i bound) fixed.width (fixed.initialized i bound)

theorem g_image : Word32Memory176.Represents after.heap gs SelectedMakeFgConvert176.gImage := by
  intro i
  apply Gate00Memory.load32_transport before.heap after.heap _ _ (SelectedFirstFrame182.g_image i) frame.size
  intro byte
  apply frame.bytes
  right; right
  change 12920≤0+4*(3230+i.val)+byte.val
  omega

theorem gm_table : KeygenMkgm3Table.Initialized after.heap gm := by
  intro i bound
  obtain ⟨w,read,law⟩ := SelectedFirstFrame182.gm_table i bound
  refine ⟨w,?_,law⟩
  exact Gate00Memory.load32_transport before.heap after.heap _ _ read frame.size
    (fun byte => frame.bytes _ _ (SelectedNttMiddle183.separate i bound byte))

end FT1536.Source3.SelectedMiddleFrame183
