import Source3.C99FiniteRead114

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99FiniteWrite114
open C99MemoryReference
open C99FiniteMemory114
open C99FiniteMap114 (lookup)

theorem byte_frame (heap : Heap) (block offset : Nat) (value : Byte) (other position : Nat)
    (outside : other≠block ∨ position≠offset) :
    (memory (putByte heap block offset value)).bytes other position = (memory heap).bytes other position := by
  cases found : lookup heap.blocks block with
  | none => simp [putByte, found]
  | some data =>
      rw [putByte, found, bytes_putBlock]
      by_cases same : other=block
      · subst other
        have different : position≠offset := by simpa using outside
        simp [read_put, different, memory, found]
      · simp [same]

theorem byte_at (heap : Heap) (block offset : Nat) (value : Byte)
    (inside : offset<(memory heap).size block) :
    (memory (putByte heap block offset value)).bytes block offset = some value := by
  cases found : lookup heap.blocks block with
  | none => simp [memory, found] at inside
  | some data =>
      have bound : offset<data.size := by simpa [memory, found] using inside
      simpa using byte_effect heap block offset value data found bound block offset

def writeVec (heap : Heap) (block offset : Nat) : (n : Nat) → (Fin n → Byte) → Heap
  | 0, _ => heap
  | n+1, values => writeVec (putByte heap block offset (values 0)) block (offset+1) n (fun i => values i.succ)

theorem writeVec_metadata (heap : Heap) (block offset n : Nat) (values : Fin n → Byte) :
    (memory (writeVec heap block offset n values)).size = (memory heap).size ∧
    (memory (writeVec heap block offset n values)).writable = (memory heap).writable := by
  induction n generalizing heap offset with
  | zero => exact ⟨rfl,rfl⟩
  | succ n ih =>
      have tail := ih (putByte heap block offset (values 0)) (offset+1) (fun i => values i.succ)
      have head := byte_metadata heap block offset (values 0)
      exact ⟨tail.1.trans head.1,tail.2.trans head.2⟩

theorem writeVec_frame (heap : Heap) (block offset n : Nat) (values : Fin n → Byte)
    (other position : Nat) (outside : other≠block ∨ position<offset ∨ offset+n≤position) :
    (memory (writeVec heap block offset n values)).bytes other position = (memory heap).bytes other position := by
  induction n generalizing heap offset with
  | zero => rfl
  | succ n ih =>
      change (memory (writeVec (putByte heap block offset (values 0)) block (offset+1) n
        (fun i => values i.succ))).bytes other position = _
      rw [ih _ (offset+1) _ (by omega)]
      exact byte_frame heap block offset (values 0) other position (by omega)

theorem writeVec_at (heap : Heap) (block offset n : Nat) (values : Fin n → Byte)
    (inside : offset+n≤(memory heap).size block) (index : Fin n) :
    (memory (writeVec heap block offset n values)).bytes block (offset+index.val) = some (values index) := by
  induction n generalizing heap offset with
  | zero => exact Fin.elim0 index
  | succ n ih =>
      have metadata := byte_metadata heap block offset (values 0)
      have bound : offset+1+n≤(memory (putByte heap block offset (values 0))).size block := by
        rw [metadata.1]
        omega
      refine Fin.cases ?_ (fun i => ?_) index
      · change (memory (writeVec (putByte heap block offset (values 0)) block (offset+1) n
          (fun i => values i.succ))).bytes block offset = some (values 0)
        rw [writeVec_frame _ block (offset+1) n _ block offset (by omega)]
        exact byte_at heap block offset (values 0) (by omega)
      · simpa only [writeVec, Fin.val_succ, Nat.add_assoc, Nat.add_comm 1] using
          ih (putByte heap block offset (values 0)) (offset+1) (fun j => values j.succ) bound i

def write64 (heap : Heap) (p : ArrayPointer) (word : BitVec 64) : Heap :=
  writeVec heap p.block p.offset 8 (byte64 word)

theorem write64_sound (heap : Heap) (p : ArrayPointer) (word : BitVec 64)
    (allocated : Allocated (memory heap) p) (width : p.elementBytes=8)
    (writable : (memory heap).writable p.block=true) :
    Store64 (memory heap) p word (memory (write64 heap p word)) := by
  have extent : p.offset+8≤(memory heap).size p.block := by
    obtain ⟨_,_,index,size,_⟩ := allocated
    simp only [width] at size
    simp only [ArrayPointer.offset,width]
    omega
  have metadata := writeVec_metadata heap p.block p.offset 8 (byte64 word)
  exact ⟨allocated,width,writable,metadata.1,metadata.2,
    writeVec_at heap p.block p.offset 8 (byte64 word) extent,
    writeVec_frame heap p.block p.offset 8 (byte64 word)⟩

def write32 (heap : Heap) (p : ArrayPointer) (word : BitVec 32) : Heap :=
  writeVec heap p.block p.offset 4 (byte32 word)

theorem write32_sound (heap : Heap) (p : ArrayPointer) (word : BitVec 32)
    (allocated : Allocated (memory heap) p) (width : p.elementBytes=4)
    (writable : (memory heap).writable p.block=true) :
    Store32 (memory heap) p word (memory (write32 heap p word)) := by
  have extent : p.offset+4≤(memory heap).size p.block := by
    obtain ⟨_,_,index,size,_⟩ := allocated
    simp only [width] at size
    simp only [ArrayPointer.offset,width]
    omega
  have metadata := writeVec_metadata heap p.block p.offset 4 (byte32 word)
  exact ⟨allocated,width,writable,metadata.1,metadata.2,
    writeVec_at heap p.block p.offset 4 (byte32 word) extent,
    writeVec_frame heap p.block p.offset 4 (byte32 word)⟩

end FT1536.Source3.C99FiniteWrite114
