import Source3.KeygenWordRunSound130
import Source3.KeygenResultantSource
import Source3.C99LazyBlock129
import Source3.KeygenInputBytes124

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenResultantInit130
open C99CompactState115 (State reference)
open C99FiniteMemory114 (Heap Block memory)

def entry (before : State) (block : Nat) : State :=
  C99CompactState115.bindPointer {before with heap := C99FiniteAllocation115.allocate before.heap block 384}
    "b".toList (KeygenResultantSource.object block)

theorem entry_source (before : State) (block : Nat) :
    reference (entry before block)=KeygenResultantSource.entry (reference before) block := by
  rw [entry,C99CompactState115.reference_bindPointer,C99CompactState115.reference_heap,
    C99FiniteAllocation115.allocate_source]
  rfl

def ZeroGuard (before : State) (block : Nat) : Prop :=
  (memory before.heap).size block=384 ∧ (memory before.heap).writable block=true

instance zeroGuardDecidable (before : State) (block : Nat) : Decidable (ZeroGuard before block) := by
  unfold ZeroGuard
  infer_instance

def zeroed (before : State) (block : Nat) : State :=
  {before with heap := C99LazyBlock129.putBlock before.heap block ⟨384,true,some 0,.empty⟩}

theorem zero_heap (before : State) (block : Nat) (guard : ZeroGuard before block) :
    memory (zeroed before block).heap=KeygenResultantSource.zeroed (memory before.heap) block := by
  change memory (C99LazyBlock129.putBlock before.heap block ⟨384,true,some 0,.empty⟩)=_
  rw [C99LazyBlock129.memory_equal]
  apply C99FiniteAllocation115.memory_ext
  · intro other offset
    rw [C99FiniteMemory114.bytes_putBlock]
    by_cases same : other=block
    · subst other
      by_cases inside : offset<384
      · simp [Block.read,C99FiniteAllocation115.lookup_empty,KeygenResultantSource.zeroed,inside]
      · have absent := KeygenInputBytes124.beyond_object before.heap block offset (by rw [guard.1]; omega)
        simp [Block.read,KeygenResultantSource.zeroed,inside,absent]
    · simp [same,KeygenResultantSource.zeroed]
  · intro other
    rw [C99FiniteMemory114.size_putBlock]
    by_cases same : other=block
    · subst other
      simpa [KeygenResultantSource.zeroed] using guard.1.symm
    · simp [same,KeygenResultantSource.zeroed]
  · intro other
    rw [C99FiniteMemory114.writable_putBlock]
    by_cases same : other=block
    · subst other
      simpa [KeygenResultantSource.zeroed] using guard.2.symm
    · simp [same,KeygenResultantSource.zeroed]

theorem zero_source (before : State) (block : Nat) (guard : ZeroGuard before block) :
    reference (zeroed before block)={reference before with heap := KeygenResultantSource.zeroed (memory before.heap) block} := by
  unfold reference
  rw [zero_heap before block guard]
  rfl

theorem zero_legal (before : State) (block : Nat) (guard : ZeroGuard before block) :
    KeygenResultantSource.ZeroLegal (memory before.heap) block := by
  refine ⟨?_,?_,guard.2⟩
  · rw [guard.1]
  · rw [guard.1]
    decide +kernel

end FT1536.Source3.KeygenResultantInit130
