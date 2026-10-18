import Source3.NttSchedule183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttMLoop183
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open NttFirstFixed182 (Fixed)

def loop : C99ModularReference.Stmt :=
  .loop KeygenNttForwardPrograms.mGuard NttMBody183.code KeygenNttForwardPrograms.mStep

theorem source (m t : Nat) (schedule : NttSchedule183.Schedule m t)
    (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (sep : NttMiddleTable183.Separate a gm) (reads : NttMiddleTable183.Reads s.heap gm)
    (mc : USlot s "m" m) (tc : USlot s "t" t) (full : Slot s "full" 1) :
    ∃ out, Exec loop s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧ USlot out "m" 512 ∧ USlot out "t" 3 ∧
      NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  induction schedule generalizing s with
  | done =>
    exact ⟨s,.loopFalse _ _ _ s (.int32 0) (NttMControl183.guard s 3 (by decide) tc full) rfl,
      fixed,mc,tc,NttWriteFrame182.refl a 1536 s.heap⟩
  | step m t h guard product half mb tb hb rest ih =>
    obtain ⟨middle,iteration,middleFixed,middleT,memory⟩ :=
      NttMBody183.source s a gm p p0i w m t h fixed product half mb tb hb sep reads mc tc
    have middleM := KeygenNttControl.keep_u64 iteration (by decide) "m" m (by decide) mc
    have middleFull := KeygenNttControl.keep_u32 iteration (by decide) "full" 1 (by decide) full
    let next := NttMControl183.after middle m
    have update := NttMControl183.advance middle m mb middleM
    obtain ⟨out,tail,fo,mo,finalT,frame⟩ := ih next (NttMControl183.fixed middle a gm p p0i w m middleFixed)
      (NttMiddleTable183.transport s.heap middle.heap a gm sep memory reads)
      (NttMControl183.counter middle m mb) middleT middleFull
    refine ⟨out,?_,fo,mo,finalT,NttWriteFrame182.trans a 1536 _ _ _ memory frame⟩
    have nonzero : (C99ScalarReference.boolean (decide (3<t))).integer≠0 := by
      simp [guard,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (NttMControl183.guard s t (by omega) tc full) nonzero iteration update tail

theorem full (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (sep : NttMiddleTable183.Separate a gm) (reads : NttMiddleTable183.Reads s.heap gm) (fc : Slot s "full" 1)
    (oldT oldM : Option C99IntegerReference.Value)
    (dt : s.locals "t".toList=some (.uint64,oldT)) (dm : s.locals "m".toList=some (.uint64,oldM)) :
    ∃ out, Exec KeygenNttForwardPrograms.intermediatePass s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧
      USlot out "m" 512 ∧ USlot out "t" 3 ∧ NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  obtain ⟨out,run,fo,mo,finalT,frame⟩ := source 2 768 NttSchedule183.selected (NttMControl183.initial s) a gm p p0i w
    (NttMControl183.initial_fixed s a gm p p0i w fixed) sep reads rfl rfl fc
  have start := NttMControl183.t_init s oldT dt fixed.hnCell
  have count := NttMControl183.m_init s oldM dm
  exact ⟨out,.seqNormal _ _ s (NttMControl183.withT s) _ start
    (.seqNormal _ _ (NttMControl183.withT s) out _
      (.seqNormal _ _ (NttMControl183.withT s) (NttMControl183.initial s) _ count run)
      (.base .skip out out (.skip out))),fo,mo,finalT,frame⟩

end FT1536.Source3.NttMLoop183
