import Source3.KeygenWordComputeSound130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordSteps130
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open C99MemoryReference
open KeygenWordExpr (Expr)

def assign (before : State) (name : C99ArrayReference.Name) (expr : Expr) : Option State := do
  let cell ← C99NameMap115.lookup before.locals name
  let value ← KeygenWordCompute130.evaluate before expr
  pure (C99CompactState115.bindValue before name cell.ty value)

theorem assign_sound (before after : State) (name : C99ArrayReference.Name) (expr : Expr)
    (computed : assign before name expr=some after) :
    KeygenWordExec.Exec (.assign name expr) (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindValue]
  refine .assign name expr (reference before) (C99ValueBridge.type cell.ty)
    (cell.value.map C99ValueBridge.value) (C99ValueBridge.value value) ?_
    (KeygenWordComputeSound130.sound before expr value evaluated)
  change (C99NameMap115.lookup before.locals name).map C99CompactCells115.Cell.reference = _
  rw [declared]
  rfl

def Guard (state : State) (pointer : ArrayPointer) : Prop :=
  Allocated (C99FiniteMemory114.memory state.heap) pointer ∧ pointer.elementBytes=4 ∧
    (C99FiniteMemory114.memory state.heap).writable pointer.block=true

instance guardDecidable (state : State) (pointer : ArrayPointer) : Decidable (Guard state pointer) := by
  unfold Guard
  infer_instance

def store (before : State) (name : C99ArrayReference.Name) (index : CLogic.Expr) (expr : Expr) : Option State := do
  let pointer ← C99CompactPointer115.pointer noCalls before name index
  let value ← KeygenWordCompute130.evaluate before expr
  if Guard before pointer then
    pure {before with heap := C99FiniteWrite114.write32 before.heap pointer (BitVec.ofInt 32 value.integer)}
  else none

theorem store_sound (before after : State) (name : C99ArrayReference.Name) (index : CLogic.Expr) (expr : Expr)
    (computed : store before name index expr=some after) :
    KeygenWordExec.Exec (.store name index expr) (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨pointer,address,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  split at result
  next guard =>
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_heap before]
    refine .store name index expr (reference before) _ pointer (C99ValueBridge.value value)
      (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before name index pointer address)
      (KeygenWordComputeSound130.sound before expr value evaluated) ?_
    simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using
      C99FiniteWrite114.write32_sound before.heap pointer (BitVec.ofInt 32 value.integer) guard.1 guard.2.1 guard.2.2
  next rejected => cases result

end FT1536.Source3.KeygenWordSteps130
