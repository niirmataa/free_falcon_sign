import Source3.NttInverseImage201

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseRound201
open C99ArrayReference (State Name Pointer bindPointer bindValue restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk walk_index walk_count walk_width)
open NttInverseMiddleBody192 (bb high)

open MkgmParams198 (Level)
open NttInverseSchedule201 (Fixed size mOf roundTws fvAt round_product two_pow_bound ht_pow_bound m_pow_bound htOf_bound mOf_bound)
open NttInverseImage201 (round_image)
open NttInverseMiddleRounds192 (mWalk names tOf htOf tOf_succ htOf_eq declared prepared innerBody mInner_split
  restore_locals put_locals effect_keep prepared_keep effect_keep32 prepared_keep32 declared_u1 declared_v1
  prepared_u1 prepared_v1 prepared_ht shr_word)

theorem fixed_state {l : Level} {s s' : State} {a igm : ArrayPointer} {stride : Nat} {p p0i : BitVec 32}
    {tws : Nat → BitVec 32} (base : Fixed l s a igm stride p p0i tws)
    (nCell : USlot s' "n" (size l)) (strideCell : USlot s' "stride" stride)
    (pCell : Slot s' "p" p) (iCell : Slot s' "p0i" p0i)
    (aBinding : s'.arrays "a".toList=some a) (igmBinding : s'.arrays "igm".toList=some igm)
    (aWritable : s'.heap.writable a.block=true)
    (twLoads : ∀ k : Nat, k < (size l) → Load32 s'.heap ({igm with index := igm.index+k}) (tws k)) :
    Fixed l s' a igm stride p p0i tws where
  strideBound := base.strideBound
  wide := base.wide
  aWidth := base.aWidth
  aCapacity := base.aCapacity
  aWritable := aWritable
  igmCapacity := base.igmCapacity
  nCell := nCell
  strideCell := strideCell
  pCell := pCell
  iCell := iCell
  aBinding := aBinding
  igmBinding := igmBinding
  separate := base.separate
  twSeparate := base.twSeparate
  twLoads := twLoads


theorem below (l : Level) (i x : Nat) (bound : i+1  ≤  l.val) (slot : x < mOf l i * tOf i) : x < (size l) := by
  have := round_product l i (by omega)
  omega


theorem round_run (l : Level) (i : Nat) (bound : i+1  ≤  l.val) (s : State) (a igm : ArrayPointer) (stride : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv0 : Nat → BitVec 32)
    (fixed : Fixed l s a igm stride p p0i tws)
    (tCell : USlot s "t" (tOf i)) (mCell : USlot s "m" (mOf l i))
    (image : NttInverseMiddleU1Loop192.Image s a stride (tOf i) (htOf i) (mOf l i)
      (roundTws l tws i) p p0i (fvAt l fv0 tws p p0i i) 0) :
    ∃ out, Exec NttInversePrograms192.mInner s ⟨out,.normal⟩ ∧
      Fixed l out a igm stride p p0i tws ∧
      USlot out "t" (tOf (i+1)) ∧ USlot out "m" (mOf l i) ∧
      NttInverseMiddleU1Loop192.Image out a stride (tOf (i+1)) (htOf (i+1)) (mOf l (i+1))
        (roundTws l tws (i+1)) p p0i (fvAt l fv0 tws p p0i (i+1)) 0 ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < (size l) → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 out.heap q w) ∧
      out.heap.writable=s.heap.writable := by
  have tBound : tOf i < 2^64 := two_pow_bound l i bound
  have htBound : htOf i < 2^64 := ht_pow_bound l i bound
  have mBound : mOf l i < 2^64 := m_pow_bound l i bound
  have product : mOf l i * tOf i = (size l) := round_product l i (by omega)
  have dc : Exec (NttInversePrograms192.declareU64 ["ht","u1","v1"]) s ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 names s)
  have tKept : USlot (declared s) "t" (tOf i) := effect_keep s "t" (tOf i) (by decide) tCell
  have mKept : USlot (declared s) "m" (mOf l i) := effect_keep s "m" (mOf l i) (by decide) mCell
  have nKept : USlot (declared s) "n" (size l) := effect_keep s "n" (size l) (by decide) fixed.nCell
  have shrWord : C99IntegerReference.ShiftExec .right (u64 (tOf i))
      (C99IntegerReference.convert .int32 1) (u64 (htOf i)) := by
    have raw : C99IntegerReference.ShiftExec .right (u64 (tOf i))
        (C99IntegerReference.convert .int32 1) (u64 (tOf i / 2)) := shr_word (tOf i) tBound
    rw [htOf_eq] at raw
    exact raw
  have htRun : Exec NttInversePrograms192.htAssign (declared s) ⟨prepared s (htOf i),.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 (htOf i)) (by rfl)
      (.scalar _ _ (.shift .right _ _ _ _ _
        (C99LoopScalar141.read (declared s) "t".toList (tOf i) tKept) (.literal .int32 1) shrWord))
  have nPrepared : USlot (prepared s (htOf i)) "n" (size l) :=
    prepared_keep s (htOf i) "n" (size l) (by decide) nKept
  have tPrepared : USlot (prepared s (htOf i)) "t" (tOf i) :=
    prepared_keep s (htOf i) "t" (tOf i) (by decide) tKept
  have mPrepared : USlot (prepared s (htOf i)) "m" (mOf l i) :=
    prepared_keep s (htOf i) "m" (mOf l i) (by decide) mKept
  have preparedFixed : Fixed l (prepared s (htOf i)) a igm stride p p0i tws :=
    fixed_state fixed nPrepared
      (prepared_keep s (htOf i) "stride" stride (by decide)
        (effect_keep s "stride" stride (by decide) fixed.strideCell))
      (prepared_keep32 s (htOf i) "p" p (by decide)
        (effect_keep32 s "p" p (by decide) fixed.pCell))
      (prepared_keep32 s (htOf i) "p0i" p0i (by decide)
        (effect_keep32 s "p0i" p0i (by decide) fixed.iCell))
      fixed.aBinding fixed.igmBinding fixed.aWritable fixed.twLoads
  have u1Fixed : NttInverseMiddleU1Loop192.Fixed (prepared s (htOf i)) a igm stride
      (tOf i) (htOf i) (mOf l i) p p0i (roundTws l tws i) (fvAt l fv0 tws p p0i i) :=
    NttInverseSchedule201.u1_fixed l (prepared s (htOf i)) a igm stride i p p0i tws (fvAt l fv0 tws p p0i i)
      preparedFixed bound tPrepared mPrepared (prepared_ht s (htOf i) htBound)
  obtain ⟨after,u1Run,afterFixed,afterU1,afterV1,afterImage,afterKeep,afterWritable⟩ :=
    NttInverseMiddleU1Loop192.full (prepared s (htOf i)) a igm stride (tOf i) (htOf i) (mOf l i)
      p p0i (roundTws l tws i) (fvAt l fv0 tws p p0i i) u1Fixed none none (prepared_u1 s (htOf i))
      (prepared_v1 s (htOf i)) image
  have tAfter : Cell after "t".toList (tOf i) := afterFixed.tCell
  have tBase : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "t".toList .shl (NttInversePrograms192.num 1))) after
      (FftLocalCells140.put after "t".toList (word (tOf i * 2))) := by
    cases C99ControlShift142.double (fun _ => none) after "t".toList (tOf i) tBound tAfter with
    | base _ _ _ source => exact source
  have tRun : Exec (NttInversePrograms192.update "t" .shl (NttInversePrograms192.num 1))
      after ⟨FftLocalCells140.put after "t".toList (word (tOf i * 2)),.normal⟩ :=
    .base _ _ _ tBase
  set shifted : State := FftLocalCells140.put after "t".toList (word (tOf i * 2)) with shiftedEq
  have skipRun : Exec (.base .skip) shifted ⟨shifted,.normal⟩ := .base _ _ _ (.skip shifted)
  have tailRun : Exec (.seq (NttInversePrograms192.update "t" .shl (NttInversePrograms192.num 1))
      (.base .skip)) after ⟨shifted,.normal⟩ :=
    .seqNormal _ _ after shifted ⟨shifted,.normal⟩ tRun skipRun
  have u1Seq : Exec (.seq NttInversePrograms192.u1Loop
      (.seq (NttInversePrograms192.update "t" .shl (NttInversePrograms192.num 1)) (.base .skip)))
      (prepared s (htOf i)) ⟨shifted,.normal⟩ :=
    .seqNormal _ _ (prepared s (htOf i)) after ⟨shifted,.normal⟩ u1Run tailRun
  have htSeq : Exec (.seq NttInversePrograms192.htAssign
      (.seq NttInversePrograms192.u1Loop
        (.seq (NttInversePrograms192.update "t" .shl (NttInversePrograms192.num 1)) (.base .skip))))
      (declared s) ⟨shifted,.normal⟩ :=
    .seqNormal _ _ (declared s) (prepared s (htOf i)) ⟨shifted,.normal⟩ htRun u1Seq
  have bodyRun : Exec innerBody s ⟨shifted,.normal⟩ :=
    .seqNormal _ _ s (declared s) ⟨shifted,.normal⟩ dc htSeq
  have innerRun : Exec NttInversePrograms192.mInner s ⟨restoreScope s shifted names [],.normal⟩ := by
    rw [mInner_split]
    exact .scope names innerBody s ⟨shifted,.normal⟩ bodyRun
  have control := KeygenNttControl.frame NttInversePrograms192.mInner s
    ⟨restoreScope s shifted names [],.normal⟩ (by decide) innerRun
  refine ⟨restoreScope s shifted names [],innerRun,?_,?_,?_,?_,?_,?_⟩
  · refine fixed_state fixed
      (control.2.1 "n".toList (by decide) |>.trans fixed.nCell)
      (control.2.1 "stride".toList (by decide) |>.trans fixed.strideCell)
      (control.2.1 "p".toList (by decide) |>.trans fixed.pCell)
      (control.2.1 "p0i".toList (by decide) |>.trans fixed.iCell)
      (control.2.2 "a".toList (by decide) |>.trans fixed.aBinding)
      (control.2.2 "igm".toList (by decide) |>.trans fixed.igmBinding) ?_ ?_
    · show after.heap.writable a.block=true
      rw [afterWritable]
      exact fixed.aWritable
    · intro k kBound
      show Load32 after.heap {igm with index := igm.index+k} (tws k)
      exact afterKeep {igm with index := igm.index+k}
        (fun x xSlot => fixed.twSeparate k kBound x (below l i x bound xSlot)) (tws k)
        (fixed.twLoads k kBound)
  · have tShift : USlot shifted "t" (tOf i * 2) :=
      FftLocalCells140.cell_at after "t".toList (word (tOf i * 2))
    have tOut : USlot (restoreScope s shifted names []) "t" (tOf i * 2) :=
      (restore_locals s shifted names "t".toList (by decide)).trans tShift
    show USlot (restoreScope s shifted names []) "t" (tOf (i+1))
    rw [tOf_succ]
    exact tOut
  · exact (control.2.1 "m".toList (by decide) |>.trans mCell)
  · show NttInverseMiddleU1Loop192.Image (restoreScope s shifted names []) a stride
      (tOf (i+1)) (htOf (i+1)) (mOf l (i+1)) (roundTws l tws (i+1)) p p0i
      (fvAt l fv0 tws p p0i (i+1)) 0
    exact round_image l _ a stride i p p0i tws fv0 bound afterImage
  · intro q sep w loaded
    show Load32 after.heap q w
    exact afterKeep q (fun x xSlot => sep x (below l i x bound xSlot)) w loaded
  · show after.heap.writable=s.heap.writable
    exact afterWritable.trans rfl

end FT1536.Source3.NttInverseRound201
