import Source3.NttInverseWholeKeep202
import Source3.MakeFgInverseShape192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseCall202
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open MkgmParams198 (Level lognWord)
open NttInverseSchedule201 (size)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)

def empty (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def withI (s : State) (p0i : BitVec 32) := bindValue (empty s) "p0i".toList .uint32 (.uint32 p0i)
def withP (s : State) (p p0i : BitVec 32) := bindValue (withI s p0i) "p".toList .uint32 (.uint32 p)
def withFull (s : State) (p p0i : BitVec 32) := bindValue (withP s p p0i) "full".toList .uint32 (.int32 0)
def withLogn (l : Level) (s : State) (p p0i : BitVec 32) := bindValue (withFull s p p0i) "logn".toList .uint32 (.uint32 (lognWord l))
def withIgm (l : Level) (s : State) (igm : ArrayPointer) (p p0i : BitVec 32) := bindPointer (withLogn l s p p0i) "igm".toList igm
def withStride (l : Level) (s : State) (igm : ArrayPointer) (stride : Nat) (p p0i : BitVec 32) :=
  bindValue (withIgm l s igm p p0i) "stride".toList .uint64 (u64 stride)
def entry (l : Level) (s : State) (a igm : ArrayPointer) (stride : Nat) (p p0i : BitVec 32) :=
  bindPointer (withStride l s igm stride p p0i) "a".toList a

structure Input (l : Level) (s : State) (fs igm : ArrayPointer) (u stride : Nat)
    (p p0i : BitVec 32) (tws fv : Nat → BitVec 32) : Prop where
  uCell : USlot s "u" u
  strideCell : USlot s "slen" stride
  lognCell : Slot s "logn" (lognWord l)
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  fBinding : s.arrays "fs".toList=some fs
  iBinding : s.arrays "igm".toList=some igm
  uBound : u<2^64
  strideBound : stride<2^64
  wide : size l*stride<2^64
  width : fs.elementBytes=4
  aCapacity : (element fs u).index+size l*stride ≤ fs.count
  iCapacity : igm.index+size l ≤ igm.count
  writable : s.heap.writable fs.block=true
  separate : ∀ j k, j<size l → k<size l → j≠k → Separate (walk (element fs u) j stride) (walk (element fs u) k stride)
  twSeparate : ∀ k, k<size l → ∀ j, j<size l → Separate (walk (element fs u) j stride) (element igm k)
  twLoads : ∀ k, k<size l → Load32 s.heap (element igm k) (tws k)
  data : ∀ j, j<size l → Load32 s.heap (walk (element fs u) j stride) (fv j)

theorem binding (l : Level) (s : State) (fs igm : ArrayPointer) (u stride : Nat)
    (p p0i : BitVec 32) (tws fv : Nat → BitVec 32) (h : Input l s fs igm u stride p p0i tws fv) :
    KeygenLevelCalls.Bind s (KeygenLevelCalls.params .inverse) MakeFgInverseShape192.inverseArgs
      (entry l s (element fs u) igm stride p p0i) := by
  have within : fs.index+u ≤ fs.count := by have a:=h.aCapacity; change fs.index+u+size l*stride ≤ fs.count at a; omega
  have aPointer : C99ArrayReference.Pointer s "fs".toList MakeFgInverseShape192.varU (element fs u) :=
    .add _ _ fs _ (u64 u) h.fBinding (.variable _ _ _ h.uCell)
      (by rw [KeygenNttLoopSupport.u64_integer u h.uBound]; omega) (by rw [KeygenNttLoopSupport.u64_toNat u h.uBound]; exact .within fs u within)
  exact .pointer "a".toList "fs".toList MakeFgInverseShape192.varU (element fs u) _ _ _ aPointer
    (.scalar .uint64 "stride".toList _ _ _ _ (u64 stride) (.modular _ _ (.scalar _ _ (.variable _ _ _ h.strideCell)))
      (.pointer "igm".toList "igm".toList C99ProcedureParser.zero igm _ _ _
        (RootBinding175.zero s "igm" igm h.iBinding (by have a:=h.iCapacity; omega))
        (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 (lognWord l)) (.modular _ _ (.scalar _ _ (.variable _ _ _ h.lognCell)))
          (.scalar .uint32 "full".toList _ _ _ _ (.int32 0) (.modular _ _ (.scalar _ _ (.literal .int32 0)))
            (.scalar .uint32 "p".toList _ _ _ _ (.uint32 p) (.modular _ _ (.scalar _ _ (.variable _ _ _ h.pCell)))
              (.scalar .uint32 "p0i".toList _ [] [] (empty s) (.uint32 p0i)
                (.modular _ _ (.scalar _ _ (.variable _ _ _ h.iCell))) .nil))))))

structure Cells (l : Level) (s : State) (a igm : ArrayPointer) (stride : Nat) (p p0i : BitVec 32) : Prop where
  logn : Slot s "logn" (lognWord l)
  full : Slot s "full" 0
  step : USlot s "stride" stride
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  aBinding : s.arrays "a".toList=some a
  iBinding : s.arrays "igm".toList=some igm

theorem cells (l : Level) (s : State) (a igm : ArrayPointer) (stride : Nat) (p p0i : BitVec 32)
    (bound : stride<2^64) : Cells l (entry l s a igm stride p p0i) a igm stride p p0i := by
  constructor
  case step => exact KeygenMkgm3RowInit.set64_slot (withIgm l s igm p p0i) "stride" stride bound
  all_goals simp [Slot,entry,withStride,withIgm,withLogn,withFull,withP,withI,
    bindPointer,bindValue,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem source (l : Level) (s : State) (fs igm : ArrayPointer) (u stride : Nat)
    (p p0i : BitVec 32) (tws fv : Nat → BitVec 32) (h : Input l s fs igm u stride p p0i tws fv) :
    ∃ out, KeygenMakeFgSource.Exec MakeFgInverseShape192.inverseCall s ⟨out,.normal⟩ ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ j, j<size l → Load32 out.heap (walk (element fs u) j stride) (scaledWord l fv tws p p0i j)) ∧
      (∀ q, (∀ j, j<size l → Separate (walk (element fs u) j stride) q) →
        ∀ z, Load32 s.heap q z → Load32 out.heap q z) := by
  have c:=cells l s (element fs u) igm stride p p0i h.strideBound
  have data := NttInverseWholeBridges201.start_image l (entry l s (element fs u) igm stride p p0i)
    (element fs u) stride tws p p0i fv h.data
  obtain ⟨generated,run,image,counter,r1,aBinding,iBinding,nCell,step,pCell,iCell,niCell,writable,keeps,wr⟩ :=
    NttInverseWholeKeep202.source l (entry l s (element fs u) igm stride p p0i) (element fs u) igm stride p p0i tws fv
      c.logn c.full c.step c.pCell c.iCell c.aBinding c.iBinding h.width h.aCapacity h.iCapacity h.writable
      h.strideBound h.wide h.separate h.twSeparate h.twLoads data
  let out := {s with heap:=generated.heap}
  have callRun : KeygenLevelCalls.Call .inverse s MakeFgInverseShape192.inverseArgs out :=
    .run _ ⟨generated,.normal⟩ (binding l s fs igm u stride p p0i tws fv h) run .voidEnd
  refine ⟨out,.level _ _ _ (.call _ _ _ _ callRun),rfl,rfl,?_,keeps⟩
  intro j bound
  exact (image j bound).1 bound

end FT1536.Source3.NttInverseCall202
