import Source3.ExactLengthOps217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ExactLengthLoop217
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer Load32)
open C99IntegerReference (Value)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenZintCall (Exec)
open StepCopyBody190 (elem)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (counter cond index test ret dec yes body loop code nonzero highest)

def step (s : State) (n : Nat) := bindValue s "xlen".toList .uint64 (.uint64 (word n))

theorem counter (s : State) (n : Nat) (bound : n<2^64) : Cell (step s n) "xlen".toList n :=
  KeygenMkgm3RowInit.set64_slot s "xlen" n bound

theorem guard (s : State) (n : Nat) (bound : n<2^64) (cell : Cell s "xlen".toList n) :
    KeygenWordExpr.Eval s cond (C99ScalarReference.boolean (decide (0<n))) :=
  .cmp .gt _ _ _ _ _ (.scalar _ _ (.variable _ _ _ cell)) (.scalar _ _ (.literal .int32 0))
    (ExactLengthOps217.positive n bound)

theorem index_eval (s : State) (n : Nat) (bound : n<2^64) (positive : 0<n) (cell : Cell s "xlen".toList n) :
    C99ArrayReference.scalar s index (.uint64 (word (n-1))) :=
  .arithmetic .minus _ _ _ _ _ (.variable _ _ _ cell) (.literal .int32 1)
    (ExactLengthOps217.sub_one n bound positive)

theorem test_eval (s : State) (root : ArrayPointer) (W : Nat → BitVec 32) (n : Nat)
    (bound : n<2^64) (positive : 0<n) (cell : Cell s "xlen".toList n)
    (binding : s.arrays "x".toList=some root) (capacity : root.index+n ≤ root.count)
    (data : Data s root n W) :
    KeygenWordExpr.Eval s test (C99ScalarReference.boolean (decide (nonzero (W (n-1))))) := by
  have idx := index_eval s n bound positive cell
  have indexBound : n-1<2^64 := by omega
  have ptr : C99ArrayReference.Pointer s "x".toList index (elem root (n-1)) :=
    .add _ _ root _ (.uint64 (word (n-1))) binding idx
      (by rw [C99NatWord141.integer _ indexBound]; omega)
      (by
        rw [C99NatWord141.integer _ indexBound]
        change C99MemoryReference.PointerAdd root (n-1) {root with index:=root.index+(n-1)}
        exact .within root (n-1) (by omega))
  exact .cmp .ne _ _ _ _ _ (.load32 _ _ _ _ ptr (data (n-1) (by omega)))
    (.scalar _ _ (.literal .int32 0)) (ExactLengthOps217.word_nonzero _)

theorem decrement (s : State) (n : Nat) (bound : n<2^64) (positive : 0<n) (cell : Cell s "xlen".toList n) :
    Exec dec s ⟨step s (n-1),.normal⟩ := by
  have value := index_eval s n bound positive cell
  exact .word _ _ _ (.modular _ _ _ (.base _ _ _ (.scalar _ _ _
    (.assign _ _ _ .uint64 (some (.uint64 (word n))) (.uint64 (word (n-1))) cell value))))

theorem ret_run (s : State) (n : Nat) (cell : Cell s "xlen".toList n) :
    Exec ret s ⟨s,.returned (some (.uint64 (word n)))⟩ :=
  .word _ _ _ (.ret _ _ _ (.scalar _ _ (.variable _ _ _ cell)))

