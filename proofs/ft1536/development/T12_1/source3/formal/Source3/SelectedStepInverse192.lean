import Source3.SelectedStepProduct191
import Source3.MakeFgInverseShape192
import Source3.NttInverseWhole192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The active inverse-call branch s3 of the make_fg_step first-prime tail
   at the actual selected seed9 product output: the KeygenLevelCalls.Bind
   of the original call arguments (fs at the u=0 cell, the slen=1 stride
   cell, igm at the parser zero index, the logn=9 cell, the original zero
   literal for full, the p/p0i slots), the modp_iNTT3_ext body execution
   through the closed KeygenLevelNtt.inverse composition, and the s3
   branch composition to the stage statement
   `KeygenMakeFgSource.Exec MakeFgTailShape190.s3 productOut out`. The
   exported image records the transformed fs words as the executed
   modp_add/modp_sub/modp_montymul/modp_R/modp_div word terms
   (NttInverseWholeBridges192.scaledWord) over the copied fs image
   (SelectedStepProduct191.fvs), with the caller locals/arrays frame
   outside v/x. No transform property or numerical claim. -/
namespace FT1536.Source3.SelectedStepInverse192
open C99ArrayReference (State Name Pointer bindPointer bindValue)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (skip)
open KeygenLevelCalls (Arg)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open SelectedStepLayout187 (fs)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges192 (finalWord scaledWord)

def raw (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def stepP0i (s : State) (p0i : BitVec 32) : State := bindValue s "p0i".toList .uint32 (.uint32 p0i)
def stepP (s : State) (p : BitVec 32) : State := bindValue s "p".toList .uint32 (.uint32 p)
def stepFull (s : State) : State := bindValue s "full".toList .uint32 (.int32 0)
def stepLogn (s : State) : State := bindValue s "logn".toList .uint32 (.uint32 9)
def stepIgm (s : State) (igm : ArrayPointer) : State := bindPointer s "igm".toList igm
def stepStride (s : State) : State := bindValue s "stride".toList .uint64 (.uint64 (C99NatWord141.word 1))
def stepA (s : State) (a : ArrayPointer) : State := bindPointer s "a".toList a

def entry (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) : State :=
  stepA (stepStride (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw s) p0i) p))) igm)) a

theorem entry_locals (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) (name : Name)
    (different : name≠"stride".toList) :
    (entry s a igm p p0i).locals name=
      (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw s) p0i) p))) igm).locals name := by
  unfold entry stepA stepStride
  simp only [C99ArrayReference.bindPointer,bindValue,C99ScalarReference.set]
  split_ifs
  · next hit => exact absurd hit different
  · rfl

theorem entry_a (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) :
    (entry s a igm p p0i).arrays "a".toList=some a := rfl

theorem entry_igm (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) :
    (entry s a igm p p0i).arrays "igm".toList=some igm := by
  unfold entry stepA stepStride stepIgm
  rfl

theorem entry_stride (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) :
    USlot (entry s a igm p p0i) "stride" 1 := by
  show (entry s a igm p p0i).locals "stride".toList=some (.uint64,some (.uint64 (C99NatWord141.word 1)))
  unfold entry stepA stepStride
  rfl

theorem entry_logn (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) :
    Slot (entry s a igm p p0i) "logn" 9 :=
  (entry_locals s a igm p p0i "logn".toList (by decide)).trans rfl

theorem entry_full (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) :
    Slot (entry s a igm p p0i) "full" 0 :=
  (entry_locals s a igm p p0i "full".toList (by decide)).trans rfl

theorem entry_p (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) :
    Slot (entry s a igm p p0i) "p" p := by
  refine (entry_locals s a igm p p0i "p".toList (by decide)).trans ?_
  show (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw s) p0i) p))) igm).locals "p".toList=
    some (.uint32,some (.uint32 p))
  have chain : (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw s) p0i) p))) igm).locals "p".toList=
      some (.uint32,some
        (C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 p).integer)) := rfl
  have key : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 p).integer=
      C99IntegerReference.Value.uint32 p :=
    C99CountedWords.convert_self (C99IntegerReference.Value.uint32 p)
  rw [chain,key]

