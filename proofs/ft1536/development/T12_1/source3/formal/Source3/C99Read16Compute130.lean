import Source3.C99FiniteRead114
import Source3.C99NarrowReads

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99Read16Compute130
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)

def read (heap : Heap) (p : ArrayPointer) : Option (BitVec 16) :=
  if Allocated (memory heap) p ∧ p.elementBytes=2 then
    (C99FiniteRead114.readVec heap p.block p.offset 2).map C99NarrowReads.le16
  else none

theorem read_sound (heap : Heap) (p : ArrayPointer) (word : BitVec 16)
    (computed : read heap p=some word) : C99NarrowReads.Load16 (memory heap) p word := by
  unfold read at computed
  split at computed
  next guard =>
    obtain ⟨bytes,loaded,same⟩ := Option.map_eq_some_iff.mp computed
    subst word
    exact .load _ _ bytes guard.1 guard.2 (C99FiniteRead114.readVec_sound heap p.block p.offset 2 bytes loaded)
  next absent => cases computed

end FT1536.Source3.C99Read16Compute130
