import Source3.ShakeSeedMemory118

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeSeedRun118
open C99CompactState115 (State reference)
open ShakeExtractSource (Layout field)
open ShakeSeedProgram (Stmt)
open ShakeSeedRead118 (evaluate evaluate_sound)

/-- Computation follows the original source grammar. Fuel failure is only
    absence of a checked finite witness, not a source failure assertion. -/
def run (ctx : Layout) : Nat → Stmt → State → Option State
  | 0, _, _ => none
  | _+1, .scalar code, state => ShakeSeedBasic118.scalar ctx state code
  | _+1, .declarePointer name, state => some (C99CompactPointer115.declarePointer state name)
  | _+1, .pointer dst src index, state => ShakeSeedBasic118.pointer state dst src index
  | _+1, .readLocal dst member, state => ShakeSeedBasic118.readLocal ctx state dst member
  | _+1, .write member value, state => ShakeSeedBasic118.writeField ctx state member value
  | _+1, .store member index value, state => ShakeSeedStores118.store ctx state member index value
  | _+1, .postByte value, state => ShakeSeedStores118.postByte ctx state value
  | _+1, .fill member start count, state => ShakeSeedMemory118.fill ctx state member start count
  | _+1, .copyData start count, state => ShakeSeedMemory118.copyData ctx state start count
  | fuel+1, .xor expression, state => do
      let value ← evaluate ctx state expression
      ShakeXorCompute117.invoke fuel state (field ctx .a) (field ctx .dbuf) value
  | fuel+1, .process, state => ShakeProcessCompute116.process fuel state (field ctx .a)
  | _+1, .skip, state => some state
  | fuel+1, .seq first second, state => do run ctx fuel second (←run ctx fuel first state)
  | fuel+1, .scope locals pointers body, state =>
      (run ctx fuel body state).map (fun after => C99CompactState115.restoreScope state after locals pointers)
  | fuel+1, .branch condition yes no, state => do
      let value ← evaluate ctx state condition
      run ctx fuel (if value.integer=0 then no else yes) state
  | fuel+1, .loop condition body, state => do
      let value ← evaluate ctx state condition
      if value.integer=0 then pure state else do
        run ctx fuel (.loop condition body) (←run ctx fuel body state)

theorem run_sound (ctx : Layout) (fuel : Nat) (code : Stmt) (before after : State)
    (computed : run ctx fuel code before=some after) :
    ShakeSeedReference.Exec ctx code (reference before) (reference after) := by
  induction fuel generalizing code before after with
  | zero => cases computed
  | succ fuel ih =>
      cases code with
      | scalar code => exact ShakeSeedBasic118.scalar_sound ctx before after code computed
      | declarePointer name =>
          have same := Option.some.inj computed
          subst after
          rw [C99CompactPointer115.declarePointer_reference]
          exact .declarePointer _ _
      | pointer dst src index => exact ShakeSeedBasic118.pointer_sound ctx before after dst src index computed
      | readLocal dst member => exact ShakeSeedBasic118.readLocal_sound ctx before after dst member computed
      | write member value => exact ShakeSeedBasic118.writeField_sound ctx before after member value computed
      | store member index value => exact ShakeSeedStores118.store_sound ctx before after member index value computed
      | postByte value => exact ShakeSeedStores118.postByte_sound ctx before after value computed
      | fill member start count => exact ShakeSeedMemory118.fill_sound ctx before after member start count computed
      | copyData start count => exact ShakeSeedMemory118.copyData_sound ctx before after start count computed
      | xor expression =>
          obtain ⟨value,evaluated,body⟩ := Option.bind_eq_some_iff.mp computed
          exact .xor (reference before) (reference after) expression (C99ValueBridge.value value)
            (evaluate_sound ctx before expression value evaluated)
            (ShakeXorCompute117.invoke_sound fuel before after (field ctx .a) (field ctx .dbuf) value body)
      | process => exact .process _ _ (ShakeProcessCompute116.process_sound fuel before after (field ctx .a) computed)
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
          have evaluated := evaluate_sound ctx before condition value guard
          by_cases zero : value.integer=0
          · simp only [zero,ite_true] at body
            exact .branchFalse condition yes no (reference before) (reference after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih no before after body)
          · simp only [zero,ite_false] at body
            exact .branchTrue condition yes no (reference before) (reference after) (C99ValueBridge.value value)
              evaluated (by simpa only [C99ValueBridge.integer_matches] using zero) (ih yes before after body)
      | loop condition body =>
          obtain ⟨value,guard,rest⟩ := Option.bind_eq_some_iff.mp computed
          have evaluated := evaluate_sound ctx before condition value guard
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

end FT1536.Source3.ShakeSeedRun118
