import Source3.KeygenCertificateCall104

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCertificateEntry104
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem shape (env : KeygenMakeInvocation.Env) (caller : State) (domain : KeygenWholeBytes088.Domain env caller) :
    KeygenMakeWorkspaceBridge.Shape env.ctx :=
  ⟨domain.rootLegal.workspaceExtent, domain.rootLegal.workspaceAligned⟩

/-- Every actual pre-certificate run derives the local certificate domain
    from the existing loop-entry invariants; neither success nor a source
    certificate realization is assumed. -/
def from_sampled (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (workspace : KeygenMakeWorkspaceBridge.Shape ctx)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenMakeSearchPrefix.Sampled ctx before out) : KeygenCertificateCall104.Input ctx where
  before := out.state
  shape := workspace
  scratch := (KeygenMakeRetryTransport.sampled_entry ctx before out i input h primes rev remaining initial source).1.scratch
  dimensions := (KeygenMakeSearchPrefix.sampled_remaining ctx before out i remaining source).2.1.2.1

end FT1536.Source3.KeygenCertificateEntry104
