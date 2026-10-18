import Source3.PublicInverseDomains172

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicInverseMemory172
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open PublicInverseDomains172 (Arrays)

theorem arrays (before after : State) (a table : ArrayPointer) (ctx : Arrays before a table)
    (bindings : after.arrays=before.arrays) (memory : PublicInitializedFrame164.Frame before.heap after.heap) :
    Arrays after a table := by
  refine ⟨PublicForwardMemory167.after_generator _ _ a ctx.data memory,?_,?_,?_,?_,ctx.separate⟩
  · rw [bindings]; exact ctx.aBinding
  · rw [bindings]; exact ctx.square
  · rw [bindings]; exact ctx.cubic
  · intro j hj
    exact memory.written _ (ctx.tableWritten j hj)

theorem allocated (s : State) (a table : ArrayPointer) (ctx : Arrays s a table) (j : Nat) (inside : j<1536) :
    Allocated s.heap (KeygenSmallOutput.element a j) := by
  obtain ⟨w,read⟩ := ctx.data.written j inside
  exact (KeygenPublicRangeMemory.load_allocated _ _ _ read).1

end FT1536.Source3.PublicInverseMemory172
