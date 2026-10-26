import Source3.StepNttU1Image195
import Source3.StepNttMloop195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/-! # Exact images of doubling rounds and the m walk

The original mInner declarations, ht assignment, u1 loop, t assignment
and scope restoration share one output with the image. The recursive
word recurrence follows the actual m-doubling/t-halving schedule.
The permanent bodyHeap supplement stays authoritative; no construction
uses the defective StepNttFirst195.stepState.
-/
namespace FT1536.Source3.StepNttRoundImage195
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open StepNttImage195 (Image)
open StepNttMiddle195
open StepNttMloop195

theorem m_body_image (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (m t h : Nat) (W : Nat → BitVec 32)
    (fixed : MFixed s a gm gvs pw p0i) (image : Image s a W)
    (mt : m*t=512) (th : t=2*h) (mb : m≤256) (tb : t≤256) (hpos : 0<h) (wide : 512≤gmn)
    (mc : USlot s "m" m) (tc : USlot s "t" t) :
    ∃ out, Exec mBlock s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧ USlot out "t" h ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap ∧
      Image out a (StepNttU1Image195.roundWords gvs W m t h pw p0i) := by
  have dc : Exec (KeygenNttForwardPrograms.sizeDeclaration ["ht","u1","v1"]) s
      ⟨mDeclared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 mNames s)
  have half : t/2=h := by omega
  have hc : USlot (mPrepared s h) "ht" h :=
    KeygenMkgm3RowInit.set64_slot (mDeclared s) "ht" h (by omega)
  have halfRun : Exec KeygenNttForwardPrograms.htAssign (mDeclared s) ⟨mPrepared s h,.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 h) rfl (.scalar _ _
      (by simpa only [half,KeygenNttForwardPrograms.var,KeygenNttForwardPrograms.num,
        KeygenNttLoopSupport.u64,C99NatWord141.word] using
        (C99OuterScalar144.half_eval (mDeclared s) "t".toList t (by omega) tc)))
  obtain ⟨vo,vRun,vFixed,vu,frame,wordImage⟩ := StepNttU1Image195.u1_loop_full_image m t h mt th mb tb hpos
    (mPrepared s h) a gm gvs pw p0i W wide (m_prepared_fixed s a gm gvs pw p0i h fixed)
    (StepNttImage195.image_keep image rfl)
    mc tc hc none none rfl rfl
  have htOut : USlot vo "ht" h := KeygenNttControl.keep_u64 vRun (by decide) "ht" h (by decide) hc
  have tOut : USlot vo "t" t := KeygenNttControl.keep_u64 vRun (by decide) "t" t (by decide) tc
  have tRun : Exec KeygenNttForwardPrograms.tFromHalf2 vo
      ⟨bindValue vo "t".toList .uint64 (u64 h),.normal⟩ :=
    .assign _ _ _ .uint64 (some (u64 t)) (u64 h) tOut (.scalar _ _ (.variable _ _ _ htOut))
  have inner : Exec KeygenNttForwardPrograms.mInner s
      ⟨bindValue vo "t".toList .uint64 (u64 h),.normal⟩ :=
    .seqNormal _ _ s (mDeclared s) _ dc
      (.seqNormal _ _ (mDeclared s) (mPrepared s h) _ halfRun
      (.seqNormal _ _ (mPrepared s h) vo _ vRun
      (.seqNormal _ _ vo (bindValue vo "t".toList .uint64 (u64 h)) _ tRun
        (.base .skip _ _ (.skip _)))))
  have run : Exec mBlock s
      ⟨C99ArrayReference.restoreScope s (bindValue vo "t".toList .uint64 (u64 h)) mNames [],.normal⟩ :=
    .scope mNames _ s ⟨bindValue vo "t".toList .uint64 (u64 h),.normal⟩ inner
  refine ⟨C99ArrayReference.restoreScope s (bindValue vo "t".toList .uint64 (u64 h)) mNames [],
    run,?_,?_,?_,?_⟩
  · exact fixed_map vo a gm gvs pw p0i vFixed
      (C99ArrayReference.restoreScope s (bindValue vo "t".toList .uint64 (u64 h)) mNames [])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ArrayReference.restoreScope])
      (by simp [mNames,C99ArrayReference.bindValue,C99ArrayReference.restoreScope])
      rfl
  · exact KeygenMkgm3RowInit.set64_slot vo "t" h (by omega)
  · exact frame
  · exact StepNttImage195.image_keep wordImage rfl

