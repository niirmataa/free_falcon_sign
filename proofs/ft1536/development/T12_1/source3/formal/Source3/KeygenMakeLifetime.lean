import Source3.KeygenMakeProgram
import Source3.KeygenMakeReady

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual outer declarations, their scope-exit operation, and the complete
   readiness-FAILURE execution. This is NOT whole-call success: cap, rejected
   attempts, accepted material and the encoding suffix still need composition.
   No arbitrary body/callee relation is supplied to the failure execution. -/
namespace FT1536.Source3.KeygenMakeLifetime
open C99MemoryReference
open C99ArrayReference (State Name)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)

def isPointer : KeygenMakeSyntax.Ty → Bool | .pointer _ => true | _ => false
def isObject (o : KeygenMakeSyntax.Object) : Bool := o.count.isSome || isPointer o.type
def declarations : List KeygenMakeSyntax.Object := KeygenMakeProgram.outer.flatMap KeygenMakeProgram.declared
def scalarNames : List Name := (declarations.filter (fun o => !isObject o)).map (·.name)
def pointerNames : List Name := (declarations.filter isObject).map (·.name)
def scalars : List Name := ["logn","ter","n","u","klen","skoff","i","local_attempts"].map String.toList
def pointers : List Name := ["f","g","F","G","h","skbuf","ske"].map String.toList
theorem outer_names_source : scalarNames=scalars ∧ pointerNames=pointers := by decide +kernel
theorem scope_source : KeygenMakeProgram.code=KeygenMakeBinding.code := rfl
def close (before : State) (blocks : Fin 6 → Nat) (raw : Result) : Result :=
  ⟨{C99ArrayReference.restoreScope before raw.state scalars pointers with
    heap := KeygenMakeObjects.dispose before.heap raw.state.heap blocks},raw.flow⟩
theorem close_flow (before : State) (blocks : Fin 6 → Nat) (raw : Result) :
    (close before blocks raw).flow=raw.flow := rfl
theorem close_object (before : State) (blocks : Fin 6 → Nat) (raw : Result) (slot : Fin 6) :
    KeygenMakeObjects.Block before.heap (close before blocks raw).state.heap (blocks slot) :=
  KeygenMakeObjects.dispose_object before.heap raw.state.heap blocks slot
theorem close_outside (before : State) (blocks : Fin 6 → Nat) (raw : Result) (block : Nat)
    (separated : ∀ slot, blocks slot≠block) :
    KeygenMakeObjects.Block raw.state.heap (close before blocks raw).state.heap block :=
  KeygenMakeObjects.dispose_other before.heap raw.state.heap blocks block separated
theorem close_local (before : State) (blocks : Fin 6 → Nat) (raw : Result) (name : Name) (localName : name∈scalars) :
    (close before blocks raw).state.locals name=before.locals name := by
  simp only [close,C99ArrayReference.restoreScope,C99ScalarReference.restore,
    List.contains_iff_mem.mpr localName,ite_true]
theorem close_pointer (before : State) (blocks : Fin 6 → Nat) (raw : Result) (name : Name) (pointerName : name∈pointers) :
    (close before blocks raw).state.arrays name=before.arrays name := by
  simp only [close,C99ArrayReference.restoreScope,List.contains_iff_mem.mpr pointerName,ite_true]

theorem original_empty (i : Nat) (before after : State) (blocks : Fin 6 → Nat)
    (source : KeygenMakeObjects.Exec i before blocks after) (slot : Fin 6) (bound : i≤slot.val) :
    before.heap.size (blocks slot)=0 := by
  by_contra different
  have live : 0<before.heap.size (blocks slot) := by omega
  exact (KeygenMakeObjects.fresh_separate i before after blocks source slot bound (blocks slot) live) rfl
