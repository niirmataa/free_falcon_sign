import Source3.KeygenSourceToFiber001
import Source3.KeygenEmittedFiber083
import Source3.KeygenEmittedFiber134
import Source3.KeygenMakeAssembly134
import Source3.KeygenPublicComplete134
import Source3.KeygenSecretComplete134
import Source3.KeygenSecretInvocation134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenSourceToFiber134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)


open KeygenSourceToFiber001
abbrev PinnedExec := KeygenSecretInvocation134.PinnedExec

abbrev Output := KeygenPublicComplete134.Output

abbrev secretBytes (r : Output env caller out) := KeygenSecretLocal081.packet r.secret.vectors

abbrev publicBytes (r : Output env caller out) := r.publicPacket

abbrev FiberFacts (r : Output env caller out) := KeygenEmittedFiber134.FiberFacts r

structure Contract (r : Output env caller out) : Prop where
  emitted : Emitted env out (secretBytes r) (publicBytes r)
  secretDecoded : KeygenSecretPacket081.DecodeSecret (secretBytes r)=
    some (r.secret.vectors 0,r.secret.vectors 1,r.secret.vectors 2,r.secret.vectors 3)
  publicDecoded : KeygenPublicPacket077.DecodePublic (publicBytes r)=some r.secret.h
  secretLength : 7681≤(secretBytes r).length ∧ (secretBytes r).length≤10369
  publicLength : (publicBytes r).length=2881
  sameCertificate : KeygenSecretComplete134.SameCertificate env caller out
    r.secret.frontier.base r.secret.vectors r.secret.h
  callBound : 1≤KeygenMakeAssembly134.callId env caller out r.secret.frontier.base ∧
    KeygenMakeAssembly134.callId env caller out r.secret.frontier.base≤3000000
  fiber : FiberFacts r

theorem contract_of_output (r : Output env caller out) : Contract r := by
  exact ⟨⟨r.secret.observed,r.publicObserved⟩,r.secret.decoded,r.publicDecoded,
    KeygenSecretComplete134.length_bounds env caller out r.secret,r.publicLength,
    r.secret.certificate,KeygenMakeAssembly134.call_id_bound env caller out r.secret.frontier.base,
    KeygenEmittedFiber134.from_output r⟩

theorem emitted_to_actual_fiber (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (publicLegal : KeygenPublicEntry082.Legal env caller capacity)
    (source : PinnedExec env caller out) (success : Success out) :
    ∃ result : Output env caller out, Contract result := by
  obtain ⟨result⟩ := KeygenPublicComplete134.observed_pair env caller out primes rev
    rootLegal buffers comp capacity publicLegal source success
  exact ⟨result,contract_of_output result⟩

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

end FT1536.Source3.KeygenSourceToFiber134
