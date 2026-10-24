import Source3.StepNttMloop195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The whole pinned modp_NTT3_ext forward body at the selected call words
   (logn = 9 / full = 0, n = 512, hn = 256, stride = 1) exported at the
   StepNttEntry195 entry frame: the prologue + w = gm[1] + first pass of
   the previous window (consumed: StepNttFirstLoop195.entry_run pieces),
   the eight doubling rounds and the KERNEL-CHECKED full = 0 branch —
   the mGuard reads `t > 1` and the final triple pass branch reads 0 and
   takes the SKIP (both checked at the frame words, not assumed). The
   composed result is `Exec KeygenNttForwardPrograms.forwardBody` at the
   call frame with the exit counters m = 512 / t = 1 / u = 256, the
   middle-pass invariant and the write frame of the doubling passes.
   Values stay executed words: no transform property, table law, root
   law or positivity claim is made here. The executed-word image of the
   doubling passes (butterfly words layered over the first-pass words)
   and the transport of these facts to the concrete part-3 CRT exit
   state remain OPEN. -/
namespace FT1536.Source3.StepNttWhole195
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open StepNttMiddle195 (MFixed)

/-! ## The m/t cells at the loop input of the export -/

theorem wState_free (before : State) (t1 gm : ArrayPointer) {gmn : Nat}
    (gvs : Fin gmn → BitVec 32) (pw p0w : BitVec 32) (gmOne : 1<gmn) :
    (StepNttFirstLoop195.wState before t1 gm gvs pw p0w gmOne).locals "m".toList=
      some (.uint64,none) ∧
    (StepNttFirstLoop195.wState before t1 gm gvs pw p0w gmOne).locals "t".toList=
      some (.uint64,none) := by
  constructor <;>
    simp [StepNttFirstLoop195.wState,ModularAtoms178.set,C99ArrayReference.bindValue,
      C99ScalarReference.set,StepNttPrologue195.ready,StepNttPrologue195.afterCompute,
      StepNttPrologue195.afterN,KeygenNttForwardExec.afterPointers,
      KeygenNttForwardExec.afterWord,KeygenNttForwardExec.afterLocals,
      KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell]

/-! ## The entry-frame assembly with the middle-pass facts -/

theorem entry_middle (before : State) (t1 gm : ArrayPointer) {gmn : Nat}
    (fv : Fin (2*256) → BitVec 32) (gvs : Fin gmn → BitVec 32) (pw p0w : BitVec 32)
    (gmOne : 1<gmn) (t1Width : t1.elementBytes=4) (t1Capacity : t1.index+512≤t1.count)
    (t1Writable : before.heap.writable t1.block=true)
    (gmSeparate : ∀ i : Fin gmn, ∀ j : Fin (2*256), Separate (elem gm i) (elem t1 j))
    (gmLoads : ∀ i : Fin gmn, Load32 before.heap (elem gm i) (gvs i))
    (input : StepNttFirst195.Pending0 (StepNttFirstLoop195.frame before t1 gm pw p0w) t1 fv) :
    ∃ mid, Exec StepNttFirstLoop195.entryPrefix
        (StepNttFirstLoop195.frame before t1 gm pw p0w) ⟨mid,.normal⟩ ∧
      MFixed mid t1 gm gvs pw p0w ∧ Cell mid "u".toList 256 ∧
      (∃ old, mid.locals "m".toList=some (.uint64,old)) ∧
      (∃ old, mid.locals "t".toList=some (.uint64,old)) := by
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
  exact ⟨after,prefixRun,middleFixed,finalU,mFree,tFree⟩


/-! ## The complete forward engine at the call words -/

theorem complete_run (before : State) (t1 gm : ArrayPointer) {gmn : Nat}
    (fv : Fin (2*256) → BitVec 32) (gvs : Fin gmn → BitVec 32) (pw p0w : BitVec 32)
    (gmOne : 1<gmn) (t1Width : t1.elementBytes=4) (t1Capacity : t1.index+512≤t1.count)
    (t1Writable : before.heap.writable t1.block=true)
    (gmSeparate : ∀ i : Fin gmn, ∀ j : Fin (2*256), Separate (elem gm i) (elem t1 j))
    (gmLoads : ∀ i : Fin gmn, Load32 before.heap (elem gm i) (gvs i))
    (input : StepNttFirst195.Pending0 (StepNttFirstLoop195.frame before t1 gm pw p0w) t1 fv)
    (wide : 512≤gmn) :
    ∃ mid out, Exec StepNttFirstLoop195.entryPrefix
        (StepNttFirstLoop195.frame before t1 gm pw p0w) ⟨mid,.normal⟩ ∧
      Exec StepNttBody195.tailT mid ⟨out,.normal⟩ ∧
      Exec KeygenNttForwardPrograms.forwardBody (StepNttFirstLoop195.frame before t1 gm pw p0w)
        ⟨out,.normal⟩ ∧
      MFixed out t1 gm gvs pw p0w ∧
      USlot out "m" 512 ∧ USlot out "t" 1 ∧
      Cell mid "u".toList 256 ∧
      NttWriteFrame182.Frame t1 512 mid.heap out.heap := by
  obtain ⟨mid,prefixRun,middleFixed,uCell,mFree,tFree⟩ := entry_middle before t1 gm fv gvs pw p0w
    gmOne t1Width t1Capacity t1Writable gmSeparate gmLoads input
  obtain ⟨out,tailRun,outFixed,mOut,tOut,frame⟩ := StepNttMloop195.tail_run mid t1 gm gvs pw p0w
    wide middleFixed tFree mFree
  have body : Exec KeygenNttForwardPrograms.forwardBody
      (StepNttFirstLoop195.frame before t1 gm pw p0w) ⟨out,.normal⟩ :=
    StepNttFirstLoop195.prefix_continue (StepNttFirstLoop195.frame before t1 gm pw p0w) mid
      ⟨out,.normal⟩ prefixRun tailRun
  exact ⟨mid,out,prefixRun,tailRun,body,outFixed,mOut,tOut,uCell,frame⟩

end FT1536.Source3.StepNttWhole195
