import Source3.C99LazyBlock129
import Source3.C99FiniteRead114

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99BlockReads136
open C99FiniteMemory114 (Heap Block memory)
open C99MemoryReference (ArrayPointer Load64)

def isolated (block : Nat) (data : Block) : Heap := C99FiniteMemory114.putBlock ⟨.empty⟩ block data

theorem isolated_lookup (block : Nat) (data : Block) :
    C99FiniteMap114.lookup (isolated block data).blocks block=some data := by
  simp [isolated,C99FiniteMemory114.putBlock,C99FiniteMap114.lookup_insert]

theorem load64_transfer (actual checked : Heap) (pointer : ArrayPointer) (word : BitVec 64)
    (same : C99FiniteMap114.lookup actual.blocks pointer.block=C99FiniteMap114.lookup checked.blocks pointer.block)
    (source : Load64 (memory checked) pointer word) : Load64 (memory actual) pointer word := by
  cases source with
  | load bytes allocated width initialized =>
      have size : (memory actual).size pointer.block=(memory checked).size pointer.block := by simp only [memory,same]
      refine .load _ _ bytes ?_ width ?_
      · simpa only [C99MemoryReference.Allocated,size] using allocated
      · intro i
        have equal : (memory actual).bytes pointer.block (pointer.offset+i.val)=
            (memory checked).bytes pointer.block (pointer.offset+i.val) := by simp only [memory,same]
        exact equal.trans (initialized i)

end FT1536.Source3.C99BlockReads136
