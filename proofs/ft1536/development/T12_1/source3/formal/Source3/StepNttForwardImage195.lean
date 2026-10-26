import Source3.StepNttWhole195
import Source3.StepNttProductImage195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Full executed-word image at the selected logn=9/full=0 forward frame.
   The first-pass image and counted doubling image share the actual output.
   No transform, root or table law is asserted. -/
namespace FT1536.Source3.StepNttForwardImage195
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open C99IntegerReference (Value)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open StepNttMiddle195 (MFixed)
open StepNttWhole195 (wState_free)

/-- Total first-pass word function; only indices below 512 are observed. -/
def firstWords (fv : Fin 512 → BitVec 32) (w pw p0i : BitVec 32) (j : Nat) : BitVec 32 :=
  if lo : j<256 then StepNttFirst195.lowWordAt 256 fv w pw p0i j lo
  else if hi : j-256<256 then StepNttFirst195.highWordAt 256 fv w pw p0i (j-256) hi
  else 0

theorem first_image {s : State} {a : ArrayPointer} {fv : Fin 512 → BitVec 32}
    {w pw p0i : BitVec 32} (image : StepNttFirst195.Image (hn:=256) s a fv w pw p0i 256) :
    StepNttImage195.Image s a (firstWords fv w pw p0i) := by
  intro j bound
  by_cases lo : j<256
  · simpa [firstWords,lo,StepCopyBody190.elem,KeygenSmallOutput.element] using (image.1 ⟨j,lo⟩ lo).1
  · have hi : j-256<256 := by omega
    have read := (image.1 ⟨j-256,hi⟩ hi).2
    have same : 256+(j-256)=j := by omega
    rw [same] at read
    simpa [firstWords,lo,hi,StepCopyBody190.elem,KeygenSmallOutput.element] using read

