import Source3.KeygenPublicEntry082
import Source3.KeygenPublicCallerComplete077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicPrivateBridge082
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenCodecTypedSegments (Site Segments)
open KeygenSecretTailSource081 (Source)
open ShakeExtractFrame (SameBlock)

theorem site_frame (env : Env) (c : Site env) (comp : env.args.comp=1) (block : Nat)
    (separate : block≠env.args.privkey.block) : SameBlock c.before.heap c.after block := by
  have window := KeygenCodecInvocationWindows.site_window env c comp
  exact ⟨window.sizes,window.writable,fun offset => window.bytes block offset (Or.inl separate)⟩

theorem segments_frame (env : Env) (i : Nat) (s : State) (out : Result) (calls : List (Site env))
    (source : Segments env i s out calls) (comp : env.args.comp=1) (block : Nat)
    (separate : block≠env.args.privkey.block) : SameBlock s.heap out.state.heap block := by
  induction source with
  | done => exact ⟨rfl,rfl,fun _ => rfl⟩
  | capacity c counter zero => exact site_frame env c comp block separate
  | next c counter nonzero skoff cell rest ih =>
    exact KeygenPublicForeign081.same_trans _ _ _ block (site_frame env c comp block separate) ih

theorem private_frame (env : Env) (s : State) (out : Result) (source : Source env s out)
    (comp : env.args.comp=1) (block : Nat)
    (bufferSeparate : block≠env.args.privkey.block) (skeSeparate : block≠env.blocks 5)
    (lengthSeparate : block≠env.args.privkeyLen.block) : SameBlock s.heap source.suffixState.heap block := by
  have first := KeygenSerializationEntry079.prefix_frame env _ s ⟨source.headState,.normal⟩ block source.prelude
    (fun _ member => member) rfl bufferSeparate skeSeparate
  have middle := segments_frame env 0 (KeygenMakeInvocation.initCounter source.headState) ⟨source.segmentState,.normal⟩
    source.privateCalls source.segments comp block bufferSeparate
  obtain ⟨skoff,cell,store⟩ := KeygenSecretCallerTrace081.length_store env source.segmentState source.suffixState source.lengthHead
  have last : SameBlock source.segmentState.heap source.suffixState.heap block :=
    ⟨store.2.2.2.1,store.2.2.2.2.1,fun offset => store.2.2.2.2.2.2 block offset (Or.inl lengthSeparate)⟩
  exact KeygenPublicForeign081.same_trans _ _ _ block first (KeygenPublicForeign081.same_trans _ _ _ block middle last)

/-- Discharge the old077 suffix-entry Legal from ORIGINAL caller capacity
    and physical memory, through KeyGen and all private serializer writes. -/
theorem public_entry (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (result : KeygenSecretComplete081.Output env caller out)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (legal : KeygenPublicEntry082.Legal env caller capacity) :
    KeygenPublicCallerComplete077.Legal env result.frontier.tail.suffixState capacity := by
  have entry := KeygenPublicEntry082.at_loop_output env caller out primes rev result.frontier.base rootLegal buffers capacity legal
  have frame := private_frame env result.frontier.base.loopOut.state result.frontier.base.tailOut result.frontier.tail comp
    env.args.pubkeyLen.block (Ne.symm buffers.privatePublicLength)
    (KeygenOutputMemory081.external env caller out result.frontier.base _ buffers.publicLengthLive 5)
    (Ne.symm buffers.lengthPublicLength)
  have read := KeygenMakeRetryTransport.load64_frame result.frontier.base.loopOut.state.heap result.frontier.tail.suffixState.heap
    env.args.pubkeyLen capacity entry.1 frame.1 (fun i => frame.2.2 _)
  have writable := KeygenPublicEntry082.writable_block result.frontier.base.loopOut.state.heap result.frontier.tail.suffixState.heap
    (KeygenCodecExecution.byteOff env.args.pubkey 1) 2880 (congrFun frame.1 _) (congrFun frame.2.1 _) entry.2
  exact ⟨result.publicProfile,read,legal.capacityBound,writable,
    Ne.symm (KeygenOutputMemory081.external env caller out result.frontier.base _ buffers.publicLive 4),buffers.publicLength⟩

end FT1536.Source3.KeygenPublicPrivateBridge082
