import Source3.NttInverseCorrectionSource201
import Source3.NttInverseFinal201
import Source3.NttInverseWholeBridges192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseWholeBridges201
open C99MemoryReference (ArrayPointer Load32)
open MkgmParams198 (Level half)
open NttInverseCorrectionLoop192 (walk)
open NttInverseCorrection201 (niWord)
open NttInverseSchedule201 (size mOf)
open NttInverseLoop201 (t_last)
open NttInverseWholeBridges192 (tOf_zero htOf_zero)

def fvLast (l : Level) (fv0 : Nat → BitVec 32) (tws : Nat → BitVec 32) (p p0i : BitVec 32) : Nat → BitVec 32 :=
  NttInverseSchedule201.fvAt l fv0 tws p p0i l.val

def finalWord (l : Level) (fv0 : Nat → BitVec 32) (tws : Nat → BitVec 32) (p p0i : BitVec 32) (k : Nat) : BitVec 32 :=
  if k<half l then NttInverseFinalLoop192.lowWord (fvLast l fv0 tws p p0i) k (half l) (tws 0) p p0i
  else NttInverseFinalLoop192.highWord (fvLast l fv0 tws p p0i) (k-half l) (half l) (tws 0) p p0i

def scaledWord (l : Level) (fv0 : Nat → BitVec 32) (tws : Nat → BitVec 32) (p p0i : BitVec 32) (k : Nat) : BitVec 32 :=
  NttInverseCorrectionLoop192.scale (finalWord l fv0 tws p p0i k) (niWord l p p0i) p p0i

theorem ht_last (l : Level) : NttInverseMiddleRounds192.htOf l.val=half l := rfl
theorem m_last (l : Level) : mOf l l.val=1 := by simp [mOf]
theorem m_zero (l : Level) : mOf l 0=half l := rfl

theorem round_raw (l : Level) (s : C99ArrayReference.State) (a : ArrayPointer) (stride : Nat)
    (tws : Nat → BitVec 32) (p p0i : BitVec 32) (fv0 : Nat → BitVec 32)
    (image : NttInverseMiddleU1Loop192.Image s a stride (NttInverseMiddleRounds192.tOf l.val)
      (NttInverseMiddleRounds192.htOf l.val) (NttInverseSchedule201.mOf l l.val)
      (NttInverseSchedule201.roundTws l tws l.val) p p0i (fvLast l fv0 tws p p0i) 0) :
    ∀ k : Nat, k < (size l) → Load32 s.heap (walk a k stride) (fvLast l fv0 tws p p0i k) := by
  have sizeHalf : size l=2*half l := rfl
  intro k bound
  rw [t_last,ht_last,m_last] at image
  by_cases low : k < (half l)
  · have facts := image 0 k (by decide) low
    have loads := facts.2 (Nat.le_refl 0)
    have position : (0:Nat)*(size l)+k=k := by omega
    rw [position] at loads
    exact loads.1
  · have upper : k-(half l)<(half l) := by omega
    have facts := image 0 (k-(half l)) (by decide) upper
    have loads := facts.2 (Nat.le_refl 0)
    have position : (0:Nat)*(size l)+(half l)+(k-(half l))=k := by omega
    rw [position] at loads
    exact loads.2


theorem start_image (l : Level) (s : C99ArrayReference.State) (a : ArrayPointer) (stride : Nat)
    (tws : Nat → BitVec 32) (p p0i : BitVec 32) (fv0 : Nat → BitVec 32)
    (raw : ∀ k : Nat, k < (size l) → Load32 s.heap (walk a k stride) (fv0 k)) :
    NttInverseMiddleU1Loop192.Image s a stride (NttInverseMiddleRounds192.tOf 0)
      (NttInverseMiddleRounds192.htOf 0) (NttInverseSchedule201.mOf l 0)
      (NttInverseSchedule201.roundTws l tws 0) p p0i fv0 0 := by
  have sizeHalf : size l=2*half l := rfl
  intro g j gBound jBound
  rw [tOf_zero,htOf_zero,m_zero] at *
  refine ⟨fun impossible => absurd impossible (by omega),fun _ => ⟨?_,?_⟩⟩
  · exact raw (g*2+j) (by omega)
  · exact raw (g*2+1+j) (by omega)


theorem final_input (l : Level) (s : C99ArrayReference.State) (a : ArrayPointer) (stride : Nat)
    (tws : Nat → BitVec 32) (p p0i : BitVec 32) (fv0 : Nat → BitVec 32)
    (raw : ∀ k : Nat, k < (size l) → Load32 s.heap (walk a k stride) (fvLast l fv0 tws p p0i k)) :
    NttInverseFinalLoop192.Image s a stride (half l) (tws 0) p p0i (fvLast l fv0 tws p p0i) 0 := by
  have sizeHalf : size l=2*half l := rfl
  intro j jBound
  refine ⟨fun impossible => absurd impossible (by omega),fun _ => ⟨?_,?_⟩⟩
  · exact raw j (by omega)
  · exact raw (j+(half l)) (by omega)


theorem correction_input (l : Level) (s : C99ArrayReference.State) (a : ArrayPointer) (stride : Nat)
    (tws : Nat → BitVec 32) (p p0i : BitVec 32) (fv0 : Nat → BitVec 32)
    (image : NttInverseFinalLoop192.Image s a stride (half l) (tws 0) p p0i (fvLast l fv0 tws p p0i) (half l)) :
    NttInverseCorrectionLoop192.Image s a stride (size l) p p0i (niWord l p p0i) (finalWord l fv0 tws p p0i)
      0 := by
  have sizeHalf : size l=2*half l := rfl
  intro j jBound
  refine ⟨fun impossible => absurd impossible (by omega),fun _ => ?_⟩
  by_cases low : j < (half l)
  · have load := (image j (by omega)).1 low
    have word : finalWord l fv0 tws p p0i j=
        NttInverseFinalLoop192.lowWord (fvLast l fv0 tws p p0i) j (half l) (tws 0) p p0i := by
      unfold finalWord
      split
      · rfl
      · next impossible => exact (impossible low).elim
    rw [word]
    exact load.1
  · have upper : j-(half l)<(half l) := by omega
    have load := (image (j-(half l)) upper).1 (by omega)
    have position : j-(half l)+(half l)=j := by omega
    rw [position] at load
    have word : finalWord l fv0 tws p p0i j=
        NttInverseFinalLoop192.highWord (fvLast l fv0 tws p p0i) (j-(half l)) (half l) (tws 0) p p0i := by
      unfold finalWord
      split
      · next impossible => exact (low impossible).elim
      · rfl
    rw [word]
    exact load.2

end FT1536.Source3.NttInverseWholeBridges201