/-- The existing schedule with an explicit remaining-round count. -/
inductive RoundPlan : Nat → Nat → Nat → Prop where
  | done : RoundPlan 0 512 1
  | step (n m t h : Nat) (guard : 1<t) (product : m*t=512) (half : t=2*h)
      (mBound : m≤256) (tBound : t≤256) (hBound : h≤256)
      (rest : RoundPlan n (2*m) h) : RoundPlan (n+1) m t

theorem selected_plan : RoundPlan 8 2 256 :=
  .step 7 2 256 128 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 6 4 128 64 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 5 8 64 32 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 4 16 32 16 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 3 32 16 8 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 2 64 8 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 1 128 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 0 256 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
    .done)))))))

/-- Compose n executed rounds, doubling m and halving t at each step. -/
def walkWords {gmn : Nat} (gvs : Fin gmn → BitVec 32) :
    Nat → Nat → Nat → (Nat → BitVec 32) → BitVec 32 → BitVec 32 → Nat → BitVec 32
  | 0, _, _, W, _, _ => W
  | n+1, m, t, W, pw, p0i =>
      walkWords gvs n (2*m) (t/2) (StepNttU1Image195.roundWords gvs W m t (t/2) pw p0i) pw p0i

/-- The eight selected rounds, beginning with m=2 and t=256. -/
def doublingWords {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (W : Nat → BitVec 32) (pw p0i : BitVec 32) : Nat → BitVec 32 :=
  walkWords gvs 8 2 256 W pw p0i

theorem m_walk_image (n m t : Nat) (schedule : RoundPlan n m t)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32) (pw p0i : BitVec 32)
    (W : Nat → BitVec 32) (wide : 512≤gmn) (fixed : MFixed s a gm gvs pw p0i)
    (image : Image s a W) (mc : USlot s "m" m) (tc : USlot s "t" t) :
    ∃ out, Exec StepNttBody195.mWalk s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧
      USlot out "m" 512 ∧ USlot out "t" 1 ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap ∧
      Image out a (walkWords gvs n m t W pw p0i) := by
  induction schedule generalizing s W with
  | done =>
      refine ⟨s,.loopFalse _ _ _ s (.int32 0) (m_guard s 1 (by decide) tc fixed.fullSlot) rfl,
        fixed,mc,tc,NttWriteFrame182.refl a 512 s.heap,?_⟩
      exact image
  | step n m t h guard product half mb tb hb rest ih =>
      obtain ⟨middle,run,middleFixed,middleT,frame,middleImage⟩ :=
        m_body_image s a gm gvs pw p0i m t h W fixed image product half mb tb (by omega) wide mc tc
      have middleM : USlot middle "m" m :=
        KeygenNttControl.keep_u64 run (by decide) "m" m (by decide) mc
      have stepRun : Exec KeygenNttForwardPrograms.mStep middle ⟨mAfter middle m,.normal⟩ :=
        m_step middle m (by omega) middleM
      have nextFixed : MFixed (mAfter middle m) a gm gvs pw p0i :=
        m_after_fixed middle a gm gvs pw p0i m middleFixed
      have nextM : USlot (mAfter middle m) "m" (2*m) := m_counter middle m (by omega)
      have nextT : USlot (mAfter middle m) "t" h :=
        KeygenNttControl.keep_u64 stepRun (by decide) "t" h (by decide) middleT
      obtain ⟨out,restRun,fo,jo,tSlot,frame2,outImage⟩ := ih (mAfter middle m)
        (StepNttU1Image195.roundWords gvs W m t h pw p0i) nextFixed
        (StepNttImage195.image_keep middleImage rfl) nextM nextT
      refine ⟨out,?_,fo,jo,tSlot,NttWriteFrame182.trans a 512 _ _ _ frame frame2,?_⟩
      · have nonzero : (C99ScalarReference.boolean (decide (1<t))).integer≠0 := by
          simp [guard,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
        exact .loopNormal _ _ _ s middle (mAfter middle m) ⟨out,.normal⟩ _
          (m_guard s t (by omega) tc fixed.fullSlot) nonzero run stepRun restRun
      · simpa only [walkWords,show t/2=h by omega] using outImage

end FT1536.Source3.StepNttRoundImage195
