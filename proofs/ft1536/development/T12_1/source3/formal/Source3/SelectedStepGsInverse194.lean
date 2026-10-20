import Source3.SelectedStepInverse192
import Source3.MakeFgGsShape194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The active inverse-call branch s7 of the make_fg_step first-prime gs
   path at the gd-product output: the KeygenLevelCalls.Bind of the
   original gs call arguments (gs at the u = 0 cell, the slen = 1 stride
   cell, igm at the parser zero index, the logn = 9 cell, the original
   zero literal for full, the p/p0i slots), the modp_iNTT3_ext body
   execution through the closed KeygenLevelNtt.inverse composition
   (NttInverseWhole192 at stride 1), and the s7 branch composition to the
   stage statement `KeygenMakeFgSource.Exec MakeFgTailShape190.s7
   productOut out`. The generic entry/Bind helpers of
   SelectedStepInverse192 are reused with the gs instance bound to the
   name "gs" and `addr gs 0 0 1`. The exported image records the
   transformed gs words as the executed modp_add/modp_sub/modp_montymul/
   modp_R/modp_div word terms (NttInverseWholeBridges192.scaledWord) over
   the gs source image, with the caller locals/arrays frame outside v/x.
   No transform property or numerical claim. -/
namespace FT1536.Source3.SelectedStepGsInverse194
open C99ArrayReference (State Name Pointer)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec skip)
open KeygenLevelCalls (Arg)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open SelectedStepLayout187 (gs)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges192 (scaledWord)
open SelectedStepInverse192 (raw stepP0i stepP stepFull stepLogn stepIgm stepStride stepA entry)

theorem walk_gs (k : Nat) : walk (addr gs 0 0 1) k 1=elem gs k := by
  have key : gs.index+0+0*1+0+k*1=gs.index+k := by omega
  exact congrArg (fun n : Nat => {gs with index := n}) key

