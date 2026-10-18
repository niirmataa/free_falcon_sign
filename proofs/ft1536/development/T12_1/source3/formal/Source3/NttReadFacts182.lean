import Source3.NttFirstLoop182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttReadFacts182
open C99MemoryReference (Memory ArrayPointer Allocated Load32)

theorem allocated (heap : Memory) (pointer : ArrayPointer) (word : BitVec 32)
    (read : Load32 heap pointer word) : Allocated heap pointer := by
  cases read with
  | load _ valid _ _ => exact valid

theorem initialized (heap : Memory) (pointer : ArrayPointer) (word : BitVec 32)
    (read : Load32 heap pointer word) : Word32Initialized180.At heap pointer := by
  cases read with
  | load bytes _ _ values =>
    intro i hi
    rw [values ⟨i,hi⟩]
    rfl

end FT1536.Source3.NttReadFacts182
