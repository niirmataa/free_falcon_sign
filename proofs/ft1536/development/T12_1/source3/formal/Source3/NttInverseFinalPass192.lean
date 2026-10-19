import Source3.NttInverseFinalLoop192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Composition of the original degree-1 final pass of the accepted
   modp_iNTT3_ext corpus at logn9/full0: the w = igm[0] assignment, the
   u/r1/r2 initialization, the complete 256-iteration butterfly loop and
   the trailing skip, closed as one execution of the finalPass statement
   chain. Values are only the executed operations; no root or transform
   property is assumed. -/
namespace FT1536.Source3.NttInverseFinalPass192
open C99ArrayReference (State Name Pointer bindPointer bindValue)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk)
open NttInverseCorrectionSource192 (walk_zero)
open NttInverseFinalLoop192 (Image Fixed remaining)

def setW (s : State) (w : BitVec 32) : State := ModularAtoms178.set s "w" w

def mid (s : State) (w : BitVec 32) (a : ArrayPointer) (stride : Nat) : State :=
  bindPointer (bindValue (setW s w) "u".toList .uint64 (.int32 0)) "r1".toList (walk a 0 stride)

def started (s : State) (w : BitVec 32) (a : ArrayPointer) (stride hn : Nat) : State :=
  bindPointer (mid s w a stride) "r2".toList (walk a (0+hn) stride)

theorem walk_zero_add (a : ArrayPointer) (stride hn : Nat) :
    walk a (0+hn) stride=walk a hn stride := by
  unfold walk StepCopyBody190.addr
  congr 1
  rw [Nat.zero_add]

theorem zero_i32 (s : State) (name : Name) (q : ArrayPointer)
    (binding : s.arrays name=some q) (capacity : q.index≤q.count) :
    Pointer s name (NttInversePrograms192.num 0) q := by
  refine .add _ _ q q (.int32 0) binding (.literal .int32 0) ?_ ?_
  · decide
  · exact .within q 0 capacity

