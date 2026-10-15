import Source3.KeygenLoopDomain105
import Source3.KeygenAttemptFunction105
import Source3.KeygenAttemptFunction134
import Source3.KeygenCertificateSource134
import Source3.KeygenRetryAt134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenLoopDomain134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenCertificateSource080 hiding Attempt AttemptExecution Loop attempt_projection loop_projection projected
open KeygenCertificateSource134
open KeygenLoopDomain105
def next (ctx : Context) (before : State) (input : Input ctx before) (out : Result)
    (source : Attempt ctx before out) : Input ctx out.state := by
  have projected := attempt_projection ctx before out input.shape source
  have retained := KeygenRetryAt134.attempt_entry ctx before out input.count input.polynomials input.h input.primes input.rev
    input.remaining input.initial input.shape input.space projected
  exact {
    count := input.count + 1
    polynomials := input.polynomials
    h := input.h
    primes := input.primes
    rev := input.rev
    initial := retained.1
    remaining := (KeygenRetryAt134.attempt_remaining ctx before out input.count input.remaining projected).2.1
    shape := input.shape
    space := KeygenCertificateAt080.space_preserved ctx before.heap out.state.heap input.primes input.rev retained.2.1 input.space
    publicLive := by rw [retained.2.1.sizes]; exact input.publicLive }

theorem attempt_unique (ctx : Context) (before : State) (input : Input ctx before) (a b : Result)
    (first : Attempt ctx before a) (second : Attempt ctx before b) : a = b :=
  KeygenAttemptFunction134.attempt ctx before input.count input.polynomials input.h input.primes input.rev
    input.shape input.initial input.remaining input.publicLive a b first second

theorem excludes (ctx : Context) (before : State) (input : Input ctx before) (a b : Result)
    (cap : KeygenMakeSampling.CappedSetup ctx before a) (exit : a.flow ≠ .normal) (source : Attempt ctx before b) : False :=
  KeygenAttemptFunction134.cap_excludes_attempt ctx before input.count a b input.remaining cap exit source

end FT1536.Source3.KeygenLoopDomain134