theorem scan (W : Nat → BitVec 32) (n : Nat) (bound : n<2^64) (s : State) (root : ArrayPointer)
    (cell : Cell s "xlen".toList n) (binding : s.arrays "x".toList=some root)
    (capacity : root.index+n ≤ root.count) (data : Data s root n W) :
    ∃ out, Exec loop s out ∧ out.state.heap=s.heap ∧
      (if highest W n=0 then out.flow=.normal ∧ Cell out.state "xlen".toList 0
       else out.flow=.returned (some (.uint64 (word (highest W n))))) := by
  classical
  induction n generalizing s with
  | zero =>
    refine ⟨⟨s,.normal⟩,.loopFalse _ _ _ s _ (by simpa using guard s 0 bound cell) rfl,rfl,?_⟩
    simpa [highest] using cell
  | succ k ih =>
    have positive : 0<k+1 := by omega
    have decision := test_eval s root W (k+1) bound positive cell binding capacity data
    by_cases hit : nonzero (W k)
    · have selected : KeygenWordExpr.Eval s test (.int32 1) := by simpa [hit,C99ScalarReference.boolean] using decision
      have returned : Exec ret s ⟨s,.returned (some (.uint64 (word (k+1))))⟩ := ret_run s (k+1) cell
      have yesRun : Exec yes s ⟨s,.returned (some (.uint64 (word (k+1))))⟩ := by
        have inner : Exec (.seq ret ZintNormWord194.wskip) s ⟨s,.returned (some (.uint64 (word (k+1))))⟩ :=
          .seqExit _ _ _ _ returned (by intro impossible; cases impossible)
        simpa only [ExactLengthProgram217.yes,ExactLengthProgram217.body,ZintNormWord194.restore_empty] using (Exec.scope [] [] _ s _ inner)
      have branch : Exec (.branch test yes ZintNormWord194.wskip) s ⟨s,.returned (some (.uint64 (word (k+1))))⟩ :=
        .branchTrue _ _ _ _ _ (.int32 1) selected (by decide) yesRun
      have bodyRun : Exec body s ⟨s,.returned (some (.uint64 (word (k+1))))⟩ := by
        have inner : Exec (.seq (.branch test yes ZintNormWord194.wskip) (.seq dec ZintNormWord194.wskip)) s
            ⟨s,.returned (some (.uint64 (word (k+1))))⟩ := .seqExit _ _ _ _ branch (by intro impossible; cases impossible)
        simpa only [ExactLengthProgram217.yes,ExactLengthProgram217.body,ZintNormWord194.restore_empty] using (Exec.scope [] [] _ s _ inner)
      refine ⟨⟨s,.returned (some (.uint64 (word (k+1))))⟩,?_,rfl,?_⟩
      · exact .loopReturn _ _ _ s s (.int32 1) (some (.uint64 (word (k+1))))
          (by simpa [C99ScalarReference.boolean] using guard s (k+1) bound cell) (by decide) bodyRun
      · simp [highest,hit]
    · have selected : KeygenWordExpr.Eval s test (.int32 0) := by simpa [hit,C99ScalarReference.boolean] using decision
      have branch : Exec (.branch test yes ZintNormWord194.wskip) s ⟨s,.normal⟩ :=
        .branchFalse _ _ _ _ _ (.int32 0) selected rfl (ZintNormWord194.word_skip s)
      have bodyRun : Exec body s ⟨step s k,.normal⟩ := by
        have inner : Exec (.seq (.branch test yes ZintNormWord194.wskip) (.seq dec ZintNormWord194.wskip)) s ⟨step s k,.normal⟩ :=
          .seqNormal _ _ _ _ _ branch (.seqNormal _ _ _ _ _ (by simpa using decrement s (k+1) bound positive cell) (ZintNormWord194.word_skip _))
        simpa only [ExactLengthProgram217.yes,ExactLengthProgram217.body,ZintNormWord194.restore_empty] using (Exec.scope [] [] _ s _ inner)
      have subBound : k<2^64 := by omega
      have subBinding : (step s k).arrays "x".toList=some root := binding
      have subData : Data (step s k) root k W := by
        intro i ib
        exact data i (by omega)
      obtain ⟨out,rest,heap,flow⟩:=ih subBound (step s k) (counter s k subBound) subBinding (by omega) subData
      refine ⟨out,?_,heap,?_⟩
      · exact .loopNormal _ _ _ s (step s k) (step s k) out (.int32 1)
          (by simpa [C99ScalarReference.boolean] using guard s (k+1) bound cell) (by decide) bodyRun (ZintNormWord194.word_skip _) rest
      · simpa [highest,hit] using flow

end FT1536.Source3.ExactLengthLoop217