theorem prefix_image (before : State) (t1 gm : ArrayPointer) {gmn : Nat}
    (fv : Fin (2*256) → BitVec 32) (gvs : Fin gmn → BitVec 32) (pw p0w : BitVec 32)
    (gmOne : 1<gmn) (t1Width : t1.elementBytes=4) (t1Capacity : t1.index+512≤t1.count)
    (t1Writable : before.heap.writable t1.block=true)
    (gmSeparate : ∀ i : Fin gmn, ∀ j : Fin (2*256), Separate (elem gm i) (elem t1 j))
    (gmLoads : ∀ i : Fin gmn, Load32 before.heap (elem gm i) (gvs i))
    (input : StepNttFirst195.Pending0 (hn:=256) (StepNttFirstLoop195.frame before t1 gm pw p0w) t1 fv) :
    ∃ mid, Exec StepNttFirstLoop195.entryPrefix
        (StepNttFirstLoop195.frame before t1 gm pw p0w) ⟨mid,.normal⟩ ∧
      MFixed mid t1 gm gvs pw p0w ∧ Cell mid "u".toList 256 ∧
      (∃ old, mid.locals "m".toList=some (.uint64,old)) ∧
      (∃ old, mid.locals "t".toList=some (.uint64,old)) ∧
      StepNttImage195.Image mid t1 (firstWords fv (gvs ⟨1,gmOne⟩) pw p0w) := by
  have logn : StepNttPrologue195.lognAt (StepNttFirstLoop195.frame before t1 gm pw p0w) :=
    StepNttFirstLoop195.frame_logn before t1 gm pw p0w
  have full : StepNttPrologue195.fullAt (StepNttFirstLoop195.frame before t1 gm pw p0w) :=
    StepNttFirstLoop195.frame_full before t1 gm pw p0w
  have prologueRun : Exec KeygenNttForwardPrograms.prologue
      (StepNttFirstLoop195.frame before t1 gm pw p0w)
      ⟨StepNttPrologue195.ready (StepNttFirstLoop195.frame before t1 gm pw p0w),.normal⟩ :=
    StepNttPrologue195.prologue_run (StepNttFirstLoop195.frame before t1 gm pw p0w) logn full
  have readyGm : (StepNttPrologue195.ready
      (StepNttFirstLoop195.frame before t1 gm pw p0w)).arrays "gm".toList=some gm :=
    (StepNttPrologue195.ready_gm (StepNttFirstLoop195.frame before t1 gm pw p0w)).trans
      (StepNttFirstLoop195.frame_gm before t1 gm pw p0w)
  have gmAlloc : Load32 before.heap (elem gm 1) (gvs ⟨1,gmOne⟩) := gmLoads ⟨1,gmOne⟩
  have gmCapacity : gm.index+1≤gm.count := by
    have h := StepNttFirstLoop195.load_allocated gmAlloc
    have b := h.2.2.1
    change gm.index+1<gm.count at b
    omega
  have gmRead : Load32 (StepNttPrologue195.ready
      (StepNttFirstLoop195.frame before t1 gm pw p0w)).heap (elem gm 1) (gvs ⟨1,gmOne⟩) :=
    gmLoads ⟨1,gmOne⟩
  have wRun : Exec KeygenNttForwardPrograms.wAssign
      (StepNttPrologue195.ready (StepNttFirstLoop195.frame before t1 gm pw p0w))
      ⟨StepNttFirstLoop195.wState before t1 gm gvs pw p0w gmOne,.normal⟩ :=
    (StepNttPrologue195.w_run (StepNttPrologue195.ready
      (StepNttFirstLoop195.frame before t1 gm pw p0w)) gm gvs gmOne
      ⟨none,StepNttFirstLoop195.ready_w_free (StepNttFirstLoop195.frame before t1 gm pw p0w)⟩
      readyGm gmCapacity gmRead).1
  have fixed : StepNttFirst195.Fixed
      (StepNttFirstLoop195.wState before t1 gm gvs pw p0w gmOne) t1 gm 256 gmn fv gvs
      (gvs ⟨1,gmOne⟩) pw p0w :=
    StepNttFirstLoop195.entry_fixed before t1 gm fv gvs pw p0w gmOne t1Width t1Capacity
      t1Writable gmSeparate gmLoads
  have uDeclared : ∃ old,
      (StepNttFirstLoop195.wState before t1 gm gvs pw p0w gmOne).locals "u".toList=
        some (.uint64,old) := by
    refine ⟨none,?_⟩
    change (ModularAtoms178.set (StepNttPrologue195.ready
      (StepNttFirstLoop195.frame before t1 gm pw p0w)) "w" (gvs ⟨1,gmOne⟩)).locals "u".toList=
      some (.uint64,none)
    rw [StepNttFirstLoop195.w_set_locals_keep _ _ "u".toList (by decide)]
    exact StepNttFirstLoop195.ready_u_free (StepNttFirstLoop195.frame before t1 gm pw p0w)
  have pending : StepNttFirst195.Pending0
      (StepNttFirstLoop195.wState before t1 gm gvs pw p0w gmOne) t1 fv := input
  obtain ⟨after,loopRun,finalFixed,finalImage,finalU,finalR1,finalR2,finalLocals,finalArrays⟩ :=
    StepNttFirstLoop195.first_run (StepNttFirstLoop195.wState before t1 gm gvs pw p0w gmOne) t1 gm
      256 gmn fv gvs (gvs ⟨1,gmOne⟩) pw p0w fixed uDeclared pending
  have prefixRun : Exec StepNttFirstLoop195.entryPrefix
      (StepNttFirstLoop195.frame before t1 gm pw p0w) ⟨after,.normal⟩ := by
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.locals_run
      (StepNttFirstLoop195.frame before t1 gm pw p0w)) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.word_run _) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.pointers_run _) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.early_run _
      (StepNttPrologue195.logn_keep _ logn)) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.n_run _
      (StepNttPrologue195.logn_keep _ logn) (StepNttPrologue195.full_keep _ full)
      (KeygenNttForwardExec.n_free _)) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.hn_run _
      (StepNttPrologue195.n_bound _) (StepNttPrologue195.hn_free _)) ?_
    exact .seqNormal _ _ _ _ _ wRun loopRun
  have fullSlot : Slot after "full" 0 := by
    have keep := finalLocals "full".toList (by decide)
    refine keep.trans ?_
    change (ModularAtoms178.set (StepNttPrologue195.ready
      (StepNttFirstLoop195.frame before t1 gm pw p0w)) "w" (gvs ⟨1,gmOne⟩)).locals "full".toList=
      some (.uint32,some (.uint32 0))
    rw [StepNttFirstLoop195.w_set_locals_keep _ _ "full".toList (by decide),
      StepNttPrologue195.ready_full]
    exact full
  have reads : ∀ j<512, ∃ w, Load32 after.heap (elem t1 j) w := by
    intro j bound
    by_cases low : j<256
    · exact ⟨_,(finalImage.1 ⟨j,low⟩ low).1⟩
    · have high : j-256<256 := by omega
      have keep := (finalImage.1 ⟨j-256,high⟩ high).2
      have same : 256+(j-256)=j := by omega
      rw [same] at keep
      exact ⟨_,keep⟩
  have mFree : ∃ old, after.locals "m".toList=some (.uint64,old) :=
    ⟨none,(finalLocals "m".toList (by decide)).trans (wState_free before t1 gm gvs pw p0w gmOne).1⟩
  have tFree : ∃ old, after.locals "t".toList=some (.uint64,old) :=
    ⟨none,(finalLocals "t".toList (by decide)).trans (wState_free before t1 gm gvs pw p0w gmOne).2⟩
  have middleFixed : MFixed after t1 gm gvs pw p0w :=
    ⟨finalFixed.pSlot,finalFixed.p0iSlot,fullSlot,finalFixed.hnCell,finalFixed.strideCell,
      finalFixed.aBinding,finalFixed.gmBinding,finalFixed.aWidth,finalFixed.aCapacity,
      finalFixed.aWritable,reads,
      fun i j _ => finalFixed.gmSeparate i ⟨j,by omega⟩,
      finalFixed.gmLoads⟩
  exact ⟨after,prefixRun,middleFixed,finalU,mFree,tFree,first_image finalImage⟩


