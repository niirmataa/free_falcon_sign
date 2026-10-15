import Source3.ShakeExtractTrace128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractTraceSound128
open C99CompactState115 (State reference)
open ShakeExtractSource (Layout Stmt)
open ShakeProcessEvents128 (Proposal Event All)
open ShakeExtractTrace128 (run ordinary)

theorem ordinary_source (computation : Option State) (after : State) (events : List Event)
    (computed : ordinary computation=some (after,events)) : computation=some after ∧ events=[] := by
  obtain ⟨middle,body,result⟩ := Option.map_eq_some_iff.mp computed
  obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj result
  subst after
  exact ⟨body,sameEvents.symm⟩

/-- All logged calls must be discharged against the ORIGINAL source
    relation. The proposal function itself has no trusted property. -/
theorem run_sound (ctx : Layout) (propose : Proposal) (fuel : Nat) (code : Stmt)
    (before after : State) (events : List Event)
    (computed : run ctx propose fuel code before=some (after,events)) (checked : All ctx events) :
    ShakeExtractSource.Exec ctx code (reference before) (reference after) := by
  induction fuel generalizing code before after events with
  | zero => cases computed
  | succ fuel ih =>
      cases code with
      | scalar code => exact ShakeExtractBasic120.scalar_sound ctx before after code (ordinary_source _ after events computed).1
      | declarePointer name =>
          have pair := Prod.mk.inj (Option.some.inj computed)
          have equal := pair.1
          subst after
          rw [C99CompactPointer115.declarePointer_reference]
          exact .declarePointer _ _
      | pointer dst src index => exact ShakeExtractBasic120.pointer_sound ctx before after dst src index (ordinary_source _ after events computed).1
      | fieldPointer dst member =>
          have equal := (Prod.mk.inj (Option.some.inj computed)).1
          subst after
          rw [C99CompactState115.reference_bindPointer]
          exact .fieldPointer _ _ _
      | fieldRead dst member => exact ShakeExtractBasic120.fieldRead_sound ctx before after dst member (ordinary_source _ after events computed).1
      | fieldStore member value => exact ShakeExtractBasic120.fieldStore_sound ctx before after member value (ordinary_source _ after events computed).1
      | process name => exact ShakeProcessEvents128.request_sound ctx propose before after name events computed checked
      | encode dst index value => exact ShakeExtractCalls120.encode_sound ctx before after dst index value (ordinary_source _ after events computed).1
      | copy dst index count => exact ShakeExtractCopy120.copy_sound ctx before after dst index count (ordinary_source _ after events computed).1
      | skip =>
          have equal := (Prod.mk.inj (Option.some.inj computed)).1
          subst after
          exact .skip _
      | seq first second =>
          obtain ⟨head,firstRun,rest⟩ := Option.bind_eq_some_iff.mp computed
          rcases head with ⟨middle,firstEvents⟩
          dsimp only at rest
          obtain ⟨tail,secondRun,result⟩ := Option.bind_eq_some_iff.mp rest
          rcases tail with ⟨last,secondEvents⟩
          obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj (Option.some.inj result)
          subst after
          subst events
          exact .seq first second (reference before) (reference middle) (reference last)
            (ih first before middle firstEvents firstRun (ShakeProcessEvents128.left ctx _ _ checked))
            (ih second middle last secondEvents secondRun (ShakeProcessEvents128.right ctx _ _ checked))
      | scope locals pointers body =>
          obtain ⟨middleResult,inner,result⟩ := Option.map_eq_some_iff.mp computed
          rcases middleResult with ⟨middle,innerEvents⟩
          obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj result
          subst after
          subst events
          rw [C99CompactState115.reference_restoreScope]
          exact .scope locals pointers body (reference before) (reference middle) (ih body before middle innerEvents inner checked)
      | branch condition yes no =>
          obtain ⟨value,guard,body⟩ := Option.bind_eq_some_iff.mp computed
          have evaluated := ShakeBlockComputeRead116.evaluate_sound before condition value guard
          by_cases zero : value.integer=0
          · simp only [zero,ite_true] at body
            exact .branchFalse condition yes no (reference before) (reference after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih no before after events body checked)
          · simp only [zero,ite_false] at body
            exact .branchTrue condition yes no (reference before) (reference after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih yes before after events body checked)
      | loop condition body =>
          obtain ⟨value,guard,rest⟩ := Option.bind_eq_some_iff.mp computed
          have evaluated := ShakeBlockComputeRead116.evaluate_sound before condition value guard
          by_cases zero : value.integer=0
          · simp only [zero,ite_true] at rest
            have equal := (Prod.mk.inj (Option.some.inj rest)).1
            subst after
            exact .loopFalse condition body (reference before) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero)
          · simp only [zero,ite_false] at rest
            obtain ⟨head,iteration,rest⟩ := Option.bind_eq_some_iff.mp rest
            rcases head with ⟨middle,headEvents⟩
            dsimp only at rest
            obtain ⟨tail,following,result⟩ := Option.bind_eq_some_iff.mp rest
            rcases tail with ⟨last,tailEvents⟩
            obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj (Option.some.inj result)
            subst after
            subst events
            exact .loopNext condition body (reference before) (reference middle) (reference last) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero)
              (ih body before middle headEvents iteration (ShakeProcessEvents128.left ctx _ _ checked))
              (ih (.loop condition body) middle last tailEvents following (ShakeProcessEvents128.right ctx _ _ checked))

end FT1536.Source3.ShakeExtractTraceSound128
