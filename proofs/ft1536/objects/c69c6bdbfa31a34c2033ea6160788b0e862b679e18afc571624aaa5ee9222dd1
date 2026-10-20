import Source3.KeygenCapWords
import Source3.C99SequenceInversion
import Source3.C99ProcedureScalars

namespace FT1536.Source3.KeygenCapExecution
open C99ArrayReference (State)
open C99ProcedureReference
open KeygenCapWords

def abortFlow : Flow := .returned (some (.int32 0))
def result (before : State) (i : Nat) : Result :=
  if KeygenAttemptCap.limit < i+1 then ⟨advanced before i,abortFlow⟩ else ⟨advanced before i,.normal⟩

theorem rejected_result (program : Program) (before : State) (out : Result)
    (source : Exec program KeygenAttemptCap.rejected before out) : out=⟨before,abortFlow⟩ := by
  cases source with
  | scope _ _ _ _ inner body =>
      cases body with
      | seqNormal _ _ _ middle _ first second =>
          obtain ⟨value,_,he⟩ := C99ProcedureReference.return_inversion program _ before ⟨middle,.normal⟩ first
          cases he
      | seqExit _ _ _ _ first exit =>
          cases first with
          | returnValue _ _ v evaluated =>
              cases evaluated with
              | scalar _ _ evaluated => cases evaluated; rfl

theorem branch_result (program : Program) (before : State) (i : Nat) (out : Result)
    (hi : i≤KeygenAttemptCap.limit+1) (counter : Count before i)
    (source : Exec program (.branch KeygenAttemptCap.condition KeygenAttemptCap.rejected KeygenAttemptCap.skip) before out) :
    out=(if KeygenAttemptCap.limit < i then ⟨before,abortFlow⟩ else ⟨before,.normal⟩) := by
  cases source with
  | branchTrue condition yes no before out v guard nonzero body =>
      have hv := KeygenCapWords.guard_value before i v hi counter guard
      have hlt : KeygenAttemptCap.limit < i := by
        by_contra h
        rw [hv] at nonzero
        simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero
      rw [ite_eq_left hlt]
      exact rejected_result program before out body
  | branchFalse condition yes no before out v guard zero body =>
      have hv := KeygenCapWords.guard_value before i v hi counter guard
      have hle : ¬KeygenAttemptCap.limit < i := by
        intro h
        rw [hv] at zero
        simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at zero
      rw [ite_eq_right hle]
      exact C99ProcedureScalars.skip_result program before out body

theorem source_result (program : Program) (before : State) (i : Nat) (out : Result)
    (hi : i≤KeygenAttemptCap.limit) (counter : Count before i)
    (source : Exec program KeygenAttemptCap.code before out) : out=result before i := by
  have tail := C99SequenceInversion.continuation program KeygenAttemptCap.increment
    (.branch KeygenAttemptCap.condition KeygenAttemptCap.rejected KeygenAttemptCap.skip) before (advanced before i) out
    (fun after h => KeygenCapWords.source_increment program before i after hi counter h) source
  exact branch_result program (advanced before i) (i+1) out (by omega) (advanced_count before i) tail

theorem successful_continuation (program : Program) (tail : Stmt) (before : State) (i : Nat) (out : Result)
    (hi : i≤KeygenAttemptCap.limit) (counter : Count before i)
    (source : Exec program (.seq KeygenAttemptCap.code tail) before out)
    (notAborted : out.flow≠abortFlow) :
    i<KeygenAttemptCap.limit ∧ Exec program tail (advanced before i) out := by
  cases source with
  | seqNormal first second before middle out head rest =>
      have he := source_result program before i ⟨middle,.normal⟩ hi counter head
      have hlt : i<KeygenAttemptCap.limit := by
        by_contra h
        have hover : KeygenAttemptCap.limit < i+1 := by omega
        rw [result,ite_eq_left hover] at he
        have hf := congrArg Result.flow he
        cases hf
      have hnot : ¬KeygenAttemptCap.limit < i+1 := by omega
      rw [result,ite_eq_right hnot] at he
      have hm := congrArg Result.state he
      change middle=advanced before i at hm
      subst middle
      exact ⟨hlt,rest⟩
  | seqExit first second before out head exit =>
      have he := source_result program before i out hi counter head
      by_cases hover : KeygenAttemptCap.limit < i+1
      · rw [result,ite_eq_left hover] at he
        exact False.elim (notAborted (congrArg Result.flow he))
      · rw [result,ite_eq_right hover] at he
        exact False.elim (exit (congrArg Result.flow he))

end FT1536.Source3.KeygenCapExecution
