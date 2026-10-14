import Source3.ShakeExtractCopy120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractRun120
open C99CompactState115 (State reference)
open ShakeExtractSource (Layout Stmt field)
open ShakeBlockComputeRead116 (evaluate evaluate_sound)

/-- A successful computation constructs a finite original source execution.
    Fuel exhaustion is not a source failure or nonreturn claim. -/
def run (ctx : Layout) : Nat → Stmt → State → Option State
  | 0, _, _ => none
  | _+1, .scalar code, state => ShakeBlockCompute116.scalar state code
  | _+1, .declarePointer name, state => some (C99CompactPointer115.declarePointer state name)
  | _+1, .pointer dst src index, state => ShakeSeedBasic118.pointer state dst src index
  | _+1, .fieldPointer dst member, state => some (C99CompactState115.bindPointer state dst (field ctx member))
  | _+1, .fieldRead dst member, state => ShakeSeedBasic118.readLocal ctx state dst member
  | _+1, .fieldStore member value, state => ShakeExtractBasic120.fieldStore ctx state member value
  | fuel+1, .process src, state => ShakeExtractCalls120.process fuel state src
  | _+1, .encode dst index value, state => ShakeExtractCalls120.encode state dst index value
  | _+1, .copy dst index count, state => ShakeExtractCopy120.copy ctx state dst index count
  | _+1, .skip, state => some state
  | fuel+1, .seq first second, state => do run ctx fuel second (←run ctx fuel first state)
  | fuel+1, .scope locals pointers body, state =>
      (run ctx fuel body state).map (fun after => C99CompactState115.restoreScope state after locals pointers)
  | fuel+1, .branch condition yes no, state => do
      let value ← evaluate state condition
      run ctx fuel (if value.integer=0 then no else yes) state
  | fuel+1, .loop condition body, state => do
      let value ← evaluate state condition
      if value.integer=0 then pure state else do
        run ctx fuel (.loop condition body) (←run ctx fuel body state)

theorem run_sound (ctx : Layout) (fuel : Nat) (code : Stmt) (before after : State)
    (computed : run ctx fuel code before=some after) :
    ShakeExtractSource.Exec ctx code (reference before) (reference after) := by
  induction fuel generalizing code before after with
  | zero => cases computed
  | succ fuel ih =>
      cases code with
      | scalar code => exact ShakeExtractBasic120.scalar_sound ctx before after code computed
      | declarePointer name =>
          have same := Option.some.inj computed
          subst after
          rw [C99CompactPointer115.declarePointer_reference]
          exact .declarePointer _ _
      | pointer dst src index => exact ShakeExtractBasic120.pointer_sound ctx before after dst src index computed
      | fieldPointer dst member =>
          have same := Option.some.inj computed
          subst after
          rw [C99CompactState115.reference_bindPointer]
          exact .fieldPointer _ _ _
      | fieldRead dst member => exact ShakeExtractBasic120.fieldRead_sound ctx before after dst member computed
      | fieldStore member value => exact ShakeExtractBasic120.fieldStore_sound ctx before after member value computed
      | process src => exact ShakeExtractCalls120.process_sound ctx fuel before after src computed
      | encode dst index value => exact ShakeExtractCalls120.encode_sound ctx before after dst index value computed
      | copy dst index count => exact ShakeExtractCopy120.copy_sound ctx before after dst index count computed
      | skip =>
          have same := Option.some.inj computed
          subst after
          exact .skip _
      | seq first second =>
          obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
          exact .seq first second (reference before) (reference middle) (reference after)
            (ih first before middle head) (ih second middle after tail)
      | scope locals pointers body =>
          obtain ⟨middle,inner,result⟩ := Option.map_eq_some_iff.mp computed
          subst after
          rw [C99CompactState115.reference_restoreScope]
          exact .scope locals pointers body (reference before) (reference middle) (ih body before middle inner)
      | branch condition yes no =>
          obtain ⟨value,guard,body⟩ := Option.bind_eq_some_iff.mp computed
          have evaluated := evaluate_sound before condition value guard
          by_cases zero : value.integer=0
          · simp only [zero,ite_true] at body
            exact .branchFalse condition yes no (reference before) (reference after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih no before after body)
          · simp only [zero,ite_false] at body
            exact .branchTrue condition yes no (reference before) (reference after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih yes before after body)
      | loop condition body =>
          obtain ⟨value,guard,rest⟩ := Option.bind_eq_some_iff.mp computed
          have evaluated := evaluate_sound before condition value guard
          by_cases zero : value.integer=0
          · simp only [zero,ite_true] at rest
            have same := Option.some.inj rest
            subst after
            exact .loopFalse condition body (reference before) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero)
          · simp only [zero,ite_false] at rest
            obtain ⟨middle,iteration,following⟩ := Option.bind_eq_some_iff.mp rest
            exact .loopNext condition body (reference before) (reference middle) (reference after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero)
              (ih body before middle iteration) (ih (.loop condition body) middle after following)

end FT1536.Source3.ShakeExtractRun120
