import Source3.NttInverseRound201

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseLoop201
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open C99IntegerReference (ArithmeticExec)
open Word32Memory176 (Separate)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk)
open MkgmParams198 (Level lognWord half)
open NttInverseSchedule201 (Fixed size size_eq size_bound mOf mOf_succ roundTws fvAt m_pow_bound)
open NttInverseRound201 (fixed_state round_run)
open NttInverseMiddleRounds192 (mWalk tOf htOf m_step tInit_value withT withT_keep withT_keep64 withT_keep32 withT_t)

theorem t_last (l : Level) : tOf l.val=size l := (size_eq l).symm

theorem guard_run (l : Level) (s : State) (i : Nat) (bound : i  ≤  l.val) (tCell : USlot s "t" (tOf i))
    (nCell : USlot s "n" (size l)) :
    C99ArrayReference.scalar s NttInversePrograms192.mGuard
      (C99ScalarReference.boolean (decide (tOf i<size l))) :=
  C99LoopScalar141.less s (NttInversePrograms192.var "t") (NttInversePrograms192.var "n")
    (tOf i) (size l) (by have h:=l.isLt; exact Nat.pow_lt_pow_of_lt (by decide : 1<2) (by omega : i+1<64))
    (size_bound l).2 (C99LoopScalar141.read s "t".toList (tOf i) tCell)
    (C99LoopScalar141.read s "n".toList (size l) nCell)

theorem tOf_small (l : Level) (i : Nat) (bound : i<l.val) : tOf i<size l := by
  rw [size_eq]
  exact Nat.pow_lt_pow_of_lt (by decide : 1<2) (by omega : i+1<l.val+1)

