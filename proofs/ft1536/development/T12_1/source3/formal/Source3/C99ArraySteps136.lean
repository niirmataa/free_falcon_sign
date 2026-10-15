import Source3.C99ArrayCompute136
import Source3.C99ScalarSteps130
import Source3.C99FiniteWrite114

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ArraySteps136
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open C99MemoryReference (ArrayPointer Allocated)
open C99ValueBridge (value)
open C99ArrayCompute136 (evaluate)

def scalar (before : State) (code : CLogic.Stmt) : Option State :=
  (C99ScalarSteps130.step before.locals code).map (fun cells => {before with locals := cells})

theorem scalar_sound (program : C99ArrayReference.Program) (before after : State) (code : CLogic.Stmt)
    (computed : scalar before code=some after) :
    C99ArrayReference.Exec program (.scalar code) (reference before) (reference after) := by
  obtain ⟨cells,step,same⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_locals]
  exact .scalar _ _ _ (C99ScalarSteps130.step_sound FprPrefixCalls.calls before.locals cells code step)

def assign (calls : B20.C.Scalar.Calls) (before : State) (name : B20.C.Name) (expr : C99ArrayReference.Expr) : Option State := do
  let cell ← C99NameMap115.lookup before.locals name
  let out ← evaluate calls before expr
  pure (C99CompactState115.bindValue before name cell.ty out)

theorem assign_sound (program : C99ArrayReference.Program) (calls : B20.C.Scalar.Calls)
    (callsSound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls) (before after : State)
    (name : B20.C.Name) (expr : C99ArrayReference.Expr) (computed : assign calls before name expr=some after) :
    C99ArrayReference.Exec program (.assign name expr) (reference before) (reference after) := by
  obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨out,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindValue]
  refine .assign _ _ _ (C99ValueBridge.type cell.ty) (cell.value.map value) (value out) ?_
    (C99ArrayCompute136.sound calls callsSound before expr out evaluated)
  change (C99NameMap115.lookup before.locals name).map C99CompactCells115.Cell.reference=_
  rw [declared]
  rfl

def WriteGuard (state : State) (pointer : ArrayPointer) : Prop :=
  Allocated (C99FiniteMemory114.memory state.heap) pointer ∧ pointer.elementBytes=8 ∧
  (C99FiniteMemory114.memory state.heap).writable pointer.block=true

instance writeGuardDecidable (state : State) (pointer : ArrayPointer) : Decidable (WriteGuard state pointer) := by
  unfold WriteGuard
  infer_instance

def store (calls : B20.C.Scalar.Calls) (before : State) (name : B20.C.Name)
    (index : CLogic.Expr) (expr : C99ArrayReference.Expr) : Option State := do
  let pointer ← C99CompactPointer115.pointer noCalls before name index
  let out ← evaluate calls before expr
  if WriteGuard before pointer then
    pure {before with heap := C99FiniteWrite114.write64 before.heap pointer (BitVec.ofInt 64 out.integer)}
  else none

theorem store_sound (program : C99ArrayReference.Program) (calls : B20.C.Scalar.Calls)
    (callsSound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls) (before after : State)
    (name : B20.C.Name) (index : CLogic.Expr) (expr : C99ArrayReference.Expr)
    (computed : store calls before name index expr=some after) :
    C99ArrayReference.Exec program (.store64 name index expr) (reference before) (reference after) := by
  obtain ⟨pointer,address,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨out,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  split at result
  next guard =>
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_heap]
    refine .store64 _ _ _ _ _ pointer (value out)
      (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before name index pointer address)
      (C99ArrayCompute136.sound calls callsSound before expr out evaluated) ?_
    simpa only [C99ValueBridge.integer_matches,reference] using
      C99FiniteWrite114.write64_sound before.heap pointer (BitVec.ofInt 64 out.integer) guard.1 guard.2.1 guard.2.2
  next rejected => cases result

def step (calls : B20.C.Scalar.Calls) (before : State) : C99ArrayReference.Stmt → Option State
  | .skip => some before
  | .scalar code => scalar before code
  | .assign name expr => assign calls before name expr
  | .store64 name index expr => store calls before name index expr
  | _ => none

theorem step_sound (program : C99ArrayReference.Program) (calls : B20.C.Scalar.Calls)
    (callsSound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls) (before after : State)
    (code : C99ArrayReference.Stmt) (computed : step calls before code=some after) :
    C99ArrayReference.Exec program code (reference before) (reference after) := by
  cases code <;> try (solve | cases computed)
  case skip =>
    have same := Option.some.inj computed
    subst after
    exact .skip _
  case scalar code => exact scalar_sound program before after code computed
  case assign name expr => exact assign_sound program calls callsSound before after name expr computed
  case store64 name index expr => exact store_sound program calls callsSound before after name index expr computed

end FT1536.Source3.C99ArraySteps136
