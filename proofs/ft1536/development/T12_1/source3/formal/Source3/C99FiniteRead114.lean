import Source3.C99FiniteMemory114

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99FiniteRead114
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)

instance allocatedDecidable (heap : Memory) (p : ArrayPointer) : Decidable (Allocated heap p) := by
  unfold Allocated
  infer_instance

def readVec (heap : Heap) (block offset : Nat) : (n : Nat) → Option (Fin n → Byte)
  | 0 => some (fun index => Fin.elim0 index)
  | n+1 => do
      let head ← (memory heap).bytes block offset
      let tail ← readVec heap block (offset+1) n
      pure (Fin.cases head tail)

theorem readVec_sound (heap : Heap) (block offset n : Nat) (bytes : Fin n → Byte)
    (read : readVec heap block offset n = some bytes) (index : Fin n) :
    (memory heap).bytes block (offset+index.val) = some (bytes index) := by
  induction n generalizing offset with
  | zero => exact Fin.elim0 index
  | succ n ih =>
      obtain ⟨head, first, rest⟩ := Option.bind_eq_some_iff.mp read
      obtain ⟨tail, following, result⟩ := Option.bind_eq_some_iff.mp rest
      have same : bytes = Fin.cases head tail := (Option.some.inj result).symm
      subst bytes
      refine Fin.cases ?_ (fun i => ?_) index
      · simpa using first
      · simpa only [Fin.val_succ, Fin.cases_succ, Nat.add_assoc, Nat.add_comm 1] using ih (offset+1) tail following i

def read64 (heap : Heap) (p : ArrayPointer) : Option (BitVec 64) :=
  if Allocated (memory heap) p ∧ p.elementBytes=8 then
    (readVec heap p.block p.offset 8).map le64
  else none

theorem read64_sound (heap : Heap) (p : ArrayPointer) (word : BitVec 64)
    (read : read64 heap p = some word) : Load64 (memory heap) p word := by
  unfold read64 at read
  split at read
  next guard =>
    obtain ⟨bytes, loaded, same⟩ := Option.map_eq_some_iff.mp read
    subst word
    exact .load _ _ bytes guard.1 guard.2 (readVec_sound heap p.block p.offset 8 bytes loaded)
  next absent => cases read

def read32 (heap : Heap) (p : ArrayPointer) : Option (BitVec 32) :=
  if Allocated (memory heap) p ∧ p.elementBytes=4 then
    (readVec heap p.block p.offset 4).map le32
  else none

theorem read32_sound (heap : Heap) (p : ArrayPointer) (word : BitVec 32)
    (read : read32 heap p = some word) : Load32 (memory heap) p word := by
  unfold read32 at read
  split at read
  next guard =>
    obtain ⟨bytes, loaded, same⟩ := Option.map_eq_some_iff.mp read
    subst word
    exact .load _ _ bytes guard.1 guard.2 (readVec_sound heap p.block p.offset 4 bytes loaded)
  next absent => cases read

end FT1536.Source3.C99FiniteRead114
