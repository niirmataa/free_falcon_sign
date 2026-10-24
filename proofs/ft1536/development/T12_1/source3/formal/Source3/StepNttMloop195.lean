import Source3.StepNttMiddle195
import Source3.PublicGenerateIndex159

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The doubling-pass composition and the KERNEL-CHECKED full = 0 branch
   of the pinned modp_NTT3_ext forward body at the selected call words
   (logn = 9 / full = 0, n = 512, hn = 256, stride = 1): the mGuard
   `t > 1+(full<<1)` reads `t > 1` at full = 0 (kernel-checked, not
   assumed), the eight doubling rounds of the m loop (m = 2^(i+1),
   t = 2^(8-i) from selected, stopping at m = 512 / t = 1) run
   in full through StepNttMiddle195.m_body, and the final triple pass
   branch `if (full)` reads 0 at the frame words, so the branch takes
   the SKIP alternative and the triple pass is NOT executed
   (kernel-checked branchFalse, not assumed). The export is the
   tailT run of the pinned parse map (t = hn assign, m = 2 init, the
   m walk, the triple-pass skip). Values stay executed words: no
   transform property, table law, root law or positivity claim is made
   here. The word image of the doubling passes (the layered butterfly
   words over the first-pass words) is NOT claimed here; this module
   exports the runs, the exit counters and the write frame. -/
namespace FT1536.Source3.StepNttMloop195
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open StepNttMiddle195 (MFixed mBlock m_body m_prepared_fixed)

/-! ## The mGuard at full = 0 (kernel-checked branch of the loop bound) -/

theorem m_compare (t : Nat) (bound : t<2^64) :
    C99IntegerReference.CompareExec .gt (u64 t) (.uint32 1 : Value)
      (C99ScalarReference.boolean (decide (1<t))) := by
  have raw := C99IntegerReference.CompareExec.step .gt (u64 t) (.uint32 1 : Value) .uint64 rfl
    (u64 t) (u64 1) (C99CountedWords.convert_self _).symm rfl
  change C99IntegerReference.CompareExec .gt (u64 t) (.uint32 1 : Value)
    (C99ScalarReference.boolean (C99IntegerReference.compare .gt (u64 t).integer
      (C99IntegerReference.Value.uint32 1).integer)) at raw
  have one : (C99IntegerReference.Value.uint32 1).integer=(1:Int) := by decide
  have key : C99IntegerReference.compare .gt (u64 t).integer
      (C99IntegerReference.Value.uint32 1).integer = decide (1<t) := by
    rw [KeygenNttLoopSupport.u64_integer t bound,one]
    simp [C99IntegerReference.compare]
  rw [key] at raw
  exact raw

theorem m_guard (s : State) (t : Nat) (bound : t<2^64) (tc : USlot s "t" t)
    (full : Slot s "full" 0) :
    C99ArrayReference.scalar s KeygenNttForwardPrograms.mGuard
      (C99ScalarReference.boolean (decide (1<t))) := by
  have shift : C99ArrayReference.scalar s (.bin .shl (.var "full".toList) (.literal .i32 1))
      (.uint32 0 : Value) :=
    .shift .left _ _ _ _ _ (.variable _ _ _ full) (.literal .int32 1)
      (.unsignedLeft (.uint32 0) (.int32 1) 1 rfl rfl (by decide))
  have rhs : C99ArrayReference.scalar s
      (.bin .add (.literal .i32 1) (.bin .shl (.var "full".toList) (.literal .i32 1)))
      (.uint32 1 : Value) :=
    .arithmetic .plus _ _ _ _ _ (.literal .int32 1) shift
      (.step .plus (.int32 1) (.uint32 0) .uint32 rfl (.uint32 1) (.uint32 0) rfl rfl
        (by intro impossible; cases impossible))
  exact .compare .gt _ _ _ _ _ (.variable _ _ _ tc) rhs (m_compare t bound)

/-! ## The m step and the round schedule -/

def mAfter (s : State) (m : Nat) := bindValue s "m".toList .uint64 (u64 (2*m))

theorem m_step (s : State) (m : Nat) (bound : m≤256) (mc : USlot s "m" m) :
    Exec KeygenNttForwardPrograms.mStep s ⟨mAfter s m,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 m)) (u64 (2*m)) mc
    (.shift .left _ _ _ _ _ (.variable _ _ _ mc) (.literal .int32 1)
      (PublicGenerateIndex159.shl_one m (by omega) _ rfl))))

