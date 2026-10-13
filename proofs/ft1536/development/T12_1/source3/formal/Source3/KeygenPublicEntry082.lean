import Source3.KeygenExternalLoop082

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEntry082
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env inputOf publicOf)

/-- The already explicit public codec input-capacity/memory domain, stated
    at the ORIGINAL caller heap. Its transport is proved below. -/
structure Legal (env : Env) (caller : State) (capacity : BitVec 64) : Prop where
  capacityRead : Load64 caller.heap env.args.pubkeyLen capacity
  capacityBound : 2881≤capacity.toNat
  writable : KeygenPublicEncodeReady077.WritableBytes caller.heap
    (KeygenCodecExecution.byteOff env.args.pubkey 1) 2880
  contextLength : env.ctx.object.block≠env.args.pubkeyLen.block
  scratchLength : env.ctx.scratch.block≠env.args.pubkeyLen.block
  tablesLength : KeygenPublicFrame.Tables caller env.args.pubkeyLen.block

theorem ready_parts (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (head : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩) :
    KeygenMakeObjects.Exec 0 (KeygenMakePrologue.projectionStart before) blocks (KeygenMakePrologue.declared before blocks) ∧
    KeygenRngReference.Call ctx (KeygenMakePrologue.ready before blocks) events after (.int32 1) := by
  cases head with
  | run objects initialized dimensioned events result declarations counter dimensions gate =>
    have objectsEq : objects=KeygenMakePrologue.declared before blocks := by cases declarations; rfl
    subst objects
    have entry := KeygenMakePrologue.initial ctx before (KeygenMakePrologue.declared before blocks)
      primes rev original blocks declarations
    have initializedEq : initialized=KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks) :=
      congrArg Result.state (KeygenMakePrologue.count_result before blocks ⟨initialized,.normal⟩ counter)
    subst initialized
    have profile : KeygenSearchContext.M0
        (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)).heap ctx := entry.profile
    have dimensionsEq := KeygenMakePrologue.dimensions_result ctx
      (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)) dimensioned profile dimensions
    subst dimensioned
    exact ⟨KeygenMakePrologue.allocation_projection before _ blocks declarations,
      KeygenMakeReady.gate_normal ctx _ after events gate⟩

