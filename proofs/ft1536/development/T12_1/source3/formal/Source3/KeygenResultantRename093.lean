import Source3.KeygenResultantBody093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenResultantRename093
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99BlockRename090
open KeygenResultantSource
open KeygenResultantBody093 (Body)

theorem allocation (r : Renaming) (before : Memory) (block : Nat) :
    heap r (KeygenResultantSource.allocated before block) = KeygenResultantSource.allocated (heap r before) (r block) := by
  apply RngTemporarySwap090.memory_ext
  · funext b o
    simp only [heap, KeygenResultantSource.allocated, RngTemporarySwap090.preimage_eq]
  · funext b
    simp only [heap, KeygenResultantSource.allocated, RngTemporarySwap090.preimage_eq]
  · funext b
    simp only [heap, KeygenResultantSource.allocated, RngTemporarySwap090.preimage_eq]

theorem zeroing (r : Renaming) (before : Memory) (block : Nat) :
    heap r (zeroed before block) = zeroed (heap r before) (r block) := by
  apply RngTemporarySwap090.memory_ext
  · funext b o
    simp only [heap, zeroed, RngTemporarySwap090.preimage_eq]
  · rfl
  · rfl

theorem entering (r : Renaming) (before : State) (block : Nat) :
    state r (entry before block) = entry (state r before) (r block) := by
  unfold entry
  rw [C99StateRename090.bindPointer]
  have heapEq := allocation r before.heap block
  change C99ArrayReference.bindPointer {state r before with heap := heap r (KeygenResultantSource.allocated before.heap block)}
    "b".toList (ptr r (object block)) = _
  rw [heapEq]
  rfl

theorem body (r : Renaming) (before : State) (block : Nat) (out : Result) (v : Value)
    (source : Body before block out v) : Body (state r before) (r block) (C99ModularRename093.result r out) v := by
  cases source with
  | run ready packed reduced out word v initial legal pack read fallthrough tail returned =>
      have initR := C99ModularRename093.execution r _ _ _ _ initial
      rw [entering] at initR
      have packR := KeygenWordRename093.execution r _ _ _ pack
      change KeygenWordExec.Exec packing {state r ready with heap := heap r (zeroed ready.heap block)}
        ⟨state r packed, .normal⟩ at packR
      rw [zeroing] at packR
      refine .run (state r ready) (state r packed) (state r reduced) _ word v initR ?_ packR read
        (KeygenWordRename093.execution r _ _ _ fallthrough) (KeygenWordRename093.execution r _ _ _ tail) returned
      simpa only [ZeroLegal, state, size_at, writable_at] using legal

def ArraysLive (s : State) : Prop := ∀ name p, s.arrays name = some p → 0 < s.heap.size p.block

theorem fresh_state (before : State) (a b : Nat) (fa : KeygenRngSource.Fresh before.heap a)
    (fb : KeygenRngSource.Fresh before.heap b) (arrays : ArraysLive before)
    (tables : RngTemporarySwap090.TablesLive before) : state (Equiv.swap a b) before = before := by
  apply C99StateRename090.ext
  · exact RngTemporarySwap090.fresh_heap_swap before.heap a b fa fb
  · rfl
  · funext name
    cases binding : before.arrays name with
    | none => simp only [state, binding, Option.map_none]
    | some p =>
        have fixed := RngTemporarySwap090.pointer_fixed (Equiv.swap a b) p
          (RngTemporarySwap090.live_fixed before.heap a b p.block fa fb (arrays name p binding))
        simp only [state, binding, Option.map_some, fixed]
  · rfl
  · exact RngTemporarySwap090.tables_fixed before a b fa fb tables

theorem value_unique (before : State) (a b : Nat) (out1 out2 : Result) (v1 v2 : Value)
    (fa : KeygenRngSource.Fresh before.heap a) (fb : KeygenRngSource.Fresh before.heap b)
    (arrays : ArraysLive before) (tables : RngTemporarySwap090.TablesLive before)
    (first : Body before a out1 v1) (second : Body before b out2 v2) : v1 = v2 := by
  have moved := body (Equiv.swap a b) before a out1 v1 first
  rw [fresh_state before a b fa fb arrays tables, Equiv.swap_apply_left] at moved
  exact (KeygenResultantBody093.body_unique before b _ out2 v1 v2 moved second).2

end FT1536.Source3.KeygenResultantRename093
