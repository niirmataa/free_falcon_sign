import Source3.NttInverseWhole192
import Source3.NttInverseFinalPassKeep194
import Source3.NttInverseCorrectionKeep194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Whole-inverse bystander keep over the NttInverseWhole192.source
   composition of the accepted modp_iNTT3_ext corpus at logn 9 / full 0:
   the prologue and the skipped divide-by-three pass are heap-free, the
   intermediate pass already exports the per-cell keep
   (NttInverseMiddleRounds192.source), and the keep-threaded final pass
   and correction re-compositions (NttInverseFinalPassKeep194,
   NttInverseCorrectionKeep194) close the chain. The export is the same
   executed-word image as NttInverseWhole192.source plus the per-cell
   bystander keep in the NttInverseMiddleRounds192.source shape and the
   writable transport. This yields the fd/gd image keeps through the
   s3/s7 inverse calls for free; no transform, root or positivity claim. -/
namespace FT1536.Source3.NttInverseWholeKeep194
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk Image)
open NttInverseCorrection192 (niWord setNi)
open NttInverseWholeBridges192 (fv8 finalWord)
open NttInverseWhole192 (final_started_keep corr_started_keep)

theorem ready_heap (s : State) : (NttInversePrologue192.ready s).heap=s.heap := rfl

theorem source (s : State) (a igm : ArrayPointer) (stride : Nat) (p p0i : BitVec 32)
    (tws : Nat → BitVec 32) (fv0 : Nat → BitVec 32)
    (logn : Slot s "logn" 9) (full : Slot s "full" 0)
    (strideCell : USlot s "stride" stride) (pc : Slot s "p" p) (ic : Slot s "p0i" p0i)
    (aBinding : s.arrays "a".toList=some a) (igmBinding : s.arrays "igm".toList=some igm)
    (aWidth : a.elementBytes=4) (aCapacity : a.index + 512*stride ≤ a.count)
    (igmCapacity : igm.index + 512 ≤ igm.count) (aWritable : s.heap.writable a.block=true)
    (strideBound : stride<2^64) (wide : 512*stride < 2^64)
    (separate : ∀ j k : Nat, j<512 → k<512 → j≠k → Separate (walk a j stride) (walk a k stride))
    (twSeparate : ∀ k : Nat, k<512 → ∀ j : Nat, j<512 →
      Separate (walk a j stride) ({igm with index := igm.index+k}))
    (twLoads : ∀ k : Nat, k<512 → Load32 s.heap ({igm with index := igm.index+k}) (tws k))
    (image : NttInverseMiddleU1Loop192.Image s a stride
      (NttInverseMiddleRounds192.tOf 0) (NttInverseMiddleRounds192.htOf 0)
      (NttInverseMiddleRounds192.mOf 0) (NttInverseMiddleRounds192.roundTws tws 0) p p0i fv0 0) :
    ∃ after, Exec KeygenLevelNtt.inverse s ⟨after,.normal⟩ ∧
      Image after a stride 512 p p0i (niWord p p0i) (finalWord fv0 tws p p0i) 512 ∧
      Cell after "u".toList 512 ∧
      after.arrays "r1".toList=some (walk a 512 stride) ∧
      after.arrays "a".toList=some a ∧ after.arrays "igm".toList=some igm ∧
      USlot after "n" 512 ∧ USlot after "stride" stride ∧
      Slot after "p" p ∧ Slot after "p0i" p0i ∧ Slot after "ni" (niWord p p0i) ∧
      after.heap.writable a.block=true ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < 512 → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=s.heap.writable := by
  have sizeRun : Exec NttInversePrograms192.sizeCode s
      ⟨NttInversePrologue192.afterSize s,.normal⟩ :=
    NttInversePrologue192.size_run s
  have mixedRun : Exec NttInversePrograms192.mixedCode (NttInversePrologue192.afterSize s)
      ⟨NttInversePrologue192.afterMixed s,.normal⟩ :=
    NttInversePrologue192.mixed_run s
  have guardRun : Exec NttInversePrograms192.guardPart (NttInversePrologue192.afterMixed s)
      ⟨NttInversePrologue192.ready s,.normal⟩ :=
    NttInversePrologue192.guard_run s logn full
  have lognReady : Slot (NttInversePrologue192.ready s) "logn" 9 :=
    (NttInversePrologue192.locals_outside s "logn".toList (by decide)).trans logn
  have fullReady : Slot (NttInversePrologue192.ready s) "full" 0 :=
    (NttInversePrologue192.locals_outside s "full".toList (by decide)).trans full
  have tripleRun : Exec NttInversePrograms192.triplePass (NttInversePrologue192.ready s)
      ⟨NttInversePrologue192.ready s,.normal⟩ :=
    NttInverseTriple192.source (NttInversePrologue192.ready s) fullReady
  have fixedReady : NttInverseMiddleRounds192.Fixed (NttInversePrologue192.ready s)
      a igm stride p p0i tws := {
    strideBound := strideBound
    wide := wide
    aWidth := aWidth
    aCapacity := aCapacity
    aWritable := aWritable
    igmCapacity := igmCapacity
    nCell := NttInversePrologue192.n_cell s
    strideCell := NttInversePrologue192.uslot_keep s "stride" stride (by decide) strideCell
    pCell := NttInversePrologue192.slot_keep s "p" p (by decide) pc
    iCell := NttInversePrologue192.slot_keep s "p0i" p0i (by decide) ic
    aBinding := (NttInversePrologue192.arrays_outside s "a".toList (by decide) (by decide)).trans
      aBinding
    igmBinding := (NttInversePrologue192.arrays_outside s "igm".toList (by decide)
      (by decide)).trans igmBinding
    separate := separate
    twSeparate := twSeparate
    twLoads := twLoads }
  obtain ⟨after1,midRun,midFixed,_,_,midImage,midKeep,midWritable⟩ :=
    NttInverseMiddleRounds192.source none none (NttInversePrologue192.ready s) a igm stride p p0i
      tws fv0 lognReady fullReady
      (NttInversePrologue192.t_declared s) (NttInversePrologue192.m_declared s) fixedReady image
  have midFrame := NttInverseFrame192.frame NttInversePrograms192.intermediatePass
    (NttInversePrologue192.ready s) ⟨after1,.normal⟩ (by decide) midRun
  have hnAfter : USlot after1 "hn" 256 :=
    (midFrame.1 "hn".toList (by decide)).trans (NttInversePrologue192.hn_cell s)
  have wAfter : after1.locals "w".toList=some (.uint32,none) :=
    (midFrame.1 "w".toList (by decide)).trans (NttInversePrologue192.w_declared s)
  have uAfter : after1.locals "u".toList=some (.uint64,none) :=
    (midFrame.1 "u".toList (by decide)).trans (NttInversePrologue192.u_declared s)
  have rAfter : after1.locals "R".toList=some (.uint32,none) :=
    (midFrame.1 "R".toList (by decide)).trans (NttInversePrologue192.R_declared s)
  have niAfter : after1.locals "ni".toList=some (.uint32,none) :=
    (midFrame.1 "ni".toList (by decide)).trans (NttInversePrologue192.ni_declared s)
  have raw8 : ∀ k : Nat, k<512 → Load32 after1.heap (walk a k stride) (fv8 fv0 tws p p0i k) :=
    NttInverseWholeBridges192.round_raw after1 a stride tws p p0i fv0 midImage
  have wRead : Load32 after1.heap igm (tws 0) :=
    midFixed.twLoads 0 (by decide)
  have capacity : a.index ≤ a.count := by
    have step := midFixed.aCapacity
    omega
  have capacity256 : a.index + 256*stride ≤ a.count := by
    have step := midFixed.aCapacity
    omega
  have wide256 : 256*stride<2^64 :=
    Nat.lt_of_le_of_lt (Nat.mul_le_mul_right stride (by decide : 256≤512)) wide
  have igmSmall : igm.index ≤ igm.count := by
    have step := midFixed.igmCapacity
    omega
  have startedHn : USlot (NttInverseFinalPass192.started after1 (tws 0) a stride 256) "hn" 256 :=
    (final_started_keep after1 (tws 0) a stride 256 "hn".toList (by decide)).trans
      (NttInverseFinalPass192.setW_keep after1 (tws 0) "hn" 256 (by decide) hnAfter)
  have startedStride : USlot (NttInverseFinalPass192.started after1 (tws 0) a stride 256)
      "stride" stride :=
    (final_started_keep after1 (tws 0) a stride 256 "stride".toList (by decide)).trans
      (NttInverseFinalPass192.setW_keep after1 (tws 0) "stride" stride (by decide)
        midFixed.strideCell)
  have startedP : Slot (NttInverseFinalPass192.started after1 (tws 0) a stride 256) "p" p := by
    have step := final_started_keep after1 (tws 0) a stride 256 "p".toList (by decide)
    exact step.trans ((ModularAtoms178.outside after1 "w" "p" (tws 0) (by decide)).trans
      midFixed.pCell)
  have startedI : Slot (NttInverseFinalPass192.started after1 (tws 0) a stride 256) "p0i" p0i := by
    have step := final_started_keep after1 (tws 0) a stride 256 "p0i".toList (by decide)
    exact step.trans ((ModularAtoms178.outside after1 "w" "p0i" (tws 0) (by decide)).trans
      midFixed.iCell)
  have startedW : Slot (NttInverseFinalPass192.started after1 (tws 0) a stride 256) "w" (tws 0) := by
    have step := final_started_keep after1 (tws 0) a stride 256 "w".toList (by decide)
    exact step.trans (ModularAtoms178.slot after1 "w" (tws 0))
  have fixedFinal : NttInverseFinalLoop192.Fixed
      (NttInverseFinalPass192.started after1 (tws 0) a stride 256) a stride 256 p p0i (tws 0)
      (fv8 fv0 tws p p0i) := {
    hnBound := by decide
    hnPositive := by decide
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
      (NttInverseFinalPass192.started after1 (tws 0) a stride 256) a stride 256 (tws 0) p p0i
      (fv8 fv0 tws p p0i) 0 :=
    NttInverseWholeBridges192.final_input after1 a stride tws p p0i fv0 raw8
  obtain ⟨after2,finalRun,finalFixed,finalImage,finalCell,_,_,finalKeep,finalWritable⟩ :=
    NttInverseFinalPassKeep194.source after1 a igm stride p p0i (tws 0) (fv8 fv0 tws p p0i)
      wAfter uAfter hnAfter midFixed.strideCell (by decide) strideBound wide256 midFixed.igmBinding
      igmSmall wRead midFixed.aBinding capacity capacity256 fixedFinal imageFinal
  have finalFrame := NttInverseFrame192.frame NttInversePrograms192.finalPass after1
    ⟨after2,.normal⟩ (by decide) finalRun
  have rAfter2 : after2.locals "R".toList=some (.uint32,none) :=
    (finalFrame.1 "R".toList (by decide)).trans rAfter
  have niAfter2 : after2.locals "ni".toList=some (.uint32,none) :=
    (finalFrame.1 "ni".toList (by decide)).trans niAfter
  have nAfter2 : USlot after2 "n" 512 :=
    (finalFrame.1 "n".toList (by decide)).trans midFixed.nCell
  have aAfter2 : after2.arrays "a".toList=some a :=
    (finalFrame.2 "a".toList (by decide)).trans midFixed.aBinding
  have corrN : USlot (NttInverseCorrectionSource192.started (setNi after2 p p0i) a stride)
      "n" 512 :=
    (corr_started_keep (setNi after2 p p0i) a stride "n".toList (by decide)).trans
      ((NttInverseCorrectionSource192.setNi_outside after2 p p0i "n" (by decide) (by decide)).trans
        nAfter2)
  have corrStride : USlot (NttInverseCorrectionSource192.started (setNi after2 p p0i) a stride)
      "stride" stride :=
    (corr_started_keep (setNi after2 p p0i) a stride "stride".toList (by decide)).trans
      ((NttInverseCorrectionSource192.setNi_outside after2 p p0i "stride" (by decide)
        (by decide)).trans finalFixed.strideCell)
  have corrP : Slot (NttInverseCorrectionSource192.started (setNi after2 p p0i) a stride) "p" p :=
    (corr_started_keep (setNi after2 p p0i) a stride "p".toList (by decide)).trans
      ((NttInverseCorrectionSource192.setNi_outside after2 p p0i "p" (by decide) (by decide)).trans
        finalFixed.pCell)
  have corrI : Slot (NttInverseCorrectionSource192.started (setNi after2 p p0i) a stride)
      "p0i" p0i :=
    (corr_started_keep (setNi after2 p p0i) a stride "p0i".toList (by decide)).trans
      ((NttInverseCorrectionSource192.setNi_outside after2 p p0i "p0i" (by decide) (by decide)).trans
        finalFixed.iCell)
  have corrNi : Slot (NttInverseCorrectionSource192.started (setNi after2 p p0i) a stride)
      "ni" (niWord p p0i) :=
    (corr_started_keep (setNi after2 p p0i) a stride "ni".toList (by decide)).trans
      (NttInverseCorrection192.ni_slot after2 p p0i)
  have fixedCorrection : NttInverseCorrectionLoop192.Fixed
      (NttInverseCorrectionSource192.started (setNi after2 p p0i) a stride) a stride 512 p p0i
      (niWord p p0i) (finalWord fv0 tws p p0i) := {
    nBound := by decide
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
      (NttInverseCorrectionSource192.started (setNi after2 p p0i) a stride) a stride 512 p p0i
      (niWord p p0i) (finalWord fv0 tws p p0i) 0 :=
    NttInverseWholeBridges192.correction_input after2 a stride tws p p0i fv0 finalImage
  have uAfter2 : after2.locals "u".toList=some (.uint64,some (u64 256)) := finalCell
  obtain ⟨after3,corrRun,corrFixed,corrImage,corrCell,corrR1,corrKeep,corrWritable⟩ :=
    NttInverseCorrectionKeep194.source after2 a stride p p0i (finalWord fv0 tws p p0i)
      (some (u64 256)) rAfter2 niAfter2 uAfter2 finalFixed.pCell finalFixed.iCell nAfter2 aAfter2
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
        (.seqNormal _ _ (NttInversePrologue192.afterMixed s) (NttInversePrologue192.ready s)
          ⟨after3,.normal⟩ guardRun
          (.seqNormal _ _ (NttInversePrologue192.ready s) (NttInversePrologue192.ready s)
            ⟨after3,.normal⟩ tripleRun
            (.seqNormal _ _ (NttInversePrologue192.ready s) after1 ⟨after3,.normal⟩ midRun
              (.seqNormal _ _ after1 after2 ⟨after3,.normal⟩ finalRun
                (.seqNormal _ _ after2 after3 ⟨after3,.normal⟩ corrRun
                  (.base _ _ _ (.skip after3))))))))
  refine ⟨after3,?_,corrImage,corrCell,corrR1,aAfter3,igmAfter3,corrFixed.nCell,
    corrFixed.strideCell,corrFixed.pCell,corrFixed.iCell,corrFixed.niCell,corrFixed.aWritable,
    ?_,?_⟩
  · rw [NttInversePrograms192.body_source]
    exact whole
  · intro q separateQ z load
    have ready : Load32 (NttInversePrologue192.ready s).heap q z := load
    exact corrKeep q separateQ z (finalKeep q separateQ z (midKeep q separateQ z ready))
  · exact corrWritable.trans (finalWritable.trans (midWritable.trans rfl))

end FT1536.Source3.NttInverseWholeKeep194
