import Source3.C99FiniteInit123
import Source3.KeygenResidueVectors

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99FiniteWords123
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open C99FiniteInit123

theorem load32 (heap : Heap) (block n : Nat) (writable : Bool) (words : Fin n → BitVec 32)
    (fits : 4*n<2^64) (i : Fin n) :
    Load32 (memory (install heap block (4*n) writable (words32 words)))
      ⟨block,4*i.val,1,4,0⟩ (words i) := by
  have size : (memory (install heap block (4*n) writable (words32 words))).size block=4*n := by
    rw [(metadata heap block (4*n) writable (words32 words)).1]
    simp
  rw [← StableBinaryByteView.flag_join_bytes (words i)]
  refine Load32.load _ _ (byte32 (words i)) ?_ rfl ?_
  · simp only [Allocated,size]
    refine ⟨by decide,?_,by decide,?_,fits⟩ <;> omega
  · intro j
    have h := initialized heap block (4*n) writable (words32 words) ⟨4*i.val+j.val,by omega⟩
    rw [words32_at] at h
    simpa only [ArrayPointer.offset,Nat.mul_zero,Nat.add_zero] using h

theorem load64 (heap : Heap) (block n : Nat) (writable : Bool) (words : Fin n → BitVec 64)
    (fits : 8*n<2^64) (i : Fin n) :
    Load64 (memory (install heap block (8*n) writable (words64 words)))
      ⟨block,8*i.val,1,8,0⟩ (words i) := by
  have size : (memory (install heap block (8*n) writable (words64 words))).size block=8*n := by
    rw [(metadata heap block (8*n) writable (words64 words)).1]
    simp
  rw [← B20.Word.LE.join_byteOf (words i)]
  refine Load64.load _ _ (byte64 (words i)) ?_ rfl ?_
  · simp only [Allocated,size]
    refine ⟨by decide,?_,by decide,?_,fits⟩ <;> omega
  · intro j
    have h := initialized heap block (8*n) writable (words64 words) ⟨8*i.val+j.val,by omega⟩
    rw [words64_at] at h
    simpa only [ArrayPointer.offset,Nat.mul_zero,Nat.add_zero] using h

def words16 {n : Nat} (words : Fin n → BitVec 16) (i : Fin (2*n)) : Byte :=
  KeygenSmallOutput.byte16 (words ⟨i.val/2,by omega⟩) ⟨i.val%2,Nat.mod_lt _ (by decide)⟩

theorem words16_at {n : Nat} (words : Fin n → BitVec 16) (i : Fin n) (j : Fin 2) :
    words16 words ⟨2*i.val+j.val,by omega⟩=KeygenSmallOutput.byte16 (words i) j := by
  unfold words16
  have div : (2*i.val+j.val)/2=i.val := by omega
  have mod : (2*i.val+j.val)%2=j.val := by omega
  simp only [div,mod]

theorem load16 (heap : Heap) (block n : Nat) (writable : Bool) (words : Fin n → BitVec 16)
    (fits : 2*n<2^64) (i : Fin n) :
    C99NarrowReads.Load16 (memory (install heap block (2*n) writable (words16 words)))
      ⟨block,2*i.val,1,2,0⟩ (words i) := by
  have size : (memory (install heap block (2*n) writable (words16 words))).size block=2*n := by
    rw [(metadata heap block (2*n) writable (words16 words)).1]
    simp
  rw [← KeygenResidueVectors.join_bytes (words i)]
  refine C99NarrowReads.Load16.load _ _ (KeygenSmallOutput.byte16 (words i)) ?_ rfl ?_
  · simp only [Allocated,size]
    refine ⟨by decide,?_,by decide,?_,fits⟩ <;> omega
  · intro j
    have h := initialized heap block (2*n) writable (words16 words) ⟨2*i.val+j.val,by omega⟩
    rw [words16_at] at h
    simpa only [ArrayPointer.offset,Nat.mul_zero,Nat.add_zero] using h

end FT1536.Source3.C99FiniteWords123
