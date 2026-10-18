import Source3.SelectedGeneratorRowTable179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorRowFrame179
open C99MemoryReference (ArrayPointer)
open SelectedGeneratorRow179 (before after)
open SelectedTopLayout177 (gm igm fs gs)

theorem outside (block offset : Nat) (separate : block≠31 ∨ offset<19064) :
    C99ArrayFrame.Outside before ["gm".toList,"igm".toList] block offset := by
  intro name member pointer binding
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl | rfl
  · have equal := Option.some.inj (binding.symm.trans SelectedGeneratorRowTable179.pointers.forward)
    subst pointer
    change block≠31 ∨ offset<19064 ∨ 286720≤offset
    omega
  · have equal := Option.some.inj (binding.symm.trans SelectedGeneratorRowTable179.pointers.inverse)
    subst pointer
    change block≠31 ∨ offset<23160 ∨ 286720≤offset
    omega

theorem bytes (block offset : Nat) (separate : block≠31 ∨ offset<19064) :
    after.heap.bytes block offset=before.heap.bytes block offset :=
  (KeygenLevelModularFrame.body_frame KeygenMkgm3Program.rowSelect before ⟨after,.normal⟩
    SelectedGeneratorRow179.source ["gm".toList,"igm".toList] (by decide) block offset
    (outside block offset separate)).2.2

theorem stable : KeygenMemoryStability.Stable before.heap after.heap :=
  KeygenMemoryStability.modular _ _ _ SelectedGeneratorRow179.source

theorem input_heap : before.heap=SelectedTopMove177.after.heap :=
  SelectedGeneratorInverseFacts178.heap.trans
    ((KeygenLevelCalls.bind_heap SelectedTopInit178.after SelectedGeneratorEntry178.entry _ _
      SelectedGeneratorEntry178.binding).trans SelectedTopInit178.heap)

theorem f_image : Word32Memory176.Represents after.heap fs SelectedMakeFgConvert176.fImage := by
  intro i
  have read : C99MemoryReference.Load32 before.heap (Word32Memory176.element fs i) (SelectedMakeFgConvert176.fImage i) := by
    rw [input_heap]
    exact SelectedTopMove177.f_image i
  apply Gate00Memory.load32_transport before.heap after.heap _ _ read stable.size
  intro byte
  apply bytes
  right
  have hi:=i.isLt
  have hb:=byte.isLt
  change 0+4*(1694+i.val)+byte.val<19064
  omega

theorem g_image : Word32Memory176.Represents after.heap gs SelectedMakeFgConvert176.gImage := by
  intro i
  have read : C99MemoryReference.Load32 before.heap (Word32Memory176.element gs i) (SelectedMakeFgConvert176.gImage i) := by
    rw [input_heap]
    exact SelectedTopMove177.g_image i
  apply Gate00Memory.load32_transport before.heap after.heap _ _ read stable.size
  intro byte
  apply bytes
  right
  have hi:=i.isLt
  have hb:=byte.isLt
  change 0+4*(3230+i.val)+byte.val<19064
  omega

end FT1536.Source3.SelectedGeneratorRowFrame179