theorem m_counter (s : State) (m : Nat) (bound : m≤256) : USlot (mAfter s m) "m" (2*m) :=
  KeygenMkgm3RowInit.set64_slot s "m" (2*m) (by omega)

theorem m_after_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (m : Nat) (fixed : MFixed s a gm gvs pw p0i) :
    MFixed (mAfter s m) a gm gvs pw p0i :=
  StepNttMiddle195.fixed_map s a gm gvs pw p0i fixed (mAfter s m)
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mAfter,C99ArrayReference.bindValue,C99ScalarReference.set])
    rfl rfl rfl

inductive Schedule : Nat → Nat → Prop where
  | done : Schedule 512 1
  | step (m t h : Nat) (guard : 1<t) (product : m*t=512) (half : t=2*h)
      (mBound : m≤256) (tBound : t≤256) (hBound : h≤256)
      (rest : Schedule (2*m) h) : Schedule m t

theorem selected : Schedule 2 256 :=
  .step 2 256 128 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 4 128 64 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 8 64 32 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 16 32 16 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 32 16 8 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 64 8 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 128 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 256 2 1 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
    .done)))))))

/-! ## The m walk: eight doubling rounds -/

def mWalkCode : C99ModularReference.Stmt :=
  .loop KeygenNttForwardPrograms.mGuard mBlock KeygenNttForwardPrograms.mStep

