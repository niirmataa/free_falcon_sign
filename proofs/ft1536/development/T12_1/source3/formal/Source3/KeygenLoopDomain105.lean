import Source3.KeygenAttemptFunction105

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLoopDomain105
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenCertificateSource080

structure Input (ctx : Context) (before : State) where
  count : Nat
  polynomials : Fin 4 → ArrayPointer
  h : ArrayPointer
  primes : ArrayPointer
  rev : ArrayPointer
  initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev
  remaining : KeygenMakeSearchPrefix.Remaining before count
  shape : KeygenMakeWorkspaceBridge.Shape ctx
  space : KeygenMakeCertRelocation.SpaceAt ctx.scratch.block before.heap
  publicLive : 0 < before.heap.size h.block

def next (ctx : Context) (before : State) (input : Input ctx before) (out : Result)
    (source : Attempt ctx before out) : Input ctx out.state := by
  have projected := attempt_projection ctx before out input.shape source
  have retained := KeygenRetryAt080.attempt_entry ctx before out input.count input.polynomials input.h input.primes input.rev
    input.remaining input.initial input.shape input.space projected
  exact {
    count := input.count + 1
    polynomials := input.polynomials
    h := input.h
    primes := input.primes
    rev := input.rev
    initial := retained.1
    remaining := (KeygenRetryAt080.attempt_remaining ctx before out input.count input.remaining projected).2.1
    shape := input.shape
    space := KeygenCertificateAt080.space_preserved ctx before.heap out.state.heap input.primes input.rev retained.2.1 input.space
    publicLive := by rw [retained.2.1.sizes]; exact input.publicLive }

theorem attempt_unique (ctx : Context) (before : State) (input : Input ctx before) (a b : Result)
    (first : Attempt ctx before a) (second : Attempt ctx before b) : a = b :=
  KeygenAttemptFunction105.attempt ctx before input.count input.polynomials input.h input.primes input.rev
    input.shape input.initial input.remaining input.publicLive a b first second

theorem cap_unique (ctx : Context) (before : State) (input : Input ctx before) (a b : Result)
    (first : KeygenMakeSampling.CappedSetup ctx before a) (second : KeygenMakeSampling.CappedSetup ctx before b) : a = b :=
  KeygenCappedSampler092.cap_unique ctx before input.count a b input.remaining first second

theorem excludes (ctx : Context) (before : State) (input : Input ctx before) (a b : Result)
    (cap : KeygenMakeSampling.CappedSetup ctx before a) (exit : a.flow ≠ .normal) (source : Attempt ctx before b) : False :=
  KeygenAttemptFunction105.cap_excludes_attempt ctx before input.count a b input.remaining cap exit source

end FT1536.Source3.KeygenLoopDomain105
