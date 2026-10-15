import Source3.C99FiniteAllocation115
import Source3.C99CompactState115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CompactBlockIdentity129
open C99FiniteMemory114 (Block Heap memory putBlock)
open C99CompactState115 (State reference)

theorem memory_same (heap : Heap) (block : Nat) (data : Block)
    (found : C99FiniteMap114.lookup heap.blocks block=some data) :
    memory (putBlock heap block data)=memory heap := by
  apply C99FiniteAllocation115.memory_ext
  · intro other offset
    rw [C99FiniteMemory114.bytes_putBlock]
    by_cases same : other=block
    · subst other
      simp [memory,found]
    · simp [same]
  · intro other
    rw [C99FiniteMemory114.size_putBlock]
    by_cases same : other=block
    · subst other
      simp [memory,found]
    · simp [same]
  · intro other
    rw [C99FiniteMemory114.writable_putBlock]
    by_cases same : other=block
    · subst other
      simp [memory,found]
    · simp [same]

def normalized (state : State) (block : Nat) (data : Block) : State :=
  {state with heap := putBlock state.heap block data}

/-- Replace a computationally expensive lookup by its checked literal block;
    this identifies the entire reference state, including every other object. -/
theorem reference_same (state : State) (block : Nat) (data : Block)
    (found : C99FiniteMap114.lookup state.heap.blocks block=some data) :
    reference (normalized state block data)=reference state := by
  unfold normalized reference
  rw [memory_same state.heap block data found]

end FT1536.Source3.CompactBlockIdentity129
