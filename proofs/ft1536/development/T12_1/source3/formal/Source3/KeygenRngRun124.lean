import Source3.KeygenRngOps124

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRngRun124
open C99CompactState115 (State reference)
open KeygenSearchContext (Context)
open KeygenRngProgram (Stmt)
open KeygenRngOps124

abbrev Result := State × Option (Option Nat)

def flow : Option (Option Nat) → C99ProcedureReference.Flow
  | none => .normal
  | some value => .returned (value.map (fun n => C99IntegerReference.convert .int32 n))

def referenceResult (out : Result) : C99ProcedureReference.Result := ⟨reference out.1,flow out.2⟩

/-- Successful computation certifies the actually followed source path.
    Unsupported entropy/remix nodes and exhausted fuel give no certificate;
    none is not a claim of source failure or divergence. -/
def run (ctx : Context) (shakeFuel : Nat) : Nat → Stmt → State → Option Result
  | 0, _, _ => none
  | _+1, .skip, state => some (state,none)
  | _+1, .init expr, state => (init ctx shakeFuel state expr).map (fun after => (after,none))
  | _+1, .inject name expr, state => (inject ctx shakeFuel state name expr).map (fun after => (after,none))
  | _+1, .flip, state => (flip ctx shakeFuel state).map (fun after => (after,none))
  | _+1, .storeFlag flag expr, state => (store ctx state flag expr).map (fun after => (after,none))
  | _+1, .ret value, state => some (state,some value)
  | fuel+1, .scope code, state => run ctx shakeFuel fuel code state
  | fuel+1, .seq first second, state => do
      let (middle,exitState) ← run ctx shakeFuel fuel first state
      match exitState with
      | none => run ctx shakeFuel fuel second middle
      | some value => pure (middle,some value)
  | fuel+1, .branchScalar expr yes no, state => do
      let value ← evaluate state expr
      run ctx shakeFuel fuel (if value.integer=0 then no else yes) state
  | fuel+1, .branchFlag flag negated yes no, state => do
      let value ← test ctx state flag negated
      run ctx shakeFuel fuel (if value.integer=0 then no else yes) state
  | _+1, .extractTmp, _ => none
  | _+1, .setSeed _ _ _, _ => none
  | _+1, .branchEntropy _ _, _ => none
  | _+1, .auto32 _, _ => none

theorem run_sound (ctx : Context) (shakeFuel fuel : Nat) (code : Stmt) (before : State) (after : Result)
    (computed : run ctx shakeFuel fuel code before=some after) :
    KeygenRngReference.Exec ctx code (reference before) [] (referenceResult after) := by
  induction fuel generalizing code before after with
  | zero => cases computed
  | succ fuel ih =>
      cases code with
      | skip =>
          have same := Option.some.inj computed
          subst after
          exact .skip _
      | init expr =>
          obtain ⟨middle,body,result⟩ := Option.map_eq_some_iff.mp computed
          subst after
          exact init_sound ctx shakeFuel before middle expr body
      | inject name expr =>
          obtain ⟨middle,body,result⟩ := Option.map_eq_some_iff.mp computed
          subst after
          exact inject_sound ctx shakeFuel before middle name expr body
      | flip =>
          obtain ⟨middle,body,result⟩ := Option.map_eq_some_iff.mp computed
          subst after
          exact flip_sound ctx shakeFuel before middle body
      | storeFlag flag expr =>
          obtain ⟨middle,body,result⟩ := Option.map_eq_some_iff.mp computed
          subst after
          exact store_sound ctx before middle flag expr body
      | ret value =>
          have same := Option.some.inj computed
          subst after
          exact .ret _ value
      | scope code => exact .scope code (reference before) [] (referenceResult after) (ih code before after computed)
      | seq first second =>
          obtain ⟨middle,head,rest⟩ := Option.bind_eq_some_iff.mp computed
          rcases middle with ⟨middle,exitState⟩
          cases exitState with
          | none =>
              exact .seqNormal first second (reference before) (reference middle) [] [] (referenceResult after)
                (ih first before (middle,none) head) (ih second middle after rest)
          | some value =>
              have same := Option.some.inj rest
              subst after
              exact .seqExit first second (reference before) [] _ (ih first before (middle,some value) head)
                (by intro equal; cases equal)
      | branchScalar expr yes no =>
          obtain ⟨value,guard,body⟩ := Option.bind_eq_some_iff.mp computed
          have evaluated := evaluate_sound before expr value guard
          by_cases zero : value.integer=0
          · simp only [zero,ite_true] at body
            exact .branchScalarFalse expr yes no (reference before) [] (referenceResult after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih no before after body)
          · simp only [zero,ite_false] at body
            exact .branchScalarTrue expr yes no (reference before) [] (referenceResult after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih yes before after body)
      | branchFlag flag negated yes no =>
          obtain ⟨value,guard,body⟩ := Option.bind_eq_some_iff.mp computed
          have evaluated := test_sound ctx before flag negated value guard
          by_cases zero : value.integer=0
          · simp only [zero,ite_true] at body
            exact .branchFlagFalse flag negated yes no (reference before) [] (referenceResult after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih no before after body)
          · simp only [zero,ite_false] at body
            exact .branchFlagTrue flag negated yes no (reference before) [] (referenceResult after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih yes before after body)
      | extractTmp | setSeed | branchEntropy | auto32 => cases computed

end FT1536.Source3.KeygenRngRun124
