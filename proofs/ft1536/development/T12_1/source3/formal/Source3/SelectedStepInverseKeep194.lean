import Source3.SelectedStepGsInverse194
import Source3.NttInverseWholeKeep194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Keep-threaded re-proof of the two modp_iNTT3_ext call statements of
   the make_fg_step tail: the fs instance s3 (the sealed
   SelectedStepInverse192.source statement) and the gs instance s7 (the
   sealed SelectedStepGsInverse194.source statement). The generic
   entry/Bind helpers of SelectedStepInverse192 are reused unchanged and
   the body is run through the whole-inverse bystander keep
   (NttInverseWholeKeep194.source) instead of the sealed
   NttInverseWhole192.source. The call result is the caller state with
   the body heap, so the per-cell keep and the writable transport lift
   through the call wrapper directly: every load from a cell separate
   from the walked call region survives the whole call statement. Values
   stay executed words: no transform property, table law, root law or
   positivity claim. -/
namespace FT1536.Source3.SelectedStepInverseKeep194
open C99ArrayReference (State Name Pointer)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec skip)
open KeygenLevelCalls (Arg)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open SelectedStepLayout187 (fs gs igm)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges192 (scaledWord)
open SelectedStepInverse192 (raw stepP0i stepP stepFull stepLogn stepIgm stepStride stepA entry
  entry_a entry_igm entry_logn entry_full entry_stride entry_p entry_p0i walk_fs)
open SelectedStepGsInverse194 (walk_gs)

theorem fs_heap (productOut : State) (p p0i : BitVec 32) :
    (entry productOut (addr fs 0 0 1) igm p p0i).heap=productOut.heap :=
  rfl

theorem gs_heap (productOut : State) (p p0i : BitVec 32) :
    (entry productOut (addr gs 0 0 1) igm p p0i).heap=productOut.heap :=
  rfl

theorem fs_source (productOut : State) (p p0i : BitVec 32) (tws : Nat → BitVec 32)
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
    (twLoads : ∀ k : Nat, k<512 →
      Load32 productOut.heap ({igm with index := igm.index+k}) (tws k))
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
      (∀ name : Name, name≠"x".toList → after.arrays name=SelectedStepProduct191.base.arrays name) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x<512 → Separate (walk (addr fs 0 0 1) x 1) q) →
        ∀ z : BitVec 32, Load32 productOut.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=productOut.heap.writable := by
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
      (stepStride (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p)))
        igm)) :=
    .scalar .uint64 "stride".toList (.modular (.scalar MakeFgInverseShape192.varSlen)) _ _
      (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p)))
        igm)
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
      (stepStride (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p)))
        igm))
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
  obtain ⟨after3,wholeRun,wholeImage3,_,_,_,_,_,_,_,_,_,_,wholeKeep,wholeWritable⟩ :=
    NttInverseWholeKeep194.source (entry productOut (addr fs 0 0 1) igm p p0i)
      (addr fs 0 0 1) igm 1
      p p0i tws SelectedStepProduct191.fvs entryLogn entryFull entryStride entryP entryI entryA
      entryIgm fsWidth fsCapacity igmCapacity fsWritable (by decide) (by decide) fsSeparate
      twSeparate twLoads wholeImage
  have bodyRun : C99ModularReference.Exec (KeygenLevelCalls.body .inverse)
      (entry productOut (addr fs 0 0 1) igm p p0i) ⟨after3,.normal⟩ :=
    wholeRun
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
  refine ⟨{productOut with heap := after3.heap},s3Run,?_,?_,?_,?_,?_⟩
  · intro i
    have read := (wholeImage3 i.val i.isLt).1 (by omega)
    rw [← walk_fs i.val]
    exact read
  · intro name different
    exact (localsKeep name different)
  · intro name different
    exact (arraysKeep name different)
  · intro q separate z load
    have entryLoad : Load32 (entry productOut (addr fs 0 0 1) igm p p0i).heap q z := load
    exact wholeKeep q separate z entryLoad
  · exact wholeWritable.trans rfl

