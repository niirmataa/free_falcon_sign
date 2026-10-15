import Source3.KeygenWordRun130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordRunSound130
open C99CompactState115 (State reference)
open C99ValueBridge (value)
open KeygenWordExec (Stmt Exec)
open KeygenWordRun130 (run result Result)

theorem sound (fuel : Nat) (code : Stmt) (before : State) (out : Result)
    (computed : run fuel code before=some out) : Exec code (reference before) (result out) := by
  induction fuel generalizing code before out with
  | zero => cases computed
  | succ fuel ih =>
      cases code with
      | modular code =>
          obtain ⟨after,source,same⟩ := Option.map_eq_some_iff.mp computed
          subst out
          exact .modular code (reference before) _ (C99ScalarSteps130.run_sound fuel code before after source)
      | assign name expr =>
          obtain ⟨after,source,same⟩ := Option.map_eq_some_iff.mp computed
          subst out
          exact KeygenWordSteps130.assign_sound before after name expr source
      | store name index expr =>
          obtain ⟨after,source,same⟩ := Option.map_eq_some_iff.mp computed
          subst out
          exact KeygenWordSteps130.store_sound before after name index expr source
      | seq first second =>
          obtain ⟨head,source,rest⟩ := Option.bind_eq_some_iff.mp computed
          rcases head with ⟨middle,returned⟩
          dsimp only at rest
          cases returned with
          | none =>
              exact .seqNormal first second (reference before) (reference middle) (result out)
                (ih first before (middle,none) source) (ih second middle out rest)
          | some returned =>
              have same := Option.some.inj rest
              subst out
              exact .seqExit first second (reference before) _
                (ih first before (middle,some returned) source) (by intro impossible; cases impossible)
      | scope locals body =>
          obtain ⟨middle,source,rest⟩ := Option.bind_eq_some_iff.mp computed
          have same := Option.some.inj rest
          subst out
          simpa only [result,C99CompactState115.reference_restoreScope] using
            (Exec.scope locals body (reference before) (result middle) (ih body before middle source))
      | branch condition yes no =>
          obtain ⟨guardValue,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
          have guard := KeygenWordComputeSound130.sound before condition guardValue evaluated
          split at rest
          next zero =>
            exact .branchFalse condition yes no (reference before) (result out) (value guardValue) guard
              (by simpa only [C99ValueBridge.integer_matches] using zero) (ih no before out rest)
          next nonzero =>
            exact .branchTrue condition yes no (reference before) (result out) (value guardValue) guard
              (by simpa only [C99ValueBridge.integer_matches] using nonzero) (ih yes before out rest)
      | loop condition body increment =>
          obtain ⟨guardValue,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
          have guard := KeygenWordComputeSound130.sound before condition guardValue evaluated
          split at rest
          next zero =>
            have same := Option.some.inj rest
            subst out
            exact .loopFalse condition body increment (reference before) (value guardValue) guard
              (by simpa only [C99ValueBridge.integer_matches] using zero)
          next nonzero =>
            have positive : (value guardValue).integer≠0 := by
              simpa only [C99ValueBridge.integer_matches] using nonzero
            obtain ⟨head,source,rest⟩ := Option.bind_eq_some_iff.mp rest
            rcases head with ⟨middle,returned⟩
            dsimp only at rest
            cases returned with
            | some returned =>
                have same := Option.some.inj rest
                subst out
                exact .loopReturn condition body increment (reference before) (reference middle)
                  (value guardValue) (value returned) guard positive
                  (ih body before (middle,some returned) source)
            | none =>
                obtain ⟨next,updated,rest⟩ := Option.bind_eq_some_iff.mp rest
                rcases next with ⟨last,returned⟩
                dsimp only at rest
                cases returned with
                | some returned => cases rest
                | none =>
                    exact .loopNormal condition body increment (reference before) (reference middle) (reference last)
                      (result out) (value guardValue) guard positive (ih body before (middle,none) source)
                      (ih increment middle (last,none) updated) (ih (.loop condition body increment) last out rest)
      | ret expr =>
          obtain ⟨returned,evaluated,same⟩ := Option.map_eq_some_iff.mp computed
          subst out
          exact .ret expr (reference before) (value returned) (KeygenWordComputeSound130.sound before expr returned evaluated)

end FT1536.Source3.KeygenWordRunSound130
