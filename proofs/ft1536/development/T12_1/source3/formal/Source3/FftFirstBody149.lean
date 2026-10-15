import Source3.FftFirstStates149
import Source3.FftLoadExec140
import Source3.FftWordStoreStep140
import Source3.C99Chain139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstBody149
open C99ArrayReference (State Pointer Eval)
open C99MemoryReference (ArrayPointer Load64)
open C99ProcedureReference (Exec)
open FftFirstShape149
open FftFirstStates149

def real (x y wr : BitVec 64) : BitVec 64 := FprAddFast137.word x (FprMulFast137.word y wr)
def imag (y wi : BitVec 64) : BitVec 64 := FprMulFast137.word y wi
def afterReal (s : State) (p : ArrayPointer) (r : BitVec 64) : State :=
  {s with heap := C99WordStore140.write s.heap p r}
def output (s : State) (p q : ArrayPointer) (r i : BitVec 64) : State :=
  {s with heap := C99WordStore140.write (C99WordStore140.write s.heap p r) q i}

theorem loads (s : State) (p q : ArrayPointer) (x y : BitVec 64)
    (pAddress : Pointer s "a".toList index0 p) (qAddress : Pointer s "a".toList index1 q)
    (xRead : Load64 s.heap p x) (yRead : Load64 s.heap q y) :
    Exec KeygenSearchFft.program (C99ProcedureParser.chain [declaration,load0,load1]) s ⟨loaded s x y,.normal⟩ := by
  have firstLoad : Exec KeygenSearchFft.program load0 (declared s) ⟨first s x,.normal⟩ := by
    apply Exec.base
    exact FftLocalCells140.assign FftLeafPrograms.program (declared s) "a0".toList
      (.load "a".toList index0) none x rfl
      (.load _ _ p x (pointer0 s (declared s) p (declared_frame s) pAddress) xRead)
  have secondLoad : Exec KeygenSearchFft.program load1 (first s x) ⟨loaded s x y,.normal⟩ := by
    apply Exec.base
    exact FftLocalCells140.assign FftLeafPrograms.program (first s x) "a1".toList
      (.load "a".toList index1) none y rfl
      (.load _ _ q y (pointer1 s (first s x) q (first_frame s x) qAddress) yRead)
  exact .seqNormal _ _ _ _ _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 names s))
    (.seqNormal _ _ _ _ _ firstLoad (.seqNormal _ _ _ _ _ secondLoad (.base _ _ _ (.skip _))))

theorem expressions (s : State) (x y wr wi : BitVec 64)
    (wrCell : s.locals "fpr_W1R".toList=some (.uint64,some (.uint64 wr)))
    (wiCell : s.locals "fpr_W1I".toList=some (.uint64,some (.uint64 wi))) :
    Eval (loaded s x y) realExpr (.uint64 (real x y wr)) ∧
    Eval (loaded s x y) imagExpr (.uint64 (imag y wi)) := by
  have xr := FftLocalCells140.read_var (loaded s x y) "a0".toList x (x_cell s x y)
  have yr := FftLocalCells140.read_var (loaded s x y) "a1".toList y (y_cell s x y)
  have wrr := FftLocalCells140.read_var (loaded s x y) "fpr_W1R".toList wr
    (((loaded_frame s x y).locals _ (by decide)).trans wrCell)
  have wir := FftLocalCells140.read_var (loaded s x y) "fpr_W1I".toList wi
    (((loaded_frame s x y).locals _ (by decide)).trans wiCell)
  exact ⟨FftWordExpressions140.add_source _ _ _ _ _ xr
    (FftWordExpressions140.mul_source _ _ _ _ _ yr wrr),
    FftWordExpressions140.mul_source _ _ _ _ _ yr wir⟩

/-- The second store reads only local words, so the first heap update cannot change it. -/
theorem imag_after_store (s : State) (p : ArrayPointer) (r y wi : BitVec 64)
    (yCell : s.locals "a1".toList=some (.uint64,some (.uint64 y)))
    (wiCell : s.locals "fpr_W1I".toList=some (.uint64,some (.uint64 wi))) :
    Eval (afterReal s p r) imagExpr (.uint64 (imag y wi)) :=
  FftWordExpressions140.mul_source _ _ _ _ _
    (FftLocalCells140.read_var (afterReal s p r) "a1".toList y yCell)
    (FftLocalCells140.read_var (afterReal s p r) "fpr_W1I".toList wi wiCell)

