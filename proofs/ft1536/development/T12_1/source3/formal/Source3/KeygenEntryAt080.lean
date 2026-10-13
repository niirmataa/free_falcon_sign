import Source3.KeygenPrecertificate080
import Source3.KeygenMakeStatementMachine

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Initial material legality and separation from actual fresh declarations;
   no canonical scratch-block or material-block numbering is assumed. -/
namespace FT1536.Source3.KeygenEntryAt080
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeStatementMachine

theorem entry_facts (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (head : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩)
    :
    KeygenPrecertificate080.Entry ctx after (KeygenMakeEntry.input blocks)
      (KeygenMakeEntry.publicPointer blocks) primes rev := by
  have facts := KeygenMakeAttemptSpine.entry_of_allocation ctx before after blocks primes rev
    events original head
  cases head with
  | run objects initialized dimensioned events out declarations counter dimensions gate =>
    have objectsEq : objects=KeygenMakePrologue.declared before blocks := by
      cases declarations
      rfl
    subst objects
    have entry := KeygenMakePrologue.initial ctx before (KeygenMakePrologue.declared before blocks)
      primes rev original blocks declarations
    have initializedEq : initialized=
        KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks) :=
      congrArg Result.state
        (KeygenMakePrologue.count_result before blocks ⟨initialized,.normal⟩ counter)
    subst initialized
    have profile : KeygenSearchContext.M0
        (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)).heap ctx :=
      entry.profile
    have dimensionsEq := KeygenMakePrologue.dimensions_result ctx
      (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks))
      dimensioned profile dimensions
    subst dimensioned
    have exec : KeygenMakeObjects.Exec 0 (KeygenMakePrologue.projectionStart before)
        blocks (KeygenMakePrologue.declared before blocks) :=
      KeygenMakePrologue.allocation_projection before
        (KeygenMakePrologue.declared before blocks) blocks declarations
    have originalP := KeygenMakePrologue.projection_original ctx before primes rev original
    have call := KeygenMakeReady.gate_normal ctx _ after events gate
    have slots := KeygenRngReference.call_slots ctx _ after events (.int32 1) call
    have objectLive : 0<(KeygenMakePrologue.projectionStart before).heap.size ctx.object.block :=
      KeygenMakeEntry.object_live ctx (KeygenMakePrologue.projectionStart before) primes rev originalP
    have scratchLive : 0<(KeygenMakePrologue.projectionStart before).heap.size ctx.scratch.block :=
      KeygenMakeEntry.scratch_live ctx (KeygenMakePrologue.projectionStart before) primes rev originalP
    have tableLive : ∀ name p, before.tables name=some p →
        0<(KeygenMakePrologue.projectionStart before).heap.size p.block := by
      intro name p binding
      exact originalP.staticLive name p binding
    have arrayFree : ∀ slot : Fin 6, (KeygenMakeObjects.pointer blocks slot).block≠
        ctx.object.block ∧ (KeygenMakeObjects.pointer blocks slot).block≠ctx.scratch.block := by
      intro slot
      refine ⟨Ne.symm (KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before) (KeygenMakePrologue.declared before blocks)
          blocks exec slot (by omega) ctx.object.block objectLive),
        Ne.symm (KeygenMakeObjects.fresh_separate 0
          (KeygenMakePrologue.projectionStart before) (KeygenMakePrologue.declared before blocks)
          blocks exec slot (by omega) ctx.scratch.block scratchLive)⟩
    have arrayShape : ∀ slot : Fin 6,
        after.heap.size (blocks slot)=KeygenMakeObjects.extent slot ∧
        after.heap.writable (blocks slot)=true ∧
        Allocated after.heap (KeygenMakeObjects.pointer blocks slot) := by
      intro slot
      have shape := KeygenMakeObjects.object 0 (KeygenMakePrologue.projectionStart before)
        (KeygenMakePrologue.declared before blocks) blocks exec slot (by omega)
      have allocated := KeygenMakeObjects.allocated_object
        (KeygenMakePrologue.projectionStart before)
        (KeygenMakePrologue.declared before blocks) blocks exec slot
      have frame := KeygenMakeReady.block_frame ctx _ after events (.int32 1) call
        (blocks slot) (arrayFree slot).1
      refine ⟨?_,?_,?_⟩
      · rw [frame.1]
        exact shape.2.1
      · rw [frame.2.1]
        exact shape.2.2.1
      · exact allocated_same (KeygenMakePrologue.declared before blocks).heap after.heap
          (KeygenMakeObjects.pointer blocks slot) frame.1.symm allocated
    have tablesAfter : after.tables=before.tables := slots.2.2.2
    have tablesH : KeygenPublicFrame.Tables after
        (KeygenMakeEntry.publicPointer blocks).block := by
      intro name p binding
      have live := tableLive name p (by simpa [tablesAfter] using binding)
      have fresh := KeygenMakeObjects.fresh_separate 0
        (KeygenMakePrologue.projectionStart before)
        (KeygenMakePrologue.declared before blocks) blocks exec (4 : Fin 6) (by omega) p.block live
      have same : (KeygenMakeEntry.publicPointer blocks).block=blocks 4 := rfl
      rw [same]
      exact fresh
    have scratchH : ctx.scratch.block≠(KeygenMakeEntry.publicPointer blocks).block := by
      have fresh := KeygenMakeObjects.fresh_separate 0
        (KeygenMakePrologue.projectionStart before)
        (KeygenMakePrologue.declared before blocks) blocks exec (4 : Fin 6) (by omega)
        ctx.scratch.block scratchLive
      have same : (KeygenMakeEntry.publicPointer blocks).block=blocks 4 := rfl
      rw [same]
      exact fresh
    refine ⟨facts.1,?_,?_,?_,tablesH,?_⟩
    · show KeygenPublicInputMaterial.Legal after.heap
        (KeygenMakeObjects.pointer blocks ⟨(0 : Fin 4).val,_⟩)
      exact legal_of_pointer after.heap blocks _ (by decide) (arrayShape _).2.2
    · show KeygenPublicInputMaterial.Legal after.heap
        (KeygenMakeObjects.pointer blocks ⟨(1 : Fin 4).val,_⟩)
      exact legal_of_pointer after.heap blocks _ (by decide) (arrayShape _).2.2
    · show KeygenPublicInputMaterial.Legal after.heap
        (KeygenMakeObjects.pointer blocks (4 : Fin 6))
      exact legal_of_pointer after.heap blocks (4 : Fin 6) (by decide) (arrayShape 4).2.2
    · exact ⟨scratchH,tablesH⟩