theorem ready_block (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (source : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩)
    (block : Nat) (live : 0<before.heap.size block) (separate : block≠ctx.object.block) :
    KeygenMakeObjects.Block before.heap after.heap block := by
  obtain ⟨allocation,call⟩ := ready_parts ctx before after blocks primes rev events original source
  have first := KeygenMakeObjects.live_frame 0 (KeygenMakePrologue.projectionStart before)
    (KeygenMakePrologue.declared before blocks) blocks allocation block live
  have last := KeygenMakeReady.block_frame ctx _ after events (.int32 1) call block separate
  exact ⟨last.1.trans first.1,last.2.1.trans first.2.1,fun offset => (last.2.2 offset).trans (first.2.2 offset)⟩

theorem ready_metadata (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (source : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩)
    (block : Nat) (live : 0<before.heap.size block) :
    after.heap.size block=before.heap.size block ∧ after.heap.writable block=before.heap.writable block := by
  obtain ⟨allocation,call⟩ := ready_parts ctx before after blocks primes rev events original source
  have first := KeygenMakeObjects.live_frame 0 (KeygenMakePrologue.projectionStart before)
    (KeygenMakePrologue.declared before blocks) blocks allocation block live
  have last := KeygenRngFrame.call_frame ctx _ after events (.int32 1) call (ctx.object.block+1) 0 (Or.inl (by omega))
  exact ⟨(congrFun last.1 block).trans first.1,(congrFun last.2.1 block).trans first.2.1⟩

theorem ready_tables (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original ctx before primes rev)
    (source : KeygenMakeReady.Prefix ctx before blocks events ⟨after,.normal⟩) : after.tables=before.tables := by
  have call := (ready_parts ctx before after blocks primes rev events original source).2
  exact (KeygenRngReference.call_slots ctx _ after events (.int32 1) call).2.2.2

theorem writable_block (before after : Memory) (ptr : ArrayPointer) (count : Nat)
    (size : after.size ptr.block=before.size ptr.block)
    (permission : after.writable ptr.block=before.writable ptr.block)
    (legal : KeygenPublicEncodeReady077.WritableBytes before ptr count) :
    KeygenPublicEncodeReady077.WritableBytes after ptr count := by
  refine ⟨by rw [permission]; exact legal.1,?_⟩
  intro i bound
  have allocated := legal.2 i bound
  obtain ⟨positive,aligned,inside,extent,fit⟩ := allocated
  exact ⟨positive,aligned,inside,by rw [show (KeygenCodecExecution.byteOff ptr i).block=ptr.block from rfl,size]; exact extent,
    by rw [show (KeygenCodecExecution.byteOff ptr i).block=ptr.block from rfl,size]; exact fit⟩

/-- The initial capacity and physical writable-buffer domain reach the
    accepted-loop output without any assumed caller or codec frame. -/
theorem at_loop_output (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (frontier : KeygenMakeAssembly080.Frontier env caller out)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (capacity : BitVec 64) (legal : Legal env caller capacity) :
    Load64 frontier.loopOut.state.heap env.args.pubkeyLen capacity ∧
      KeygenPublicEncodeReady077.WritableBytes frontier.loopOut.state.heap (KeygenCodecExecution.byteOff env.args.pubkey 1) 2880 := by
  have boundEq := KeygenMakeArguments.bind_exact caller env.args frontier.bound frontier.binding
  have boundHeap := KeygenOutputMemory081.bound_heap env caller out frontier
  have original : KeygenMakeEntry.Original env.ctx frontier.bound primes rev := by rw [boundEq]; exact rootLegal.original
  have shape : KeygenMakeWorkspaceBridge.Shape env.ctx := ⟨rootLegal.workspaceExtent,rootLegal.workspaceAligned⟩
  have space : KeygenMakeCertRelocation.SpaceAt env.ctx.scratch.block frontier.entry.heap := by
    change C99Automatic32.align4 (frontier.entry.heap.size env.ctx.scratch.block)+4<2^64
    rw [KeygenEntryAt080.scratch_size env.ctx frontier.bound frontier.entry env.blocks primes rev frontier.events original frontier.ready,boundHeap]
    exact rootLegal.workspaceSpace
  have facts := KeygenEntryAt080.entry_facts env.ctx frontier.bound frontier.entry env.blocks primes rev frontier.events original frontier.ready
  have remaining := KeygenMakeLoopChronology.entry_remaining env frontier.bound frontier.entry primes rev frontier.events original frontier.ready
  have entryLength := ready_block env.ctx frontier.bound frontier.entry env.blocks primes rev frontier.events original frontier.ready
    env.args.pubkeyLen.block (by rw [boundHeap]; exact buffers.publicLengthLive) (Ne.symm legal.contextLength)
  have tables : frontier.entry.tables=caller.tables := (ready_tables env.ctx frontier.bound frontier.entry env.blocks primes rev
    frontier.events original frontier.ready).trans (by rw [boundEq]; rfl)
  have foreign : KeygenExternalSampling082.Outside env.ctx frontier.entry (inputOf env) (publicOf env) env.args.pubkeyLen.block := by
    refine ⟨legal.contextLength,legal.scratchLength,?_,?_,?_,?_⟩
    · intro slot
      exact Ne.symm (KeygenOutputMemory081.external env caller out frontier _ buffers.publicLengthLive
        ⟨slot.val,by have bound:=slot.isLt; omega⟩)
    · exact Ne.symm (KeygenOutputMemory081.external env caller out frontier _ buffers.publicLengthLive 4)
    · exact KeygenMakeAttemptSpine.tables_same caller frontier.entry _ tables.symm legal.tablesLength
    · rw [entryLength.1,boundHeap]
      exact buffers.publicLengthLive
  have frame := KeygenExternalLoop082.loop env.ctx frontier.entry frontier.loopOut frontier.attempts frontier.loop
    (inputOf env) (publicOf env) primes rev env.args.pubkeyLen.block shape 0 remaining facts.initial foreign space frontier.loopNormal
  have entryRead : Load64 frontier.entry.heap env.args.pubkeyLen capacity :=
    KeygenSecretObserved081.length_block frontier.bound.heap frontier.entry.heap env.args.pubkeyLen capacity entryLength
      (by rw [boundHeap]; exact legal.capacityRead)
  have capacityRead := KeygenMakeRetryTransport.load64_frame frontier.entry.heap frontier.loopOut.state.heap env.args.pubkeyLen capacity
    entryRead frame.1 (fun i => frame.2.2 _)
  have entryBuffer := ready_metadata env.ctx frontier.bound frontier.entry env.blocks primes rev frontier.events original frontier.ready
    env.args.pubkey.block (by rw [boundHeap]; exact buffers.publicLive)
  have entryWritable := writable_block frontier.bound.heap frontier.entry.heap (KeygenCodecExecution.byteOff env.args.pubkey 1) 2880
    entryBuffer.1 entryBuffer.2 (by rw [boundHeap]; exact legal.writable)
  exact ⟨capacityRead,writable_block frontier.entry.heap frontier.loopOut.state.heap (KeygenCodecExecution.byteOff env.args.pubkey 1) 2880
    (congrFun frame.1 _) (congrFun frame.2.1 _) entryWritable⟩

end FT1536.Source3.KeygenPublicEntry082
