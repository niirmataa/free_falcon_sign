import Source3.SelectedForwardCall184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedForwardFrame184
open C99MemoryReference (Load32)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (fs gs gm)
open SelectedForwardCall184 (before after)

theorem combined_frame : NttWriteFrame182.Frame fs 1536 before.heap after.heap := by
  have frame := NttWriteFrame182.trans fs 1536 _ _ _ SelectedMiddleFrame183.combined_frame SelectedNttTriple184.frame
  rw [SelectedFirstInput182.entry_heap] at frame
  exact frame

theorem bytes (block offset : Nat) (outside : block≠31 ∨ offset<6776 ∨ 12920≤offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := combined_frame.bytes block offset outside

theorem a_read (i : Nat) (bound : i<1536) : ∃ word, Load32 after.heap (element fs i) word :=
  Word32Initialized180.load after.heap (element fs i) (SelectedNttTriple184.fixed.allocated i bound)
    SelectedNttTriple184.fixed.width (SelectedNttTriple184.fixed.initialized i bound)

theorem g_image : Word32Memory176.Represents after.heap gs SelectedMakeFgConvert176.gImage := by
  intro i
  apply Gate00Memory.load32_transport before.heap after.heap _ _ (SelectedGeneratorFrame181.g_image i) combined_frame.size
  intro byte
  apply bytes
  right; right
  change 12920≤0+4*(3230+i.val)+byte.val
  omega

theorem gm_table : KeygenMkgm3Table.Initialized after.heap gm := by
  intro i bound
  obtain ⟨w,read,law⟩ := SelectedGeneratorCall181.forward_table i bound
  refine ⟨w,?_,law⟩
  exact Gate00Memory.load32_transport before.heap after.heap _ _ read combined_frame.size
    (fun byte => combined_frame.bytes _ _ (SelectedNttMiddle183.separate i bound byte))

theorem locals : after.locals=before.locals := rfl
theorem arrays : after.arrays=before.arrays := rfl

end FT1536.Source3.SelectedForwardFrame184