theorem scratch_size (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (head : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩) :
    after.heap.size ctx.scratch.block=before.heap.size ctx.scratch.block := by
  cases head with
  | run objects initialized dimensioned events out declarations counter dimensions gate =>
    have objectsEq : objects=KeygenMakePrologue.declared before blocks := by cases declarations; rfl
    subst objects
    have entry := KeygenMakePrologue.initial ctx before (KeygenMakePrologue.declared before blocks)
      primes rev original blocks declarations
    have initializedEq : initialized=KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks) :=
      congrArg Result.state (KeygenMakePrologue.count_result before blocks ⟨initialized,.normal⟩ counter)
    subst initialized
    have profile : KeygenSearchContext.M0
        (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)).heap ctx := entry.profile
    have dimensionsEq := KeygenMakePrologue.dimensions_result ctx
      (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)) dimensioned profile dimensions
    subst dimensioned
    have exec := KeygenMakePrologue.allocation_projection before (KeygenMakePrologue.declared before blocks) blocks declarations
    have originalP := KeygenMakePrologue.projection_original ctx before primes rev original
    have allocated := KeygenMakeObjects.live_frame 0 (KeygenMakePrologue.projectionStart before)
      (KeygenMakePrologue.declared before blocks) blocks exec ctx.scratch.block
      (KeygenMakeEntry.scratch_live ctx _ primes rev originalP)
    have call := KeygenMakeReady.gate_normal ctx _ after events gate
    have rng := KeygenMakeReady.block_frame ctx _ after events (.int32 1) call ctx.scratch.block original.contextScratch
    exact rng.1.trans allocated.1

end FT1536.Source3.KeygenEntryAt080
