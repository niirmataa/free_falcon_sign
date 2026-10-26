import Source3.NttInverseCall202
import Source3.SecondStepCopy203

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseSides203
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open MkgmParams198 (Level lognWord)
open NttInverseSchedule201 (size)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)
open NttInverseCall202 (empty entry cells)
open SecondStepCopy203 (Side)

def name : Side → String | .f => "fs" | .g => "gs"
def args (side : Side) : List KeygenLevelCalls.Arg :=
  [.pointer (name side).toList MakeFgInverseShape192.varU,
    .scalar (.modular (.scalar MakeFgInverseShape192.varSlen)),
    .pointer "igm".toList C99ProcedureParser.zero,
    .scalar (.modular (.scalar MakeFgInverseShape192.varLogn)),
    .scalar (.modular (.scalar (MakeFgInverseShape192.num 0))),
    .scalar (.modular (.scalar MakeFgInverseShape192.varP)),
    .scalar (.modular (.scalar MakeFgInverseShape192.varI))]
def code (side : Side) : KeygenMakeFgSource.Stmt := .level (.call .inverse (args side))

theorem f_shape : code .f=MakeFgInverseShape192.inverseCall := rfl
theorem g_shape : code .g=MakeFgGsShape194.inverseCallGs := rfl

structure Input (side : Side) (l : Level) (s : State) (fs igm : ArrayPointer) (u stride : Nat)
    (p p0i : BitVec 32) (tws fv : Nat → BitVec 32) : Prop where
  uCell : USlot s "u" u
  strideCell : USlot s "slen" stride
  lognCell : Slot s "logn" (lognWord l)
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  fBinding : s.arrays (name side).toList=some fs
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

theorem binding (side : Side) (l : Level) (s : State) (fs igm : ArrayPointer) (u stride : Nat)
    (p p0i : BitVec 32) (tws fv : Nat → BitVec 32) (h : Input side l s fs igm u stride p p0i tws fv) :
    KeygenLevelCalls.Bind s (KeygenLevelCalls.params .inverse) (args side)
      (entry l s (element fs u) igm stride p p0i) := by
  have within : fs.index+u ≤ fs.count := by have a:=h.aCapacity; change fs.index+u+size l*stride ≤ fs.count at a; omega
  have aPointer : C99ArrayReference.Pointer s (name side).toList MakeFgInverseShape192.varU (element fs u) :=
    .add _ _ fs _ (u64 u) h.fBinding (.variable _ _ _ h.uCell)
      (by rw [KeygenNttLoopSupport.u64_integer u h.uBound]; omega) (by rw [KeygenNttLoopSupport.u64_toNat u h.uBound]; exact .within fs u within)
  exact .pointer "a".toList (name side).toList MakeFgInverseShape192.varU (element fs u) _ _ _ aPointer
    (.scalar .uint64 "stride".toList _ _ _ _ (u64 stride) (.modular _ _ (.scalar _ _ (.variable _ _ _ h.strideCell)))
      (.pointer "igm".toList "igm".toList C99ProcedureParser.zero igm _ _ _
        (RootBinding175.zero s "igm" igm h.iBinding (by have a:=h.iCapacity; omega))
        (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 (lognWord l)) (.modular _ _ (.scalar _ _ (.variable _ _ _ h.lognCell)))
          (.scalar .uint32 "full".toList _ _ _ _ (.int32 0) (.modular _ _ (.scalar _ _ (.literal .int32 0)))
            (.scalar .uint32 "p".toList _ _ _ _ (.uint32 p) (.modular _ _ (.scalar _ _ (.variable _ _ _ h.pCell)))
              (.scalar .uint32 "p0i".toList _ [] [] (empty s) (.uint32 p0i)
                (.modular _ _ (.scalar _ _ (.variable _ _ _ h.iCell))) .nil))))))

