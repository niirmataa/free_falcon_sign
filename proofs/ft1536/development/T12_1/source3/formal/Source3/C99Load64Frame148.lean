import Source3.C99MemoryReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99Load64Frame148
open C99MemoryReference

theorem source (before after : Memory) (p : ArrayPointer) (word : BitVec 64)
    (sizes : after.size=before.size) (bytes : ∀ i : Fin 8, after.bytes p.block (p.offset+i.val)=before.bytes p.block (p.offset+i.val))
    (read : Load64 before p word) : Load64 after p word := by
  cases read with
  | load values allocated width initialized =>
    have nextAllocated : Allocated after p := by
      unfold Allocated at allocated ⊢
      rw [sizes]
      exact allocated
    exact Load64.load after p values nextAllocated width (fun i => (bytes i).trans (initialized i))

end FT1536.Source3.C99Load64Frame148
