import Source3.KeygenCallerDomain123
import Source3.KeygenSeedEntry089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenInputBytes124
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open C99CompactState115 (State reference)
open KeygenSeedEntry089 (Seed)

theorem beyond_object (heap : Heap) (block offset : Nat) (outside : (memory heap).size block≤offset) :
    (memory heap).bytes block offset=none := by
  cases found : C99FiniteMap114.lookup heap.blocks block with
  | none => simp [memory,found]
  | some data =>
      have bound : data.size≤offset := by simpa [memory,found] using outside
      simp [memory,found,C99FiniteMemory114.Block.read,show ¬offset<data.size by omega]

def install (heap : Heap) (block : Nat) (seed : Seed) : Heap :=
  C99FiniteInit123.install heap block 32 true seed

theorem source_heap (heap : Heap) (block : Nat) (seed : Seed) :
    memory (install heap block seed)=KeygenSeedEntry089.seedHeap (memory heap) block seed := by
  apply C99FiniteAllocation115.memory_ext
  · intro other offset
    by_cases same : other=block
    · subst other
      by_cases inside : offset<32
      · have byte := C99FiniteInit123.initialized heap block 32 true seed ⟨offset,inside⟩
        simpa [install,KeygenSeedEntry089.seedHeap,inside] using byte
      · have size : (memory (install heap block seed)).size block=32 := by
          unfold install
          rw [(C99FiniteInit123.metadata heap block 32 true seed).1]
          simp
        have absent := beyond_object (install heap block seed) block offset (by rw [size]; omega)
        simpa [KeygenSeedEntry089.seedHeap,inside] using absent
    · have frame := C99FiniteInit123.outside heap block 32 true seed other same
      simpa [install,KeygenSeedEntry089.seedHeap,same] using frame.2.2 offset
  · intro other
    exact congrFun (C99FiniteInit123.metadata heap block 32 true seed).1 other
  · intro other
    exact congrFun (C99FiniteInit123.metadata heap block 32 true seed).2 other

def caller (before : State) (block : Nat) (seed : Seed) : State :=
  {before with heap := install before.heap block seed}

theorem source_caller (before : State) (block : Nat) (seed : Seed) :
    reference (caller before block seed)=KeygenSeedEntry089.caller (reference before) block seed := by
  unfold caller
  rw [C99CompactState115.reference_heap,source_heap]
  rfl

def entered (env : KeygenMakeInvocation.Env) (before : State) (block : Nat) (seed : Seed) : State :=
  C99CompactState115.bindPointer (C99CompactState115.bindPointer
    (C99CompactState115.bindValue (C99CompactState115.bindValue
      (C99CompactState115.base (caller before block seed)) "replace".toList .i32 (.i32 1))
      "len".toList .u64 (.u64 32)) "seed".toList (KeygenSeedEntry089.pointer block)) "fk".toList env.args.fk

theorem source_entry (env : KeygenMakeInvocation.Env) (before : State) (block : Nat) (seed : Seed) :
    reference (entered env before block seed)=KeygenSeedEntry089.entry env (reference before) block seed := by
  unfold entered
  rw [C99CompactState115.reference_bindPointer,C99CompactState115.reference_bindPointer,
    C99CompactState115.reference_bindValue,C99CompactState115.reference_bindValue,
    C99CompactState115.reference_base,source_caller]
  rfl

end FT1536.Source3.KeygenInputBytes124