theorem word_mul (a b : Nat) (boundA : a<2^64) (boundB : b<2^64) :
    C99IntegerReference.ArithmeticExec .times (.uint64 (word a)) (.uint64 (word b))
      (.uint64 (word (a*b))) := by
  have raw := C99IntegerReference.ArithmeticExec.step .times
    (.uint64 (word a)) (.uint64 (word b)) .uint64 rfl
    (.uint64 (word a)) (.uint64 (word b))
    (C99CountedWords.convert_self (.uint64 (word a))).symm
    (C99CountedWords.convert_self (.uint64 (word b))).symm (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .times (.uint64 (word a)) (.uint64 (word b))
    (.uint64 (BitVec.ofInt 64
      ((C99IntegerReference.Value.uint64 (word a)).integer*
        (C99IntegerReference.Value.uint64 (word b)).integer))) at raw
  rw [C99NatWord141.integer a boundA,C99NatWord141.integer b boundB] at raw
  have product : (a : Int)*(b : Int)=((a*b : Nat) : Int) := by omega
  rw [product,BitVec.ofInt_natCast] at raw
  exact raw

theorem setW_keep (s : State) (w : BitVec 32) (name : String) (n : Nat)
    (different : name.toList≠"w".toList) (base : USlot s name n) :
    USlot (setW s w) name n :=
  (ModularAtoms178.outside s "w" name w different).trans base

theorem mid_keep (s : State) (w : BitVec 32) (a : ArrayPointer) (stride : Nat) (name : String)
    (n : Nat) (different : name.toList≠"u".toList) (base : USlot (setW s w) name n) :
    USlot (mid s w a stride) name n := by
  show (mid s w a stride).locals name.toList=some (.uint64,some (u64 n))
  have locals : (mid s w a stride).locals name.toList=
      (bindValue (setW s w) "u".toList .uint64 (.int32 0)).locals name.toList := rfl
  rw [locals]
  have update : (bindValue (setW s w) "u".toList .uint64 (.int32 0)).locals name.toList=
      (setW s w).locals name.toList := by
    simp only [bindValue,C99ScalarReference.set,different,ite_false]
  rw [update]
  exact base

theorem mid_arrays (s : State) (w : BitVec 32) (a : ArrayPointer) (stride : Nat) (name : Name)
    (different : name≠"r1".toList) : (mid s w a stride).arrays name=s.arrays name := by
  have step : (mid s w a stride).arrays name=
      (bindValue (setW s w) "u".toList .uint64 (.int32 0)).arrays name :=
    StepProductFixed191.bindPointer_arrays (bindValue (setW s w) "u".toList .uint64 (.int32 0))
      "r1".toList (walk a 0 stride) name different
  rw [step]
  rfl

theorem u_zero (s : State) (w : BitVec 32) (a : ArrayPointer) (stride : Nat) :
    Cell (mid s w a stride) "u".toList 0 := rfl

theorem started_u (s : State) (w : BitVec 32) (a : ArrayPointer) (stride hn : Nat) :
    Cell (started s w a stride hn) "u".toList 0 := rfl

theorem started_r1 (s : State) (w : BitVec 32) (a : ArrayPointer) (stride hn : Nat) :
    (started s w a stride hn).arrays "r1".toList=some (walk a 0 stride) := by
  have step : (started s w a stride hn).arrays "r1".toList=
      (mid s w a stride).arrays "r1".toList :=
    StepProductFixed191.bindPointer_arrays (mid s w a stride) "r2".toList
      (walk a (0+hn) stride) "r1".toList (by decide)
  rw [step]
  rfl

theorem started_r2 (s : State) (w : BitVec 32) (a : ArrayPointer) (stride hn : Nat) :
    (started s w a stride hn).arrays "r2".toList=some (walk a (0+hn) stride) := rfl

theorem w_run (s : State) (igm : ArrayPointer) (w : BitVec 32)
    (wDeclared : s.locals "w".toList=some (.uint32,none))
    (igmBinding : s.arrays "igm".toList=some igm) (capacity : igm.index ≤ igm.count)
    (read : Load32 s.heap igm w) :
    Exec NttInversePrograms192.wAssign s ⟨setW s w,.normal⟩ :=
  ModularAtoms178.assign s "w" none
    (NttInversePrograms192.read "igm" (NttInversePrograms192.num 0)) w wDeclared
    (.load32 "igm".toList (NttInversePrograms192.num 0) igm w
      (zero_i32 s "igm".toList igm igmBinding capacity) read)

theorem u_run (s : State) (w : BitVec 32)
    (uDeclared : (setW s w).locals "u".toList=some (.uint64,none)) :
    Exec NttInversePrograms192.uInit (setW s w)
      ⟨bindValue (setW s w) "u".toList .uint64 (.int32 0),.normal⟩ :=
  .assign _ _ _ .uint64 none (.int32 0) uDeclared (.scalar _ _ (.literal .int32 0))

theorem r1_run (s : State) (w : BitVec 32) (a : ArrayPointer) (stride : Nat)
    (aBinding : (bindValue (setW s w) "u".toList .uint64 (.int32 0)).arrays "a".toList=some a)
    (capacity : a.index≤a.count) :
    Exec NttInversePrograms192.r1Init (bindValue (setW s w) "u".toList .uint64 (.int32 0))
      ⟨mid s w a stride,.normal⟩ := by
  have address : Pointer (bindValue (setW s w) "u".toList .uint64 (.int32 0))
      "a".toList NttInversePrograms192.zero a :=
    StepCopyBody190.zero_pointer (bindValue (setW s w) "u".toList .uint64 (.int32 0))
      "a".toList a aBinding capacity
  have bindRun : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "r1".toList "a".toList NttInversePrograms192.zero)
      (bindValue (setW s w) "u".toList .uint64 (.int32 0))
      (bindPointer (bindValue (setW s w) "u".toList .uint64 (.int32 0)) "r1".toList a) :=
    .bindPtr _ _ _ _ _ address
  have final : bindPointer (bindValue (setW s w) "u".toList .uint64 (.int32 0)) "r1".toList a=
      mid s w a stride := by
    simp only [mid]
    rw [walk_zero]
  rw [← final]
  exact .base _ _ _ bindRun

theorem r2_run (s : State) (w : BitVec 32) (a : ArrayPointer) (stride hn : Nat)
    (hnCell : USlot s "hn" hn) (strideCell : USlot s "stride" stride)
    (hnBound : hn<2^64) (strideBound : stride<2^64) (wide : hn*stride<2^64)
    (aBinding : s.arrays "a".toList=some a)
    (aCapacity : a.index+hn*stride≤a.count) :
    Exec NttInversePrograms192.r2Init (mid s w a stride) ⟨started s w a stride hn,.normal⟩ := by
  have aMid : (mid s w a stride).arrays "a".toList=some a :=
    (mid_arrays s w a stride "a".toList (by decide)).trans aBinding
  have hnMid : USlot (mid s w a stride) "hn" hn :=
    mid_keep s w a stride "hn" hn (by decide) (setW_keep s w "hn" hn (by decide) hnCell)
  have strideMid : USlot (mid s w a stride) "stride" stride :=
    mid_keep s w a stride "stride" stride (by decide)
      (setW_keep s w "stride" stride (by decide) strideCell)
  have index : C99ArrayReference.scalar (mid s w a stride)
      (.bin .mul (NttInversePrograms192.var "hn") (NttInversePrograms192.var "stride"))
      (.uint64 (word (hn*stride))) :=
    .arithmetic .times _ _ _ _ _
      (C99LoopScalar141.read (mid s w a stride) "hn".toList hn hnMid)
      (C99LoopScalar141.read (mid s w a stride) "stride".toList stride strideMid)
      (word_mul hn stride hnBound strideBound)
  have address : Pointer (mid s w a stride) "a".toList
      (.bin .mul (NttInversePrograms192.var "hn") (NttInversePrograms192.var "stride"))
      (walk a hn stride) := by
    refine .add _ _ a (walk a hn stride) (.uint64 (word (hn*stride))) aMid index ?_ ?_
    · rw [C99NatWord141.integer (hn*stride) wide]
      omega
    · rw [C99NatWord141.integer (hn*stride) wide]
      exact .within a (hn*stride) (by omega)
  have bindRun : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "r2".toList "a".toList
        (.bin .mul (NttInversePrograms192.var "hn") (NttInversePrograms192.var "stride")))
      (mid s w a stride)
      (bindPointer (mid s w a stride) "r2".toList (walk a hn stride)) :=
    .bindPtr _ _ _ _ _ address
  have final : bindPointer (mid s w a stride) "r2".toList (walk a hn stride)=
      started s w a stride hn := by
    simp only [started]
    rw [walk_zero_add]
  rw [← final]
  exact .base _ _ _ bindRun

