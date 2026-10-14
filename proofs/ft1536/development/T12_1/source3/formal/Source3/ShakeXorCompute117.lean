import Source3.ShakeEncodeCompute117
import Source3.ShakeBlockCompute116

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeXorCompute117
open C99MemoryReference
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open B20.C (Val)

def scalar (state : State) (code : CLogic.Stmt) : Option State :=
  (C99CompactScalar115.step noCalls state.locals code).map (fun locals => {state with locals := locals})

theorem scalar_sound (before after : State) (code : CLogic.Stmt) (computed : scalar before code=some after) :
    C99ModularReference.Exec (.base (.scalar code)) (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨locals,step,result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_locals]
  exact .base _ _ _ (.scalar _ _ _ (C99CompactScalar115.step_sound FprPrefixCalls.calls noCalls
    (C99CompactPointer115.noCalls_sound _) before.locals locals code step))

def initial (state : State) : Option State := do
  let cell ← C99NameMap115.lookup state.locals "u".toList
  pure (C99CompactState115.bindValue state "u".toList cell.ty (.i32 0))

theorem initial_sound (before after : State) (computed : initial before=some after) :
    C99ModularReference.Exec ShakeSeedMemory.initial (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨cell,found,result⟩ := Option.bind_eq_some_iff.mp computed
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindValue]
  refine .assign _ _ _ (C99ValueBridge.type cell.ty) (cell.value.map C99ValueBridge.value) (.int32 0) ?_ ?_
  · change (C99NameMap115.lookup before.locals "u".toList).map C99CompactCells115.Cell.reference = _
    rw [found]
    rfl
  · exact .scalar _ _ (.literal _ _)

def step (before : State) : Option State := do
  let destination ← C99CompactPointer115.pointer noCalls before "A".toList ShakeSeedMemory.index
  let source ← C99CompactPointer115.pointer noCalls before "data".toList (.var "u".toList)
  let old ← C99FiniteRead114.read64 before.heap destination
  let decoded ← ShakeDecodeCompute117.decode before source
  let value ← B20.C.bin .xor (.u64 old) (.u64 decoded)
  if ShakeBlockCompute116.WriteGuard before destination then
    pure {before with heap := C99FiniteWrite114.write64 before.heap destination (BitVec.ofInt 64 value.integer)}
  else none

theorem step_sound (before after : State) (computed : step before=some after) :
    ShakeSeedMemory.XorStep (reference before) (reference after) := by
  obtain ⟨destination,dst,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨source,src,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨old,read,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨decoded,decode,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨value,operation,result⟩ := Option.bind_eq_some_iff.mp rest
  split at result
  next guard =>
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_heap]
    refine .run destination source old decoded (C99ValueBridge.value value) _
      (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before _ _ destination dst)
      (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before _ _ source src)
      (C99FiniteRead114.read64_sound before.heap destination old read)
      (ShakeDecodeCompute117.decode_sound before source decoded decode)
      (C99IntegerSound.bitwise_sound .xor (.u64 old) (.u64 decoded) value operation) ?_
    simpa only [C99CompactState115.reference,C99ValueBridge.integer_matches] using
      C99FiniteWrite114.write64_sound before.heap destination (BitVec.ofInt 64 value.integer) guard.1 guard.2.1 guard.2.2
  next rejected => cases result

def loop : Nat → State → Option State
  | 0, _ => none
  | fuel+1, before => do
      let value ← C99CompactScalar115.evaluate noCalls before.locals ShakeSeedMemory.condition
      if value.integer=0 then pure before else do
        let middle ← step before
        let next ← scalar middle (.update "u".toList .add (.literal .i32 8))
        loop fuel next

theorem loop_sound (fuel : Nat) (before after : State) (computed : loop fuel before=some after) :
    ShakeSeedMemory.XorLoop (reference before) (reference after) := by
  induction fuel generalizing before with
  | zero => cases computed
  | succ fuel ih =>
      obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
      have guard := C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
        before.locals ShakeSeedMemory.condition value evaluated
      by_cases zero : value.integer=0
      · simp only [zero,ite_true] at rest
        have same := Option.some.inj rest
        subst after
        exact .done (reference before) (C99ValueBridge.value value) guard (by simpa only [C99ValueBridge.integer_matches] using zero)
      · simp only [zero,ite_false] at rest
        obtain ⟨middle,body,rest⟩ := Option.bind_eq_some_iff.mp rest
        obtain ⟨next,increment,remaining⟩ := Option.bind_eq_some_iff.mp rest
        exact .next (reference before) (reference middle) (reference next) (reference after) (C99ValueBridge.value value)
          guard (by simpa only [C99ValueBridge.integer_matches] using zero)
          (step_sound before middle body) (scalar_sound middle next _ increment) (ih next remaining)

def entry (state : State) (a data : ArrayPointer) (rate : Val) : State :=
  {state with
    locals := [("rate".toList,C99CompactCells115.Cell.converted .u64 rate)]
    arrays := [("A".toList,a),("data".toList,data)]}

theorem entry_bound (state : State) (a data : ArrayPointer) (rate : Val) :
    reference (entry state a data rate)=ShakeSeedMemory.xorEntry (reference state) a data (C99ValueBridge.value rate) := by
  simp only [entry,reference,ShakeSeedMemory.xorEntry,ShakeEncodeCompute117.singleton_environment]
  rfl

def invoke (fuel : Nat) (before : State) (a data : ArrayPointer) (rate : Val) : Option State := do
  let declared ← scalar (entry before a data rate) (.declare .u64 ["u".toList])
  let ready ← initial declared
  let after ← loop fuel ready
  pure {before with heap := after.heap}

theorem invoke_sound (fuel : Nat) (before after : State) (a data : ArrayPointer) (rate : Val)
    (computed : invoke fuel before a data rate=some after) :
    ShakeSeedMemory.XorCall (reference before) a data (C99ValueBridge.value rate) (reference after) := by
  let declared : State := {entry before a data rate with
    locals := C99CompactScalar115.declareMany (entry before a data rate).locals .u64 ["u".toList]}
  let ready := C99CompactState115.bindValue declared "u".toList .u64 (.i32 0)
  have declaration : scalar (entry before a data rate) (.declare .u64 ["u".toList])=some declared := rfl
  have initialized : initial declared=some ready := rfl
  change (loop fuel ready).bind (fun middle => some {before with heap := middle.heap})=some after at computed
  obtain ⟨middle,body,result⟩ := Option.bind_eq_some_iff.mp computed
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_heap]
  refine .run (reference declared) (reference ready) (reference middle) ?_
    (initial_sound declared ready initialized) (loop_sound fuel ready middle body)
  have source := scalar_sound (entry before a data rate) declared _ declaration
  rw [entry_bound] at source
  exact source

end FT1536.Source3.ShakeXorCompute117
