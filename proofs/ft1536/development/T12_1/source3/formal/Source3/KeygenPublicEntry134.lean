import Source3.KeygenPublicEntry082
import Source3.KeygenExternalLoop082
import Source3.KeygenExternalLoop134
import Source3.KeygenMakeAssembly134
import Source3.KeygenOutputMemory134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenPublicEntry134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env inputOf publicOf)




open KeygenPublicEntry082
theorem at_loop_output (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (frontier : KeygenMakeAssembly134.Frontier env caller out)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (capacity : BitVec 64) (legal : Legal env caller capacity) :
    Load64 frontier.loopOut.state.heap env.args.pubkeyLen capacity ∧
      KeygenPublicEncodeReady077.WritableBytes frontier.loopOut.state.heap (KeygenCodecExecution.byteOff env.args.pubkey 1) 2880 := by
  have boundEq := KeygenMakeArguments.bind_exact caller env.args frontier.bound frontier.binding
  have boundHeap := KeygenOutputMemory134.bound_heap env caller out frontier
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
      exact Ne.symm (KeygenOutputMemory134.external env caller out frontier _ buffers.publicLengthLive
        ⟨slot.val,by have bound:=slot.isLt; omega⟩)
    · exact Ne.symm (KeygenOutputMemory134.external env caller out frontier _ buffers.publicLengthLive 4)
    · exact KeygenMakeAttemptSpine.tables_same caller frontier.entry _ tables.symm legal.tablesLength
    · rw [entryLength.1,boundHeap]
      exact buffers.publicLengthLive
  have frame := KeygenExternalLoop134.loop env.ctx frontier.entry frontier.loopOut frontier.attempts frontier.loop
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

end FT1536.Source3.KeygenPublicEntry134
