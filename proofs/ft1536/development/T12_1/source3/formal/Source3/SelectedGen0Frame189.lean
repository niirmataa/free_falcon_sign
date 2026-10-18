import Source3.SelectedGen0Call189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGen0Frame189
open C99MemoryReference (Memory Allocated Load32)
open SelectedStepLayout187 (gm igm fs gs)
open KeygenSmallOutput (element)
open SelectedGen0Call189 (before after)

theorem entry_heap : StepGeneratorEntry188.entry.heap=before.heap :=
  KeygenLevelCalls.bind_heap before StepGeneratorEntry188.entry _ _ StepGeneratorEntry188.binding

theorem stable : KeygenMemoryStability.Stable before.heap after.heap := by
  have result := KeygenMemoryStability.modular _ _ _ SelectedGen0Top189.body_source
  rw [entry_heap] at result
  exact result

theorem outside (block offset : Nat) (separate : block≠31 ∨ offset<10872) :
    C99ArrayFrame.Outside StepGeneratorEntry188.entry ["gm".toList,"igm".toList] block offset := by
  intro name member pointer binding
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl | rfl
  · have current : StepGeneratorEntry188.entry.arrays "gm".toList=some gm := rfl
    have equal := Option.some.inj (binding.symm.trans current)
    subst pointer
    change block≠31 ∨ offset<10872 ∨ 286720≤offset
    omega
  · have current : StepGeneratorEntry188.entry.arrays "igm".toList=some igm := rfl
    have equal := Option.some.inj (binding.symm.trans current)
    subst pointer
    change block≠31 ∨ offset<12920 ∨ 286720≤offset
    omega

theorem bytes (block offset : Nat) (separate : block≠31 ∨ offset<10872) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  have frame := (KeygenLevelModularFrame.body_frame KeygenMkgm3Program.code StepGeneratorEntry188.entry
    ⟨SelectedGen0Top189.after,.normal⟩ SelectedGen0Top189.body_source ["gm".toList,"igm".toList]
    (by decide) block offset (outside block offset separate)).2.2
  rw [entry_heap] at frame
  exact frame

theorem f_read (j : Nat) (bound : j<512) : ∃ word, Load32 after.heap (element fs j) word := by
  have reads : ∃ word, Load32 before.heap (element fs j) word := by
    rw [SelectedStepPrime188.heap]
    exact SelectedStepMove187.f_read j bound
  obtain ⟨word,read⟩ := reads
  refine ⟨word,Gate00Memory.load32_transport before.heap after.heap _ _ read stable.size ?_⟩
  intro byte
  apply bytes
  right
  have hb:=byte.isLt
  change 0+4*(1694+j)+byte.val<10872
  omega

theorem g_read (j : Nat) (bound : j<512) : ∃ word, Load32 after.heap (element gs j) word := by
  have reads : ∃ word, Load32 before.heap (element gs j) word := by
    rw [SelectedStepPrime188.heap]
    exact SelectedStepMove187.g_read j bound
  obtain ⟨word,read⟩ := reads
  refine ⟨word,Gate00Memory.load32_transport before.heap after.heap _ _ read stable.size ?_⟩
  intro byte
  apply bytes
  right
  have hb:=byte.isLt
  change 0+4*(2206+j)+byte.val<10872
  omega

theorem g_allocated (j : Nat) (bound : j<512) : Allocated after.heap (element gm j) := by
  unfold Allocated
  rw [stable.size]
  have old : Allocated StepGeneratorEntry188.entry.heap (element gm j) := StepGeneratorEntry188.allocated (2718+j) (by omega)
  rw [entry_heap] at old
  exact old

theorem i_allocated (j : Nat) (bound : j<512) : Allocated after.heap (element igm j) := by
  unfold Allocated
  rw [stable.size]
  have old : Allocated StepGeneratorEntry188.entry.heap (element igm j) := StepGeneratorEntry188.allocated (3230+j) (by omega)
  rw [entry_heap] at old
  exact old

theorem gm_read (j : Nat) (bound : j<512) : ∃ word, Load32 after.heap (element gm j) word :=
  Word32Initialized180.load after.heap (element gm j) (g_allocated j bound) rfl
    (SelectedGen0Top189.initialized j (Nat.zero_le j) (by omega)).1

theorem igm_read (j : Nat) (bound : j<512) : ∃ word, Load32 after.heap (element igm j) word :=
  Word32Initialized180.load after.heap (element igm j) (i_allocated j bound) rfl
    (SelectedGen0Top189.initialized j (Nat.zero_le j) (by omega)).2

theorem locals : after.locals=before.locals := rfl
theorem arrays : after.arrays=before.arrays := rfl

end FT1536.Source3.SelectedGen0Frame189
