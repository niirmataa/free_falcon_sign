import Source3.ShakeBlockCompute116

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeProcessCompute116
open C99MemoryReference
open C99CompactState115 (State reference)

def StaticGuard (heap : C99FiniteMemory114.Heap) (table : ArrayPointer) : Prop :=
  (C99FiniteMemory114.memory heap).writable table.block=false ∧ table.elementBytes=8 ∧
  ∀ i : Fin 24, C99FiniteRead114.read64 heap (KeygenSmallOutput.element table i.val)=some (ShakeExtractSource.rc[i.val]!)

instance staticGuardDecidable (heap : C99FiniteMemory114.Heap) (table : ArrayPointer) :
    Decidable (StaticGuard heap table) := by
  unfold StaticGuard
  infer_instance

theorem static_sound (heap : C99FiniteMemory114.Heap) (table : ArrayPointer) (guard : StaticGuard heap table) :
    ShakeExtractSource.StaticRC (C99FiniteMemory114.memory heap) table :=
  ⟨guard.1,guard.2.1,fun i => C99FiniteRead114.read64_sound heap _ _ (guard.2.2 i)⟩

def entry (state : State) (pointer table : ArrayPointer) : State :=
  {state with locals := [], arrays := [("A".toList,pointer),("RC".toList,table)]}

theorem reference_entry (state : State) (pointer table : ArrayPointer) :
    reference (entry state pointer table) = ShakeExtractSource.blockEntry (reference state) pointer table := rfl

def process (fuel : Nat) (state : State) (pointer : ArrayPointer) : Option State := do
  let table ← C99NameMap115.lookup state.tables "RC".toList
  if StaticGuard state.heap table then
    let after ← ShakeBlockCompute116.run fuel ShakeBlockProgram.code (entry state pointer table)
    pure {state with heap := after.heap}
  else none

theorem process_sound (fuel : Nat) (before after : State) (pointer : ArrayPointer)
    (computed : process fuel before pointer=some after) :
    ShakeExtractSource.Process (reference before) pointer (reference after) := by
  obtain ⟨table,binding,rest⟩ := Option.bind_eq_some_iff.mp computed
  split at rest
  next guard =>
    obtain ⟨middle,body,result⟩ := Option.bind_eq_some_iff.mp rest
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_heap]
    refine .run table (reference middle) binding (static_sound before.heap table guard) ?_
    change ShakeBlock.Exec ShakeBlockProgram.code (reference (entry before pointer table)) (reference middle)
    exact ShakeBlockCompute116.run_sound fuel ShakeBlockProgram.code (entry before pointer table) middle body
  next rejected => cases rest

end FT1536.Source3.ShakeProcessCompute116