theorem gs_source (productOut : State) (p p0i : BitVec 32) (gvs tws : Nat → BitVec 32)
    (uCell : Cell productOut "u".toList 0) (slenCell : USlot productOut "slen" 1)
    (lognCell : Slot productOut "logn" 9) (terCell : Slot productOut "ter" 1)
    (inNttCell : productOut.locals "in_ntt".toList=some (.int32,some (.int32 1)))
    (pc : Slot productOut "p" p) (ic : Slot productOut "p0i" p0i)
    (gsBinding : productOut.arrays "gs".toList=some gs)
    (igmBinding : productOut.arrays "igm".toList=some igm)
    (gsWritable : productOut.heap.writable gs.block=true)
    (gsCapacity : (addr gs 0 0 1).index + 512 ≤ (addr gs 0 0 1).count)
    (igmCapacity : igm.index + 512 ≤ igm.count)
    (gsSeparate : ∀ j k : Nat, j<512 → k<512 → j≠k →
      Separate (walk (addr gs 0 0 1) j 1) (walk (addr gs 0 0 1) k 1))
    (twSeparate : ∀ k : Nat, k<512 → ∀ j : Nat, j<512 →
      Separate (walk (addr gs 0 0 1) j 1) ({igm with index := igm.index+k}))
    (twLoads : ∀ k : Nat, k<512 →
      Load32 productOut.heap ({igm with index := igm.index+k}) (tws k))
    (gsImage : ∀ i : Fin 512, Load32 productOut.heap (elem gs i.val) (gvs i.val))
    (localsKeep : ∀ name : Name, name≠"v".toList →
      productOut.locals name=SelectedStepProduct191.base.locals name)
    (arraysKeep : ∀ name : Name, name≠"x".toList →
      productOut.arrays name=SelectedStepProduct191.base.arrays name) :
    ∃ after, KeygenMakeFgSource.Exec MakeFgTailShape190.s7 productOut ⟨after,.normal⟩ ∧
      (∀ i : Fin 512, Load32 after.heap (elem gs i.val)
        (scaledWord gvs tws p p0i i.val)) ∧
      (∀ name : Name, name≠"v".toList → after.locals name=SelectedStepProduct191.base.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=SelectedStepProduct191.base.arrays name) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x<512 → Separate (walk (addr gs 0 0 1) x 1) q) →
        ∀ z : BitVec 32, Load32 productOut.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=productOut.heap.writable := by
  have aPointer : Pointer productOut "gs".toList MakeFgGsShape194.varU (addr gs 0 0 1) :=
    .add "gs".toList MakeFgGsShape194.varU gs (addr gs 0 0 1)
      (.uint64 (C99NatWord141.word 0)) gsBinding
      (C99LoopScalar141.read productOut "u".toList 0 uCell) (by decide)
      (C99MemoryReference.PointerAdd.within gs 0 (by decide))
  have igmPointer : Pointer productOut "igm".toList C99ProcedureParser.zero igm :=
    StepCopyBody190.zero_pointer productOut "igm".toList igm igmBinding (by
      have step := igmCapacity
      omega)
  have evalSlen : KeygenLevelCalls.Eval productOut
      (.modular (.scalar MakeFgGsShape194.varSlen)) (.uint64 (C99NatWord141.word 1)) :=
    .modular _ _ (.scalar _ _ (.variable _ _ _ slenCell))
  have evalLogn : KeygenLevelCalls.Eval productOut
      (.modular (.scalar MakeFgGsShape194.varLogn)) (.uint32 9) :=
    .modular _ _ (.scalar _ _ (.variable _ _ _ lognCell))
  have evalFull : KeygenLevelCalls.Eval productOut
      (.modular (.scalar (MakeFgGsShape194.num 0))) (.int32 0) :=
    .modular _ _ (.scalar _ _ (.literal .int32 0))
  have evalP : KeygenLevelCalls.Eval productOut
      (.modular (.scalar MakeFgGsShape194.varP)) (.uint32 p) :=
    .modular _ _ (.scalar _ _ (.variable _ _ _ pc))
  have evalI : KeygenLevelCalls.Eval productOut
      (.modular (.scalar MakeFgGsShape194.varI)) (.uint32 p0i) :=
    .modular _ _ (.scalar _ _ (.variable _ _ _ ic))
  have bNil : KeygenLevelCalls.Bind productOut [] [] (raw productOut) := .nil
  have bP0i : KeygenLevelCalls.Bind productOut
      [(.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.scalar (.modular (.scalar MakeFgGsShape194.varI)) : Arg)]
      (stepP0i (raw productOut) p0i) :=
    .scalar .uint32 "p0i".toList (.modular (.scalar MakeFgGsShape194.varI)) [] []
      (raw productOut) (.uint32 p0i) evalI bNil
  have bP : KeygenLevelCalls.Bind productOut
      [(.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.scalar (.modular (.scalar MakeFgGsShape194.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varI)) : Arg)]
      (stepP (stepP0i (raw productOut) p0i) p) :=
    .scalar .uint32 "p".toList (.modular (.scalar MakeFgGsShape194.varP)) _ _
      (stepP0i (raw productOut) p0i) (.uint32 p) evalP bP0i
  have bFull : KeygenLevelCalls.Bind productOut
      [(.scalar .uint32 "full".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.scalar (.modular (.scalar (MakeFgGsShape194.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varI)) : Arg)]
      (stepFull (stepP (stepP0i (raw productOut) p0i) p)) :=
    .scalar .uint32 "full".toList (.modular (.scalar (MakeFgGsShape194.num 0))) _ _
      (stepP (stepP0i (raw productOut) p0i) p) (.int32 0) evalFull bP
  have bLogn : KeygenLevelCalls.Bind productOut
      [(.scalar .uint32 "logn".toList : C99ArrayReference.Param),
        (.scalar .uint32 "full".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.scalar (.modular (.scalar MakeFgGsShape194.varLogn)) : Arg),
        (.scalar (.modular (.scalar (MakeFgGsShape194.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varI)) : Arg)]
      (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p))) :=
    .scalar .uint32 "logn".toList (.modular (.scalar MakeFgGsShape194.varLogn)) _ _
      (stepFull (stepP (stepP0i (raw productOut) p0i) p)) (.uint32 9) evalLogn bFull
  have bIgm : KeygenLevelCalls.Bind productOut
      [(.pointer "igm".toList : C99ArrayReference.Param),
        (.scalar .uint32 "logn".toList : C99ArrayReference.Param),
        (.scalar .uint32 "full".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.pointer "igm".toList C99ProcedureParser.zero : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varLogn)) : Arg),
        (.scalar (.modular (.scalar (MakeFgGsShape194.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varI)) : Arg)]
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
      [(.scalar (.modular (.scalar MakeFgGsShape194.varSlen)) : Arg),
        (.pointer "igm".toList C99ProcedureParser.zero : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varLogn)) : Arg),
        (.scalar (.modular (.scalar (MakeFgGsShape194.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varI)) : Arg)]
      (stepStride (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p)))
        igm)) :=
    .scalar .uint64 "stride".toList (.modular (.scalar MakeFgGsShape194.varSlen)) _ _
      (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p)))
        igm)
      (.uint64 (C99NatWord141.word 1)) evalSlen bIgm
  have binding : KeygenLevelCalls.Bind productOut (KeygenLevelCalls.params .inverse)
      MakeFgGsShape194.inverseArgsGs (entry productOut (addr gs 0 0 1) igm p p0i) := by
    show KeygenLevelCalls.Bind productOut
      [(.pointer "a".toList : C99ArrayReference.Param),
        (.scalar .uint64 "stride".toList : C99ArrayReference.Param),
        (.pointer "igm".toList : C99ArrayReference.Param),
        (.scalar .uint32 "logn".toList : C99ArrayReference.Param),
        (.scalar .uint32 "full".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p".toList : C99ArrayReference.Param),
        (.scalar .uint32 "p0i".toList : C99ArrayReference.Param)]
      [(.pointer "gs".toList MakeFgGsShape194.varU : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varSlen)) : Arg),
        (.pointer "igm".toList C99ProcedureParser.zero : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varLogn)) : Arg),
        (.scalar (.modular (.scalar (MakeFgGsShape194.num 0))) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varP)) : Arg),
        (.scalar (.modular (.scalar MakeFgGsShape194.varI)) : Arg)]
      (entry productOut (addr gs 0 0 1) igm p p0i)
    exact .pointer "a".toList "gs".toList MakeFgGsShape194.varU (addr gs 0 0 1) _ _
      (stepStride (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p)))
        igm))
      aPointer bStride
  have entryA : (entry productOut (addr gs 0 0 1) igm p p0i).arrays "a".toList=some (addr gs 0 0 1) :=
    entry_a productOut (addr gs 0 0 1) igm p p0i
  have entryIgm : (entry productOut (addr gs 0 0 1) igm p p0i).arrays "igm".toList=some igm :=
    entry_igm productOut (addr gs 0 0 1) igm p p0i
  have entryLogn : Slot (entry productOut (addr gs 0 0 1) igm p p0i) "logn" 9 :=
    entry_logn productOut (addr gs 0 0 1) igm p p0i
  have entryFull : Slot (entry productOut (addr gs 0 0 1) igm p p0i) "full" 0 :=
    entry_full productOut (addr gs 0 0 1) igm p p0i
  have entryStride : USlot (entry productOut (addr gs 0 0 1) igm p p0i) "stride" 1 :=
    entry_stride productOut (addr gs 0 0 1) igm p p0i
  have entryP : Slot (entry productOut (addr gs 0 0 1) igm p p0i) "p" p :=
    entry_p productOut (addr gs 0 0 1) igm p p0i
  have entryI : Slot (entry productOut (addr gs 0 0 1) igm p p0i) "p0i" p0i :=
    entry_p0i productOut (addr gs 0 0 1) igm p p0i
  have gsWidth : (addr gs 0 0 1).elementBytes=4 := by decide
  have rawImage : ∀ k : Nat, k<512 →
      Load32 (entry productOut (addr gs 0 0 1) igm p p0i).heap
        (walk (addr gs 0 0 1) k 1) (gvs k) := by
    intro k bound
    have read := gsImage ⟨k,bound⟩
    rw [walk_gs k]
    exact read
  have wholeImage : NttInverseMiddleU1Loop192.Image
      (entry productOut (addr gs 0 0 1) igm p p0i) (addr gs 0 0 1) 1
      (NttInverseMiddleRounds192.tOf 0) (NttInverseMiddleRounds192.htOf 0)
      (NttInverseMiddleRounds192.mOf 0) (NttInverseMiddleRounds192.roundTws tws 0) p p0i gvs 0 :=
    NttInverseWholeBridges192.start_image (entry productOut (addr gs 0 0 1) igm p p0i)
      (addr gs 0 0 1) 1 tws p p0i gvs rawImage
  obtain ⟨after3,wholeRun,wholeImage3,_,_,_,_,_,_,_,_,_,_,wholeKeep,wholeWritable⟩ :=
    NttInverseWholeKeep194.source (entry productOut (addr gs 0 0 1) igm p p0i)
      (addr gs 0 0 1) igm 1
      p p0i tws gvs entryLogn entryFull entryStride entryP entryI entryA
      entryIgm gsWidth gsCapacity igmCapacity gsWritable (by decide) (by decide) gsSeparate
      twSeparate twLoads wholeImage
  have bodyRun : C99ModularReference.Exec (KeygenLevelCalls.body .inverse)
      (entry productOut (addr gs 0 0 1) igm p p0i) ⟨after3,.normal⟩ :=
    wholeRun
  have callRun : KeygenLevelCalls.Call .inverse productOut MakeFgGsShape194.inverseArgsGs
      {productOut with heap := after3.heap} :=
    .run (entry productOut (addr gs 0 0 1) igm p p0i) ⟨after3,.normal⟩ binding bodyRun .voidEnd
  have levelRun : KeygenLevelExec.Exec (.call .inverse MakeFgGsShape194.inverseArgsGs)
      productOut ⟨{productOut with heap := after3.heap},.normal⟩ :=
    .call _ _ _ _ callRun
  have inverseRun : KeygenMakeFgSource.Exec MakeFgGsShape194.inverseCallGs productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ :=
    .level _ _ _ levelRun
  have terYesRun : KeygenMakeFgSource.Exec MakeFgGsShape194.terYes7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.terYes7_shape]
    exact .scope [] [] (.seq MakeFgGsShape194.inverseCallGs skip) productOut
      ⟨{productOut with heap := after3.heap},.normal⟩
      (.seqNormal _ _ productOut {productOut with heap := after3.heap}
        ⟨{productOut with heap := after3.heap},.normal⟩ inverseRun
        (.level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _)))))
  have terRun : KeygenMakeFgSource.Exec MakeFgGsShape194.terBranch7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.terBranch7_shape]
    refine .branchTrue _ _ _ productOut ⟨{productOut with heap := after3.heap},.normal⟩
      (.uint32 1) ?_ (by decide) terYesRun
    exact .variable _ _ _ terCell
  have innerRun : KeygenMakeFgSource.Exec MakeFgGsShape194.inner7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.inner7_shape]
    exact .seqNormal _ _ productOut {productOut with heap := after3.heap}
      ⟨{productOut with heap := after3.heap},.normal⟩ terRun
      (.level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _))))
  have s7YesRun : KeygenMakeFgSource.Exec MakeFgGsShape194.s7Yes productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.s7Yes_shape]
    exact .scope [] [] MakeFgGsShape194.inner7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ innerRun
  have s7Run : KeygenMakeFgSource.Exec MakeFgTailShape190.s7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.s7_shape]
    refine .branchTrue _ _ _ productOut ⟨{productOut with heap := after3.heap},.normal⟩
      (.int32 1) ?_ (by decide) s7YesRun
    exact .variable _ _ _ inNttCell
  refine ⟨{productOut with heap := after3.heap},s7Run,?_,?_,?_,?_,?_⟩
  · intro i
    have read := (wholeImage3 i.val i.isLt).1 (by omega)
    rw [← walk_gs i.val]
    exact read
  · intro name different
    exact (localsKeep name different)
  · intro name different
    exact (arraysKeep name different)
  · intro q separate z load
    have entryLoad : Load32 (entry productOut (addr gs 0 0 1) igm p p0i).heap q z := load
    exact wholeKeep q separate z entryLoad
  · exact wholeWritable.trans rfl

end FT1536.Source3.SelectedStepInverseKeep194
