import Source3.KeygenDecodePointerFrame
import Source3.KeygenDecodeStateFrame
import Source3.KeygenDecodeNoneScalar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Physical byte consequences of decoder stores. No output value, returned
   length or whole-decoder frame is assumed in these statements. -/
namespace FT1536.Source3.KeygenDecodeMemory
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference

def Window (ptr : ArrayPointer) (before after : Memory) : Prop :=
  after.size=before.size ∧ after.writable=before.writable ∧
  ∀ block offset, block≠ptr.block ∨ offset<ptr.offset ∨ ptr.base+2*ptr.count≤offset →
    after.bytes block offset=before.bytes block offset

theorem window_refl (ptr : ArrayPointer) (heap : Memory) : Window ptr heap heap :=
  ⟨rfl,rfl,fun _ _ _ => rfl⟩

theorem window_trans (ptr : ArrayPointer) (a b c : Memory)
    (first : Window ptr a b) (second : Window ptr b c) : Window ptr a c :=
  ⟨second.1.trans first.1,second.2.1.trans first.2.1,
    fun block offset outside => (second.2.2 block offset outside).trans (first.2.2 block offset outside)⟩

theorem store_window (ptr atWord : ArrayPointer) (index : Nat) (word : BitVec 16)
    (before after : Memory) (advance : PointerAdd ptr index atWord)
    (store : Store16 before atWord word after) : Window ptr before after := by
  obtain ⟨allocated,width,writable,sizes,permissions,low,high,frame⟩ := store
  cases advance
  have bound : ptr.index+index<ptr.count := allocated.2.2.1
  have ptrWidth : ptr.elementBytes=2 := width
  refine ⟨sizes,permissions,?_⟩
  intro block offset outside
  apply frame block offset
  rcases outside with different | earlier | later
  · exact Or.inl different
  · right; left
    simp only [ArrayPointer.offset] at earlier ⊢
    rw [ptrWidth] at earlier ⊢
    omega
  · right; right
    simp only [ArrayPointer.offset]
    rw [ptrWidth]
    omega

theorem bytes_reconstruct (word : BitVec 16) :
    ((word >>> 8).setWidth 8) ++ word.setWidth 8=word := by
  apply BitVec.eq_of_getLsbD_eq
  intro i bound
  have bits (j : Fin 16) :
      (((word >>> 8).setWidth 8) ++ word.setWidth 8).getLsbD j.val=word.getLsbD j.val := by
    fin_cases j <;> simp only [BitVec.getLsbD_append,BitVec.getLsbD_setWidth,
      BitVec.getLsbD_ushiftRight] <;> rfl
  exact bits ⟨i,bound⟩

theorem store_readback (ptr : ArrayPointer) (word : BitVec 16) (before after : Memory)
    (store : Store16 before ptr word after) : Load16 after ptr word := by
  obtain ⟨allocated,width,writable,sizes,permissions,low,high,frame⟩ := store
  have loaded := Load16.load after ptr (word.setWidth 8) ((word >>> 8).setWidth 8)
    (by simpa only [Allocated,sizes] using allocated) width low high
  simpa only [bytes_reconstruct] using loaded

theorem load_unique (heap : Memory) (ptr : ArrayPointer) (a b : BitVec 16)
    (first : Load16 heap ptr a) (second : Load16 heap ptr b) : a=b := by
  cases first with
  | load lo hi allocated width low high =>
    cases second with
    | load lo' hi' allocated' width' low' high' =>
      have sameLo := Option.some.inj (low.symm.trans low')
      have sameHi := Option.some.inj (high.symm.trans high')
      subst lo'; subst hi'; rfl

/-- Writing the word already represented at the destination restores every
    physical byte of that memory, including its metadata. -/
theorem store_same_memory (ptr : ArrayPointer) (word : BitVec 16) (before after : Memory)
    (load : Load16 before ptr word) (store : Store16 before ptr word after) : after=before := by
  obtain ⟨allocated,width,writable,sizes,permissions,low,high,frame⟩ := store
  cases load with
  | load lo hi allocated' width' oldLow oldHigh =>
    have lowByte : (hi ++ lo).setWidth 8=lo := by
      have bits (i : Fin 8) : ((hi ++ lo).setWidth 8).getLsbD i.val=lo.getLsbD i.val := by
        fin_cases i <;> simp only [BitVec.getLsbD_setWidth,BitVec.getLsbD_append] <;> rfl
      apply BitVec.eq_of_getLsbD_eq
      intro i bound
      exact bits ⟨i,bound⟩
    have highByte : ((hi ++ lo) >>> 8).setWidth 8=hi := by
      have bits (i : Fin 8) : (((hi ++ lo) >>> 8).setWidth 8).getLsbD i.val=hi.getLsbD i.val := by
        fin_cases i <;> simp only [BitVec.getLsbD_setWidth,BitVec.getLsbD_ushiftRight,
          BitVec.getLsbD_append] <;> rfl
      apply BitVec.eq_of_getLsbD_eq
      intro i bound
      exact bits ⟨i,bound⟩
    rw [lowByte] at low
    rw [highByte] at high
    have bytes : after.bytes=before.bytes := by
      funext block offset
      by_cases sameBlock : block=ptr.block
      · subst block
        by_cases atLow : offset=ptr.offset
        · subst offset; exact low.trans oldLow.symm
        · by_cases atHigh : offset=ptr.offset+1
          · subst offset; exact high.trans oldHigh.symm
          · exact frame _ _ (by omega)
      · exact frame _ _ (Or.inl sameBlock)
    cases before; cases after
    simp_all

end FT1536.Source3.KeygenDecodeMemory
