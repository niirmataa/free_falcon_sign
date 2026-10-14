import Source3.C99BlockRename090

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99StateRename090
open C99ArrayReference (State Name)
open C99MemoryReference
open C99BlockRename090

theorem ext (a b : State) (heapEq : a.heap = b.heap) (localsEq : a.locals = b.locals)
    (arraysEq : a.arrays = b.arrays) (globalsEq : a.globals = b.globals) (tablesEq : a.tables = b.tables) :
    a = b := by cases a; cases b; simp_all

theorem bindValue (r : Renaming) (s : State) (n : Name) (ty : C99IntegerReference.Ty)
    (v : C99IntegerReference.Value) :
    state r (C99ArrayReference.bindValue s n ty v) = C99ArrayReference.bindValue (state r s) n ty v := rfl

theorem bindPointer (r : Renaming) (s : State) (n : Name) (p : ArrayPointer) :
    state r (C99ArrayReference.bindPointer s n p) = C99ArrayReference.bindPointer (state r s) n (ptr r p) := by
  apply ext <;> try rfl
  funext name
  by_cases equal : name = n <;> simp [state, C99ArrayReference.bindPointer, equal]

theorem declarePointer (r : Renaming) (s : State) (n : Name) :
    state r {s with arrays := fun name => if name = n then none else s.arrays name} =
      {state r s with arrays := fun name => if name = n then none else (state r s).arrays name} := by
  apply ext <;> try rfl
  funext name
  by_cases equal : name = n <;> simp [state, equal]

theorem restoreScope (r : Renaming) (before after : State) (locals pointers : List Name) :
    state r (C99ArrayReference.restoreScope before after locals pointers) =
      C99ArrayReference.restoreScope (state r before) (state r after) locals pointers := by
  apply ext <;> try rfl
  funext name
  by_cases member : name ∈ pointers <;> simp [state, C99ArrayReference.restoreScope, member]

theorem scalar (r : Renaming) (s : State) (e : CLogic.Expr) (v : C99IntegerReference.Value)
    (source : C99ArrayReference.scalar s e v) : C99ArrayReference.scalar (state r s) e v := source

theorem pointer (r : Renaming) (s : State) (name : Name) (index : CLogic.Expr) (p : ArrayPointer)
    (source : C99ArrayReference.Pointer s name index p) :
    C99ArrayReference.Pointer (state r s) name index (ptr r p) := by
  cases source with
  | add root p value binding evaluated nonnegative address =>
      exact .add name index (ptr r root) (ptr r p) value
        (by simp only [state, binding, Option.map_some]) (scalar r s index value evaluated)
        nonnegative (pointer_add r root p value.integer.toNat address)

end FT1536.Source3.C99StateRename090
