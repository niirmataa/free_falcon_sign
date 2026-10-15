import Source3.KeygenPublicDomain095
import Source3.KeygenPublicCall095
import Source3.KeygenCallerPrefix134
import Source3.KeygenMakeRetryTransport134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenPublicDomain134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)


open KeygenPublicDomain095
def after_ternary (ctx : Context) (before : State) (i : Nat) (out : Result)
    (polynomials : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev)
    (size : C99CountedWords.Limit before) (hLive : 0 < before.heap.size h.block)
    (source : KeygenCallerPrefix134.Ternary ctx (KeygenMakeSearchPrefix.updated ctx before i) out) :
    KeygenPublicCall095.Input := by
  let entry := KeygenMakeSearchPrefix.updated ctx before i
  have prepared := KeygenMakeSampling.prepared_initial ctx before i polynomials h primes rev initial
  have material := KeygenMakeSampling.entry_from_prepared ctx before i polynomials h primes rev initial size
  have retained := KeygenMakeRetryTransport134.initial_of_ternary ctx entry out polynomials h primes rev prepared material
    (KeygenMakeSearchMaterial.context_norm ctx before i polynomials h primes rev initial) source
  have closed := KeygenMakeRetryTransport.initial_of_close ctx before out.state polynomials h primes rev retained
  have sizes := KeygenCallerPrefix134.ternary_size ctx entry out (polynomials 0) (polynomials 1) material source
  apply KeygenPublicCall095.from_initial ctx _ polynomials h primes rev closed
  change 0 < out.state.heap.size h.block
  rw [sizes]
  exact hLive

end FT1536.Source3.KeygenPublicDomain134