theorem m_walk (m t : Nat) (schedule : Schedule m t)
    (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32) (pw p0i : BitVec 32)
    (wide : 512≤gmn) (fixed : MFixed s a gm gvs pw p0i)
    (mc : USlot s "m" m) (tc : USlot s "t" t) :
    ∃ out, Exec StepNttBody195.mWalk s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧
      USlot out "m" 512 ∧ USlot out "t" 1 ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap := by
  induction schedule generalizing s with
  | done =>
      exact ⟨s,.loopFalse _ _ _ s (.int32 0) (m_guard s 1 (by decide) tc fixed.fullSlot) rfl,
        fixed,mc,tc,NttWriteFrame182.refl a 512 s.heap⟩
  | step m t h guard product half mb tb hb rest ih =>
      obtain ⟨middle,run,middleFixed,middleT,frame⟩ :=
        m_body s a gm gvs pw p0i m t h fixed product half mb tb (by omega) wide mc tc
      have middleM : USlot middle "m" m :=
        KeygenNttControl.keep_u64 run (by decide) "m" m (by decide) mc
      have stepRun : Exec KeygenNttForwardPrograms.mStep middle ⟨mAfter middle m,.normal⟩ :=
        m_step middle m (by omega) middleM
      have nextFixed : MFixed (mAfter middle m) a gm gvs pw p0i :=
        m_after_fixed middle a gm gvs pw p0i m middleFixed
      have nextM : USlot (mAfter middle m) "m" (2*m) := m_counter middle m (by omega)
      have nextT : USlot (mAfter middle m) "t" h :=
        KeygenNttControl.keep_u64 stepRun (by decide) "t" h (by decide) middleT
      obtain ⟨out,rest',fo,jo,tSlot,frame2⟩ := ih (mAfter middle m) nextFixed nextM nextT
      refine ⟨out,?_,fo,jo,tSlot,NttWriteFrame182.trans a 512 _ _ _ frame frame2⟩
      have nonzero : (C99ScalarReference.boolean (decide (1<t))).integer≠0 := by
        simp [guard,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
      exact .loopNormal _ _ _ s middle (mAfter middle m) ⟨out,.normal⟩ _
        (m_guard s t (by omega) tc fixed.fullSlot) nonzero run stepRun rest'

/-! ## The t = hn assign and the m = 2 init -/

def tFrom (s : State) := bindValue s "t".toList .uint64 (u64 256)
def mStart (s : State) := bindValue (tFrom s) "m".toList .uint64 (u64 2)

theorem t_init (s : State) (old : Option Value) (declared : s.locals "t".toList=some (.uint64,old))
    (hc : USlot s "hn" 256) : Exec KeygenNttForwardPrograms.tFromHalf s ⟨tFrom s,.normal⟩ :=
  .assign _ _ _ .uint64 old (u64 256) declared (.scalar _ _ (.variable _ _ _ hc))

theorem m_init (s : State) (old : Option Value) (declared : s.locals "m".toList=some (.uint64,old)) :
    Exec KeygenNttForwardPrograms.mInit (tFrom s) ⟨mStart s,.normal⟩ :=
  .assign _ _ _ .uint64 old (.int32 2) declared (.scalar _ _ (.literal .int32 2))

theorem t_from_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (fixed : MFixed s a gm gvs pw p0i) :
    MFixed (tFrom s) a gm gvs pw p0i :=
  StepNttMiddle195.fixed_map s a gm gvs pw p0i fixed (tFrom s)
    (by simp [tFrom,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [tFrom,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [tFrom,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [tFrom,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [tFrom,C99ArrayReference.bindValue,C99ScalarReference.set])
    rfl rfl rfl

theorem m_start_fixed (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (fixed : MFixed s a gm gvs pw p0i) :
    MFixed (mStart s) a gm gvs pw p0i :=
  StepNttMiddle195.fixed_map (tFrom s) a gm gvs pw p0i (t_from_fixed s a gm gvs pw p0i fixed)
    (mStart s)
    (by simp [mStart,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mStart,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mStart,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mStart,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [mStart,C99ArrayReference.bindValue,C99ScalarReference.set])
    rfl rfl rfl

/-! ## The triple pass at full = 0: the branch reads false (kernel check) -/

theorem triple_skip (s : State) (full : Slot s "full" 0) :
    Exec KeygenNttForwardPrograms.triplePass s ⟨s,.normal⟩ := by
  have guard : C99ArrayReference.scalar s (KeygenNttForwardPrograms.var "full") (.uint32 0) :=
    .variable "full".toList .uint32 (.uint32 0) full
  have branch : Exec (.branch (KeygenNttForwardPrograms.var "full")
      (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.tripleInner)
      (.base .skip)) s ⟨s,.normal⟩ :=
    .branchFalse _ _ _ s ⟨s,.normal⟩ (.uint32 0) guard rfl (.base _ _ _ (.skip s))
  exact .seqNormal _ _ s s ⟨s,.normal⟩ branch (.base .skip s s (.skip s))

/-! ## The tailT run: doubling passes + skipped triple pass -/

theorem tail_run (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (wide : 512≤gmn) (fixed : MFixed s a gm gvs pw p0i)
    (tFree : ∃ old, s.locals "t".toList=some (.uint64,old))
    (mFree : ∃ old, s.locals "m".toList=some (.uint64,old)) :
    ∃ out, Exec StepNttBody195.tailT s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧
      USlot out "m" 512 ∧ USlot out "t" 1 ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap := by
  obtain ⟨oldT,tCell⟩ := tFree
  obtain ⟨oldM,mCell⟩ := mFree
  have tRun : Exec KeygenNttForwardPrograms.tFromHalf s ⟨tFrom s,.normal⟩ :=
    t_init s oldT tCell fixed.hnSlot
  have mRun : Exec KeygenNttForwardPrograms.mInit (tFrom s) ⟨mStart s,.normal⟩ :=
    m_init s oldM mCell
  obtain ⟨out,walkRun,mFixed,mOut,tOut,frame⟩ := m_walk 2 256 selected (mStart s) a gm
    gvs pw p0i wide (m_start_fixed s a gm gvs pw p0i fixed) rfl rfl
  have triple : Exec KeygenNttForwardPrograms.triplePass out ⟨out,.normal⟩ :=
    triple_skip out mFixed.fullSlot
  have mHeadRun : Exec StepNttBody195.mHead (tFrom s) ⟨out,.normal⟩ :=
    .seqNormal _ _ (tFrom s) (mStart s) ⟨out,.normal⟩ mRun walkRun
  have middle : Exec StepNttBody195.tailMiddle (tFrom s) ⟨out,.normal⟩ :=
    .seqNormal _ _ (tFrom s) out ⟨out,.normal⟩ mHeadRun triple
  have tail : Exec StepNttBody195.tailT s ⟨out,.normal⟩ :=
    .seqNormal _ _ s (tFrom s) ⟨out,.normal⟩ tRun middle
  exact ⟨out,tail,mFixed,mOut,tOut,frame⟩

end FT1536.Source3.StepNttMloop195