theorem stores (s : State) (p q : ArrayPointer) (r y wi : BitVec 64)
    (pAddress : Pointer s "a".toList index0 p) (qAddress : Pointer s "a".toList index1 q)
    (pAllocated : C99MemoryReference.Allocated s.heap p) (qAllocated : C99MemoryReference.Allocated s.heap q)
    (pWidth : p.elementBytes=8) (qWidth : q.elementBytes=8)
    (pWrite : s.heap.writable p.block=true) (qWrite : s.heap.writable q.block=true)
    (realEval : Eval s realExpr (.uint64 r))
    (yCell : s.locals "a1".toList=some (.uint64,some (.uint64 y)))
    (wiCell : s.locals "fpr_W1I".toList=some (.uint64,some (.uint64 wi))) :
    Exec KeygenSearchFft.program (C99ProcedureParser.chain [store0,store1]) s ⟨output s p q r (imag y wi),.normal⟩ := by
  have a : Exec KeygenSearchFft.program store0 s ⟨afterReal s p r,.normal⟩ :=
    .base _ _ _ (FftWordStoreStep140.source _ s _ _ _ p r pAddress realEval pAllocated pWidth pWrite)
  have b : Exec KeygenSearchFft.program store1 (afterReal s p r) ⟨output s p q r (imag y wi),.normal⟩ :=
    .base _ _ _ (FftWordStoreStep140.source _ (afterReal s p r) _ _ _ q (imag y wi)
      (FftHeapTransport140.pointer s _ _ _ q qAddress) (imag_after_store s p r y wi yCell wiCell)
      qAllocated qWidth qWrite)
  exact .seqNormal _ _ _ _ _ a (.seqNormal _ _ _ _ _ b (.base _ _ _ (.skip _)))

theorem source (s : State) (p q : ArrayPointer) (x y wr wi : BitVec 64)
    (pAddress : Pointer s "a".toList index0 p) (qAddress : Pointer s "a".toList index1 q)
    (xRead : Load64 s.heap p x) (yRead : Load64 s.heap q y)
    (pWrite : s.heap.writable p.block=true) (qWrite : s.heap.writable q.block=true)
    (wrCell : s.locals "fpr_W1R".toList=some (.uint64,some (.uint64 wr)))
    (wiCell : s.locals "fpr_W1I".toList=some (.uint64,some (.uint64 wi))) :
    Exec KeygenSearchFft.program FftShape138.firstBody s ⟨output s p q (real x y wr) (imag y wi),.normal⟩ := by
  have head := loads s p q x y pAddress qAddress xRead yRead
  have tail := stores (loaded s x y) p q (real x y wr) y wi
    (pointer0 s (loaded s x y) p (loaded_frame s x y) pAddress)
    (pointer1 s (loaded s x y) q (loaded_frame s x y) qAddress)
    (FftLoadExec140.allocated_of_load s.heap p x xRead) (FftLoadExec140.allocated_of_load s.heap q y yRead)
    (FftLoadExec140.width_of_load s.heap p x xRead) (FftLoadExec140.width_of_load s.heap q y yRead)
    pWrite qWrite (expressions s x y wr wi wrCell wiCell).1 (y_cell s x y)
    (((loaded_frame s x y).locals _ (by decide)).trans wiCell)
  have full := C99Chain139.append KeygenSearchFft.program [declaration,load0,load1] [store0,store1]
    s (loaded s x y) ⟨output (loaded s x y) p q (real x y wr) (imag y wi),.normal⟩ head tail
  have frame : C99ScopeFrame147.Frame names s (output (loaded s x y) p q (real x y wr) (imag y wi)) :=
    C99ScopeFrame147.trans names _ _ _ (loaded_frame s x y) (C99ScopeFrame147.heap_only names _ _)
  have restored := C99ScopeFrame147.restored names s _ frame
  change C99ArrayReference.restoreScope s (output (loaded s x y) p q (real x y wr) (imag y wi)) names []=
    output s p q (real x y wr) (imag y wi) at restored
  rw [body_shape]
  rw [← restored]
  exact .scope _ _ _ _ _ full

end FT1536.Source3.FftFirstBody149
