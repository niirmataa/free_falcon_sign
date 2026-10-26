import Source3.StepWalkLoop195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Per-cell bystander keeps through the actual modular-reduction march. -/
namespace FT1536.Source3.StepWalkKeep195
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Load32)
open C99ProcedureReference (Result)
open C99LoopScalar141 (Cell)
open KeygenMakeFgSource (Exec)
open ZintModSignedWord194 (modSignedWord)
open StepCopyBody190 (addr elem output next)
open StepWalkFixed195 (Fixed PrefixImage)

/- The loop guard of the walk (the condition clause of walkLoop, the
   copy-loop guard verbatim). -/
open StepWalkLoop195
theorem remaining (count v : Nat) (s : State) (srcName : Name) (src t1 : ArrayPointer) (n : Nat)
    (fv : Fin n → BitVec 32) (pw p0w r2w rxw : BitVec 32)
    (fixed : Fixed s srcName src t1 n fv pw p0w r2w rxw)
    (vCell : Cell s "v".toList v) (xBinding : s.arrays "x".toList=some (addr src 0 v 1))
    (copied : PrefixImage s t1 fv pw p0w r2w rxw v) (finish : v+count=n) :
    ∃ after, Exec MakeFgAddPrimeShape194.walkLoop s ⟨after,.normal⟩ ∧
      Fixed after srcName src t1 n fv pw p0w r2w rxw ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr src 0 n 1) ∧
      PrefixImage after t1 fv pw p0w r2w rxw n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Nat, i<n → Word32Memory176.Separate (elem t1 i) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 after.heap q w) := by
  induction count generalizing v s with
  | zero =>
    have equal : v=n := by omega
    subst v
    have guard : C99ArrayReference.scalar s MakeFgTailShape190.copyCondition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        StepCopyLoop190.guard s n n fixed.nBound fixed.nBound vCell fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guard (by decide),fixed,vCell,xBinding,copied,
      fun _ _ => rfl,fun _ _ => rfl,fun _ _ _ read => read⟩
  | succ count ih =>
    have slot : v<n := by omega
    have nonzero : (C99ScalarReference.boolean (decide (v<n))).integer≠0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    have body : Exec MakeFgAddPrimeShape194.walkBody s
        ⟨output s t1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw),.normal⟩ :=
      StepWalkBody195.body_source s src t1 v (fv ⟨v,slot⟩) pw p0w r2w rxw
        (by have h := fixed.nBound; omega)
        (StepWalkBody195.march_capacity src n v fixed.srcCapacity slot)
        (by have := fixed.t1Capacity; omega)
        fixed.t1Binding xBinding vCell fixed.slenCell fixed.pSlot fixed.p0iSlot fixed.r2Slot
        fixed.rxSlot (fixed.loads ⟨v,slot⟩) (fixed.t1Allocated ⟨v,slot⟩) fixed.t1Width
        fixed.t1Writable
    have update : Exec MakeFgAddPrimeShape194.walkInc
        (output s t1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        ⟨next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw),.normal⟩ :=
      StepWalkBody195.inc_source s src t1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
        (by have h := fixed.nBound; omega)
        (StepWalkBody195.march_capacity_next src n v fixed.srcCapacity slot)
        vCell fixed.slenCell xBinding
    obtain ⟨after,rest,finalFixed,finalV,finalX,finalPrefix,finalLocals,finalArrays,finalKeep⟩ :=
      ih (v+1) (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        (StepWalkFixed195.next_fixed s srcName src t1 n v fv pw p0w r2w rxw fixed slot)
        (StepCopyLoop190.next_v s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        (StepCopyFixed190.next_x s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        (StepWalkFixed195.next_prefix s srcName src t1 n v fv pw p0w r2w rxw fixed slot copied)
        (by omega)
    refine ⟨after,?_,finalFixed,finalV,finalX,finalPrefix,?_,?_,?_⟩
    · refine .loopNormal _ _ _ s (output s t1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        ⟨after,.normal⟩ (C99ScalarReference.boolean (decide (v<n))) ?_ nonzero body update rest
      exact StepCopyLoop190.guard s v n (by have h := fixed.nBound; omega) fixed.nBound vCell
        fixed.nCell
    · intro name different
      exact (finalLocals name different).trans
        (StepCopyFixed190.next_locals s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
          name different)
    · intro name different
      exact (finalArrays name different).trans
        (StepCopyFixed190.next_arrays s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
          name different)

    · intro q separate w read
      apply finalKeep q separate w
      show Load32 (Word32Memory176.write s.heap (elem t1 v)
        (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)) q w
      exact Word32Memory176.outside _ _ _ _ _ (separate v slot) read

theorem walk_run (s : State) (srcName : Name) (src t1 : ArrayPointer) (n : Nat)
    (fv : Fin n → BitVec 32) (pw p0w r2w rxw : BitVec 32)
    (fixed : Fixed s srcName src t1 n fv pw p0w r2w rxw)
    (vDeclared : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec (walkOf srcName) s ⟨after,.normal⟩ ∧
      Fixed after srcName src t1 n fv pw p0w r2w rxw ∧
      PrefixImage after t1 fv pw p0w r2w rxw n ∧
      Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr src 0 n 1) ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Nat, i<n → Word32Memory176.Separate (elem t1 i) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 after.heap q w) := by
  have srcCapacity : src.index≤src.count := by
    have h := fixed.srcCapacity
    omega
  have initRun : Exec (initOf srcName) s ⟨midState s src,.normal⟩ :=
    init_source s srcName src vDeclared fixed.srcBinding srcCapacity
  have midFixed : Fixed (midState s src) srcName src t1 n fv pw p0w r2w rxw :=
    mid_fixed s srcName src t1 n fv pw p0w r2w rxw fixed
  obtain ⟨after,rest,finalFixed,finalV,finalX,finalPrefix,finalLocals,finalArrays,finalKeep⟩ :=
    remaining n 0 (midState s src) srcName src t1 n fv pw p0w r2w rxw midFixed
      (mid_v s src) (mid_x s src)
      (fun i bound => absurd bound (by omega)) (by omega)
  refine ⟨after,?_,finalFixed,finalPrefix,finalV,finalX,?_,?_,?_⟩
  · exact .seqNormal _ _ s (midState s src) ⟨after,.normal⟩ initRun rest
  · intro name different
    exact (finalLocals name different).trans (mid_locals s src name different)
  · intro name different
    exact (finalArrays name different).trans (mid_arrays s src name different)

  · intro q separate w read
    exact finalKeep q separate w read

end FT1536.Source3.StepWalkKeep195