theorem source (s : State) (a igm : ArrayPointer) (stride : Nat) (p p0i w : BitVec 32)
    (fv : Nat → BitVec 32)
    (wDeclared : s.locals "w".toList=some (.uint32,none))
    (uDeclared : s.locals "u".toList=some (.uint64,none))
    (hnCell : USlot s "hn" 256) (strideCell : USlot s "stride" stride)
    (hnBound : 256<2^64) (strideBound : stride<2^64) (wide : 256*stride<2^64)
    (igmBinding : s.arrays "igm".toList=some igm) (igmCapacity : igm.index ≤ igm.count)
    (wRead : Load32 s.heap igm w)
    (aBinding : s.arrays "a".toList=some a) (capacity : a.index≤a.count)
    (aCapacity : a.index+256*stride≤a.count)
    (fixed : Fixed (started s w a stride 256) a stride 256 p p0i w fv)
    (image : Image (started s w a stride 256) a stride 256 w p p0i fv 0) :
    ∃ after, Exec NttInversePrograms192.finalPass s ⟨after,.normal⟩ ∧
      Fixed after a stride 256 p p0i w fv ∧
      Image after a stride 256 w p p0i fv 256 ∧
      Cell after "u".toList 256 ∧
      after.arrays "r1".toList=some (walk a 256 stride) ∧
      after.arrays "r2".toList=some (walk a (256+256) stride) := by
  have wRun : Exec NttInversePrograms192.wAssign s ⟨setW s w,.normal⟩ :=
    w_run s igm w wDeclared igmBinding igmCapacity wRead
  have uAfter : (setW s w).locals "u".toList=some (.uint64,none) :=
    (ModularAtoms178.outside s "w" "u" w (by decide)).trans uDeclared
  have uRun : Exec NttInversePrograms192.uInit (setW s w)
      ⟨bindValue (setW s w) "u".toList .uint64 (.int32 0),.normal⟩ :=
    u_run s w uAfter
  have r1Run : Exec NttInversePrograms192.r1Init
      (bindValue (setW s w) "u".toList .uint64 (.int32 0)) ⟨mid s w a stride,.normal⟩ :=
    r1_run s w a stride aBinding capacity
  have r2Run : Exec NttInversePrograms192.r2Init (mid s w a stride)
      ⟨started s w a stride 256,.normal⟩ :=
    r2_run s w a stride 256 hnCell strideCell hnBound strideBound wide aBinding aCapacity
  have initRun : Exec (.seq NttInversePrograms192.uInit
      (.seq NttInversePrograms192.r1Init NttInversePrograms192.r2Init))
      (setW s w) ⟨started s w a stride 256,.normal⟩ :=
    .seqNormal _ _ (setW s w) (bindValue (setW s w) "u".toList .uint64 (.int32 0))
      ⟨started s w a stride 256,.normal⟩ uRun
      (.seqNormal _ _ (bindValue (setW s w) "u".toList .uint64 (.int32 0)) (mid s w a stride)
        ⟨started s w a stride 256,.normal⟩ r1Run r2Run)
  obtain ⟨after,loopRun,loopFixed,loopCell,loopR1,loopR2,loopImage,_,_⟩ :=
    remaining 256 0 (started s w a stride 256) a stride 256 p p0i w fv fixed
      (started_u s w a stride 256) (started_r1 s w a stride 256) (started_r2 s w a stride 256)
      image (by omega)
  have fLoopRun : Exec NttInversePrograms192.fLoop (setW s w) ⟨after,.normal⟩ :=
    .seqNormal _ _ (setW s w) (started s w a stride 256) ⟨after,.normal⟩ initRun loopRun
  refine ⟨after,?_,loopFixed,loopImage,loopCell,loopR1,loopR2⟩
  exact .seqNormal _ _ s (setW s w) ⟨after,.normal⟩ wRun
    (.seqNormal _ _ (setW s w) after ⟨after,.normal⟩ fLoopRun (.base _ _ _ (.skip _)))

end FT1536.Source3.NttInverseFinalPass192
