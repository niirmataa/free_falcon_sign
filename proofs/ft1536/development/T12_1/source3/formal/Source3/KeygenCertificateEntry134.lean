import Source3.KeygenCertificateEntry104
import Source3.KeygenCertificateCall104
import Source3.KeygenMakeRetryTransport134
import Source3.KeygenMakeSearchPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenCertificateEntry134
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)


open KeygenCertificateEntry104
def from_sampled (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (workspace : KeygenMakeWorkspaceBridge.Shape ctx)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenMakeSearchPrefix134.Sampled ctx before out) : KeygenCertificateCall104.Input ctx where
  before := out.state
  shape := workspace
  scratch := (KeygenMakeRetryTransport134.sampled_entry ctx before out i input h primes rev remaining initial source).1.scratch
  dimensions := (KeygenMakeSearchPrefix134.sampled_remaining ctx before out i remaining source).2.1.2.1

end FT1536.Source3.KeygenCertificateEntry134
