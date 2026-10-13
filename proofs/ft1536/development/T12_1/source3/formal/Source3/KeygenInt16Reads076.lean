import Source3.KeygenInt16Vector076

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual little-endian physical16-bit reads and the existing raw-byte
   material predicate. No equality of abstract array names is substituted. -/
namespace FT1536.Source3.KeygenInt16Reads076
open C99MemoryReference

abbrev Read := KeygenCodecValues.Load16

theorem low_byte (hi lo : BitVec 8) : ((hi++lo).setWidth 8)=lo := by
  apply BitVec.eq_of_getLsbD_eq
  intro i bound
  have bits (j : Fin 8) : ((hi++lo).setWidth 8).getLsbD j.val=lo.getLsbD j.val := by
    fin_cases j <;> simp only [BitVec.getLsbD_setWidth,BitVec.getLsbD_append] <;> rfl
  exact bits ⟨i,bound⟩

theorem high_byte (hi lo : BitVec 8) : (((hi++lo) >>> 8).setWidth 8)=hi := by
  apply BitVec.eq_of_getLsbD_eq
  intro i bound
  have bits (j : Fin 8) : (((hi++lo) >>> 8).setWidth 8).getLsbD j.val=hi.getLsbD j.val := by
    fin_cases j <;> simp only [BitVec.getLsbD_setWidth,BitVec.getLsbD_ushiftRight,BitVec.getLsbD_append] <;> rfl
  exact bits ⟨i,bound⟩

theorem stored_read (heap : Memory) (ptr : ArrayPointer) (word : BitVec 16)
    (allocated : Allocated heap ptr) (width : ptr.elementBytes=2)
    (stored : KeygenSmallOutput.Stored heap ptr word) : Read heap ptr word := by
  have low := stored ⟨0,by decide +kernel⟩
  have high := stored ⟨1,by decide +kernel⟩
  change heap.bytes ptr.block (ptr.offset+0)=some ((word >>> 0).setWidth 8) at low
  change heap.bytes ptr.block (ptr.offset+1)=some ((word >>> 8).setWidth 8) at high
  have source : Read heap ptr (((word >>> 8).setWidth 8)++word.setWidth 8) :=
    .load heap ptr (word.setWidth 8) ((word >>> 8).setWidth 8) allocated width
      (by simpa only [Nat.add_zero,BitVec.ushiftRight_zero] using low) high
  rw [KeygenDecodeMemory.bytes_reconstruct] at source
  exact source

theorem read_stored (heap : Memory) (ptr : ArrayPointer) (word : BitVec 16)
    (read : Read heap ptr word) : KeygenSmallOutput.Stored heap ptr word := by
  cases read with
  | load lo hi allocated width low high =>
    intro i
    fin_cases i
    · change heap.bytes ptr.block (ptr.offset+0)=some (((hi++lo) >>> 0).setWidth 8)
      simpa only [Nat.add_zero,BitVec.ushiftRight_zero,low_byte] using low
    · change heap.bytes ptr.block (ptr.offset+1)=some (((hi++lo) >>> 8).setWidth 8)
      simpa only [high_byte] using high

theorem decoder_read (heap : Memory) (ptr : ArrayPointer) (word : BitVec 16)
    (read : KeygenDecodeValues.Load16 heap ptr word) : Read heap ptr word := by
  cases read with
  | load lo hi allocated width low high => exact .load heap ptr lo hi allocated width low high

theorem narrow_read (heap : Memory) (ptr : ArrayPointer) (word : BitVec 16)
    (read : C99NarrowReads.Load16 heap ptr word) : Read heap ptr word := by
  cases read with
  | load bytes allocated width initialized =>
    have low := initialized (0 : Fin 2)
    have high := initialized (1 : Fin 2)
    change heap.bytes ptr.block (ptr.offset+0)=some (bytes 0) at low
    change heap.bytes ptr.block (ptr.offset+1)=some (bytes 1) at high
    exact .load heap ptr (bytes 0) (bytes 1) allocated width
      (by simpa only [Nat.add_zero] using low) high

end FT1536.Source3.KeygenInt16Reads076
