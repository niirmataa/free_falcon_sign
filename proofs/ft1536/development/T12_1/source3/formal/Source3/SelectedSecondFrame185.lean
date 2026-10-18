import Source3.SelectedSecondCall185

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSecondFrame185
open C99MemoryReference (Load32)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (fs gs gm)
open SelectedSecondCall185 (before after)

theorem caller_frame : NttWriteFrame182.Frame gs 1536 before.heap after.heap := by
  have frame := SelectedSecondBody185.frame
  rw [SelectedSecondInput185.entry_heap] at frame
  exact frame

theorem bytes (block offset : Nat) (outside : block≠31 ∨ offset<12920 ∨ 19064≤offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := caller_frame.bytes block offset outside

theorem f_read (i : Fin 1536) (word : BitVec 32) (read : Load32 before.heap (element fs i.val) word) :
    Load32 after.heap (element fs i.val) word := by
  apply Gate00Memory.load32_transport before.heap after.heap _ _ read caller_frame.size
  intro byte
  apply bytes
  right; left
  have hi:=i.isLt
  have hb:=byte.isLt
  change 0+4*(1694+i.val)+byte.val<12920
  omega

theorem f_readable (i : Nat) (bound : i<1536) : ∃ word, Load32 after.heap (element fs i) word := by
  obtain ⟨word,read⟩ := SelectedForwardFrame184.a_read i bound
  exact ⟨word,f_read ⟨i,bound⟩ word read⟩

theorem g_readable (i : Nat) (bound : i<1536) : ∃ word, Load32 after.heap (element gs i) word :=
  Word32Initialized180.load after.heap (element gs i) (SelectedSecondBody185.fixed.allocated i bound)
    SelectedSecondBody185.fixed.width (SelectedSecondBody185.fixed.initialized i bound)

theorem gm_table : KeygenMkgm3Table.Initialized after.heap gm := by
  intro i bound
  obtain ⟨w,read,law⟩ := SelectedForwardFrame184.gm_table i bound
  refine ⟨w,?_,law⟩
  exact Gate00Memory.load32_transport before.heap after.heap _ _ read caller_frame.size
    (fun byte => caller_frame.bytes _ _ (SelectedSecondInput185.separate i bound byte))

theorem paired_bytes (block offset : Nat) (outside : block≠31 ∨ offset<6776 ∨ 19064≤offset) :
    after.heap.bytes block offset=SelectedForwardCall184.before.heap.bytes block offset := by
  have second := bytes block offset (by omega)
  have first := SelectedForwardFrame184.bytes block offset (by omega)
  exact second.trans first

theorem paired_sizes : after.heap.size=SelectedForwardCall184.before.heap.size :=
  caller_frame.size.trans SelectedForwardFrame184.combined_frame.size

theorem paired_writable : after.heap.writable=SelectedForwardCall184.before.heap.writable :=
  caller_frame.writable.trans SelectedForwardFrame184.combined_frame.writable

theorem locals : after.locals=SelectedForwardCall184.before.locals := rfl
theorem arrays : after.arrays=SelectedForwardCall184.before.arrays := rfl

end FT1536.Source3.SelectedSecondFrame185
