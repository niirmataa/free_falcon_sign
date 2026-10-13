import Source3.KeygenPublicPrivateBridge082

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicComplete082
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)

structure Output (env : Env) (caller : State) (out : Result) where
  secret : KeygenSecretComplete081.Output env caller out
  publicPacket : List (BitVec 8)
  publicObserved : KeygenPublicObserved077.ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap publicPacket
  publicLength : publicPacket.length=2881
  publicDecoded : KeygenPublicPacket077.DecodePublic publicPacket=some secret.h

theorem public_after_return (env : Env) (caller : State) (out : Result)
    (frontier : KeygenMakeAssembly080.Frontier env caller out) (buffers : KeygenOutputMemory081.Legal env caller)
    (packet : List (BitVec 8))
    (observed : KeygenPublicObserved077.ObservedPublic env.args.pubkey env.args.pubkeyLen frontier.tailOut.state.heap packet) :
    KeygenPublicObserved077.ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap packet := by
  rw [frontier.output]
  exact KeygenSecretObserved081.preserved _ _ _ _ packet
    (KeygenMakeLifetime.close_outside frontier.bound env.blocks frontier.tailOut env.args.pubkey.block
      (fun slot => Ne.symm (KeygenOutputMemory081.external env caller out frontier _ buffers.publicLive slot)))
    (KeygenMakeLifetime.close_outside frontier.bound env.blocks frontier.tailOut env.args.pubkeyLen.block
      (fun slot => Ne.symm (KeygenOutputMemory081.external env caller out frontier _ buffers.publicLengthLive slot))) observed

/-- B1.09: both actual final outputs are tied to the SAME accepted attempt,
    four secret vectors, public/inverse equations and source certificate.
    Public input capacity and memory are checked at the original caller heap. -/
theorem observed_pair (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (publicLegal : KeygenPublicEntry082.Legal env caller capacity)
    (source : KeygenSecretInvocation081.PinnedExec env caller out)
    (success : out.flow=.returned (some (.int32 1))) : Nonempty (Output env caller out) := by
  obtain ⟨secret⟩ := KeygenSecretComplete081.observed_secret env caller out primes rev rootLegal buffers comp source success
  have entry := KeygenPublicPrivateBridge082.public_entry env caller out primes rev secret rootLegal buffers comp capacity publicLegal
  obtain ⟨packet,observed,length,decoded,call⟩ := KeygenPublicCallerComplete077.observed_output env
    secret.frontier.tail.suffixState secret.frontier.base.tailOut secret.frontier.tail.publicCalls capacity secret.h
    entry secret.publicAtSuffix secret.frontier.tail.publicRun secret.frontier.base.tailSuccess
  exact ⟨⟨secret,packet,public_after_return env caller out secret.frontier.base buffers packet observed,length,decoded⟩⟩

/-- Both decoders consume independently observed final bytes. Their common
    mathematical material is derived; no agreement of packets is assumed. -/
theorem actual_observed_pair (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (publicLegal : KeygenPublicEntry082.Legal env caller capacity)
    (source : KeygenSecretInvocation081.PinnedExec env caller out)
    (success : out.flow=.returned (some (.int32 1))) (sk pk : List (BitVec 8))
    (secretObserved : KeygenSecretObserved081.ObservedSecret env.args.privkey env.args.privkeyLen out.state.heap sk)
    (publicObserved : KeygenPublicObserved077.ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap pk) :
    ∃ result : Output env caller out,
      KeygenSecretPacket081.DecodeSecret sk=some (result.secret.vectors 0,result.secret.vectors 1,result.secret.vectors 2,result.secret.vectors 3) ∧
      KeygenPublicPacket077.DecodePublic pk=some result.secret.h ∧ pk.length=2881 ∧ 7681≤sk.length ∧ sk.length≤10369 := by
  obtain ⟨result⟩ := observed_pair env caller out primes rev rootLegal buffers comp capacity publicLegal source success
  have secretEq := KeygenSecretObserved081.unique env.args.privkey env.args.privkeyLen out.state.heap sk _
    secretObserved result.secret.observed
  have publicEq := KeygenPublicObserved077.observed_unique env.args.pubkey env.args.pubkeyLen out.state.heap pk _
    publicObserved result.publicObserved
  have lengths := KeygenSecretComplete081.length_bounds env caller out result.secret
  exact ⟨result,by rw [secretEq]; exact result.secret.decoded,
    by rw [publicEq]; exact result.publicDecoded,
    by rw [publicEq]; exact result.publicLength,
    by rw [secretEq]; exact lengths.1,by rw [secretEq]; exact lengths.2⟩

end FT1536.Source3.KeygenPublicComplete082
