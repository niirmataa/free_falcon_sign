import Source3.ShakeBlockComputeRead116

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeBlockCompute116
open C99MemoryReference
open C99CompactState115 (State reference)
open ShakeBlock (Stmt)
open ShakeBlockComputeRead116 (calls calls_sound evaluate evaluate_sound)

def scalar (state : State) (code : CLogic.Stmt) : Option State :=
  (C99CompactScalar115.step (calls state) state.locals code).map (fun locals => {state with locals := locals})

theorem scalar_sound (before after : State) (code : CLogic.Stmt) (computed : scalar before code=some after) :
    ShakeBlock.Exec (.scalar code) (reference before) (reference after) := by
  obtain ⟨locals, step, result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_locals]
  exact .scalar code (reference before) (C99CompactCells115.environment locals)
    (C99CompactScalar115.step_sound (ShakeBlock.ReadCall (reference before)) (calls before)
      (calls_sound before) before.locals locals code step)

def WriteGuard (state : State) (pointer : ArrayPointer) : Prop :=
  Allocated (C99FiniteMemory114.memory state.heap) pointer ∧ pointer.elementBytes=8 ∧
  (C99FiniteMemory114.memory state.heap).writable pointer.block=true

instance writeGuardDecidable (state : State) (pointer : ArrayPointer) : Decidable (WriteGuard state pointer) := by
  unfold WriteGuard
  infer_instance

def write (state : State) (name : C99ArrayReference.Name) (index value : CLogic.Expr) : Option State := do
  let pointer ← C99CompactPointer115.pointer C99CompactPointer115.noCalls state name index
  let word ← evaluate state value
  if WriteGuard state pointer then
    pure {state with heap := C99FiniteWrite114.write64 state.heap pointer (BitVec.ofInt 64 word.integer)}
  else none

theorem write_sound (before after : State) (name : C99ArrayReference.Name) (index value : CLogic.Expr)
    (computed : write before name index value=some after) :
    ShakeBlock.Exec (.store name index value) (reference before) (reference after) := by
  obtain ⟨pointer, address, tail⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨word, evaluated, result⟩ := Option.bind_eq_some_iff.mp tail
  split at result
  next guard =>
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_heap]
    refine .store name index value (reference before) _ pointer (C99ValueBridge.value word)
      (C99CompactPointer115.pointer_sound C99CompactPointer115.noCalls (C99CompactPointer115.noCalls_sound _)
        before name index pointer address) (evaluate_sound before value word evaluated) ?_
    simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using
      C99FiniteWrite114.write64_sound before.heap pointer (BitVec.ofInt 64 word.integer) guard.1 guard.2.1 guard.2.2
  next rejected => cases result

/-- Finite fuel is only a witness-checking bound. None is NOT interpreted
    as source failure or nonreturn. Successful evaluation is proved sound. -/
def run : Nat → Stmt → State → Option State
  | 0, _, _ => none
  | _+1, .scalar code, state => scalar state code
  | _+1, .store name index value, state => write state name index value
  | _+1, .skip, state => some state
  | fuel+1, .seq first second, state => do run fuel second (← run fuel first state)
  | fuel+1, .scope locals body, state =>
      (run fuel body state).map (fun after => C99CompactState115.restoreScope state after locals [])
  | fuel+1, .loop condition body increment, state => do
      let value ← evaluate state condition
      if value.integer=0 then pure state else do
        let middle ← run fuel body state
        let next ← run fuel increment middle
        run fuel (.loop condition body increment) next

theorem run_sound (fuel : Nat) (code : Stmt) (before after : State)
    (computed : run fuel code before=some after) : ShakeBlock.Exec code (reference before) (reference after) := by
  induction fuel generalizing code before after with
  | zero => cases computed
  | succ fuel ih =>
      cases code with
      | scalar code => exact scalar_sound before after code computed
      | store name index value => exact write_sound before after name index value computed
      | skip =>
          have same := Option.some.inj computed
          subst after
          exact .skip _
      | seq first second =>
          obtain ⟨middle, head, tail⟩ := Option.bind_eq_some_iff.mp computed
          exact .seq first second (reference before) (reference middle) (reference after)
            (ih first before middle head) (ih second middle after tail)
      | scope locals body =>
          obtain ⟨middle, bodyRun, result⟩ := Option.map_eq_some_iff.mp computed
          subst after
          rw [C99CompactState115.reference_restoreScope]
          exact .scope locals body (reference before) (reference middle) (ih body before middle bodyRun)
      | loop condition body increment =>
          obtain ⟨value, guard, rest⟩ := Option.bind_eq_some_iff.mp computed
          have evaluated := evaluate_sound before condition value guard
          by_cases zero : value.integer=0
          · simp only [zero,ite_true] at rest
            have same := Option.some.inj rest
            subst after
            exact .loopFalse condition body increment (reference before) (C99ValueBridge.value value) evaluated
              (by simpa only [C99ValueBridge.integer_matches] using zero)
          · simp only [zero,ite_false] at rest
            obtain ⟨middle, bodyRun, rest⟩ := Option.bind_eq_some_iff.mp rest
            obtain ⟨next, incrementRun, loopRun⟩ := Option.bind_eq_some_iff.mp rest
            exact .loopNext condition body increment (reference before) (reference middle) (reference next)
              (reference after) (C99ValueBridge.value value) evaluated
              (by simpa only [C99ValueBridge.integer_matches] using zero)
              (ih body before middle bodyRun) (ih increment middle next incrementRun)
              (ih (.loop condition body increment) next after loopRun)

end FT1536.Source3.ShakeBlockCompute116