theorem source (productOut : State) (p p0i : BitVec 32) (gvs tws : Nat → BitVec 32)
    (uCell : Cell productOut "u".toList 0) (slenCell : USlot productOut "slen" 1)
    (lognCell : Slot productOut "logn" 9) (terCell : Slot productOut "ter" 1)
    (inNttCell : productOut.locals "in_ntt".toList=some (.int32,some (.int32 1)))
    (pc : Slot productOut "p" p) (ic : Slot productOut "p0i" p0i)
    (gsBinding : productOut.arrays "gs".toList=some gs)
    (igmBinding : productOut.arrays "igm".toList=some SelectedStepLayout187.igm)
    (gsWritable : productOut.heap.writable gs.block=true)
    (gsCapacity : (addr gs 0 0 1).index + 512 ≤ (addr gs 0 0 1).count)
    (igmCapacity : SelectedStepLayout187.igm.index + 512 ≤ SelectedStepLayout187.igm.count)
    (gsSeparate : ∀ j k : Nat, j<512 → k<512 → j≠k →
      Separate (walk (addr gs 0 0 1) j 1) (walk (addr gs 0 0 1) k 1))
    (twSeparate : ∀ k : Nat, k<512 → ∀ j : Nat, j<512 →
      Separate (walk (addr gs 0 0 1) j 1)
        ({SelectedStepLayout187.igm with index := SelectedStepLayout187.igm.index+k}))
    (twLoads : ∀ k : Nat, k<512 →
      Load32 productOut.heap ({SelectedStepLayout187.igm with index :=
        SelectedStepLayout187.igm.index+k}) (tws k))
    (gsImage : ∀ i : Fin 512, Load32 productOut.heap (elem gs i.val) (gvs i.val))
    (localsKeep : ∀ name : Name, name≠"v".toList →
      productOut.locals name=SelectedStepProduct191.base.locals name)
    (arraysKeep : ∀ name : Name, name≠"x".toList →
      productOut.arrays name=SelectedStepProduct191.base.arrays name) :
    ∃ after, Exec MakeFgTailShape190.s7 productOut ⟨after,.normal⟩ ∧
      (∀ i : Fin 512, Load32 after.heap (elem gs i.val)
        (scaledWord gvs tws p p0i i.val)) ∧
      (∀ name : Name, name≠"v".toList → after.locals name=SelectedStepProduct191.base.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=SelectedStepProduct191.base.arrays name) := by
  have aPointer : Pointer productOut "gs".toList MakeFgGsShape194.varU (addr gs 0 0 1) :=
    .add "gs".toList MakeFgGsShape194.varU gs (addr gs 0 0 1)
      (.uint64 (C99NatWord141.word 0)) gsBinding
      (C99LoopScalar141.read productOut "u".toList 0 uCell) (by decide)
      (C99MemoryReference.PointerAdd.within gs 0 (by decide))
  have igmPointer : Pointer productOut "igm".toList C99ProcedureParser.zero
      SelectedStepLayout187.igm :=
    StepCopyBody190.zero_pointer productOut "igm".toList SelectedStepLayout187.igm igmBinding (by
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
      (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p)))
        SelectedStepLayout187.igm) :=
    .pointer "igm".toList "igm".toList C99ProcedureParser.zero SelectedStepLayout187.igm _ _
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
        SelectedStepLayout187.igm)) :=
    .scalar .uint64 "stride".toList (.modular (.scalar MakeFgGsShape194.varSlen)) _ _
      (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p)))
        SelectedStepLayout187.igm)
      (.uint64 (C99NatWord141.word 1)) evalSlen bIgm
  have binding : KeygenLevelCalls.Bind productOut (KeygenLevelCalls.params .inverse)
      MakeFgGsShape194.inverseArgsGs (entry productOut (addr gs 0 0 1)
        SelectedStepLayout187.igm p p0i) := by
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
      (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i)
    exact .pointer "a".toList "gs".toList MakeFgGsShape194.varU (addr gs 0 0 1) _ _
      (stepStride (stepIgm (stepLogn (stepFull (stepP (stepP0i (raw productOut) p0i) p)))
        SelectedStepLayout187.igm))
      aPointer bStride
  have entryA : (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i).arrays
      "a".toList=some (addr gs 0 0 1) :=
    SelectedStepInverse192.entry_a productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i
  have entryIgm : (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i).arrays
      "igm".toList=some SelectedStepLayout187.igm :=
    SelectedStepInverse192.entry_igm productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i
  have entryLogn : Slot (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i)
      "logn" 9 :=
    SelectedStepInverse192.entry_logn productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i
  have entryFull : Slot (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i)
      "full" 0 :=
    SelectedStepInverse192.entry_full productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i
  have entryStride : USlot (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i)
      "stride" 1 :=
    SelectedStepInverse192.entry_stride productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i
  have entryP : Slot (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i) "p" p :=
    SelectedStepInverse192.entry_p productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i
  have entryI : Slot (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i)
      "p0i" p0i :=
    SelectedStepInverse192.entry_p0i productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i
  have gsWidth : (addr gs 0 0 1).elementBytes=4 := by decide
  have rawImage : ∀ k : Nat, k<512 →
      Load32 (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i).heap
        (walk (addr gs 0 0 1) k 1) (gvs k) := by
    intro k bound
    have read := gsImage ⟨k,bound⟩
    rw [walk_gs k]
    exact read
  have wholeImage : NttInverseMiddleU1Loop192.Image
      (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i) (addr gs 0 0 1) 1
      (NttInverseMiddleRounds192.tOf 0) (NttInverseMiddleRounds192.htOf 0)
      (NttInverseMiddleRounds192.mOf 0) (NttInverseMiddleRounds192.roundTws tws 0) p p0i
      gvs 0 :=
    NttInverseWholeBridges192.start_image
      (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i)
      (addr gs 0 0 1) 1 tws p p0i gvs rawImage
  obtain ⟨after3,wholeRun,wholeImage3,_,_,_,_,_,_,_,_,_,_⟩ :=
    NttInverseWhole192.source (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i)
      (addr gs 0 0 1) SelectedStepLayout187.igm 1
      p p0i tws gvs entryLogn entryFull entryStride entryP entryI entryA
      entryIgm gsWidth gsCapacity igmCapacity gsWritable (by decide) (by decide) gsSeparate
      twSeparate twLoads wholeImage
  have bodyRun : C99ModularReference.Exec (KeygenLevelCalls.body .inverse)
      (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i) ⟨after3,.normal⟩ :=
    wholeRun
  have callRun : KeygenLevelCalls.Call .inverse productOut MakeFgGsShape194.inverseArgsGs
      {productOut with heap := after3.heap} :=
    .run (entry productOut (addr gs 0 0 1) SelectedStepLayout187.igm p p0i) ⟨after3,.normal⟩
      binding bodyRun .voidEnd
  have levelRun : KeygenLevelExec.Exec (.call .inverse MakeFgGsShape194.inverseArgsGs)
      productOut ⟨{productOut with heap := after3.heap},.normal⟩ :=
    .call _ _ _ _ callRun
  have inverseRun : Exec MakeFgGsShape194.inverseCallGs productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ :=
    .level _ _ _ levelRun
  have terYesRun : Exec MakeFgGsShape194.terYes7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.terYes7_shape]
    exact .scope [] [] (.seq MakeFgGsShape194.inverseCallGs skip) productOut
      ⟨{productOut with heap := after3.heap},.normal⟩
      (.seqNormal _ _ productOut {productOut with heap := after3.heap}
        ⟨{productOut with heap := after3.heap},.normal⟩ inverseRun
        (.level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _)))))
  have terRun : Exec MakeFgGsShape194.terBranch7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.terBranch7_shape]
    refine .branchTrue _ _ _ productOut ⟨{productOut with heap := after3.heap},.normal⟩
      (.uint32 1) ?_ (by decide) terYesRun
    exact .variable _ _ _ terCell
  have innerRun : Exec MakeFgGsShape194.inner7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.inner7_shape]
    exact .seqNormal _ _ productOut {productOut with heap := after3.heap}
      ⟨{productOut with heap := after3.heap},.normal⟩ terRun
      (.level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _))))
  have s7YesRun : Exec MakeFgGsShape194.s7Yes productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.s7Yes_shape]
    exact .scope [] [] MakeFgGsShape194.inner7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ innerRun
  have s7Run : Exec MakeFgTailShape190.s7 productOut
      ⟨{productOut with heap := after3.heap},.normal⟩ := by
    rw [MakeFgGsShape194.s7_shape]
    refine .branchTrue _ _ _ productOut ⟨{productOut with heap := after3.heap},.normal⟩
      (.int32 1) ?_ (by decide) s7YesRun
    exact .variable _ _ _ inNttCell
  refine ⟨{productOut with heap := after3.heap},s7Run,?_,?_,?_⟩
  · intro i
    have read := (wholeImage3 i.val i.isLt).1 (by omega)
    rw [← walk_gs i.val]
    exact read
  · intro name different
    exact (localsKeep name different)
  · intro name different
    exact (arraysKeep name different)

end FT1536.Source3.SelectedStepGsInverse194
