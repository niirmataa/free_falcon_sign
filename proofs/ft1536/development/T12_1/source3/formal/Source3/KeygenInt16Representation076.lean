import Source3.KeygenInt16Words076

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Bind the EXISTING source-proved paired mathematical material to actual
   codec words and back. Allocation is explicit; agreement is derived from
   the real bytes, never from equality of array names. -/
namespace FT1536.Source3.KeygenInt16Representation076
open C99MemoryReference KeygenInt16Reads076
open KeygenInt16Vector076 (lowIndex highIndex coefficient words vector Signed16)
open KeygenInt16Words076 (element CodecWords)

def wordList (v : Geometry.Vec) : List (BitVec 16) := List.ofFn (words v)
def Indexed (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec) : Prop :=
  ∀ i : Fin 1536, Read heap (element ptr i.val) (words v i)

theorem wordList_length (v : Geometry.Vec) : (wordList v).length=1536 := List.length_ofFn

theorem wordList_get (v : Geometry.Vec) (i : Nat) (bound : i<1536) :
    (wordList v)[i]'(by rw [wordList_length]; exact bound)=words v ⟨i,bound⟩ := by
  unfold wordList
  rw [List.getElem_ofFn]

theorem represented_stored (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (represented : KeygenMaterial.Represents heap ptr v) (i : Fin 1536) :
    KeygenSmallOutput.Stored heap (element ptr i.val) (words v i) := by
  by_cases low : i.val<768
  · let j : Fin 768 := ⟨i.val,low⟩
    have same : lowIndex j=i := by apply Fin.ext; rfl
    rw [←same]
    change KeygenSmallOutput.Stored heap (KeygenSmallOutput.element ptr j.val) (BitVec.ofInt 16 (coefficient v (lowIndex j)))
    rw [KeygenInt16Vector076.coefficient_low]
    exact (represented j).1
  · let j : Fin 768 := ⟨i.val-768,by have bound:=i.isLt; omega⟩
    have same : highIndex j=i := by apply Fin.ext; dsimp [highIndex,j]; omega
    rw [←same]
    change KeygenSmallOutput.Stored heap (KeygenSmallOutput.element ptr (j.val+768)) (BitVec.ofInt 16 (coefficient v (highIndex j)))
    rw [KeygenInt16Vector076.coefficient_high]
    exact (represented j).2

theorem represents_indexed (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (legal : KeygenPublicInputMaterial.Legal heap ptr) (represented : KeygenMaterial.Represents heap ptr v) :
    Indexed heap ptr v := by
  intro i
  exact stored_read heap (element ptr i.val) (words v i) (legal.2 i.val i.isLt) legal.1
    (represented_stored heap ptr v represented i)

theorem indexed_represents (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (indexed : Indexed heap ptr v) : KeygenMaterial.Represents heap ptr v := by
  intro i
  have low := indexed (lowIndex i)
  have high := indexed (highIndex i)
  change Read heap (KeygenSmallOutput.element ptr i.val) (BitVec.ofInt 16 (coefficient v (lowIndex i))) at low
  change Read heap (KeygenSmallOutput.element ptr (i.val+768)) (BitVec.ofInt 16 (coefficient v (highIndex i))) at high
  rw [KeygenInt16Vector076.coefficient_low] at low
  rw [KeygenInt16Vector076.coefficient_high] at high
  exact ⟨read_stored _ _ _ low,read_stored _ _ _ high⟩

theorem indexed_words (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (indexed : Indexed heap ptr v) : CodecWords heap ptr (wordList v) := by
  apply KeygenInt16Words076.from_reads
  intro i
  have bound : i.val<1536 := by simpa only [wordList_length] using i.isLt
  have read := indexed ⟨i.val,bound⟩
  change Read heap (element ptr i.val) ((wordList v)[i.val]'i.isLt)
  rw [wordList_get v i.val bound]
  exact read

theorem words_indexed (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (material : CodecWords heap ptr (wordList v)) : Indexed heap ptr v := by
  intro i
  have bound : i.val<(wordList v).length := by rw [wordList_length]; exact i.isLt
  have read := KeygenInt16Words076.to_reads heap ptr (wordList v) material ⟨i.val,bound⟩
  change Read heap (element ptr i.val) ((wordList v)[i.val]'bound) at read
  rw [wordList_get v i.val i.isLt] at read
  exact read

theorem represents_words (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (legal : KeygenPublicInputMaterial.Legal heap ptr) (represented : KeygenMaterial.Represents heap ptr v) :
    CodecWords heap ptr (wordList v) := indexed_words heap ptr v (represents_indexed heap ptr v legal represented)

theorem words_represents (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (material : CodecWords heap ptr (wordList v)) : KeygenMaterial.Represents heap ptr v :=
  indexed_represents heap ptr v (words_indexed heap ptr v material)

theorem represents_iff_words (heap : Memory) (ptr : ArrayPointer) (v : Geometry.Vec)
    (legal : KeygenPublicInputMaterial.Legal heap ptr) :
    KeygenMaterial.Represents heap ptr v ↔ CodecWords heap ptr (wordList v) :=
  ⟨represents_words heap ptr v legal,words_represents heap ptr v⟩

theorem represents_unique (heap : Memory) (ptr : ArrayPointer) (v w : Geometry.Vec)
    (legal : KeygenPublicInputMaterial.Legal heap ptr) (signedV : Signed16 v) (signedW : Signed16 w)
    (first : KeygenMaterial.Represents heap ptr v) (second : KeygenMaterial.Represents heap ptr w) : v=w := by
  have readsV := represents_indexed heap ptr v legal first
  have readsW := represents_indexed heap ptr w legal second
  have same : words v=words w := by
    funext i
    exact KeygenCodecStaticMaterial.load_unique heap _ _ _ (readsV i) (readsW i)
  calc
    v=vector (words v) := (KeygenInt16Vector076.vector_words v signedV).symm
    _=vector (words w) := congrArg vector same
    _=w := KeygenInt16Vector076.vector_words w signedW

end FT1536.Source3.KeygenInt16Representation076
