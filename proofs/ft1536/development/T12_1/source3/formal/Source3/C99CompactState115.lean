import Source3.C99CompactScalar115
import Source3.C99FiniteAllocation115
import Source3.ShakeSeedReference
import Source3.KeygenMakeArguments

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99CompactState115
open C99MemoryReference (ArrayPointer)
open C99ArrayReference (Name)
open C99CompactCells115 (Locals Cell environment)
open B20.C (Ty Val)

abbrev Pointers := C99NameMap115.Table ArrayPointer

/-- Finite computational representation of all five original state fields. -/
structure State where
  heap : C99FiniteMemory114.Heap
  locals : Locals
  arrays : Pointers
  globals : Locals
  tables : Pointers
  deriving Repr, DecidableEq

def reference (state : State) : C99ArrayReference.State where
  heap := C99FiniteMemory114.memory state.heap
  locals := environment state.locals
  arrays := C99NameMap115.lookup state.arrays
  globals := environment state.globals
  tables := C99NameMap115.lookup state.tables

def bindValue (state : State) (name : Name) (ty : Ty) (value : Val) : State :=
  {state with locals := C99NameMap115.put state.locals name (Cell.converted ty value)}

theorem reference_bindValue (state : State) (name : Name) (ty : Ty) (value : Val) :
    reference (bindValue state name ty value) = C99ArrayReference.bindValue (reference state)
      name (C99ValueBridge.type ty) (C99ValueBridge.value value) := by
  simp only [reference,bindValue,C99ArrayReference.bindValue,C99CompactCells115.environment_put,Cell.converted_reference]

def bindPointer (state : State) (name : Name) (pointer : ArrayPointer) : State :=
  {state with arrays := C99NameMap115.put state.arrays name pointer}

theorem reference_bindPointer (state : State) (name : Name) (pointer : ArrayPointer) :
    reference (bindPointer state name pointer) = C99ArrayReference.bindPointer (reference state) name pointer := by
  have arrays : C99NameMap115.lookup (C99NameMap115.put state.arrays name pointer) =
      fun other => if other=name then some pointer else C99NameMap115.lookup state.arrays other := by
    funext other
    exact C99NameMap115.lookup_put state.arrays name other pointer
  simp only [reference,bindPointer,C99ArrayReference.bindPointer,arrays]

theorem reference_heap (state : State) (heap : C99FiniteMemory114.Heap) :
    reference {state with heap := heap} = {reference state with heap := C99FiniteMemory114.memory heap} := rfl

theorem reference_locals (state : State) (locals : Locals) :
    reference {state with locals := locals} = {reference state with locals := environment locals} := rfl

def restoreScope (before after : State) (locals pointers : List Name) : State :=
  {after with
    locals := C99NameMap115.restore before.locals after.locals locals
    arrays := C99NameMap115.restore before.arrays after.arrays pointers}

theorem reference_restoreScope (before after : State) (locals pointers : List Name) :
    reference (restoreScope before after locals pointers) =
      C99ArrayReference.restoreScope (reference before) (reference after) locals pointers := by
  have arrays : C99NameMap115.lookup (C99NameMap115.restore before.arrays after.arrays pointers) =
      fun name => if pointers.contains name then C99NameMap115.lookup before.arrays name else C99NameMap115.lookup after.arrays name := by
    funext name
    by_cases inside : name∈pointers
    all_goals simp [C99NameMap115.lookup_restore,inside]
  simp only [reference,restoreScope,C99ArrayReference.restoreScope,C99CompactCells115.environment_restore,arrays]

def base (caller : State) : State := {caller with locals := caller.globals, arrays := caller.tables}

theorem reference_base (caller : State) : reference (base caller) = KeygenMakeArguments.base (reference caller) := rfl

def clearLocals (state : State) : State := {state with locals := [], arrays := []}

theorem reference_clearLocals (state : State) : reference (clearLocals state) = ShakeSeedReference.entry (reference state) := rfl

end FT1536.Source3.C99CompactState115
