import Source3.KeygenPublicComplete082
import Source3.KeygenPublicPrivateBridge082
import Source3.KeygenMakeAssembly134
import Source3.KeygenOutputMemory134
import Source3.KeygenPublicPrivateBridge134
import Source3.KeygenSecretComplete134
import Source3.KeygenSecretInvocation134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenPublicComplete134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)


open KeygenPublicComplete082
structure Output (env : Env) (caller : State) (out : Result) where
  secret : KeygenSecretComplete134.Output env caller out
  publicPacket : List (BitVec 8)
  publicObserved : KeygenPublicObserved077.ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap publicPacket
  publicLength : publicPacket.length=2881
  publicDecoded : KeygenPublicPacket077.DecodePublic publicPacket=some secret.h

theorem public_after_return (env : Env) (caller : State) (out : Result)
    (frontier : KeygenMakeAssembly134.Frontier env caller out) (buffers : KeygenOutputMemory081.Legal env caller)
    (packet : List (BitVec 8))
    (observed : KeygenPublicObserved077.ObservedPublic env.args.pubkey env.args.pubkeyLen frontier.tailOut.state.heap packet) :
    KeygenPublicObserved077.ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap packet := by
  rw [frontier.output]
  exact KeygenSecretObserved081.preserved _ _ _ _ packet
    (KeygenMakeLifetime.close_outside frontier.bound env.blocks frontier.tailOut env.args.pubkey.block
      (fun slot => Ne.symm (KeygenOutputMemory134.external env caller out frontier _ buffers.publicLive slot)))
    (KeygenMakeLifetime.close_outside frontier.bound env.blocks frontier.tailOut env.args.pubkeyLen.block
      (fun slot => Ne.symm (KeygenOutputMemory134.external env caller out frontier _ buffers.publicLengthLive slot))) observed

theorem observed_pair (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (publicLegal : KeygenPublicEntry082.Legal env caller capacity)
    (source : KeygenSecretInvocation134.PinnedExec env caller out)
    (success : out.flow=.returned (some (.int32 1))) : Nonempty (Output env caller out) := by
  obtain ⟨secret⟩ := KeygenSecretComplete134.observed_secret env caller out primes rev rootLegal buffers comp source success
  have entry := KeygenPublicPrivateBridge134.public_entry env caller out primes rev secret rootLegal buffers comp capacity publicLegal
  obtain ⟨packet,observed,length,decoded,call⟩ := KeygenPublicCallerComplete077.observed_output env
    secret.frontier.tail.suffixState secret.frontier.base.tailOut secret.frontier.tail.publicCalls capacity secret.h
    entry secret.publicAtSuffix secret.frontier.tail.publicRun secret.frontier.base.tailSuccess
  exact ⟨⟨secret,packet,public_after_return env caller out secret.frontier.base buffers packet observed,length,decoded⟩⟩

end FT1536.Source3.KeygenPublicComplete134
