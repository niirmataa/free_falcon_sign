import Source3.C99ArraySteps136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ArrayRun138
open C99CompactState115 (State reference)
open C99ArrayReference (Stmt Exec Program)
open C99ValueBridge (value)

/- Compound scalar/store macro blocks retain their original C scope. -/
def run (calls : B20.C.Scalar.Calls) : Nat → Stmt → State → Option State
  | 0, _, _ => none
  | fuel+1, .seq first second, before => do run calls fuel second (← run calls fuel first before)
  | fuel+1, .scope locals pointers body, before =>
      (run calls fuel body before).map (fun after => C99CompactState115.restoreScope before after locals pointers)
  | fuel+1, .branch condition yes no, before => do
      let out ← C99ScalarCompute130.evaluate before.locals condition
      if out.integer=0 then run calls fuel no before else run calls fuel yes before
  | fuel+1, .while condition body, before => do
      let out ← C99ScalarCompute130.evaluate before.locals condition
      if out.integer=0 then some before else do
        run calls fuel (.while condition body) (← run calls fuel body before)
  | _+1, code, before => C99ArraySteps136.step calls before code

theorem sound (program : Program) (calls : B20.C.Scalar.Calls)
    (callsSound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls)
    (fuel : Nat) (code : Stmt) (before after : State) (computed : run calls fuel code before=some after) :
    Exec program code (reference before) (reference after) := by
  induction fuel generalizing code before after with
  | zero => cases computed
  | succ fuel ih =>
    cases code with
    | seq first second =>
      obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
      exact .seq _ _ _ _ _ (ih first before middle head) (ih second middle after tail)
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
    | «while» condition body =>
      obtain ⟨out,guard,rest⟩ := Option.bind_eq_some_iff.mp computed
      have evaluated := C99ScalarCompute130.evaluate_sound FprPrefixCalls.calls before.locals condition out guard
      by_cases zero : out.integer=0
      · have same : before=after := Option.some.inj (by simpa [zero] using rest)
        subst after
        exact .whileFalse _ _ _ (value out) evaluated (by simpa only [C99ValueBridge.integer_matches] using zero)
      · have continued : (run calls fuel body before).bind (run calls fuel (.while condition body))=some after := by simpa [zero] using rest
        obtain ⟨middle,iteration,tail⟩ := Option.bind_eq_some_iff.mp continued
        exact .whileTrue _ _ _ _ _ (value out) evaluated
          (by simpa only [C99ValueBridge.integer_matches] using zero) (ih body before middle iteration)
          (ih (.while condition body) middle after tail)
    | skip | scalar | assign | declarePtr | bindPtr | store64 | store32 | copy | call =>
      exact C99ArraySteps136.step_sound program calls callsSound before after _ computed

end FT1536.Source3.C99ArrayRun138