theorem prefix_empty (ctx : Context) (before : State) (blocks : Fin 6 → Nat)
    (events : List KeygenEntropySource.Event) (raw : Result)
    (source : KeygenMakeReady.Prefix ctx before blocks events raw) (slot : Fin 6) :
    before.heap.size (blocks slot)=0 := by
  cases source with
  | run objects initialized dimensioned events out declarations counter dimensions gate =>
    exact original_empty 0 (KeygenMakePrologue.projectionStart before) objects blocks
      (KeygenMakePrologue.allocation_projection before objects blocks declarations) slot (by omega)
theorem closed_empty (ctx : Context) (before : State) (blocks : Fin 6 → Nat)
    (events : List KeygenEntropySource.Event) (raw : Result)
    (source : KeygenMakeReady.Prefix ctx before blocks events raw) (slot : Fin 6) :
    (close before blocks raw).state.heap.size (blocks slot)=0 :=
  (close_object before blocks raw slot).1.trans (prefix_empty ctx before blocks events raw source slot)
theorem dead_read16 (ctx : Context) (before : State) (blocks : Fin 6 → Nat)
    (events : List KeygenEntropySource.Event) (raw : Result)
    (source : KeygenMakeReady.Prefix ctx before blocks events raw) (slot : Fin 6)
    (p : ArrayPointer) (block : p.block=blocks slot) (word : BitVec 16) :
    ¬C99NarrowReads.Load16 (close before blocks raw).state.heap p word := by
  intro read
  cases read with
  | load bytes allocated width initialized =>
    have positive := KeygenCallerEntry.allocated_live _ _ allocated
    rw [block,closed_empty ctx before blocks events raw source slot] at positive
    omega
theorem dead_read64 (ctx : Context) (before : State) (blocks : Fin 6 → Nat)
    (events : List KeygenEntropySource.Event) (raw : Result)
    (source : KeygenMakeReady.Prefix ctx before blocks events raw) (slot : Fin 6)
    (p : ArrayPointer) (block : p.block=blocks slot) (word : BitVec 64) :
    ¬Load64 (close before blocks raw).state.heap p word := by
  intro read
  cases read with
  | load bytes allocated width initialized =>
    have positive := KeygenCallerEntry.allocated_live _ _ allocated
    rw [block,closed_empty ctx before blocks events raw source slot] at positive
    omega
theorem failed_prefix_result (ctx : Context) (before : State) (blocks : Fin 6 → Nat)
    (events : List KeygenEntropySource.Event) (raw : Result)
    (source : KeygenMakeReady.Prefix ctx before blocks events raw) (exit : raw.flow≠.normal) :
    raw.flow=.returned (some (.int32 0)) := by
  cases source with
  | run objects initialized dimensioned events out declarations counter dimensions gate =>
    cases gate with
    | normal after word v call test zero => exact (exit rfl).elim
    | failure after word v out call test nonzero returned =>
      exact congrArg Result.flow (KeygenMakeReady.failure_result after _ returned)

/- Only the actual ready-return edge, followed by the source outer teardown.
   There is no callback for a later body, no encoder rule and no success case. -/
inductive ReadinessFailure (ctx : Context) (before : State) (blocks : Fin 6 → Nat) :
    List KeygenEntropySource.Event → Result → Prop where
  | run (events : List KeygenEntropySource.Event) (raw : Result)
      (source : KeygenMakeReady.Prefix ctx before blocks events raw) (exit : raw.flow≠.normal) :
      ReadinessFailure ctx before blocks events (close before blocks raw)
theorem readiness_failure (ctx : Context) (before : State) (blocks : Fin 6 → Nat)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : ReadinessFailure ctx before blocks events out) :
    out.flow=.returned (some (.int32 0)) ∧
    (∀ slot, out.state.heap.size (blocks slot)=0) ∧
    (∀ name∈scalars, out.state.locals name=before.locals name) ∧
    (∀ name∈pointers, out.state.arrays name=before.arrays name) := by
  cases source with
  | run raw source exit =>
    exact ⟨failed_prefix_result ctx before blocks events raw source exit,
      closed_empty ctx before blocks events raw source,
      close_local before blocks raw,close_pointer before blocks raw⟩

end FT1536.Source3.KeygenMakeLifetime
