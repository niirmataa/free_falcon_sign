import Source3.SelectedInput124
import Source3.KeygenMakePrologue

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenMakeDeclare125
open C99CompactState115 (State reference)

def declare (before : State) (ty : B20.C.Ty) (names : List C99ArrayReference.Name) : State :=
  {before with locals := C99CompactScalar115.declareMany before.locals ty names}

theorem reference_declare (before : State) (ty : B20.C.Ty) (names : List C99ArrayReference.Name) :
    reference (declare before ty names)=C99DeclarationStatements.effect ty names (reference before) := by
  have complete := C99DeclarationCells.complete FprPrefixCalls.calls (C99ValueBridge.type ty) names
    (C99CompactCells115.environment before.locals) _
    (C99CompactScalar115.declareMany_sound FprPrefixCalls.calls before.locals ty names)
  have cells := C99ScalarReference.Result.normal.inj complete
  unfold declare
  rw [C99CompactState115.reference_locals,cells]
  rfl

def enter (before : State) (blocks : Fin 6 → Nat) (slot : Fin 6) : State :=
  C99CompactState115.bindPointer
    {before with heap := C99FiniteAllocation115.allocate before.heap (blocks slot) (KeygenMakeObjects.extent slot)}
    (KeygenMakeObjects.name slot) (KeygenMakeObjects.pointer blocks slot)

theorem reference_enter (before : State) (blocks : Fin 6 → Nat) (slot : Fin 6) :
    reference (enter before blocks slot)=KeygenMakeObjects.enter (reference before) blocks slot := by
  unfold enter
  rw [C99CompactState115.reference_bindPointer,
    C99CompactState115.reference_heap before (C99FiniteAllocation115.allocate before.heap (blocks slot) (KeygenMakeObjects.extent slot)),
    C99FiniteAllocation115.allocate_source]
  rfl

def middle (s : State) : State :=
  C99CompactPointer115.declarePointer (declare s .u64 ["klen".toList,"skoff".toList]) "skbuf".toList
def tailDeclared (s : State) : State := declare (declare s .i32 ["i".toList]) .u64 ["local_attempts".toList]
def a0 (s : State) : State := declare (declare s .u32 ["logn".toList,"ter".toList]) .u64 ["n".toList,"u".toList]
def a1 (s : State) (blocks : Fin 6 → Nat) : State := enter (a0 s) blocks 0
def a2 (s : State) (blocks : Fin 6 → Nat) : State := enter (a1 s blocks) blocks 1
def a3 (s : State) (blocks : Fin 6 → Nat) : State := enter (a2 s blocks) blocks 2
def a4 (s : State) (blocks : Fin 6 → Nat) : State := enter (a3 s blocks) blocks 3
def a5 (s : State) (blocks : Fin 6 → Nat) : State := enter (a4 s blocks) blocks 4
def a6 (s : State) (blocks : Fin 6 → Nat) : State := enter (middle (a5 s blocks)) blocks 5
def declared (s : State) (blocks : Fin 6 → Nat) : State := tailDeclared (a6 s blocks)

theorem reference_middle (s : State) : reference (middle s)=KeygenMakePrologue.middle (reference s) := by
  unfold middle
  rw [C99CompactPointer115.declarePointer_reference,reference_declare]
  rfl

theorem reference_tail (s : State) : reference (tailDeclared s)=KeygenMakePrologue.tailDeclared (reference s) := by
  unfold tailDeclared
  rw [reference_declare,reference_declare]
  rfl

theorem reference_a0 (s : State) : reference (a0 s)=KeygenMakePrologue.a0 (reference s) := by
  unfold a0
  rw [reference_declare,reference_declare]
  rfl

theorem reference_declared (s : State) (blocks : Fin 6 → Nat) :
    reference (declared s blocks)=KeygenMakePrologue.declared (reference s) blocks := by
  simp only [declared,a6,a5,a4,a3,a2,a1,reference_tail,reference_enter,reference_middle,reference_a0,
    KeygenMakePrologue.declared,KeygenMakePrologue.a6,KeygenMakePrologue.a5,KeygenMakePrologue.a4,
    KeygenMakePrologue.a3,KeygenMakePrologue.a2,KeygenMakePrologue.a1]

end FT1536.Source3.KeygenMakeDeclare125
