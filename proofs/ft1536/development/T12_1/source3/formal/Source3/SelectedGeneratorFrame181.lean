import Source3.SelectedGeneratorCall181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorFrame181
open C99MemoryReference (Memory Load32)
open SelectedTopLayout177 (gm igm fs gs)
open SelectedGeneratorCall181 (before after)

theorem entry_heap : SelectedGeneratorEntry178.entry.heap=before.heap :=
  KeygenLevelCalls.bind_heap before SelectedGeneratorEntry178.entry _ _ SelectedGeneratorEntry178.binding

theorem sizes : after.heap.size=before.heap.size :=
  (KeygenMemoryStability.modular KeygenMkgm3Program.code SelectedGeneratorEntry178.entry
    ⟨SelectedGeneratorTop181.after,.normal⟩ SelectedGeneratorTop181.body_source).size.trans
      (congrArg Memory.size entry_heap)

theorem outside (block offset : Nat) (separate : block≠31 ∨ offset<19064) :
    C99ArrayFrame.Outside SelectedGeneratorEntry178.entry ["gm".toList,"igm".toList] block offset := by
  intro name member pointer binding
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl | rfl
  · have current : SelectedGeneratorEntry178.entry.arrays "gm".toList=some gm := rfl
    have equal := Option.some.inj (binding.symm.trans current)
    subst pointer
    change block≠31 ∨ offset<19064 ∨ 286720≤offset
    omega
  · have current : SelectedGeneratorEntry178.entry.arrays "igm".toList=some igm := rfl
    have equal := Option.some.inj (binding.symm.trans current)
    subst pointer
    change block≠31 ∨ offset<23160 ∨ 286720≤offset
    omega

theorem bytes (block offset : Nat) (separate : block≠31 ∨ offset<19064) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  have frame := (KeygenLevelModularFrame.body_frame KeygenMkgm3Program.code SelectedGeneratorEntry178.entry
    ⟨SelectedGeneratorTop181.after,.normal⟩ SelectedGeneratorTop181.body_source ["gm".toList,"igm".toList]
    (by decide) block offset (outside block offset separate)).2.2
  rw [entry_heap] at frame
  exact frame

theorem f_image : Word32Memory176.Represents after.heap fs SelectedMakeFgConvert176.fImage := by
  intro i
  have read : Load32 before.heap (Word32Memory176.element fs i) (SelectedMakeFgConvert176.fImage i) := by
    rw [SelectedGeneratorCall181.before,SelectedTopInit178.heap]
    exact SelectedTopMove177.f_image i
  apply Gate00Memory.load32_transport before.heap after.heap _ _ read sizes
  intro byte
  apply bytes
  right
  have hi:=i.isLt
  have hb:=byte.isLt
  change 0+4*(1694+i.val)+byte.val<19064
  omega

theorem g_image : Word32Memory176.Represents after.heap gs SelectedMakeFgConvert176.gImage := by
  intro i
  have read : Load32 before.heap (Word32Memory176.element gs i) (SelectedMakeFgConvert176.gImage i) := by
    rw [SelectedGeneratorCall181.before,SelectedTopInit178.heap]
    exact SelectedTopMove177.g_image i
  apply Gate00Memory.load32_transport before.heap after.heap _ _ read sizes
  intro byte
  apply bytes
  right
  have hi:=i.isLt
  have hb:=byte.isLt
  change 0+4*(3230+i.val)+byte.val<19064
  omega

theorem g_read (i : Nat) (bound : i < 1024) : ∃ word, Load32 after.heap (KeygenSmallOutput.element gm i) word :=
  Word32Initialized180.load after.heap (KeygenSmallOutput.element gm i) (SelectedGeneratorTop181.fixed.gAllocated i bound)
    SelectedGeneratorTop181.fixed.gWidth (SelectedGeneratorCall181.both_initialized i (by omega) bound).1

theorem i_read (i : Nat) (bound : i < 1024) : ∃ word, Load32 after.heap (KeygenSmallOutput.element igm i) word :=
  Word32Initialized180.load after.heap (KeygenSmallOutput.element igm i) (SelectedGeneratorTop181.fixed.iAllocated i bound)
    SelectedGeneratorTop181.fixed.iWidth (SelectedGeneratorCall181.both_initialized i (by omega) bound).2

end FT1536.Source3.SelectedGeneratorFrame181
