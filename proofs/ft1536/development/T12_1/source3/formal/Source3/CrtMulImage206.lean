import Source3.CrtRoundReady206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtMulImage206
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open Word32Memory176 (Separate)
open CrtState205 (Slot64)
open KeygenModpR2Exec (Slot)

theorem source (s : State) (tmp : ArrayPointer) (t p : BitVec 32)
    (binding : s.arrays "tmp".toList=some tmp) (u : Slot64 s "u" 1) (pp : Slot s "p" p)
    (read : Load32 s.heap tmp t) (cap : tmp.index+1 < tmp.count) (writable : s.heap.writable tmp.block=true) :
    let out:={s with heap:=CrtMulCall205.finalHeap s tmp t p}
    KeygenZintCall.Exec CrtRoundShape205.mulCall s ⟨out,.normal⟩ ∧
      Load32 out.heap tmp (ZintMulWord205.low t p) ∧
      Load32 out.heap (ZintAddMulWord205.next tmp) (ZintMulWord205.carry t p) ∧
      (∀ q old, Separate tmp q → Separate (ZintAddMulWord205.next tmp) q →
        Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨alloc,width⟩ : Allocated s.heap tmp ∧ tmp.elementBytes=4 := by
    cases read with | load _ h w _ => exact ⟨h,w⟩
  have tailAlloc : Allocated s.heap (ZintAddMulWord205.next tmp) := ⟨alloc.1,alloc.2.1,cap,alloc.2.2.2⟩
  have apart : Separate (ZintAddMulWord205.next tmp) tmp := by
    change tmp.block≠tmp.block ∨ tmp.base+tmp.elementBytes*(tmp.index+1)+4 ≤ tmp.base+tmp.elementBytes*tmp.index ∨
      tmp.base+tmp.elementBytes*tmp.index+4 ≤ tmp.base+tmp.elementBytes*(tmp.index+1)
    rw [width]
    omega
  refine ⟨CrtMulCall205.source s tmp t p binding u pp read cap writable,?_,?_,?_⟩
  · exact Word32Memory176.outside _ _ _ _ _ apart (Word32Memory176.here _ _ _ alloc width writable)
  · exact Word32Memory176.here _ _ _ tailAlloc width writable
  · intro q old first second hr
    exact Word32Memory176.outside _ _ _ _ _ second (Word32Memory176.outside _ _ _ _ _ first hr)

end FT1536.Source3.CrtMulImage206
