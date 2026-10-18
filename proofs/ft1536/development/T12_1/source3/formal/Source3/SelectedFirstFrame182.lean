import Source3.SelectedNttFirst182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFirstFrame182
open C99MemoryReference (ArrayPointer Load32)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (fs gs gm)
open SelectedForwardEntry182 (entry)
open SelectedNttFirst182 (after frame fixed)

theorem bytes (block offset : Nat) (outside : block≠31 ∨ offset<6776 ∨ 12920≤offset) :
    after.heap.bytes block offset=entry.heap.bytes block offset := frame.bytes block offset outside

theorem a_read (i : Nat) (bound : i < 1536) : ∃ word, Load32 after.heap (element fs i) word :=
  Word32Initialized180.load after.heap (element fs i) (fixed.allocated i bound) fixed.width (fixed.initialized i bound)

theorem g_image : Word32Memory176.Represents after.heap gs SelectedMakeFgConvert176.gImage := by
  intro i
  have read : Load32 entry.heap (Word32Memory176.element gs i) (SelectedMakeFgConvert176.gImage i) := by
    rw [SelectedFirstInput182.entry_heap]
    exact SelectedGeneratorFrame181.g_image i
  apply Gate00Memory.load32_transport entry.heap after.heap _ _ read frame.size
  intro byte
  apply bytes
  right; right
  change 12920≤0+4*(3230+i.val)+byte.val
  omega

theorem gm_table : KeygenMkgm3Table.Initialized after.heap gm := by
  intro i bound
  obtain ⟨w,read,law⟩ := SelectedGeneratorCall181.forward_table i bound
  have beforeRead : Load32 entry.heap (element gm i) w := by
    rw [SelectedFirstInput182.entry_heap]
    exact read
  refine ⟨w,?_,law⟩
  apply Gate00Memory.load32_transport entry.heap after.heap _ _ beforeRead frame.size
  intro byte
  apply bytes
  right; right
  change 12920≤0+4*(4766+i)+byte.val
  omega

end FT1536.Source3.SelectedFirstFrame182