/-- The full selected forward image, as recursive executed words. -/
def forwardWords {gmn : Nat} (fv : Fin 512 → BitVec 32) (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (gmOne : 1<gmn) : Nat → BitVec 32 :=
  StepNttRoundImage195.doublingWords gvs (firstWords fv (gvs ⟨1,gmOne⟩) pw p0i) pw p0i

theorem complete_image (before : State) (t1 gm : ArrayPointer) {gmn : Nat}
    (fv : Fin 512 → BitVec 32) (gvs : Fin gmn → BitVec 32) (pw p0w : BitVec 32)
    (gmOne : 1<gmn) (t1Width : t1.elementBytes=4) (t1Capacity : t1.index+512≤t1.count)
    (t1Writable : before.heap.writable t1.block=true)
    (gmSeparate : ∀ i : Fin gmn, ∀ j : Fin 512, Separate (elem gm i) (elem t1 j))
    (gmLoads : ∀ i : Fin gmn, Load32 before.heap (elem gm i) (gvs i))
    (input : StepNttFirst195.Pending0 (hn:=256) (StepNttFirstLoop195.frame before t1 gm pw p0w) t1 fv)
    (wide : 512≤gmn) :
    ∃ out, Exec KeygenNttForwardPrograms.forwardBody
        (StepNttFirstLoop195.frame before t1 gm pw p0w) ⟨out,.normal⟩ ∧
      MFixed out t1 gm gvs pw p0w ∧ USlot out "m" 512 ∧ USlot out "t" 1 ∧
      StepNttImage195.Image out t1 (forwardWords fv gvs pw p0w gmOne) := by
  obtain ⟨mid,prefixRun,fixed,uCell,mFree,tFree,image⟩ := prefix_image before t1 gm fv gvs pw p0w
    gmOne t1Width t1Capacity t1Writable gmSeparate gmLoads input
  obtain ⟨out,tailRun,outFixed,mOut,tOut,frame,outImage⟩ := StepNttProductImage195.tail_run_image
    mid t1 gm gvs pw p0w (firstWords fv (gvs ⟨1,gmOne⟩) pw p0w) wide fixed image tFree mFree
  exact ⟨out,StepNttFirstLoop195.prefix_continue _ _ _ prefixRun tailRun,
    outFixed,mOut,tOut,outImage⟩

/-- Actual seven-argument binding and heap-only return to the caller. -/
theorem call_image (before : State) (t1 gm : ArrayPointer) {gmn : Nat}
    (fv : Fin 512 → BitVec 32) (gvs : Fin gmn → BitVec 32) (pw p0w : BitVec 32)
    (gmOne : 1<gmn) (t1Width : t1.elementBytes=4) (t1Capacity : t1.index+512≤t1.count)
    (t1Writable : before.heap.writable t1.block=true)
    (gmSeparate : ∀ i : Fin gmn, ∀ j : Fin 512, Separate (elem gm i) (elem t1 j))
    (gmLoads : ∀ i : Fin gmn, Load32 before.heap (elem gm i) (gvs i))
    (input : StepNttFirst195.Pending0 (hn:=256) (StepNttFirstLoop195.frame before t1 gm pw p0w) t1 fv)
    (wide : 512≤gmn) (t1Binding : before.arrays "t1".toList=some t1)
    (gmBinding : before.arrays "gm".toList=some gm) (lognCell : Slot before "logn" 9)
    (pCell : Slot before "p" pw) (iCell : Slot before "p0i" p0w) :
    ∃ after, KeygenLevelCalls.Call .forward before MakeFgAddPrimeShape194.forwardArgs after ∧
      KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.forwardCall before ⟨after,.normal⟩ ∧
      after.locals=before.locals ∧ after.arrays=before.arrays ∧
      StepNttImage195.Image after t1 (forwardWords fv gvs pw p0w gmOne) := by
  obtain ⟨out,run,fixed,mOut,tOut,image⟩ := complete_image before t1 gm fv gvs pw p0w gmOne
    t1Width t1Capacity t1Writable gmSeparate gmLoads input wide
  have gmCapacity : gm.index≤gm.count := by
    have h := (StepNttFirstLoop195.load_allocated (gmLoads ⟨1,gmOne⟩)).2.2.1
    change gm.index+1<gm.count at h
    omega
  have binding := StepNttEntry195.bind_forward before t1 gm 9 pw p0w t1Binding (by omega)
    gmBinding gmCapacity lognCell pCell iCell
  let after : State := {before with heap := out.heap}
  have call : KeygenLevelCalls.Call .forward before MakeFgAddPrimeShape194.forwardArgs after :=
    .run _ ⟨out,.normal⟩ binding run .voidEnd
  exact ⟨after,call,.level _ _ _ (.call .forward _ _ _ call),rfl,rfl,
    StepNttImage195.image_keep image rfl⟩

/-- The actual ternary branch, with all caller cells preserved. -/
theorem branch_image {before after : State} {t1 : ArrayPointer} {W : Nat → BitVec 32}
    (call : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.forwardCall before ⟨after,.normal⟩)
    (image : StepNttImage195.Image after t1 W)
    (ter : Slot before "ter" 1) :
    KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.nttBranch before ⟨after,.normal⟩ ∧
      StepNttImage195.Image after t1 W := by
  have scopedRun : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.nttYes before ⟨after,.normal⟩ :=
    MakeFgScope187.source _ before after
      (.seqNormal _ _ before after _ call (MakeFgDeclarations176.array_source .skip after after (.skip after)))
  exact ⟨.branchTrue _ _ _ before ⟨after,.normal⟩ (.uint32 1)
    (.variable _ _ _ ter) (by decide) scopedRun,image⟩

/-- Actual call execution preserves allocation metadata, derived from writes. -/
theorem call_stable {before after : State}
    (call : KeygenLevelCalls.Call .forward before MakeFgAddPrimeShape194.forwardArgs after) :
    KeygenMemoryStability.Stable before.heap after.heap := by
  cases call with
  | run entry out binding execution returned =>
    have stable := KeygenMemoryStability.modular _ _ _ execution
    rw [KeygenLevelCalls.bind_heap _ _ _ _ binding] at stable
    exact stable

end FT1536.Source3.StepNttForwardImage195
