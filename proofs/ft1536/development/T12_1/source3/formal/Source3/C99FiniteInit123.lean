import Source3.C99FiniteWrite114
import Source3.C99NarrowReads
import Source3.KeygenMakeEntry

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99FiniteInit123
open C99MemoryReference
open C99FiniteMemory114 (Heap memory putBlock)
open C99FiniteWrite114 (writeVec)

/-- Data construction, not a C write: immutable source tables may be
    initialized here, while later execution retains their readonly bit. -/
def install (heap : Heap) (block n : Nat) (writable : Bool) (bytes : Fin n → Byte) : Heap :=
  writeVec (putBlock heap block ⟨n,writable,none,.empty⟩) block 0 n bytes

theorem metadata (heap : Heap) (block n : Nat) (writable : Bool) (bytes : Fin n → Byte) :
    (memory (install heap block n writable bytes)).size =
      (fun b => if b=block then n else (memory heap).size b) ∧
    (memory (install heap block n writable bytes)).writable =
      (fun b => if b=block then writable else (memory heap).writable b) := by
  have h := C99FiniteWrite114.writeVec_metadata (putBlock heap block ⟨n,writable,none,.empty⟩) block 0 n bytes
  unfold install
  constructor
  · rw [h.1]
    funext b
    exact C99FiniteMemory114.size_putBlock heap block b _
  · rw [h.2]
    funext b
    exact C99FiniteMemory114.writable_putBlock heap block b _

theorem initialized (heap : Heap) (block n : Nat) (writable : Bool) (bytes : Fin n → Byte)
    (i : Fin n) : (memory (install heap block n writable bytes)).bytes block i.val=some (bytes i) := by
  have bound : 0+n≤(memory (putBlock heap block ⟨n,writable,none,.empty⟩)).size block := by
    rw [C99FiniteMemory114.size_putBlock]
    simp
  simpa only [install,Nat.zero_add] using C99FiniteWrite114.writeVec_at _ block 0 n bytes bound i

theorem outside (heap : Heap) (block n : Nat) (writable : Bool) (bytes : Fin n → Byte)
    (other : Nat) (different : other≠block) :
    KeygenMakeObjects.Block (memory heap) (memory (install heap block n writable bytes)) other := by
  have h := metadata heap block n writable bytes
  refine ⟨by rw [h.1]; simp [different],by rw [h.2]; simp [different],?_⟩
  intro offset
  unfold install
  rw [C99FiniteWrite114.writeVec_frame _ block 0 n bytes other offset (Or.inl different),
    C99FiniteMemory114.bytes_putBlock]
  simp [different]

def words32 {n : Nat} (words : Fin n → BitVec 32) (i : Fin (4*n)) : Byte :=
  byte32 (words ⟨i.val/4,by omega⟩) ⟨i.val%4,Nat.mod_lt _ (by decide)⟩

def words64 {n : Nat} (words : Fin n → BitVec 64) (i : Fin (8*n)) : Byte :=
  byte64 (words ⟨i.val/8,by omega⟩) ⟨i.val%8,Nat.mod_lt _ (by decide)⟩

theorem words32_at {n : Nat} (words : Fin n → BitVec 32) (i : Fin n) (j : Fin 4) :
    words32 words ⟨4*i.val+j.val,by omega⟩=byte32 (words i) j := by
  unfold words32
  have div : (4*i.val+j.val)/4=i.val := by omega
  have mod : (4*i.val+j.val)%4=j.val := by omega
  simp only [div,mod]

theorem words64_at {n : Nat} (words : Fin n → BitVec 64) (i : Fin n) (j : Fin 8) :
    words64 words ⟨8*i.val+j.val,by omega⟩=byte64 (words i) j := by
  unfold words64
  have div : (8*i.val+j.val)/8=i.val := by omega
  have mod : (8*i.val+j.val)%8=j.val := by omega
  simp only [div,mod]

end FT1536.Source3.C99FiniteInit123
