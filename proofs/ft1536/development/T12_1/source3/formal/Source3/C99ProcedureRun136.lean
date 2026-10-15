import Source3.C99ArraySteps136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ProcedureRun136
open C99CompactState115 (State reference)
open C99ProcedureReference (Stmt)
open C99ValueBridge (value)

/- A successful finite check certifies a normal source path with every
   original guard. Unsupported returns/calls and exhausted fuel yield none. -/
def run (calls : B20.C.Scalar.Calls) : Nat → Stmt → State → Option State
  | 0, _, _ => none
  | _+1, .base code, before => C99ArraySteps136.step calls before code
  | fuel+1, .seq first second, before => do run calls fuel second (← run calls fuel first before)
  | fuel+1, .scope locals pointers body, before =>
      (run calls fuel body before).map (fun after => C99CompactState115.restoreScope before after locals pointers)
  | fuel+1, .branch condition yes no, before => do
      let out ← C99ScalarCompute130.evaluate before.locals condition
      if out.integer=0 then run calls fuel no before else run calls fuel yes before
  | fuel+1, .loop condition body increment, before => do
      let out ← C99ScalarCompute130.evaluate before.locals condition
      if out.integer=0 then some before else do
        let middle ← run calls fuel body before
        let next ← run calls fuel increment middle
        run calls fuel (.loop condition body increment) next
  | _, _, _ => none

theorem sound (program : C99ProcedureReference.Program) (calls : B20.C.Scalar.Calls)
    (callsSound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls)
    (fuel : Nat) (code : Stmt) (before after : State) (computed : run calls fuel code before=some after) :
    C99ProcedureReference.Exec program code (reference before) ⟨reference after,.normal⟩ := by
  induction fuel generalizing code before after with
  | zero => cases computed
  | succ fuel ih =>
    cases code with
    | base code => exact .base _ _ _ (C99ArraySteps136.step_sound _ calls callsSound before after code computed)
    | seq first second =>
      obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
      exact .seqNormal _ _ _ _ _ (ih first before middle head) (ih second middle after tail)
    | scope locals pointers body =>
      obtain ⟨middle,inner,same⟩ := Option.map_eq_some_iff.mp computed
      subst after
      rw [C99CompactState115.reference_restoreScope]
      exact .scope _ _ _ _ _ (ih body before middle inner)
    | branch condition yes no =>
      obtain ⟨out,guard,rest⟩ := Option.bind_eq_some_iff.mp computed
      have evaluated := C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls before.locals condition out guard
      by_cases zero : out.integer=0
      · exact .branchFalse _ _ _ _ _ (value out) evaluated
          (by simpa only [C99ValueBridge.integer_matches] using zero) (ih no before after (by simpa [zero] using rest))
      · exact .branchTrue _ _ _ _ _ (value out) evaluated
          (by simpa only [C99ValueBridge.integer_matches] using zero) (ih yes before after (by simpa [zero] using rest))
    | loop condition body increment =>
      obtain ⟨out,guard,rest⟩ := Option.bind_eq_some_iff.mp computed
      have evaluated := C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls before.locals condition out guard
      by_cases zero : out.integer=0
      · have same : before=after := Option.some.inj (by simpa [zero] using rest)
        subst after
        exact .loopFalse _ _ _ _ (value out) evaluated (by simpa only [C99ValueBridge.integer_matches] using zero)
      · have continued : (do
            let middle ← run calls fuel body before
            let next ← run calls fuel increment middle
            run calls fuel (.loop condition body increment) next)=some after := by simpa [zero] using rest
        obtain ⟨middle,iteration,tail⟩ := Option.bind_eq_some_iff.mp continued
        obtain ⟨next,update,finish⟩ := Option.bind_eq_some_iff.mp tail
        exact .loopNormal _ _ _ _ _ _ _ (value out) evaluated
          (by simpa only [C99ValueBridge.integer_matches] using zero)
          (ih body before middle iteration) (ih increment middle next update)
          (ih (.loop condition body increment) next after finish)
    | ret | breakLoop | continueLoop | call => cases computed

end FT1536.Source3.C99ProcedureRun136
