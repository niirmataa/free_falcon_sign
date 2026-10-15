import Source3.KeygenCallerTransport
import Source3.KeygenCallerEntry
import Source3.KeygenAttemptNorm133

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenCallerTransport134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenRootCaller (Legal)
open KeygenAttemptSlots (Slots)


open KeygenCallerTransport
theorem norm_root (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : Legal ctx before input primes rev) (separate : KeygenAttemptNorm.Protected ctx before ctx.object.block)
    (source : KeygenAttemptNorm133.Exec ctx before out) : Legal ctx out.state input primes rev := by
  have stable := KeygenAttemptNorm133.stable ctx before out source
  exact legal_stable ctx before out.state input primes rev legal (KeygenAttemptNorm133.slots ctx before out source) stable
    (profile_bytes ctx before.heap out.state.heap legal.profile stable.size (KeygenAttemptNorm133.bytes ctx before out source ctx.object.block separate))

end FT1536.Source3.KeygenCallerTransport134
