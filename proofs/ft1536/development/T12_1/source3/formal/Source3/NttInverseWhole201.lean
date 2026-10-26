import Source3.NttInverseCorrectionInit201
import Source3.NttInverseWholeBridges201
import Source3.NttInverseWhole192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseWhole201
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open MkgmParams198 (Level half lognWord)
open NttInverseSchedule201 (size)
open NttInverseCorrectionLoop192 (walk Image)
open NttInverseCorrection201 (niWord setNi)
open NttInverseWholeBridges201 (fvLast finalWord)
open NttInverseWhole192 (final_started_keep corr_started_keep)

theorem source (l : Level) (s : State) (a igm : ArrayPointer) (stride : Nat) (p p0i : BitVec 32)
    (tws : Nat → BitVec 32) (fv0 : Nat → BitVec 32)
    (logn : Slot s "logn" (lognWord l)) (full : Slot s "full" 0)
    (strideCell : USlot s "stride" stride) (pc : Slot s "p" p) (ic : Slot s "p0i" p0i)
    (aBinding : s.arrays "a".toList=some a) (igmBinding : s.arrays "igm".toList=some igm)
    (aWidth : a.elementBytes=4) (aCapacity : a.index + (size l)*stride ≤ a.count)
    (igmCapacity : igm.index + (size l) ≤ igm.count) (aWritable : s.heap.writable a.block=true)
    (strideBound : stride<2^64) (wide : (size l)*stride < 2^64)
    (separate : ∀ j k : Nat, j<(size l) → k<(size l) → j≠k → Separate (walk a j stride) (walk a k stride))
    (twSeparate : ∀ k : Nat, k<(size l) → ∀ j : Nat, j<(size l) →
      Separate (walk a j stride) ({igm with index := igm.index+k}))
    (twLoads : ∀ k : Nat, k<(size l) → Load32 s.heap ({igm with index := igm.index+k}) (tws k))
    (image : NttInverseMiddleU1Loop192.Image s a stride
      (NttInverseMiddleRounds192.tOf 0) (NttInverseMiddleRounds192.htOf 0)
      (NttInverseSchedule201.mOf l 0) (NttInverseSchedule201.roundTws l tws 0) p p0i fv0 0) :
    ∃ after, Exec KeygenLevelNtt.inverse s ⟨after,.normal⟩ ∧
      Image after a stride (size l) p p0i (niWord l p p0i) (finalWord l fv0 tws p p0i) (size l) ∧
      Cell after "u".toList (size l) ∧
      after.arrays "r1".toList=some (walk a (size l) stride) ∧
      after.arrays "a".toList=some a ∧ after.arrays "igm".toList=some igm ∧
      USlot after "n" (size l) ∧ USlot after "stride" stride ∧
      Slot after "p" p ∧ Slot after "p0i" p0i ∧ Slot after "ni" (niWord l p p0i) ∧
      after.heap.writable a.block=true := by
  have hRange:=MkgmParams198.half_range l
  have sizeHalf : size l=2*half l := rfl
  have lowSize : half l ≤ size l := by omega
  have lowProduct : half l*stride ≤ size l*stride := Nat.mul_le_mul_right stride lowSize
  have sizeRun : Exec NttInversePrograms192.sizeCode s
      ⟨NttInversePrologue192.afterSize s,.normal⟩ :=
    NttInversePrologue192.size_run s
  have mixedRun : Exec NttInversePrograms192.mixedCode (NttInversePrologue192.afterSize s)
      ⟨NttInversePrologue192.afterMixed s,.normal⟩ :=
    NttInversePrologue192.mixed_run s
  have guardRun : Exec NttInversePrograms192.guardPart (NttInversePrologue192.afterMixed s)
      ⟨NttInversePrologue201.ready l s,.normal⟩ :=
    NttInversePrologue201.guard_run l s logn full
  have lognReady : Slot (NttInversePrologue201.ready l s) "logn" (lognWord l) :=
    (NttInversePrologue201.locals_outside l s "logn".toList (by decide)).trans logn
  have fullReady : Slot (NttInversePrologue201.ready l s) "full" 0 :=
    (NttInversePrologue201.locals_outside l s "full".toList (by decide)).trans full
  have tripleRun : Exec NttInversePrograms192.triplePass (NttInversePrologue201.ready l s)
      ⟨NttInversePrologue201.ready l s,.normal⟩ :=
    NttInverseTriple192.source (NttInversePrologue201.ready l s) fullReady
  have fixedReady : NttInverseSchedule201.Fixed l (NttInversePrologue201.ready l s)
      a igm stride p p0i tws := {
    strideBound := strideBound
    wide := wide
    aWidth := aWidth
    aCapacity := aCapacity
    aWritable := aWritable
    igmCapacity := igmCapacity
    nCell := NttInversePrologue201.ready_n l s
    strideCell := NttInversePrologue201.uslot_keep l s "stride" stride (by decide) strideCell
    pCell := NttInversePrologue201.slot_keep l s "p" p (by decide) pc
    iCell := NttInversePrologue201.slot_keep l s "p0i" p0i (by decide) ic
    aBinding := (NttInversePrologue201.arrays_outside l s "a".toList (by decide) (by decide)).trans
      aBinding
    igmBinding := (NttInversePrologue201.arrays_outside l s "igm".toList (by decide)
      (by decide)).trans igmBinding
    separate := separate
    twSeparate := twSeparate
    twLoads := twLoads }
  obtain ⟨after1,midRun,midFixed,_,_,midImage,_,_⟩ :=
    NttInverseLoop201.source l none none (NttInversePrologue201.ready l s) a igm stride p p0i
      tws fv0 lognReady fullReady
      (NttInversePrologue201.t_declared l s) (NttInversePrologue201.m_declared l s) fixedReady image
  have midFrame := NttInverseFrame192.frame NttInversePrograms192.intermediatePass
    (NttInversePrologue201.ready l s) ⟨after1,.normal⟩ (by decide) midRun
  have hnAfter : USlot after1 "hn" (half l) :=
    (midFrame.1 "hn".toList (by decide)).trans (NttInversePrologue201.ready_hn l s)
  have wAfter : after1.locals "w".toList=some (.uint32,none) :=
    (midFrame.1 "w".toList (by decide)).trans (NttInversePrologue201.w_declared l s)
  have uAfter : after1.locals "u".toList=some (.uint64,none) :=
    (midFrame.1 "u".toList (by decide)).trans (NttInversePrologue201.u_declared l s)
  have rAfter : after1.locals "R".toList=some (.uint32,none) :=
    (midFrame.1 "R".toList (by decide)).trans (NttInversePrologue201.R_declared l s)
  have niAfter : after1.locals "ni".toList=some (.uint32,none) :=
    (midFrame.1 "ni".toList (by decide)).trans (NttInversePrologue201.ni_declared l s)
  have raw8 : ∀ k : Nat, k<(size l) → Load32 after1.heap (walk a k stride) (fvLast l fv0 tws p p0i k) :=
    NttInverseWholeBridges201.round_raw l after1 a stride tws p p0i fv0 midImage
  have wRead : Load32 after1.heap igm (tws 0) :=
    midFixed.twLoads 0 (by omega)
  have capacity : a.index ≤ a.count := by
    have step := midFixed.aCapacity
    omega
  have capacity256 : a.index + (half l)*stride ≤ a.count := by
    have step := midFixed.aCapacity
    omega
  have wide256 : (half l)*stride<2^64 :=
    Nat.lt_of_le_of_lt (Nat.mul_le_mul_right stride (by omega : (half l)≤(size l))) wide
  have igmSmall : igm.index ≤ igm.count := by
    have step := midFixed.igmCapacity
    omega
  have startedHn : USlot (NttInverseFinalPass192.started after1 (tws 0) a stride (half l)) "hn" (half l) :=
    (final_started_keep after1 (tws 0) a stride (half l) "hn".toList (by decide)).trans
      (NttInverseFinalPass192.setW_keep after1 (tws 0) "hn" (half l) (by decide) hnAfter)
  have startedStride : USlot (NttInverseFinalPass192.started after1 (tws 0) a stride (half l))
      "stride" stride :=
    (final_started_keep after1 (tws 0) a stride (half l) "stride".toList (by decide)).trans
      (NttInverseFinalPass192.setW_keep after1 (tws 0) "stride" stride (by decide)
        midFixed.strideCell)
  have startedP : Slot (NttInverseFinalPass192.started after1 (tws 0) a stride (half l)) "p" p := by
    have step := final_started_keep after1 (tws 0) a stride (half l) "p".toList (by decide)
    exact step.trans ((ModularAtoms178.outside after1 "w" "p" (tws 0) (by decide)).trans
      midFixed.pCell)
  have startedI : Slot (NttInverseFinalPass192.started after1 (tws 0) a stride (half l)) "p0i" p0i := by
    have step := final_started_keep after1 (tws 0) a stride (half l) "p0i".toList (by decide)
    exact step.trans ((ModularAtoms178.outside after1 "w" "p0i" (tws 0) (by decide)).trans
      midFixed.iCell)
  have startedW : Slot (NttInverseFinalPass192.started after1 (tws 0) a stride (half l)) "w" (tws 0) := by
    have step := final_started_keep after1 (tws 0) a stride (half l) "w".toList (by decide)
    exact step.trans (ModularAtoms178.slot after1 "w" (tws 0))
  have fixedFinal : NttInverseFinalLoop192.Fixed
      (NttInverseFinalPass192.started after1 (tws 0) a stride (half l)) a stride (half l) p p0i (tws 0)
      (fvLast l fv0 tws p p0i) := {
    hnBound := by omega
    hnPositive := by omega
    strideBound := strideBound
    aWidth := aWidth
    aCapacity := midFixed.aCapacity
    aWritable := midFixed.aWritable
    hnCell := startedHn
    strideCell := startedStride
    pCell := startedP
    iCell := startedI
    wCell := startedW
    separate := separate }
  have imageFinal : NttInverseFinalLoop192.Image
      (NttInverseFinalPass192.started after1 (tws 0) a stride (half l)) a stride (half l) (tws 0) p p0i
      (fvLast l fv0 tws p p0i) 0 :=
    NttInverseWholeBridges201.final_input l after1 a stride tws p p0i fv0 raw8
  obtain ⟨after2,finalRun,finalFixed,finalImage,finalCell,_,_⟩ :=
    NttInverseFinal201.source after1 a igm stride (half l) p p0i (tws 0) (fvLast l fv0 tws p p0i)
      wAfter uAfter hnAfter midFixed.strideCell (by omega) strideBound wide256 midFixed.igmBinding
      igmSmall wRead midFixed.aBinding capacity capacity256 fixedFinal imageFinal
  have finalFrame := NttInverseFrame192.frame NttInversePrograms192.finalPass after1
    ⟨after2,.normal⟩ (by decide) finalRun
  have rAfter2 : after2.locals "R".toList=some (.uint32,none) :=
    (finalFrame.1 "R".toList (by decide)).trans rAfter
  have niAfter2 : after2.locals "ni".toList=some (.uint32,none) :=
    (finalFrame.1 "ni".toList (by decide)).trans niAfter
  have nAfter2 : USlot after2 "n" (size l) :=
    (finalFrame.1 "n".toList (by decide)).trans midFixed.nCell
  have aAfter2 : after2.arrays "a".toList=some a :=
    (finalFrame.2 "a".toList (by decide)).trans midFixed.aBinding
  have corrN : USlot (NttInverseCorrectionSource192.started (setNi l after2 p p0i) a stride)
      "n" (size l) :=
    (corr_started_keep (setNi l after2 p p0i) a stride "n".toList (by decide)).trans
      ((NttInverseCorrectionSource201.setNi_outside l after2 p p0i "n" (by decide) (by decide)).trans
        nAfter2)
  have corrStride : USlot (NttInverseCorrectionSource192.started (setNi l after2 p p0i) a stride)
      "stride" stride :=
    (corr_started_keep (setNi l after2 p p0i) a stride "stride".toList (by decide)).trans
      ((NttInverseCorrectionSource201.setNi_outside l after2 p p0i "stride" (by decide)
        (by decide)).trans finalFixed.strideCell)
  have corrP : Slot (NttInverseCorrectionSource192.started (setNi l after2 p p0i) a stride) "p" p :=
    (corr_started_keep (setNi l after2 p p0i) a stride "p".toList (by decide)).trans
      ((NttInverseCorrectionSource201.setNi_outside l after2 p p0i "p" (by decide) (by decide)).trans
        finalFixed.pCell)
  have corrI : Slot (NttInverseCorrectionSource192.started (setNi l after2 p p0i) a stride)
      "p0i" p0i :=
    (corr_started_keep (setNi l after2 p p0i) a stride "p0i".toList (by decide)).trans
      ((NttInverseCorrectionSource201.setNi_outside l after2 p p0i "p0i" (by decide) (by decide)).trans
        finalFixed.iCell)
  have corrNi : Slot (NttInverseCorrectionSource192.started (setNi l after2 p p0i) a stride)
      "ni" (niWord l p p0i) :=
    (corr_started_keep (setNi l after2 p p0i) a stride "ni".toList (by decide)).trans
      (NttInverseCorrection201.ni_slot l after2 p p0i)
  have fixedCorrection : NttInverseCorrectionLoop192.Fixed
      (NttInverseCorrectionSource192.started (setNi l after2 p p0i) a stride) a stride (size l) p p0i
      (niWord l p p0i) (finalWord l fv0 tws p p0i) := {
    nBound := (NttInverseSchedule201.size_bound l).2
    strideBound := strideBound
    wideBound := wide
    aWidth := aWidth
    aCapacity := aCapacity
    aWritable := finalFixed.aWritable
    nCell := corrN
    strideCell := corrStride
    pCell := corrP
    iCell := corrI
    niCell := corrNi
    separate := separate }
  have imageCorrection : NttInverseCorrectionLoop192.Image
      (NttInverseCorrectionSource192.started (setNi l after2 p p0i) a stride) a stride (size l) p p0i
      (niWord l p p0i) (finalWord l fv0 tws p p0i) 0 :=
    NttInverseWholeBridges201.correction_input l after2 a stride tws p p0i fv0 finalImage
  have uAfter2 : after2.locals "u".toList=some (.uint64,some (u64 (half l))) := finalCell
  obtain ⟨after3,corrRun,corrFixed,corrImage,corrCell,corrR1⟩ :=
    NttInverseCorrectionInit201.source l after2 a stride p p0i (finalWord l fv0 tws p p0i)
      (some (u64 (half l))) rAfter2 niAfter2 uAfter2 finalFixed.pCell finalFixed.iCell nAfter2 aAfter2
      capacity fixedCorrection imageCorrection
  have corrFrame := NttInverseFrame192.frame NttInversePrograms192.correction after2
    ⟨after3,.normal⟩ (by decide) corrRun
  have aAfter3 : after3.arrays "a".toList=some a :=
    (corrFrame.2 "a".toList (by decide)).trans aAfter2
  have igmAfter3 : after3.arrays "igm".toList=some igm :=
    (corrFrame.2 "igm".toList (by decide)).trans
      ((finalFrame.2 "igm".toList (by decide)).trans midFixed.igmBinding)
  have whole : Exec NttInversePrograms192.inverseBody s ⟨after3,.normal⟩ :=
    .seqNormal _ _ s (NttInversePrologue192.afterSize s) ⟨after3,.normal⟩ sizeRun
      (.seqNormal _ _ (NttInversePrologue192.afterSize s) (NttInversePrologue192.afterMixed s)
        ⟨after3,.normal⟩ mixedRun
        (.seqNormal _ _ (NttInversePrologue192.afterMixed s) (NttInversePrologue201.ready l s)
          ⟨after3,.normal⟩ guardRun
          (.seqNormal _ _ (NttInversePrologue201.ready l s) (NttInversePrologue201.ready l s)
            ⟨after3,.normal⟩ tripleRun
            (.seqNormal _ _ (NttInversePrologue201.ready l s) after1 ⟨after3,.normal⟩ midRun
              (.seqNormal _ _ after1 after2 ⟨after3,.normal⟩ finalRun
                (.seqNormal _ _ after2 after3 ⟨after3,.normal⟩ corrRun
                  (.base _ _ _ (.skip after3))))))))
  refine ⟨after3,?_,corrImage,corrCell,corrR1,aAfter3,igmAfter3,corrFixed.nCell,
    corrFixed.strideCell,corrFixed.pCell,corrFixed.iCell,corrFixed.niCell,corrFixed.aWritable⟩
  rw [NttInversePrograms192.body_source]
  exact whole

end FT1536.Source3.NttInverseWhole201