theorem entry_p0i (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) :
    Slot (entry s a igm p p0i) "p0i" p0i := by
  refine (entry_locals s a igm p p0i "p0i".toList (by decide)).trans ?_
  show (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw s) p0i) p))) igm).locals "p0i".toList=
    some (.uint32,some (.uint32 p0i))
  have chain : (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw s) p0i) p))) igm).locals "p0i".toList=
      some (.uint32,some
        (C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 p0i).integer)) := rfl
  have key : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 p0i).integer=
      C99IntegerReference.Value.uint32 p0i :=
    C99CountedWords.convert_self (C99IntegerReference.Value.uint32 p0i)
  rw [chain,key]

theorem walk_fs (k : Nat) : walk (addr fs 0 0 1) k 1=elem fs k := by
  have key : fs.index+0+0*1+0+k*1=fs.index+k := by omega
  exact congrArg (fun n : Nat => {fs with index := n}) key

theorem source (productOut : State) (p p0i : BitVec 32) (tws : Nat → BitVec 32)
    (uCell : Cell productOut "u".toList 0) (slenCell : USlot productOut "slen" 1)
    (lognCell : Slot productOut "logn" 9) (terCell : Slot productOut "ter" 1)
    (inNttCell : productOut.locals "in_ntt".toList=some (.int32,some (.int32 1)))
    (pc : Slot productOut "p" p) (ic : Slot productOut "p0i" p0i)
    (fsBinding : productOut.arrays "fs".toList=some fs)
    (igmBinding : productOut.arrays "igm".toList=some igm)
    (fsWritable : productOut.heap.writable fs.block=true)
    (fsCapacity : (addr fs 0 0 1).index + 512 ≤ (addr fs 0 0 1).count)
    (igmCapacity : igm.index + 512 ≤ igm.count)
    (fsSeparate : ∀ j k : Nat, j<512 → k<512 → j≠k →
      Separate (walk (addr fs 0 0 1) j 1) (walk (addr fs 0 0 1) k 1))
    (twSeparate : ∀ k : Nat, k<512 → ∀ j : Nat, j<512 →
      Separate (walk (addr fs 0 0 1) j 1) ({igm with index := igm.index+k}))
    (twLoads : ∀ k : Nat, k<512 → Load32 productOut.heap ({igm with index := igm.index+k}) (tws k))
    (fsImage : ∀ i : Fin 512, Load32 productOut.heap (elem fs i.val)
      (SelectedStepProduct191.fvs i.val))
    (localsKeep : ∀ name : Name, name≠"v".toList →
      productOut.locals name=SelectedStepProduct191.base.locals name)
    (arraysKeep : ∀ name : Name, name≠"x".toList →
      productOut.arrays name=SelectedStepProduct191.base.arrays name) :
    ∃ after, KeygenMakeFgSource.Exec MakeFgTailShape190.s3 productOut ⟨after,.normal⟩ ∧
      (∀ i : Fin 512, Load32 after.heap (elem fs i.val)
        (scaledWord SelectedStepProduct191.fvs tws p p0i i.val)) ∧
      (∀ name : Name, name≠"v".toList → after.locals name=SelectedStepProduct191.base.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=SelectedStepProduct191.base.arrays name) := by
  have aPointer : Pointer productOut "fs".toList MakeFgInverseShape192.varU (addr fs 0 0 1) :=
    .add "fs".toList MakeFgInverseShape192.varU fs (addr fs 0 0 1)
      (.uint64 (C99NatWord141.word 0)) fsBinding
      (C99LoopScalar141.read productOut "u".toList 0 uCell) (by decide)
      (C99MemoryReference.PointerAdd.within fs 0 (by decide))
  have igmPointer : Pointer productOut "igm".toList C99ProcedureParser.zero igm :=
    StepCopyBody190.zero_pointer productOut "igm".toList igm igmBinding (by
      have step := igmCapacity
      omega)
  have evalSlen : KeygenLevelCalls.Eval productOut
      (.modular (.scalar MakeFgInverseShape192.varSlen)) (.uint64 (C99NatWord141.word 1)) :=
    .modular _ _ (.scalar _ _ (.variable _ _ _ slenCell))
  have evalLogn : KeygenLevelCalls.Eval productOut
      (.modular (.scalar MakeFgInverseShape192.varLogn)) (.uint32 9) :=
    .modular _ _ (.scalar _ _ (.variable _ _ _ lognCell))
  have evalFull : KeygenLevelCalls.Eval productOut
      (.modular (.scalar (MakeFgInverseShape192.num 0))) (.int32 0) :=
    .modular _ _ (.scalar _ _ (.literal .int32 0))
  have evalP : KeygenLevelCalls.Eval productOut
      (.modular (.scalar MakeFgInverseShape192.varP)) (.uint32 p) :=
    .modular _ _ (.scalar _ _ (.variable _ _ _ pc))
  have evalI : KeygenLevelCalls.Eval productOut
      (.modular (.scalar MakeFgInverseShape192.varI)) (.uint32 p0i) :=
    .modular _ _ (.scalar _ _ (.variable _ _ _ ic))
  have bNil : KeygenLevelCalls.Bind productOut [] [] (raw productOut) := .nil
  have bP0i : KeygenLevelCalls.Bind productOut
      [(.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.scalar (.modular (.scalar MakeFgInverseShape192.varI)) : Arg)]
      (stepP0i (raw productOut) p0i) :=
    .scalar .uint32 "p0i".toList (.modular (.scalar MakeFgInverseShape192.varI)) [] []
      (raw productOut) (.uint32 p0i) evalI bNil
  have bP : KeygenLevelCalls.Bind productOut
      [(.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.scalar (.modular (.scalar MakeFgInverseShape192.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varI)) : Arg)]
      (stepP (stepP0i (raw productOut) p0i) p) :=
    .scalar .uint32 "p".toList (.modular (.scalar MakeFgInverseShape192.varP)) _ _
      (stepP0i (raw productOut) p0i) (.uint32 p) evalP bP0i
  have bFull : KeygenLevelCalls.Bind productOut
      [(.scalar .uint32 "full".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.scalar (.modular (.scalar (MakeFgInverseShape192.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varI)) : Arg)]
      (stepFull (stepP (stepP0i (raw productOut) p0i) p)) :=
    .scalar .uint32 "full".toList (.modular (.scalar (MakeFgInverseShape192.num 0))) _ _
      (stepP (stepP0i (raw productOut) p0i) p) (.int32 0) evalFull bP
  have bLogn : KeygenLevelCalls.Bind productOut
      [(.scalar .uint32 "logn".toList : C99ArrayReference.Param),
        (.scalar .uint32 "full".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.scalar (.modular (.scalar MakeFgInverseShape192.varLogn)) : Arg),
        (.scalar (.modular (.scalar (MakeFgInverseShape192.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varI)) : Arg)]
      (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p))) :=
    .scalar .uint32 "logn".toList (.modular (.scalar MakeFgInverseShape192.varLogn)) _ _
      (stepFull (stepP (stepP0i (raw productOut) p0i) p)) (.uint32 9) evalLogn bFull
  have bIgm : KeygenLevelCalls.Bind productOut
      [(.pointer "igm".toList : C99ArrayReference.Param),
        (.scalar .uint32 "logn".toList : C99ArrayReference.Param),
        (.scalar .uint32 "full".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.pointer "igm".toList C99ProcedureParser.zero : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varLogn)) : Arg),
        (.scalar (.modular (.scalar (MakeFgInverseShape192.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varI)) : Arg)]
      (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p))) igm) :=
    .pointer "igm".toList "igm".toList C99ProcedureParser.zero igm _ _
      (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p))) igmPointer bLogn
  have bStride : KeygenLevelCalls.Bind productOut
      [(.scalar .uint64 "stride".toList : C99ArrayReference.Param),
        (.pointer "igm".toList : C99ArrayReference.Param),
        (.scalar .uint32 "logn".toList : C99ArrayReference.Param),
        (.scalar .uint32 "full".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.scalar (.modular (.scalar MakeFgInverseShape192.varSlen)) : Arg),
        (.pointer "igm".toList C99ProcedureParser.zero : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varLogn)) : Arg),
        (.scalar (.modular (.scalar (MakeFgInverseShape192.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varI)) : Arg)]
      (stepStride (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p))) igm)) :=
    .scalar .uint64 "stride".toList (.modular (.scalar MakeFgInverseShape192.varSlen)) _ _
      (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p))) igm)
      (.uint64 (C99NatWord141.word 1)) evalSlen bIgm
  have binding : KeygenLevelCalls.Bind productOut (KeygenLevelCalls.params .inverse)
      MakeFgInverseShape192.inverseArgs (entry productOut (addr fs 0 0 1) igm p p0i) := by
    show KeygenLevelCalls.Bind productOut
      [(.pointer "a".toList : C99ArrayReference.Param),
        (.scalar .uint64 "stride".toList : C99ArrayReference.Param),
        (.pointer "igm".toList : C99ArrayReference.Param),
        (.scalar .uint32 "logn".toList : C99ArrayReference.Param),
        (.scalar .uint32 "full".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.pointer "fs".toList MakeFgInverseShape192.varU : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varSlen)) : Arg),
        (.pointer "igm".toList C99ProcedureParser.zero : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varLogn)) : Arg),
        (.scalar (.modular (.scalar (MakeFgInverseShape192.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgInverseShape192.varI)) : Arg)]
      (entry productOut (addr fs 0 0 1) igm p p0i)
    exact .pointer "a".toList "fs".toList MakeFgInverseShape192.varU (addr fs 0 0 1) _ _
      (stepStride (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p))) igm))
      aPointer bStride
  have entryA : (entry productOut (addr fs 0 0 1) igm p p0i).arrays "a".toList=some (addr fs 0 0 1) :=
    entry_a productOut (addr fs 0 0 1) igm p p0i
  have entryIgm : (entry productOut (addr fs 0 0 1) igm p p0i).arrays "igm".toList=some igm :=
    entry_igm productOut (addr fs 0 0 1) igm p p0i
  have entryLogn : Slot (entry productOut (addr fs 0 0 1) igm p p0i) "logn" 9 :=
    entry_logn productOut (addr fs 0 0 1) igm p p0i
  have entryFull : Slot (entry productOut (addr fs 0 0 1) igm p p0i) "full" 0 :=
    entry_full productOut (addr fs 0 0 1) igm p p0i
  have entryStride : USlot (entry productOut (addr fs 0 0 1) igm p p0i) "stride" 1 :=
    entry_stride productOut (addr fs 0 0 1) igm p p0i
  have entryP : Slot (entry productOut (addr fs 0 0 1) igm p p0i) "p" p :=
    entry_p productOut (addr fs 0 0 1) igm p p0i
  have entryI : Slot (entry productOut (addr fs 0 0 1) igm p p0i) "p0i" p0i :=
    entry_p0i productOut (addr fs 0 0 1) igm p p0i
  have fsWidth : (addr fs 0 0 1).elementBytes=4 := by decide
  have rawImage : ∀ k : Nat, k<512 →
      Load32 (entry productOut (addr fs 0 0 1) igm p p0i).heap
        (walk (addr fs 0 0 1) k 1) (SelectedStepProduct191.fvs k) := by
    intro k bound
    have read := fsImage ⟨k,bound⟩
    rw [walk_fs k]
    exact read
  have wholeImage : NttInverseMiddleU1Loop192.Image
      (entry productOut (addr fs 0 0 1) igm p p0i) (addr fs 0 0 1) 1
      (NttInverseMiddleRounds192.tOf 0) (NttInverseMiddleRounds192.htOf 0)
      (NttInverseMiddleRounds192.mOf 0) (NttInverseMiddleRounds192.roundTws tws 0) p p0i
      SelectedStepProduct191.fvs 0 :=
    NttInverseWholeBridges192.start_image (entry productOut (addr fs 0 0 1) igm p p0i)
      (addr fs 0 0 1) 1 tws p p0i SelectedStepProduct191.fvs rawImage
  obtain ⟨after3,wholeRun,wholeImage3,_,_,_,_,_,_,_,_,_,_⟩ :=
    NttInverseWhole192.source (entry productOut (addr fs 0 0 1) igm p p0i) (addr fs 0 0 1) igm 1
      p p0i tws SelectedStepProduct191.fvs entryLogn entryFull entryStride entryP entryI entryA
      entryIgm fsWidth fsCapacity igmCapacity fsWritable (by decide) (by decide) fsSeparate
      twSeparate twLoads wholeImage
  have bodyRun : C99ModularReference.Exec (KeygenLevelCalls.body .inverse)
      (entry productOut (addr fs 0 0 1) igm p p0i) ⟨after3,.normal⟩ := wholeRun
  have callRun : KeygenLevelCalls.Call .inverse productOut MakeFgInverseShape192.inverseArgs
      {productOut with heap := after3.heap} :=
    .run (entry productOut (addr fs 0 0 1) igm p p0i) ⟨after3,.normal⟩ binding bodyRun .voidEnd
  have levelRun : KeygenLevelExec.Exec (.call .inverse MakeFgInverseShape192.inverseArgs)
      productOut ⟨{productOut with heap := after3.heap},.normal⟩ :=
    .call _ _ _ _ callRun
  have inverseRun : KeygenMakeFgSource.Exec MakeFgInverseShape192.inverseCall productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ :=
    .level _ _ _ levelRun
  have terYesRun : KeygenMakeFgSource.Exec MakeFgInverseShape192.terYes productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgInverseShape192.terYes_shape]
    exact .scope [] [] (.seq MakeFgInverseShape192.inverseCall skip) productOut
      ⟨{productOut with heap := after3.heap},.normal⟩
      (.seqNormal _ _ productOut {productOut with heap := after3.heap}
        ⟨{productOut with heap := after3.heap},.normal⟩ inverseRun
        (.level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _)))))
  have terRun : KeygenMakeFgSource.Exec MakeFgInverseShape192.terBranch productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgInverseShape192.terBranch_shape]
    refine .branchTrue _ _ _ productOut ⟨{productOut with heap := after3.heap},.normal⟩
      (.uint32 1) ?_ (by decide) terYesRun
    exact .variable _ _ _ terCell
  have innerRun : KeygenMakeFgSource.Exec MakeFgInverseShape192.inner productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgInverseShape192.inner_shape]
    exact .seqNormal _ _ productOut {productOut with heap := after3.heap}
      ⟨{productOut with heap := after3.heap},.normal⟩ terRun
      (.level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _))))
  have s3YesRun : KeygenMakeFgSource.Exec MakeFgTailShape190.s3Yes productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgInverseShape192.s3Yes_shape]
    exact .scope [] [] MakeFgInverseShape192.inner productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ innerRun
  have s3Run : KeygenMakeFgSource.Exec MakeFgTailShape190.s3 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgTailShape190.s3_shape]
    refine .branchTrue _ _ _ productOut ⟨{productOut with heap := after3.heap},.normal⟩
      (.int32 1) ?_ (by decide) s3YesRun
    exact .variable _ _ _ inNttCell
  refine ⟨{productOut with heap := after3.heap},s3Run,?_,?_,?_⟩
  · intro i
    have read := (wholeImage3 i.val i.isLt).1 (by omega)
    rw [← walk_fs i.val]
    exact read
  · intro name different
    exact (localsKeep name different)
  · intro name different
    exact (arraysKeep name different)

end FT1536.Source3.SelectedStepInverse192
