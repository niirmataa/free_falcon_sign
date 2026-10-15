import Source3.SelectedFftGComplete150
import Source3.C99Load64Frame148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGFrame150
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents element)
open SelectedFftGComplete150 (after)

theorem sizes : after.heap.size=SelectedFftFComplete148.after.heap.size :=
  SelectedFftGTripling150.loop_frame.sizes.trans
    (SelectedFftGMiddle150.frame.sizes.trans SelectedFftGFirst150.frame.sizes)

theorem permissions : after.heap.writable=SelectedFftFComplete148.after.heap.writable :=
  SelectedFftGTripling150.loop_frame.writable.trans
    (SelectedFftGMiddle150.frame.writable.trans SelectedFftGFirst150.frame.writable)

theorem outside (block offset : Nat) (separate : FftLoopFrame141.Outside SelectedFftGInput148.base 1536 block offset) :
    after.heap.bytes block offset=SelectedFftFComplete148.after.heap.bytes block offset :=
  (SelectedFftGTripling150.loop_frame.bytes block offset separate).trans
    ((SelectedFftGMiddle150.frame.bytes block offset separate).trans (SelectedFftGFirst150.frame.bytes block offset separate))

theorem pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment after.heap :=
  FftPinned139.procedure _ _ _ _ SelectedFftGComplete150.source SelectedFftFFrame148.pinned

theorem rt1_outside (i : Fin 1536) (j : Fin 8) :
    FftLoopFrame141.Outside SelectedFftGInput148.base 1536 (element SelectedFftBuffer141.base i).block
      ((element SelectedFftBuffer141.base i).offset+j.val) := by
  have iBound := i.isLt
  have jBound := j.isLt
  simp only [FftLoopFrame141.Outside,SelectedFftGInput148.base,SelectedFftBuffer141.base,
    GeneratedFft140Middle16.pointer,element,ArrayPointer.offset,Nat.zero_add]
  omega

/-- The second actual call preserves the complete output of the first FFT. -/
theorem rt1_image : Represents after.heap SelectedFftBuffer141.base SelectedTripling148.finalValues := by
  intro i
  exact C99Load64Frame148.source SelectedFftFComplete148.after.heap after.heap (element SelectedFftBuffer141.base i)
    (SelectedTripling148.finalValues i) sizes (fun j => outside _ _ (rt1_outside i j)) (SelectedFftFComplete148.image i)

theorem both_images : Represents after.heap SelectedFftBuffer141.base SelectedTripling148.finalValues ∧
    Represents after.heap SelectedFftGInput148.base SelectedFftGTripling150.finalValues :=
  ⟨rt1_image,SelectedFftGComplete150.image⟩

end FT1536.Source3.SelectedFftGFrame150
