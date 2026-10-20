import Source3.NttInverseFinalPass192
import Source3.NttInverseMiddleRounds192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Word bridges between the three inverse passes, only as executed word
   terms: the composed round-8 image at index 0 gives the final-pass pairs
   (j, j+256) over the fvAt 8 words, the final-pass output image feeds the
   correction input through the finalWord case split at 256 (lowWord/
   highWord of the fvAt 8 words), and the correction words are the
   scale/Montgomery words over those with the niWord (modp_R/modp_div)
   cell word. No transform property, root law or numerical claim. -/
namespace FT1536.Source3.NttInverseWholeBridges192
open C99MemoryReference (ArrayPointer Load32)
open NttInverseCorrectionLoop192 (walk)
open NttInverseCorrection192 (niWord)

def fv8 (fv0 : Nat → BitVec 32) (tws : Nat → BitVec 32) (p p0i : BitVec 32) : Nat → BitVec 32 :=
  NttInverseMiddleRounds192.fvAt fv0 tws p p0i 8

def finalWord (fv0 : Nat → BitVec 32) (tws : Nat → BitVec 32) (p p0i : BitVec 32) (k : Nat) :
    BitVec 32 :=
  if k < 256 then NttInverseFinalLoop192.lowWord (fv8 fv0 tws p p0i) k 256 (tws 0) p p0i
  else NttInverseFinalLoop192.highWord (fv8 fv0 tws p p0i) (k-256) 256 (tws 0) p p0i

def scaledWord (fv0 : Nat → BitVec 32) (tws : Nat → BitVec 32) (p p0i : BitVec 32) (k : Nat) :
    BitVec 32 :=
  NttInverseCorrectionLoop192.scale (finalWord fv0 tws p p0i k) (niWord p p0i) p p0i

theorem tOf_eight : NttInverseMiddleRounds192.tOf 8=512 := rfl
theorem htOf_eight : NttInverseMiddleRounds192.htOf 8=256 := rfl
theorem mOf_eight : NttInverseMiddleRounds192.mOf 8=1 := rfl
theorem tOf_zero : NttInverseMiddleRounds192.tOf 0=2 := rfl
theorem htOf_zero : NttInverseMiddleRounds192.htOf 0=1 := rfl
theorem mOf_zero : NttInverseMiddleRounds192.mOf 0=256 := rfl

/- Bridge 1: the round-8 image at index 0 is the raw load of every walked
   position with the composed fvAt 8 word. -/
theorem round_raw (s : C99ArrayReference.State) (a : ArrayPointer) (stride : Nat)
    (tws : Nat → BitVec 32) (p p0i : BitVec 32) (fv0 : Nat → BitVec 32)
    (image : NttInverseMiddleU1Loop192.Image s a stride (NttInverseMiddleRounds192.tOf 8)
      (NttInverseMiddleRounds192.htOf 8) (NttInverseMiddleRounds192.mOf 8)
      (NttInverseMiddleRounds192.roundTws tws 8) p p0i (fv8 fv0 tws p p0i) 0) :
    ∀ k : Nat, k < 512 → Load32 s.heap (walk a k stride) (fv8 fv0 tws p p0i k) := by
  intro k bound
  rw [tOf_eight,htOf_eight,mOf_eight] at image
  by_cases low : k < 256
  · have facts := image 0 k (by decide) low
    have loads := facts.2 (Nat.le_refl 0)
    have position : (0:Nat)*512+k=k := by omega
    rw [position] at loads
    exact loads.1
  · have upper : k-256<256 := by omega
    have facts := image 0 (k-256) (by decide) upper
    have loads := facts.2 (Nat.le_refl 0)
    have position : (0:Nat)*512+256+(k-256)=k := by omega
    rw [position] at loads
    exact loads.2

/- The raw image at the call entry: every walked position holds the fv0
   word, presented as the round-0 image of the intermediate pass. -/
theorem start_image (s : C99ArrayReference.State) (a : ArrayPointer) (stride : Nat)
    (tws : Nat → BitVec 32) (p p0i : BitVec 32) (fv0 : Nat → BitVec 32)
    (raw : ∀ k : Nat, k < 512 → Load32 s.heap (walk a k stride) (fv0 k)) :
    NttInverseMiddleU1Loop192.Image s a stride (NttInverseMiddleRounds192.tOf 0)
      (NttInverseMiddleRounds192.htOf 0) (NttInverseMiddleRounds192.mOf 0)
      (NttInverseMiddleRounds192.roundTws tws 0) p p0i fv0 0 := by
  intro g j gBound jBound
  rw [tOf_zero,htOf_zero,mOf_zero] at *
  refine ⟨fun impossible => absurd impossible (by omega),fun _ => ⟨?_,?_⟩⟩
  · exact raw (g*2+j) (by omega)
  · exact raw (g*2+1+j) (by omega)

/- Bridge 2: the raw round-8 words are exactly the final-pass input pairs
   (j, j+256) for j<256. -/
theorem final_input (s : C99ArrayReference.State) (a : ArrayPointer) (stride : Nat)
    (tws : Nat → BitVec 32) (p p0i : BitVec 32) (fv0 : Nat → BitVec 32)
    (raw : ∀ k : Nat, k < 512 → Load32 s.heap (walk a k stride) (fv8 fv0 tws p p0i k)) :
    NttInverseFinalLoop192.Image s a stride 256 (tws 0) p p0i (fv8 fv0 tws p p0i) 0 := by
  intro j jBound
  refine ⟨fun impossible => absurd impossible (by omega),fun _ => ⟨?_,?_⟩⟩
  · exact raw j (by omega)
  · exact raw (j+256) (by omega)

/- Bridge 3: the final-pass output image is the correction input through
   the finalWord case split at 256. -/
theorem correction_input (s : C99ArrayReference.State) (a : ArrayPointer) (stride : Nat)
    (tws : Nat → BitVec 32) (p p0i : BitVec 32) (fv0 : Nat → BitVec 32)
    (image : NttInverseFinalLoop192.Image s a stride 256 (tws 0) p p0i (fv8 fv0 tws p p0i) 256) :
    NttInverseCorrectionLoop192.Image s a stride 512 p p0i (niWord p p0i) (finalWord fv0 tws p p0i)
      0 := by
  intro j jBound
  refine ⟨fun impossible => absurd impossible (by omega),fun _ => ?_⟩
  by_cases low : j < 256
  · have load := (image j (by omega)).1 low
    have word : finalWord fv0 tws p p0i j=
        NttInverseFinalLoop192.lowWord (fv8 fv0 tws p p0i) j 256 (tws 0) p p0i := by
      unfold finalWord
      split
      · rfl
      · next impossible => exact (impossible low).elim
    rw [word]
    exact load.1
  · have upper : j-256<256 := by omega
    have load := (image (j-256) upper).1 (by omega)
    have position : j-256+256=j := by omega
    rw [position] at load
    have word : finalWord fv0 tws p p0i j=
        NttInverseFinalLoop192.highWord (fv8 fv0 tws p p0i) (j-256) 256 (tws 0) p p0i := by
      unfold finalWord
      split
      · next impossible => exact (low impossible).elim
      · rfl
    rw [word]
    exact load.2

end FT1536.Source3.NttInverseWholeBridges192
