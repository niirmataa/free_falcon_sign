import Source3.ZintAddMulWord205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtLeafImages205
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open Word32Memory176 (Separate)

theorem mul (s : State) (p : ArrayPointer) (a b : BitVec 32)
    (binding : s.arrays "m".toList=some p) (xb : KeygenModpR2Exec.Slot s "x" b)
    (len : CrtState205.Slot64 s "mlen" 1) (read : Load32 s.heap p a)
    (writable : s.heap.writable p.block=true) :
    ∃ out, KeygenWordExec.Exec (KeygenZintLeaves.code .mul) s out ∧
      out.flow=.returned (some (.uint32 (ZintMulWord205.carry a b))) ∧
      Load32 out.state.heap p (ZintMulWord205.low a b) ∧
      (∀ q old, Separate p q → Load32 s.heap q old → Load32 out.state.heap q old) := by
  obtain ⟨out,run,flow,heap⟩:=ZintMulWord205.source s p a b binding xb len read writable
  obtain ⟨alloc,width⟩ : Allocated s.heap p ∧ p.elementBytes=4 := by
    cases read with | load _ h w _ => exact ⟨h,w⟩
  refine ⟨out,run,flow,?_,?_⟩
  · rw [heap]
    exact Word32Memory176.here _ _ _ alloc width writable
  · intro q old sep hr
    rw [heap]
    exact Word32Memory176.outside _ _ _ _ _ sep hr

theorem addMul (s : State) (p q : ArrayPointer) (a b c : BitVec 32)
    (px : s.arrays "x".toList=some p) (qy : s.arrays "y".toList=some q)
    (len : CrtState205.Slot64 s "len" 1) (cs : KeygenModpR2Exec.Slot s "s" c)
    (readX0 : Load32 s.heap p a) (readY0 : Load32 s.heap q b)
    (cap : p.index+1 < p.count) (writable : s.heap.writable p.block=true) :
    ∃ out, KeygenWordExec.Exec (KeygenZintLeaves.code .addMul) s out ∧ out.flow=.normal ∧
      Load32 out.state.heap p (ZintAddMulWord205.low a b c) ∧
      Load32 out.state.heap (ZintAddMulWord205.next p) (ZintAddMulWord205.carry a b c) ∧
      (∀ q old, Separate p q → Separate (ZintAddMulWord205.next p) q →
        Load32 s.heap q old → Load32 out.state.heap q old) := by
  obtain ⟨out,run,flow,heap⟩:=ZintAddMulWord205.source s p q a b c px qy len cs readX0 readY0 cap writable
  obtain ⟨alloc,width⟩ : Allocated s.heap p ∧ p.elementBytes=4 := by
    cases readX0 with | load _ h w _ => exact ⟨h,w⟩
  have tailAlloc : Allocated s.heap (ZintAddMulWord205.next p) := ⟨alloc.1,alloc.2.1,cap,alloc.2.2.2⟩
  have apart : Separate (ZintAddMulWord205.next p) p := by
    change p.block≠p.block ∨ p.base+p.elementBytes*(p.index+1)+4 ≤ p.base+p.elementBytes*p.index ∨
      p.base+p.elementBytes*p.index+4 ≤ p.base+p.elementBytes*(p.index+1)
    rw [width]
    omega
  refine ⟨out,run,flow,?_,?_,?_⟩
  · rw [heap]
    exact Word32Memory176.outside _ _ _ _ _ apart (Word32Memory176.here _ _ _ alloc width writable)
  · rw [heap]
    exact Word32Memory176.here _ _ _ tailAlloc width writable
  · intro q old first second hr
    rw [heap]
    exact Word32Memory176.outside _ _ _ _ _ second (Word32Memory176.outside _ _ _ _ _ first hr)

end FT1536.Source3.CrtLeafImages205
