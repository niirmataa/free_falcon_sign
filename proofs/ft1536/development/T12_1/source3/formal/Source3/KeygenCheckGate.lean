import Source3.KeygenCheckExpression

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenCheckGate
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ModularReference (Stmt Exec)
open C99ProcedureReference (Result Flow)

def abortFlow : Flow := .returned (some (.int32 0))
def verdict (out target : BitVec 32) : Flow := if out=target then .normal else abortFlow

theorem comparison_value (s : State) (out target : BitVec 32) (value : Value)
    (z : s.locals "z".toList=some (.uint32,some (.uint32 out)))
    (r : s.locals "r".toList=some (.uint32,some (.uint32 target)))
    (source : C99ArrayReference.scalar s KeygenCheckProgram.condition value) :
    value=C99ScalarReference.boolean (decide (out≠target)) := by
  change C99ScalarReference.Eval _ _ (.compare .ne (.variable "z".toList) (.variable "r".toList)) value at source
  cases source with
  | compare op a b x y value hx hy operation =>
      have he := C99CountedWords.variable_exact s "z".toList .uint32 (.uint32 out) x z hx
      have hf := C99CountedWords.variable_exact s "r".toList .uint32 (.uint32 target) y r hy
      subst x
      subst y
      have hv := C99CountedWords.comparison_result .ne (.uint32 out) (.uint32 target) value operation
      change value=C99ScalarReference.boolean
        (C99IntegerReference.compare .ne
          (C99IntegerReference.convert (Value.uint32 out).type (Value.uint32 out).integer).integer
          (C99IntegerReference.convert (Value.uint32 target).type (Value.uint32 target).integer).integer) at hv
      rw [C99CountedWords.convert_self,C99CountedWords.convert_self] at hv
      change value=C99ScalarReference.boolean (decide ((out.toNat : Int)≠(target.toNat : Int))) at hv
      have hn : ((out.toNat : Int)≠(target.toNat : Int)) ↔ out≠target := by
        constructor
        · intro h equal; subst target; exact h rfl
        · intro h equal; exact h (BitVec.eq_of_toNat_eq (by omega))
      simpa only [hn] using hv

theorem return_literal (n : Nat) (s : State) (result : Result)
    (source : Exec (.ret (.scalar (.literal .i32 n))) s result) :
    result=⟨s,.returned (some (C99IntegerReference.convert .int32 n))⟩ := by
  cases source with
  | ret _ _ v value => cases value with | scalar _ _ source => cases source; rfl

theorem rejected_result (s : State) (result : Result) (source : Exec KeygenCheckProgram.rejected s result) :
    result=⟨s,abortFlow⟩ := by
  cases source with
  | scope _ _ _ inner body =>
      have hi : inner=⟨s,abortFlow⟩ := by
        cases body with
        | seqNormal _ _ _ middle _ first _ =>
            have hf := congrArg Result.flow (return_literal 0 s ⟨middle,.normal⟩ first)
            cases hf
        | seqExit _ _ _ _ first _ => exact return_literal 0 s inner first
      rw [hi]
      rfl

theorem source_result (s : State) (out target : BitVec 32) (result : Result)
    (z : s.locals "z".toList=some (.uint32,some (.uint32 out)))
    (r : s.locals "r".toList=some (.uint32,some (.uint32 target)))
    (source : Exec KeygenCheckProgram.gate s result) : result=⟨s,verdict out target⟩ := by
  cases source with
  | branchTrue condition yes no before result v guard nonzero body =>
      have hv := comparison_value s out target v z r guard
      have different : out≠target := by
        intro equal
        rw [hv] at nonzero
        simp [equal,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero
      rw [verdict,ite_eq_right different]
      exact rejected_result s result body
  | branchFalse condition yes no before result v guard zero body =>
      have hv := comparison_value s out target v z r guard
      have equal : out=target := by
        by_contra different
        rw [hv] at zero
        simp [different,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at zero
      rw [verdict,ite_eq_left equal]
      exact C99ModularReference.skip_result s result body

theorem gate_then_skip (s : State) (out target : BitVec 32) (result : Result)
    (z : s.locals "z".toList=some (.uint32,some (.uint32 out)))
    (r : s.locals "r".toList=some (.uint32,some (.uint32 target)))
    (source : Exec (.seq KeygenCheckProgram.gate KeygenCheckProgram.skip) s result) :
    result=⟨s,verdict out target⟩ := by
  cases source with
  | seqNormal _ _ _ middle _ head tail =>
      have he := source_result s out target ⟨middle,.normal⟩ z r head
      have hm := congrArg Result.state he
      change middle=s at hm
      subst middle
      exact (C99ModularReference.skip_result s result tail).trans he
  | seqExit _ _ _ _ head _ => exact source_result s out target result z r head

end FT1536.Source3.KeygenCheckGate
