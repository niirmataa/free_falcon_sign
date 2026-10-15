import Source3.GsAutoShape155
import Source3.FftFirstBuffer149

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsAutoBody155
open C99ArrayReference (State Pointer Eval)
open C99MemoryReference (ArrayPointer Load64)
open C99ProcedureReference (Exec Program)

def output (s : State) (p q : ArrayPointer) (x y z : BitVec 64) : State :=
  FftFirstBody149.output s p q (FprMulFast137.word x z) (FprMulFast137.word y z)

theorem source (program : Program) (s : State) (p q r : ArrayPointer) (x y z : BitVec 64)
    (pAddress : Pointer s "a".toList FftFirstShape149.index0 p)
    (qAddress : Pointer s "a".toList FftFirstShape149.index1 q)
    (rAddress : Pointer s "b".toList FftFirstShape149.index0 r)
    (xRead : Load64 s.heap p x) (yRead : Load64 s.heap q y) (zRead : Load64 s.heap r z)
    (pWrite : s.heap.writable p.block=true) (qWrite : s.heap.writable q.block=true)
    (pq : C99WordRead140.Separate p q) (pr : C99WordRead140.Separate p r) :
    Exec program GsAutoShape155.body s ⟨output s p q x y z,.normal⟩ := by
  let middle := FftFirstBody149.afterReal s p (FprMulFast137.word x z)
  have first : Exec program GsAutoShape155.store0 s ⟨middle,.normal⟩ :=
    .base _ _ _ (FftWordStoreStep140.source _ s _ _ _ p (FprMulFast137.word x z) pAddress
      (FftWordExpressions140.mul_source _ _ _ _ _ (.load _ _ p x pAddress xRead) (.load _ _ r z rAddress zRead))
      (FftLoadExec140.allocated_of_load s.heap p x xRead) (FftLoadExec140.width_of_load s.heap p x xRead) pWrite)
  have qAddress' : Pointer middle "a".toList FftFirstShape149.index1 q := FftHeapTransport140.pointer s _ _ _ q qAddress
  have rAddress' : Pointer middle "b".toList FftFirstShape149.index0 r := FftHeapTransport140.pointer s _ _ _ r rAddress
  have yRead' : Load64 middle.heap q y := C99WordRead140.outside s.heap p q _ y pq yRead
  have zRead' : Load64 middle.heap r z := C99WordRead140.outside s.heap p r _ z pr zRead
  have second : Exec program GsAutoShape155.store1 middle ⟨output s p q x y z,.normal⟩ :=
    .base _ _ _ (FftWordStoreStep140.source _ middle _ _ _ q (FprMulFast137.word y z) qAddress'
      (FftWordExpressions140.mul_source _ _ _ _ _ (.load _ _ q y qAddress' yRead') (.load _ _ r z rAddress' zRead'))
      (FftLoadExec140.allocated_of_load middle.heap q y yRead') (FftLoadExec140.width_of_load middle.heap q y yRead') qWrite)
  exact .scope _ _ _ _ _ (.seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second (.base _ _ _ (.skip _))))

end FT1536.Source3.GsAutoBody155
