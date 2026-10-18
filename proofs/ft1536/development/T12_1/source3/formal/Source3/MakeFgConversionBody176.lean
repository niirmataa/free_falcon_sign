import Source3.MakeFgConversionShape176
import Source3.Word32Memory176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgConversionBody176
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenMakeFgSource (Exec)
open KeygenWordExpr (Eval)
open MakeFgConversionShape176 (index converted)

def word (x : BitVec 16) : BitVec 32 := KeygenModpSet.word (BitVec.ofInt 32 x.toInt) KeygenNinv31.prime
def firstState (s : State) (ft : ArrayPointer) (x : BitVec 16) : State :=
  {s with heap:=Word32Memory176.write s.heap ft (word x)}
def output (s : State) (ft gt : ArrayPointer) (x y : BitVec 16) : State :=
  {s with heap:=Word32Memory176.write (Word32Memory176.write s.heap ft (word x)) gt (word y)}

theorem expression (s : State) (name : String) (p : ArrayPointer) (x : BitVec 16)
    (address : Pointer s name.toList index p) (read : C99NarrowReads.Load16 s.heap p x)
    (prime : s.locals "p0".toList=some (.uint32,some (.uint32 KeygenNinv31.prime))) :
    Eval s (converted name) (.uint32 (word x)) :=
  .call2 _ _ _ (C99NarrowReads.signedPromotion x) (.uint32 KeygenNinv31.prime) _
    (.load16 _ _ p x address read) (.scalar _ _ (.variable _ _ _ prime))
    (.set _ _ (KeygenModpSet.source_exists (BitVec.ofInt 32 x.toInt) KeygenNinv31.prime))

theorem pointer_heap (s : State) (heap : C99MemoryReference.Memory) (name : C99ArrayReference.Name)
    (index : CLogic.Expr) (p : ArrayPointer) (address : Pointer s name index p) :
    Pointer {s with heap:=heap} name index p := by
  cases address with
  | add base _ v binding value positive within =>
    exact .add _ _ base p v binding value positive within

theorem source (s : State) (f g ft gt : ArrayPointer) (x y : BitVec 16)
    (fAddress : Pointer s "f".toList index f) (gAddress : Pointer s "g".toList index g)
    (ftAddress : Pointer s "ft".toList index ft) (gtAddress : Pointer s "gt".toList index gt)
    (fRead : C99NarrowReads.Load16 s.heap f x) (gRead : C99NarrowReads.Load16 s.heap g y)
    (ftAllocated : Allocated s.heap ft) (gtAllocated : Allocated s.heap gt)
    (ftWidth : ft.elementBytes=4) (gtWidth : gt.elementBytes=4)
    (ftWritable : s.heap.writable ft.block=true) (gtWritable : s.heap.writable gt.block=true)
    (outsideG : ft.block≠g.block)
    (prime : s.locals "p0".toList=some (.uint32,some (.uint32 KeygenNinv31.prime))) :
    Exec MakeFgConversionShape176.body s ⟨output s ft gt x y,.normal⟩ := by
  have first : Exec MakeFgConversionShape176.first s ⟨firstState s ft x,.normal⟩ :=
    .word _ _ _ (.store _ _ _ _ _ ft (.uint32 (word x)) ftAddress (expression s "f" f x fAddress fRead prime)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq] using
        Word32Memory176.source s.heap ft (word x) ftAllocated ftWidth ftWritable))
  have nextG := Word32Memory176.outside16 s.heap ft g (word x) y outsideG gRead
  have second : Exec MakeFgConversionShape176.second (firstState s ft x) ⟨output s ft gt x y,.normal⟩ :=
    .word _ _ _ (.store _ _ _ _ _ gt (.uint32 (word y))
      (pointer_heap s _ _ _ gt gtAddress)
      (expression (firstState s ft x) "g" g y (pointer_heap s _ _ _ g gAddress) nextG prime)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,firstState] using
        Word32Memory176.source (firstState s ft x).heap gt (word y) gtAllocated gtWidth gtWritable))
  have inner : Exec (KeygenMakeFgSource.chain [MakeFgConversionShape176.first,MakeFgConversionShape176.second])
      s ⟨output s ft gt x y,.normal⟩ :=
    .seqNormal _ _ s (firstState s ft x) ⟨output s ft gt x y,.normal⟩ first
      (.seqNormal _ _ (firstState s ft x) (output s ft gt x y) ⟨output s ft gt x y,.normal⟩ second
        (MakeFgDeclarations176.array_source .skip _ _ (.skip _)))
  have scopeRun := KeygenMakeFgSource.Exec.scope [] [] _ s ⟨output s ft gt x y,.normal⟩ inner
  simpa only [KeygenPublicForwardCall.restore_empty,MakeFgConversionShape176.body] using scopeRun

end FT1536.Source3.MakeFgConversionBody176
