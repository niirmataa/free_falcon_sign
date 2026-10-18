import Source3.StepGeneratorReady188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Gen0RawInitialized189
open C99MemoryReference (ArrayPointer Load32)
open KeygenSmallOutput (element)
open SelectedStepLayout187 (gm igm)

/- These are raw initialized scratch spans inherited from executed source,
   not canonical twiddle assertions and not additional source operations. -/
theorem old_g (j : Nat) (bound : j<1024) : ∃ word, Load32 SelectedStepMove187.before.heap (element gm j) word := by
  rw [SelectedStepMove187.before_heap]
  by_cases low : j<512
  · obtain ⟨word,read⟩ := SelectedTopOutput186.f_readable (1024+j) (by omega)
    have equal : element SelectedTopLayout177.fs (1024+j)=element gm j := by
      change (⟨31,0,71680,4,1694+(1024+j)⟩ : ArrayPointer)=⟨31,0,71680,4,2718+j⟩
      apply congrArg (fun k : Nat => (⟨31,0,71680,4,k⟩ : ArrayPointer))
      omega
    rw [equal] at read
    exact ⟨word,read⟩
  · obtain ⟨word,read⟩ := SelectedTopOutput186.g_readable (j-512) (by omega)
    have equal : element SelectedTopLayout177.gs (j-512)=element gm j := by
      change (⟨31,0,71680,4,3230+(j-512)⟩ : ArrayPointer)=⟨31,0,71680,4,2718+j⟩
      apply congrArg (fun k : Nat => (⟨31,0,71680,4,k⟩ : ArrayPointer))
      omega
    rw [equal] at read
    exact ⟨word,read⟩

theorem old_i (j : Nat) (bound : j<1024) : ∃ word, Load32 SelectedStepMove187.before.heap (element igm j) word := by
  rw [SelectedStepMove187.before_heap]
  exact SelectedTopOutput186.g_readable j (by omega)

theorem copied_g (j : Nat) (bound : j<1024) : ∃ word, Load32 SelectedStepMove187.after.heap (element gm j) word := by
  obtain ⟨word,read⟩ := old_g j bound
  refine ⟨word,Gate00Memory.load32_transport _ _ _ _ read rfl ?_⟩
  intro byte
  apply SelectedStepMove187.outside
  right; right
  change 10872≤0+4*(2718+j)+byte.val
  omega

theorem copied_i (j : Nat) (bound : j<1024) : ∃ word, Load32 SelectedStepMove187.after.heap (element igm j) word := by
  obtain ⟨word,read⟩ := old_i j bound
  refine ⟨word,Gate00Memory.load32_transport _ _ _ _ read rfl ?_⟩
  intro byte
  apply SelectedStepMove187.outside
  right; right
  change 10872≤0+4*(3230+j)+byte.val
  omega

theorem initialized : GeneratorSquareDomains181.From StepGeneratorInverseCall188.after.heap gm igm 0 := by
  intro j lower upper
  rw [StepGeneratorReady188.heap]
  obtain ⟨g,rg⟩ := copied_g j upper
  obtain ⟨i,ri⟩ := copied_i j upper
  exact ⟨NttReadFacts182.initialized _ _ _ rg,NttReadFacts182.initialized _ _ _ ri⟩

end FT1536.Source3.Gen0RawInitialized189