theorem m_loop (l : Level) (count i : Nat) (s : State) (a igm : ArrayPointer) (stride : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv0 : Nat → BitVec 32)
    (fixed : Fixed l s a igm stride p p0i tws) (tCell : USlot s "t" (tOf i))
    (mCell : USlot s "m" (mOf l i))
    (image : NttInverseMiddleU1Loop192.Image s a stride (tOf i) (htOf i) (mOf l i)
      (roundTws l tws i) p p0i (fvAt l fv0 tws p p0i i) 0) (finish : i+count = l.val) :
    ∃ after, Exec mWalk s ⟨after,.normal⟩ ∧
      Fixed l after a igm stride p p0i tws ∧
      USlot after "t" (tOf l.val) ∧ USlot after "m" (mOf l l.val) ∧
      NttInverseMiddleU1Loop192.Image after a stride (tOf l.val) (htOf l.val) (mOf l l.val)
        (roundTws l tws l.val) p p0i (fvAt l fv0 tws p p0i l.val) 0 ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < (size l) → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 after.heap q w) ∧
      after.heap.writable=s.heap.writable := by
  induction count generalizing i s with
  | zero =>
    have equal : i = l.val := by omega
    subst i
    have false : C99ArrayReference.scalar s NttInversePrograms192.mGuard (.int32 0) := by
      simpa [t_last,C99ScalarReference.boolean] using guard_run l s l.val (by omega) tCell fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),fixed,tCell,mCell,image,
      fun _ _ _ => id,rfl⟩
  | succ count ih =>
    have slot : i < l.val := by omega
    have nonzero : (C99ScalarReference.boolean (decide (tOf i < (size l)))).integer ≠ 0 := by
      simp [tOf_small l i slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    obtain ⟨out,bodyExec,outFixed,outT,outM,outImage,outKeep,outWritable⟩ :=
      round_run l i (by omega) s a igm stride p p0i tws fv0 fixed tCell mCell image
    have stepRun : Exec NttInversePrograms192.mStep out
        ⟨FftLocalCells140.put out "m".toList (word (mOf l i / 2)),.normal⟩ :=
      .base _ _ _ (m_step out (mOf l i) (m_pow_bound l i (by omega)) outM)
    set mid : State := FftLocalCells140.put out "m".toList (word (mOf l i / 2)) with midEq
    have midFixed : Fixed l mid a igm stride p p0i tws := by
      rw [midEq]
      refine fixed_state outFixed
        ((FftLocalCells140.outside out "m".toList "n".toList (word (mOf l i / 2))
          (by decide)).trans outFixed.nCell)
        ((FftLocalCells140.outside out "m".toList "stride".toList (word (mOf l i / 2))
          (by decide)).trans outFixed.strideCell)
        ((FftLocalCells140.outside out "m".toList "p".toList (word (mOf l i / 2))
          (by decide)).trans outFixed.pCell)
        ((FftLocalCells140.outside out "m".toList "p0i".toList (word (mOf l i / 2))
          (by decide)).trans outFixed.iCell)
        outFixed.aBinding outFixed.igmBinding outFixed.aWritable outFixed.twLoads
    have midT : USlot mid "t" (tOf (i+1)) := by
      rw [midEq]
      exact (FftLocalCells140.outside out "m".toList "t".toList (word (mOf l i / 2))
        (by decide)).trans outT
    have midM : USlot mid "m" (mOf l (i+1)) := by
      rw [midEq]
      have base : USlot (FftLocalCells140.put out "m".toList (word (mOf l i / 2))) "m" (mOf l i / 2) :=
        FftLocalCells140.cell_at out "m".toList (word (mOf l i / 2))
      rw [← mOf_succ l i (by omega)]
      exact base
    have midImage : NttInverseMiddleU1Loop192.Image mid a stride (tOf (i+1)) (htOf (i+1))
        (mOf l (i+1)) (roundTws l tws (i+1)) p p0i (fvAt l fv0 tws p p0i (i+1)) 0 := by
      rw [midEq]
      exact outImage
    have midKeep : ∀ q : ArrayPointer, (∀ x : Nat, x < (size l) → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 mid.heap q w := by
      intro q sep w loaded
      rw [midEq]
      exact outKeep q sep w loaded
    have midWritable : mid.heap.writable=s.heap.writable := by
      rw [midEq]
      exact outWritable
    obtain ⟨after,rest,afterFixed,afterT,afterM,afterImage,afterKeep,afterWritable⟩ :=
      ih (i+1) mid midFixed midT midM midImage (by omega)
    refine ⟨after,?_,afterFixed,afterT,afterM,afterImage,?_,?_⟩
    · refine .loopNormal _ _ _ s out mid ⟨after,.normal⟩
        (C99ScalarReference.boolean (decide (tOf i < (size l))))
        (guard_run l s i (by omega) tCell fixed.nCell) nonzero bodyExec stepRun rest
    · intro q sep w loaded
      exact afterKeep q sep w (midKeep q sep w loaded)
    · exact afterWritable.trans midWritable


theorem subtract_index_zero (l : Level) : ArithmeticExec .minus
    (.uint32 (MkgmControl199.word l.val)) (.uint32 0) (.uint32 (MkgmControl199.word l.val)) := by
  fin_cases l
  all_goals exact .step .minus _ _ .uint32 rfl _ _ rfl rfl (by intro impossible; cases impossible)

theorem mInit_value (l : Level) (s : State) (logn : Slot s "logn" (lognWord l)) (full : Slot s "full" 0) :
    C99ArrayReference.scalar s (.bin .shl (.cast .u64 (NttInversePrograms192.num 1))
      (.bin .sub (.bin .sub (NttInversePrograms192.var "logn") (NttInversePrograms192.num 1))
        (NttInversePrograms192.var "full"))) (u64 (half l)) :=
  .shift .left _ _ _ _ _ (.cast .uint64 _ (.int32 1) (.literal .int32 1))
    (.arithmetic .minus _ _ _ _ _
      (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn) (.literal .int32 1) (MkgmControl199.lower_power l))
      (.variable _ _ _ full) (subtract_index_zero l)) (MkgmControl199.half_shift l)

def initial (l : Level) (s : State) := bindValue (withT s) "m".toList .uint64 (u64 (half l))

theorem initial_keep (l : Level) (s : State) (name : String) (ty : C99IntegerReference.Ty)
    (old : Option C99IntegerReference.Value) (different : name.toList≠"m".toList)
    (cell : (withT s).locals name.toList=some (ty,old)) :
    (initial l s).locals name.toList=some (ty,old) :=
  (NttInversePrologue201.bind_keep (withT s) "m".toList .uint64 (u64 (half l)) name.toList different).trans cell

theorem initial_keep64 (l : Level) (s : State) (name : String) (n : Nat) (different : name.toList≠"m".toList)
    (cell : USlot (withT s) name n) : USlot (initial l s) name n := initial_keep l s name _ _ different cell

theorem initial_keep32 (l : Level) (s : State) (name : String) (w : BitVec 32) (different : name.toList≠"m".toList)
    (cell : Slot (withT s) name w) : Slot (initial l s) name w := initial_keep l s name _ _ different cell

theorem initial_m (l : Level) (s : State) : USlot (initial l s) "m" (half l) :=
  KeygenMkgm3RowInit.set64_slot _ _ _ (by have h:=MkgmParams198.half_range l; omega)

theorem source (l : Level) (oldT oldM : Option C99IntegerReference.Value) (s : State)
    (a igm : ArrayPointer) (stride : Nat) (p p0i : BitVec 32) (tws : Nat → BitVec 32)
    (fv0 : Nat → BitVec 32)
    (logn : Slot s "logn" (lognWord l)) (full : Slot s "full" 0)
    (tDeclared : s.locals "t".toList=some (.uint64,oldT))
    (mDeclared : s.locals "m".toList=some (.uint64,oldM))
    (fixed : Fixed l s a igm stride p p0i tws)
    (image : NttInverseMiddleU1Loop192.Image s a stride (tOf 0) (htOf 0) (mOf l 0)
      (roundTws l tws 0) p p0i fv0 0) :
    ∃ after, Exec NttInversePrograms192.intermediatePass s ⟨after,.normal⟩ ∧
      Fixed l after a igm stride p p0i tws ∧
      USlot after "t" (tOf l.val) ∧ USlot after "m" (mOf l l.val) ∧
      NttInverseMiddleU1Loop192.Image after a stride (tOf l.val) (htOf l.val) (mOf l l.val)
        (roundTws l tws l.val) p p0i (fvAt l fv0 tws p p0i l.val) 0 ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < (size l) → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 after.heap q w) ∧
      after.heap.writable=s.heap.writable := by
  have tRun : Exec NttInversePrograms192.tInit s ⟨withT s,.normal⟩ :=
    .assign _ _ _ .uint64 oldT (.uint32 2) tDeclared (.scalar _ _ (tInit_value s full))
  have mDeclaredT : (withT s).locals "m".toList=some (.uint64,oldM) :=
    withT_keep s "m" .uint64 oldM (by decide) mDeclared
  have lognT : Slot (withT s) "logn" (lognWord l) :=
    withT_keep32 s "logn" (lognWord l) (by decide) logn
  have fullT : Slot (withT s) "full" 0 :=
    withT_keep32 s "full" 0 (by decide) full
  have mRun : Exec NttInversePrograms192.mInit (withT s) ⟨initial l s,.normal⟩ :=
    .assign _ _ _ .uint64 oldM (u64 (half l)) mDeclaredT (.scalar _ _ (mInit_value l (withT s) lognT fullT))
  have nInitial : USlot (initial l s) "n" (size l) :=
    initial_keep64 l s "n" (size l) (by decide) (withT_keep64 s "n" (size l) (by decide) fixed.nCell)
  have strideInitial : USlot (initial l s) "stride" stride :=
    initial_keep64 l s "stride" stride (by decide)
      (withT_keep64 s "stride" stride (by decide) fixed.strideCell)
  have pInitial : Slot (initial l s) "p" p :=
    initial_keep32 l s "p" p (by decide) (withT_keep32 s "p" p (by decide) fixed.pCell)
  have iInitial : Slot (initial l s) "p0i" p0i :=
    initial_keep32 l s "p0i" p0i (by decide) (withT_keep32 s "p0i" p0i (by decide) fixed.iCell)
  have fixedInitial : Fixed l (initial l s) a igm stride p p0i tws :=
    fixed_state fixed nInitial strideInitial pInitial iInitial
      fixed.aBinding fixed.igmBinding fixed.aWritable fixed.twLoads
  have tInitial : USlot (initial l s) "t" (tOf 0) :=
    initial_keep64 l s "t" 2 (by decide) (withT_t s)
  have mInitial : USlot (initial l s) "m" (mOf l 0) := initial_m l s
  obtain ⟨after,loopRun,afterFixed,afterT,afterM,afterImage,afterKeep,afterWritable⟩ :=
    m_loop l l.val 0 (initial l s) a igm stride p p0i tws fv0 fixedInitial tInitial mInitial image
      (by omega)
  have mLoopRun : Exec NttInversePrograms192.mLoop (withT s) ⟨after,.normal⟩ :=
    .seqNormal _ _ (withT s) (initial l s) ⟨after,.normal⟩ mRun loopRun
  refine ⟨after,?_,afterFixed,afterT,afterM,afterImage,afterKeep,afterWritable⟩
  exact .seqNormal _ _ s (withT s) ⟨after,.normal⟩ tRun
    (.seqNormal _ _ (withT s) after ⟨after,.normal⟩ mLoopRun (.base _ _ _ (.skip after)))

end FT1536.Source3.NttInverseLoop201
