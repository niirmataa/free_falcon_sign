import Source3.KeygenEmittedFiber083

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- B1.10 reference contract. Execution, input memory, return value and byte
   observations are independent of the conclusions. This is a deterministic
   contract; it does not identify a probability law of successful keygen. -/
namespace FT1536.Source3.KeygenSourceToFiber001
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)

abbrev PinnedExec := KeygenSecretInvocation081.PinnedExec
def Success (out : Result) : Prop := out.flow=.returned (some (.int32 1))
def Emitted (env : Env) (out : Result) (sk pk : List (BitVec 8)) : Prop :=
  KeygenSecretObserved081.ObservedSecret env.args.privkey env.args.privkeyLen out.state.heap sk ∧
  KeygenPublicObserved077.ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap pk

abbrev Output := KeygenPublicComplete082.Output
abbrev secretBytes (r : Output env caller out) := KeygenSecretLocal081.packet r.secret.vectors
abbrev publicBytes (r : Output env caller out) := r.publicPacket
abbrev FiberFacts (r : Output env caller out) := KeygenEmittedFiber083.FiberFacts r

/-- Named conclusions consumed by B4/B5. The material, source certificate,
    three equations and chronological attempts remain in the SAME Output. -/
structure Contract (r : Output env caller out) : Prop where
  emitted : Emitted env out (secretBytes r) (publicBytes r)
  secretDecoded : KeygenSecretPacket081.DecodeSecret (secretBytes r)=
    some (r.secret.vectors 0,r.secret.vectors 1,r.secret.vectors 2,r.secret.vectors 3)
  publicDecoded : KeygenPublicPacket077.DecodePublic (publicBytes r)=some r.secret.h
  secretLength : 7681≤(secretBytes r).length ∧ (secretBytes r).length≤10369
  publicLength : (publicBytes r).length=2881
  sameCertificate : KeygenSecretComplete081.SameCertificate env caller out
    r.secret.frontier.base r.secret.vectors r.secret.h
  callBound : 1≤KeygenMakeAssembly080.callId env caller out r.secret.frontier.base ∧
    KeygenMakeAssembly080.callId env caller out r.secret.frontier.base≤3000000
  fiber : FiberFacts r

theorem contract_of_output (r : Output env caller out) : Contract r := by
  exact ⟨⟨r.secret.observed,r.publicObserved⟩,r.secret.decoded,r.publicDecoded,
    KeygenSecretComplete081.length_bounds env caller out r.secret,r.publicLength,
    r.secret.certificate,KeygenMakeAssembly080.call_id_bound env caller out r.secret.frontier.base,
    KeygenEmittedFiber083.from_output r⟩

/-- The reference B1.10 contract, with the allowed premise boundary written
    out. No equation, codec result, certificate acceptance or loop success
    is an additional premise. Return 1 is an observed execution condition. -/
theorem emitted_to_actual_fiber (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (publicLegal : KeygenPublicEntry082.Legal env caller capacity)
    (source : PinnedExec env caller out) (success : Success out) :
    ∃ result : Output env caller out, Contract result := by
  obtain ⟨result⟩ := KeygenPublicComplete082.observed_pair env caller out primes rev
    rootLegal buffers comp capacity publicLegal source success
  exact ⟨result,contract_of_output result⟩

/-- Independently observed final bytes are identified with the derived
    packets. Both decoders and the fiber therefore concern identical keys. -/
theorem actual_observed_fiber (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (publicLegal : KeygenPublicEntry082.Legal env caller capacity)
    (source : PinnedExec env caller out) (success : Success out) (sk pk : List (BitVec 8))
    (observed : Emitted env out sk pk) :
    ∃ result : Output env caller out, Contract result ∧
      sk=secretBytes result ∧ pk=publicBytes result := by
  obtain ⟨result,contract⟩ := emitted_to_actual_fiber env caller out primes rev
    rootLegal buffers comp capacity publicLegal source success
  exact ⟨result,contract,
    KeygenSecretObserved081.unique _ _ _ sk _ observed.1 contract.emitted.1,
    KeygenPublicObserved077.observed_unique _ _ _ pk _ observed.2 contract.emitted.2⟩

end FT1536.Source3.KeygenSourceToFiber001
