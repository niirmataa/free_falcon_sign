import Source3.ShakeDecodeCompute117

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeEncodeCompute117
open C99MemoryReference
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open B20.C (Val)

def WriteGuard (state : State) (pointer : ArrayPointer) : Prop :=
  Allocated (C99FiniteMemory114.memory state.heap) pointer ∧ pointer.elementBytes=1 ∧
  (C99FiniteMemory114.memory state.heap).writable pointer.block=true

instance writeGuardDecidable (state : State) (pointer : ArrayPointer) : Decidable (WriteGuard state pointer) := by
  unfold WriteGuard
  infer_instance

def step (before : State) (instruction : ShakeEncode.Instruction) : Option State := do
  let pointer ← C99CompactPointer115.pointer noCalls before "buf".toList instruction.index
  let value ← C99CompactScalar115.evaluate noCalls before.locals instruction.value
  if WriteGuard before pointer then
    pure {before with heap := C99FiniteMemory114.putByte before.heap pointer.block pointer.offset (BitVec.ofInt 8 value.integer)}
  else none

def run : List ShakeEncode.Instruction → State → Option State
  | [], before => some before
  | instruction::rest, before => do run rest (←step before instruction)

theorem run_sound (code : List ShakeEncode.Instruction) (before after : State)
    (computed : run code before=some after) : ShakeEncode.Exec code (reference before) (reference after) := by
  induction code generalizing before with
  | nil =>
      have same := Option.some.inj computed
      subst after
      exact .done _
  | cons instruction rest ih =>
      obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨pointer,address,head⟩ := Option.bind_eq_some_iff.mp head
      obtain ⟨value,evaluated,head⟩ := Option.bind_eq_some_iff.mp head
      split at head
      next guard =>
        have same := Option.some.inj head
        subst middle
        have following := ih _ tail
        rw [C99CompactState115.reference_heap] at following
        refine .next instruction rest (reference before) _ (reference after) pointer (C99ValueBridge.value value)
          (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before _ _ pointer address)
          (C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
            before.locals _ value evaluated) ?_ following
        simpa only [C99CompactState115.reference,C99ValueBridge.integer_matches] using
          C99FiniteMemory114.store8 before.heap pointer (BitVec.ofInt 8 value.integer) guard.1 guard.2.1 guard.2.2
      next rejected => cases head

def entry (before : State) (pointer : ArrayPointer) (value : Val) : State :=
  {before with
    locals := [("x".toList,C99CompactCells115.Cell.converted .u64 value)]
    arrays := [("out".toList,pointer)]}

theorem singleton_environment (name : C99ArrayReference.Name) (ty : B20.C.Ty) (value : Val) :
    C99CompactCells115.environment [(name,C99CompactCells115.Cell.converted ty value)] =
      C99ScalarReference.set (fun _ => none) name (C99ValueBridge.type ty,
        some (C99IntegerReference.convert (C99ValueBridge.type ty) (C99ValueBridge.value value).integer)) := by
  funext query
  by_cases found : query=name
  all_goals simp [C99CompactCells115.environment,C99NameMap115.lookup,C99ScalarReference.set,
    found,C99CompactCells115.Cell.converted_reference]

theorem entry_bound (before : State) (pointer : ArrayPointer) (value : Val) :
    reference (entry before pointer value)=ShakeEncode.entry (reference before) pointer (C99ValueBridge.value value) := by
  simp only [entry,reference,ShakeEncode.entry,singleton_environment]
  rfl

def invoke (before : State) (pointer : ArrayPointer) (value : Val) : Option State := do
  let declared := C99CompactPointer115.declarePointer (entry before pointer value) "buf".toList
  let out ← C99CompactPointer115.pointer noCalls declared "out".toList C99ProcedureParser.zero
  let ready := C99CompactState115.bindPointer declared "buf".toList out
  let after ← run ShakeEncode.code ready
  pure {before with heap := after.heap}

theorem invoke_sound (before after : State) (pointer : ArrayPointer) (value : Val)
    (computed : invoke before pointer value=some after) :
    ShakeEncode.Invoke (reference before) pointer (C99ValueBridge.value value) (reference after) := by
  let declared := C99CompactPointer115.declarePointer (entry before pointer value) "buf".toList
  obtain ⟨out,address,rest⟩ := Option.bind_eq_some_iff.mp computed
  let ready := C99CompactState115.bindPointer declared "buf".toList out
  obtain ⟨middle,body,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_heap]
  refine .run (reference declared) (reference ready) (reference middle) ?_ ?_ (run_sound _ ready middle body)
  · dsimp only [declared]
    rw [C99CompactPointer115.declarePointer_reference,entry_bound]
    exact .declarePtr _ _
  · dsimp only [ready]
    rw [C99CompactState115.reference_bindPointer]
    exact .bindPtr _ _ _ _ out
      (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) declared _ _ out address)

end FT1536.Source3.ShakeEncodeCompute117
