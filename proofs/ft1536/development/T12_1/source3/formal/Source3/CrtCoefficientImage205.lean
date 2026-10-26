import Source3.CrtCoefficient205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtCoefficientImage205
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open Word32Memory176 (Separate)
open KeygenModpR2Exec (Slot)
open CrtState205 (Slot64)
open CrtCoefficient205

/- The two updated limbs, unchanged caller cells and arbitrary separated
   reads all belong to the same actual scoped coefficient execution. -/
theorem source (s : State) (x tmp : ArrayPointer) (a b t p pi r2 c : BitVec 32)
    (xb : s.arrays "x".toList=some x) (tb : s.arrays "tmp".toList=some tmp)
    (u : Slot64 s "u" 1) (pp : Slot s "p" p) (ip : Slot s "p0i" pi)
    (rp : Slot s "R2" r2) (sp : Slot s "s" c)
    (ra : Load32 s.heap x a) (rb : Load32 s.heap (ZintAddMulWord205.next x) b)
    (rt : Load32 s.heap tmp t) (cap : x.index+1 < x.count)
    (writable : s.heap.writable x.block=true) :
    let out:=after s x a b t p pi r2 c
    KeygenZintCall.Exec CrtRoundShape205.coeff s ⟨out,.normal⟩ ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      Load32 out.heap x (ZintAddMulWord205.low a t (correctionWord a b p pi r2 c)) ∧
      Load32 out.heap (ZintAddMulWord205.next x) (ZintAddMulWord205.carry a t (correctionWord a b p pi r2 c)) ∧
      (∀ q old, Separate x q → Separate (ZintAddMulWord205.next x) q →
        Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨alloc,width⟩ : Allocated s.heap x ∧ x.elementBytes=4 := by
    cases ra with | load _ h w _ => exact ⟨h,w⟩
  have tailAlloc : Allocated s.heap (ZintAddMulWord205.next x) := ⟨alloc.1,alloc.2.1,cap,alloc.2.2.2⟩
  have apart : Separate (ZintAddMulWord205.next x) x := by
    change x.block≠x.block ∨ x.base+x.elementBytes*(x.index+1)+4 ≤ x.base+x.elementBytes*x.index ∨
      x.base+x.elementBytes*x.index+4 ≤ x.base+x.elementBytes*(x.index+1)
    rw [width]
    omega
  refine ⟨CrtCoefficient205.source s x tmp a b t p pi r2 c xb tb u pp ip rp sp ra rb rt cap writable,
    restored_locals s x a b t p pi r2 c,rfl,?_,?_,?_⟩
  · exact Word32Memory176.outside _ _ _ _ _ apart (Word32Memory176.here _ _ _ alloc width writable)
  · exact Word32Memory176.here _ _ _ tailAlloc width writable
  · intro q old first second read
    exact Word32Memory176.outside _ _ _ _ _ second (Word32Memory176.outside _ _ _ _ _ first read)

end FT1536.Source3.CrtCoefficientImage205
