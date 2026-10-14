import Source3.KeygenPublicCall095

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDomain095
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem gate_sizes (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : KeygenMakeReady.Gate ctx before events out) : out.state.heap.size = before.heap.size := by
  cases source with
  | normal after word v call test zero =>
      exact (KeygenRngFrame.call_frame ctx before after events _ call (ctx.object.block + 1) 0 (Or.inl (by omega))).1
  | failure after word v out call test nonzero returned =>
      rw [KeygenMakeReady.failure_result after out returned]
      exact (KeygenRngFrame.call_frame ctx before after events _ call (ctx.object.block + 1) 0 (Or.inl (by omega))).1

/-- The public output workspace is live because the real prefix allocated
    it. No separate source-realization or success assumption is supplied. -/
theorem prefix_public_live (ctx : Context) (before : State) (blocks : Fin 6 → Nat)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : KeygenMakeReady.Prefix ctx before blocks events out) :
    0 < out.state.heap.size (KeygenMakeEntry.publicPointer blocks).block := by
  cases source with
  | run objects initialized dimensioned events out declarations counter dimensions gate =>
      have allocated := KeygenMakePrologue.allocation_projection before objects blocks declarations
      have objectSize := (KeygenMakeObjects.object 0 (KeygenMakePrologue.projectionStart before) objects blocks
        allocated 4 (by decide)).2.1
      have counterSize := (KeygenMemoryStability.procedure _ _ objects ⟨initialized, .normal⟩ counter).size
      have dimensionHeap : dimensioned.heap = initialized.heap := by cases dimensions; rfl
      change 0 < out.state.heap.size (blocks 4)
      rw [gate_sizes ctx dimensioned events out gate, dimensionHeap, counterSize, objectSize]
      exact (KeygenMakeObjects.sizes 4).2.2.1

def after_ternary (ctx : Context) (before : State) (i : Nat) (out : Result)
    (polynomials : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev)
    (size : C99CountedWords.Limit before) (hLive : 0 < before.heap.size h.block)
    (source : KeygenCallerPrefix.Ternary ctx (KeygenMakeSearchPrefix.updated ctx before i) out) :
    KeygenPublicCall095.Input := by
  let entry := KeygenMakeSearchPrefix.updated ctx before i
  have prepared := KeygenMakeSampling.prepared_initial ctx before i polynomials h primes rev initial
  have material := KeygenMakeSampling.entry_from_prepared ctx before i polynomials h primes rev initial size
  have retained := KeygenMakeRetryTransport.initial_of_ternary ctx entry out polynomials h primes rev prepared material
    (KeygenMakeSearchMaterial.context_norm ctx before i polynomials h primes rev initial) source
  have closed := KeygenMakeRetryTransport.initial_of_close ctx before out.state polynomials h primes rev retained
  have sizes := KeygenCallerPrefix.ternary_size ctx entry out (polynomials 0) (polynomials 1) material source
  apply KeygenPublicCall095.from_initial ctx _ polynomials h primes rev closed
  change 0 < out.state.heap.size h.block
  rw [sizes]
  exact hLive

end FT1536.Source3.KeygenPublicDomain095
