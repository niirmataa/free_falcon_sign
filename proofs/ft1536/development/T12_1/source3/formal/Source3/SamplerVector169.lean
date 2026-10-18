import Source3.SelectedForwardT168
import Source3.KeygenPublicCommonCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SamplerVector169
open C99MemoryReference (Memory ArrayPointer)
open KeygenPublicInputMaterial (coefficient)

def vector (words : Fin 1536 → BitVec 16) : Geometry.Vec := fun i =>
  ((words ⟨i.val,by have bound:=i.isLt; omega⟩).toInt,
   (words ⟨i.val+768,by have bound:=i.isLt; omega⟩).toInt)

theorem coefficient_word (words : Fin 1536 → BitVec 16) (i : Nat) (inside : i<1536) :
    coefficient (vector words) i=(words ⟨i,inside⟩).toInt := by
  unfold coefficient
  split_ifs with low
  · rfl
  · change (words ⟨i-768+768,_⟩).toInt=(words ⟨i,inside⟩).toInt
    congr 2
    apply Fin.ext
    change i-768+768=i
    omega

theorem signed (heap : Memory) (p : ArrayPointer) (words : Fin 1536 → BitVec 16)
    (image : Word16Memory158.Represents heap p words)
    (small : SelectedPublicBounds158.check words=true) :
    KeygenPublicInputCells.Signed heap p (coefficient (vector words)) := by
  intro i hi
  refine ⟨words ⟨i,hi⟩,image ⟨i,hi⟩,(coefficient_word words i hi).symm,?_,?_⟩
  all_goals
    rw [coefficient_word words i hi]
    rcases SelectedPublicBounds158.sound words small ⟨i,hi⟩ with h|h|h
    all_goals rw [h]; decide +kernel

end FT1536.Source3.SamplerVector169