theorem source (side : Side) (l : Level) (s : State) (fs igm : ArrayPointer) (u stride : Nat)
    (p p0i : BitVec 32) (tws fv : Nat → BitVec 32) (h : Input side l s fs igm u stride p p0i tws fv) :
    ∃ out, KeygenMakeFgSource.Exec (code side) s ⟨out,.normal⟩ ∧
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
  have callRun : KeygenLevelCalls.Call .inverse s (args side) out :=
    .run _ ⟨generated,.normal⟩ (binding side l s fs igm u stride p p0i tws fv h) run .voidEnd
  refine ⟨out,.level _ _ _ (.call _ _ _ _ callRun),rfl,rfl,?_,keeps⟩
  intro j bound
  exact (image j bound).1 bound


def terNo : Side → KeygenMakeFgSource.Stmt
  | .f => MakeFgInverseShape192.terNo
  | .g => MakeFgGsShape194.terNo7

def branch : Side → KeygenMakeFgSource.Stmt
  | .f => MakeFgTailShape190.s3
  | .g => MakeFgTailShape190.s7

theorem branch_shape (side : Side) : branch side=
    .branch (.var "in_ntt".toList)
      (.scope [] [] (.seq (.branch (.var "ter".toList)
        (.scope [] [] (.seq (code side) KeygenMakeFgSource.skip)) (terNo side)) KeygenMakeFgSource.skip))
      KeygenMakeFgSource.skip := by
  cases side
  · rw [branch,MakeFgTailShape190.s3_shape,MakeFgInverseShape192.s3Yes_shape,
      MakeFgInverseShape192.inner_shape,MakeFgInverseShape192.terBranch_shape,MakeFgInverseShape192.terYes_shape]
    rfl
  · rw [branch,MakeFgGsShape194.s7_shape,MakeFgGsShape194.s7Yes_shape,
      MakeFgGsShape194.inner7_shape,MakeFgGsShape194.terBranch7_shape,MakeFgGsShape194.terYes7_shape]
    rfl

theorem branch_source (side : Side) (l : Level) (s : State) (fs igm : ArrayPointer) (u stride : Nat)
    (p p0i : BitVec 32) (tws fv : Nat → BitVec 32) (h : Input side l s fs igm u stride p p0i tws fv)
    (inCell : s.locals "in_ntt".toList=some (.int32,some (.int32 1))) (terCell : Slot s "ter" 1) :
    ∃ out, KeygenMakeFgSource.Exec (branch side) s ⟨out,.normal⟩ ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ j, j<size l → Load32 out.heap (walk (element fs u) j stride) (scaledWord l fv tws p p0i j)) ∧
      (∀ q, (∀ j, j<size l → Separate (walk (element fs u) j stride) q) →
        ∀ z, Load32 s.heap q z → Load32 out.heap q z) := by
  obtain ⟨out,callRun,locals,arrays,image,keeps⟩ := source side l s fs igm u stride p p0i tws fv h
  have inner : KeygenMakeFgSource.Exec (.scope [] [] (.seq (code side) KeygenMakeFgSource.skip)) s ⟨out,.normal⟩ :=
    MakeFgScope187.source _ s out (.seqNormal _ _ s out _ callRun (SelectedStepAddPrime195.skip_run out))
  have terRun : KeygenMakeFgSource.Exec (.branch (.var "ter".toList)
      (.scope [] [] (.seq (code side) KeygenMakeFgSource.skip)) (terNo side)) s ⟨out,.normal⟩ :=
    .branchTrue _ _ _ s _ (.uint32 1) (.variable _ _ _ terCell) (by decide) inner
  refine ⟨out,?_,locals,arrays,image,keeps⟩
  rw [branch_shape]
  exact .branchTrue _ _ _ s _ (.int32 1) (.variable _ _ _ inCell) (by decide)
    (MakeFgScope187.source _ s out (.seqNormal _ _ s out _ terRun (SelectedStepAddPrime195.skip_run out)))

end FT1536.Source3.NttInverseSides203
