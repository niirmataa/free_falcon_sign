import Source3.PublicGroupLoop162
import Source3.C99OuterScalar144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRoundContext163
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenSmallOutput (element)
open PublicGenerateTable159 (Written)
open PublicMiddleWrites161 (MemoryFrame)

structure Arrays (s : State) (a gm : ArrayPointer) : Prop where
  capacity : a.index+1536 ≤ a.count
  tableCapacity : gm.index+1024 ≤ gm.count
  binding : s.arrays "a".toList=some a
  tableBinding : s.arrays "gm_square".toList=some gm
  tableWritten : ∀ j, j < 1024 → Written s.heap (element gm j)
  separate : gm.block≠a.block
  width : a.elementBytes=2
  writable : s.heap.writable a.block=true
  allocated : ∀ j, j < 1536 → Allocated s.heap (element a j)
  written : ∀ j, j < 1536 → Written s.heap (element a j)

structure Valid (t m : Nat) : Prop where
  wordBound : t < 2^64
  groupsBound : m ≤ 512
  even : t=2*(t/2)
  total : m*(2*(t/2))=1536

theorem transfer (s after : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (arrays : after.arrays=s.arrays) (memory : MemoryFrame s after a) : Arrays after a gm := by
  refine ⟨ctx.capacity,ctx.tableCapacity,?_,?_,?_,ctx.separate,ctx.width,?_,?_,?_⟩
  · rw [arrays]; exact ctx.binding
  · rw [arrays]; exact ctx.tableBinding
  · intro j hj
    obtain ⟨w,read⟩ := ctx.tableWritten j hj
    exact ⟨w,C99NarrowReads.load16_transport s.heap after.heap (element gm j) w read memory.size
      (fun byte => memory.outside gm.block ctx.separate ((element gm j).offset+byte.val))⟩
  · rw [memory.writable]; exact ctx.writable
  · intro j hj
    simpa only [Allocated,memory.size] using ctx.allocated j hj
  · intro j hj
    exact memory.written j (ctx.written j hj)

theorem of_group (s : State) (a gm : ArrayPointer) (ht m : Nat)
    (fixed : PublicGroupInvariant162.Fixed s a gm ht m) : Arrays s a gm :=
  ⟨fixed.capacity,fixed.tableCapacity,fixed.binding,fixed.tableBinding,fixed.tableWritten,
    fixed.separate,fixed.width,fixed.writable,fixed.allocated,fixed.written⟩

end FT1536.Source3.PublicRoundContext163
