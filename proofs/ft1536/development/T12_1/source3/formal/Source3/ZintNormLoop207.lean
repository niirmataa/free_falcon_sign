import Source3.ZintNormBranches207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormLoop207
open C99ArrayReference (State restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open ZintNormFixed207 (Fixed Image choice resultWord flow)
open ZintNormState207 (lower prepared tied)
open KeygenZintCall (Exec)

theorem source (k : Nat) (s : State) (px pp : ArrayPointer) (n : Nat) (xv pv : Nat → BitVec 32) (cc : BitVec 32)
    (fixed : Fixed s px pp n xv pv) (within : k ≤ n) (uc : Cell s ZintNormWord194.uName k) (cc0 : Slot s "cc" cc) :
    ∃ out : C99ProcedureReference.Result, Exec ZintNormWord194.normLoop s out ∧ out.flow=flow (choice xv pv cc k) ∧
      Image out.state px n xv pv (choice xv pv cc k) ∧
      (out.flow=.normal → Cell out.state ZintNormWord194.uName 0) ∧
      (∀ q old, (∀ i, i < n → Separate (elem px i) q) → Load32 s.heap q old → Load32 out.state.heap q old) := by
  induction k generalizing s cc with
  | zero =>
    have test : KeygenWordExpr.Eval s ZintNormWord194.normGuard (.int32 0) :=
      .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s ZintNormWord194.uName 0 uc))
        (WordAtoms205.literal _ 0) ZintNormWord194.gt_zero_false
    exact ⟨⟨s,.normal⟩,.loopFalse _ _ _ _ (.int32 0) test (by decide),rfl,fixed.xRead,fun _ => uc,
      fun _ _ _ read => read⟩
  | succ k ih =>
    have slot : k < n := by omega
    have bound : k+1 < 2^64 := by have h:=fixed.nBound; omega
    have uLower : Cell (lower s k) ZintNormWord194.uName k := CrtState205.cell64 s "u" (C99NatWord141.word k)
    have checks:=ZintNormPrepare207.comparisons (lower s k) px k (xv k) (pv k) cc fixed.xBinding uLower
      (by omega) (fixed.xRead k slot)
    have test:=ZintNormState207.guard_pos s k bound uc
    by_cases less : (xv k).toNat < (ZintNormPrepare207.threshold (pv k) cc).toNat
    · have decision : choice xv pv cc (k+1)=.lt := by simp only [choice,ite_eq_left less]
      have first : KeygenWordExpr.Eval (prepared s k (pv k) cc) ZintNormWord194.test1 (.int32 1) := by
        simpa [prepared,C99ScalarReference.boolean,less] using checks.1
      have rest:=ZintNormBranches207.less (prepared s k (pv k) cc) first
      have body:=ZintNormState207.iterate s px pp n k xv pv cc fixed slot uc cc0 _ rest
      have run : Exec ZintNormWord194.normLoop s ⟨tied s k (pv k) cc,.returned none⟩ :=
        .loopReturn _ _ _ _ _ (.int32 1) none test (by decide) body
      refine ⟨⟨tied s k (pv k) cc,.returned none⟩,run,?_,?_,?_,?_⟩
      · rw [decision]; rfl
      · intro i before
        rw [decision]
        exact fixed.xRead i before
      · intro h; cases h
      · intro q old _ read
        exact read
    · have first : KeygenWordExpr.Eval (prepared s k (pv k) cc) ZintNormWord194.test1 (.int32 0) := by
        simpa [prepared,C99ScalarReference.boolean,less] using checks.1
      by_cases greater : (ZintNormPrepare207.threshold (pv k) cc).toNat < (xv k).toNat
      · have decision : choice xv pv cc (k+1)=.gt := by simp only [choice,ite_eq_right less,ite_eq_left greater]
        have second : KeygenWordExpr.Eval (prepared s k (pv k) cc) ZintNormWord194.test2 (.int32 1) := by
          simpa [prepared,C99ScalarReference.boolean,greater] using checks.2
        have ready:=ZintNormState207.prepared_fixed s px pp n k xv pv cc fixed
        obtain ⟨subOut,subRun,subWritten,_,_,subKeep⟩:=ZintSubCall207.source (prepared s k (pv k) cc) px pp n xv pv
          ready.xBinding ready.pBinding ready.lenCell ready.nBound ready.width ready.capacity ready.pCapacity ready.writable
          ready.xRead ready.pRead ready.apart
        have rest:=ZintNormBranches207.greater (prepared s k (pv k) cc) subOut first second subRun
        have body:=ZintNormState207.iterate s px pp n k xv pv cc fixed slot uc cc0 _ rest
        let doneState:=restoreScope (lower s k) subOut [ZintNormWord194.wName] []
        have run : Exec ZintNormWord194.normLoop s ⟨doneState,.returned none⟩ :=
          .loopReturn _ _ _ _ _ (.int32 1) none test (by decide) body
        refine ⟨⟨doneState,.returned none⟩,run,?_,?_,?_,?_⟩
        · rw [decision]; rfl
        · intro i before
          rw [decision]
          exact subWritten i before
        · intro h; cases h
        · intro q old apart read
          exact subKeep q old apart read
      · have second : KeygenWordExpr.Eval (prepared s k (pv k) cc) ZintNormWord194.test2 (.int32 0) := by
          simpa [prepared,C99ScalarReference.boolean,greater] using checks.2
        have decision : choice xv pv cc (k+1)=choice xv pv (pv k &&& 1) k := by
          simp only [choice,ite_eq_right less,ite_eq_right greater]
        have rest:=ZintNormBranches207.equal (prepared s k (pv k) cc) first second
        have body : Exec ZintNormWord194.normIter s ⟨tied s k (pv k) cc,.normal⟩ :=
          ZintNormState207.iterate s px pp n k xv pv cc fixed slot uc cc0 _ rest
        have update : Exec ZintNormWord194.wskip (tied s k (pv k) cc) ⟨tied s k (pv k) cc,.normal⟩ :=
          ZintNormWord194.word_skip _
        obtain ⟨out,loopRun,flowOut,image,zero,keep⟩:=ih (tied s k (pv k) cc) (pv k &&& 1)
          (ZintNormState207.tied_fixed s px pp n k xv pv cc fixed) (by omega)
          (ZintNormState207.tied_u s k (pv k) cc) (ZintNormState207.tied_cc s k (pv k) cc)
        refine ⟨out,.loopNormal _ _ _ _ _ _ _ (.int32 1) test (by decide) body update loopRun,?_,?_,zero,?_⟩
        · rw [decision]; exact flowOut
        · rw [decision]; exact image
        · intro q old apart read
          exact keep q old apart read

end FT1536.Source3.ZintNormLoop207
