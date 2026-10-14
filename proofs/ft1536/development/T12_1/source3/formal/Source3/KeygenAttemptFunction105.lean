import Source3.KeygenAttemptGates105

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenAttemptFunction105
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenCertificateSource080

theorem after_sampled (ctx : Context) (before : State) (raw : Result) (i : Nat)
    (polynomials : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeSearchPrefix.Sampled ctx before raw) (a b : Result)
    (first : Gate ctx raw.state a) (second : Gate ctx raw.state b) : a = b := by
  let domain := KeygenCertificateEntry104.from_sampled ctx before raw i polynomials h primes rev shape remaining initial source
  exact KeygenCertificateCall104.gate_unique ctx raw.state a b domain.shape domain.scratch domain.dimensions first second

theorem attempt (ctx : Context) (before : State) (i : Nat)
    (polynomials : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (hLive : 0 < before.heap.size h.block) (a b : Result)
    (first : Attempt ctx before a) (second : Attempt ctx before b) : a = b := by
  have prefixUnique := KeygenAttemptGates105.sampled ctx before i polynomials h primes rev initial remaining hLive
  have gateUnique := after_sampled ctx before
  cases first <;> cases second
  all_goals grind (ematch := 8)

theorem has_normal_cap (ctx : Context) (before : State) (out : Result) (source : Attempt ctx before out) :
    ∃ entry, KeygenMakeSampling.CappedSetup ctx before ⟨entry,.normal⟩ := by
  cases source with
  | earlyRejected raw sample rejected | throughCertificate raw sample atCert out gate =>
      cases sample with
      | run entry out cap gates => exact ⟨entry, cap⟩

theorem cap_excludes_attempt (ctx : Context) (before : State) (i : Nat) (out other : Result)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (cap : KeygenMakeSampling.CappedSetup ctx before out) (exit : out.flow ≠ .normal)
    (source : Attempt ctx before other) : False := by
  obtain ⟨entry, normal⟩ := has_normal_cap ctx before other source
  have same := KeygenCappedSampler092.cap_unique ctx before i out ⟨entry,.normal⟩ remaining cap normal
  exact exit (congrArg Result.flow same)

end FT1536.Source3.KeygenAttemptFunction105
