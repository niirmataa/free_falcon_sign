import Source3.KeygenPublicPrivateBridge082
import Source3.KeygenPublicEntry082
import Source3.KeygenPublicCallerComplete077
import Source3.KeygenOutputMemory134
import Source3.KeygenPublicEntry134
import Source3.KeygenSecretComplete134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenPublicPrivateBridge134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenCodecTypedSegments (Site Segments)
open KeygenSecretTailSource081 (Source)
open ShakeExtractFrame (SameBlock)


open KeygenPublicPrivateBridge082
theorem public_entry (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (result : KeygenSecretComplete134.Output env caller out)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (legal : KeygenPublicEntry082.Legal env caller capacity) :
    KeygenPublicCallerComplete077.Legal env result.frontier.tail.suffixState capacity := by
  have entry := KeygenPublicEntry134.at_loop_output env caller out primes rev result.frontier.base rootLegal buffers capacity legal
  have frame := private_frame env result.frontier.base.loopOut.state result.frontier.base.tailOut result.frontier.tail comp
    env.args.pubkeyLen.block (Ne.symm buffers.privatePublicLength)
    (KeygenOutputMemory134.external env caller out result.frontier.base _ buffers.publicLengthLive 5)
    (Ne.symm buffers.lengthPublicLength)
  have read := KeygenMakeRetryTransport.load64_frame result.frontier.base.loopOut.state.heap result.frontier.tail.suffixState.heap
    env.args.pubkeyLen capacity entry.1 frame.1 (fun i => frame.2.2 _)
  have writable := KeygenPublicEntry082.writable_block result.frontier.base.loopOut.state.heap result.frontier.tail.suffixState.heap
    (KeygenCodecExecution.byteOff env.args.pubkey 1) 2880 (congrFun frame.1 _) (congrFun frame.2.1 _) entry.2
  exact ⟨result.publicProfile,read,legal.capacityBound,writable,
    Ne.symm (KeygenOutputMemory134.external env caller out result.frontier.base _ buffers.publicLive 4),buffers.publicLength⟩

end FT1536.Source3.KeygenPublicPrivateBridge134
