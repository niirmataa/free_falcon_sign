import Source3.KeygenPublicRoundtrip077
import Source3.KeygenInt16Words076
import Source3.KeygenPublicNormalizePolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicMaterial077
open C99MemoryReference
open KeygenPublicAlgebra (R)
open KeygenInt16Vector076 (lowIndex highIndex)
open KeygenInt16Reads076 (Read)

def coefficient (h : Relation.Rq) (i : Fin 1536) : R :=
  if low : i.val<768 then (h ⟨i.val,low⟩).1 else (h ⟨i.val-768,by have bound:=i.isLt; omega⟩).2
def Realizes (inputs : List (BitVec 16)) (h : Relation.Rq) : Prop :=
  ∃ w : Fin 1536 → BitVec 16, inputs=List.ofFn w ∧ ∀ i, ((w i).toNat : R)=coefficient h i

theorem coefficient_low (h : Relation.Rq) (i : Fin 768) : coefficient h (lowIndex i)=(h i).1 := by
  unfold coefficient lowIndex
  dsimp only
  rw [dite_eq_left i.isLt]
theorem coefficient_high (h : Relation.Rq) (i : Fin 768) : coefficient h (highIndex i)=(h i).2 := by
  unfold coefficient highIndex
  dsimp only
  rw [dite_eq_right (by omega)]
  have same : (⟨i.val+768-768,by have bound:=i.isLt; omega⟩ : Fin 768)=i := by
    apply Fin.ext
    change i.val+768-768=i.val
    omega
  rw [same]

theorem represented_cell (heap : Memory) (ptr : ArrayPointer) (h : Relation.Rq)
    (represented : KeygenPublicNormalizePolynomial.Represents heap ptr h) (i : Fin 1536) :
    ∃ w, Read heap (KeygenDecodeNoneMemory.element ptr i.val) w ∧ w.toNat<18433 ∧ (w.toNat : R)=coefficient h i := by
  by_cases low : i.val<768
  · obtain ⟨w,read,range,value⟩ := (represented ⟨i.val,low⟩).1
    refine ⟨w,KeygenInt16Reads076.narrow_read _ _ _ read,range,?_⟩
    simpa only [coefficient,dite_eq_left low] using value
  · let j : Fin 768 := ⟨i.val-768,by have bound:=i.isLt; omega⟩
    obtain ⟨w,read,range,value⟩ := (represented j).2
    have index : j.val+768=i.val := by dsimp only [j]; omega
    rw [index] at read
    refine ⟨w,KeygenInt16Reads076.narrow_read _ _ _ read,range,?_⟩
    simpa only [coefficient,dite_eq_right low,j] using value

theorem represented_words (heap : Memory) (ptr : ArrayPointer) (h : Relation.Rq)
    (represented : KeygenPublicNormalizePolynomial.Represents heap ptr h) :
    ∃ inputs, inputs.length=1536 ∧ KeygenPublicBits077.Canonical inputs ∧
      KeygenCodecStaticMaterial.Words heap ptr inputs ∧ Realizes inputs h := by
  classical
  choose words reads ranges values using represented_cell heap ptr h represented
  refine ⟨List.ofFn words,List.length_ofFn,?_,?_,⟨words,rfl,values⟩⟩
  · intro input member
    obtain ⟨i,same⟩ := List.mem_ofFn.mp member
    subst input
    exact ranges i
  · apply KeygenInt16Words076.from_reads
    intro i
    have bound : i.val<1536 := by simpa only [List.length_ofFn] using i.isLt
    change Read heap (KeygenDecodeNoneMemory.element ptr i.val) ((List.ofFn words)[i.val]'i.isLt)
    rw [List.getElem_ofFn]
    exact reads ⟨i.val,bound⟩

theorem decoder_narrow (heap : Memory) (ptr : ArrayPointer) (word : BitVec 16)
    (read : KeygenDecodeValues.Load16 heap ptr word) : C99NarrowReads.Load16 heap ptr word := by
  have stored := KeygenInt16Reads076.read_stored heap ptr word (KeygenInt16Reads076.decoder_read heap ptr word read)
  have allocated : Allocated heap ptr := by cases read; assumption
  have width : ptr.elementBytes=2 := by cases read; assumption
  have result := C99NarrowReads.Load16.load heap ptr (KeygenSmallOutput.byte16 word) allocated width stored
  rw [KeygenResidueVectors.join_bytes] at result
  exact result

theorem decoded_represents (heap : Memory) (ptr : ArrayPointer) (h : Relation.Rq) (inputs : List (BitVec 16))
    (canonical : KeygenPublicBits077.Canonical inputs) (realizes : Realizes inputs h)
    (reads : ∀ i : Fin inputs.length, KeygenDecodeValues.Load16 heap (KeygenDecodeNoneMemory.element ptr i.val) inputs[i]) :
    KeygenPublicNormalizePolynomial.Represents heap ptr h := by
  obtain ⟨words,rfl,values⟩ := realizes
  have cells (i : Fin 1536) : KeygenPublicInputCells.Cell heap ptr i.val (coefficient h i) := by
    have bound : i.val<(List.ofFn words).length := by rw [List.length_ofFn]; exact i.isLt
    have read := reads ⟨i.val,bound⟩
    change KeygenDecodeValues.Load16 heap (KeygenDecodeNoneMemory.element ptr i.val) ((List.ofFn words)[i.val]'bound) at read
    rw [List.getElem_ofFn] at read
    exact ⟨words i,decoder_narrow _ _ _ read,canonical (words i) (List.mem_ofFn.mpr ⟨i,rfl⟩),values i⟩
  intro i
  have low := cells (lowIndex i)
  have high := cells (highIndex i)
  rw [coefficient_low] at low
  rw [coefficient_high] at high
  exact ⟨low,high⟩

end FT1536.Source3.KeygenPublicMaterial077
