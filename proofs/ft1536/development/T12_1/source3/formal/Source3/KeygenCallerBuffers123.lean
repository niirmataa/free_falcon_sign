import Source3.KeygenCallerDomain123

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCallerBuffers123
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99CompactState115 (reference)
open KeygenCallerData123
open KeygenCallerMemory123
open KeygenCallerShape123

theorem writable_span (heap : Memory) (block count : Nat) (size : heap.size block=count)
    (permission : heap.writable block=true) (fits : count<2^64) :
    KeygenPublicEncodeReady077.WritableBytes heap ⟨block,0,count,1,0⟩ count := by
  refine ⟨permission,?_⟩
  intro i bound
  simpa [Allocated,KeygenCodecExecution.byteOff,ArrayPointer.offset,size] using And.intro bound fits

theorem private_capacity : Load64 (reference base).heap env.args.privkeyLen 12289 :=
  load64_block _ _ env.args.privkeyLen 12289 (external_block 4 (by decide) (by decide) (by decide))
    (C99FiniteRead114.read64_sound externals env.args.privkeyLen 12289 (by decide +kernel))

theorem private_writable : KeygenPublicEncodeReady077.WritableBytes (reference base).heap env.args.privkey 12289 := by
  apply writable_span
  · change (memory heap).size 3=12289
    rw [sizes,external_sizes]
    decide
  · change (memory heap).writable 3=true
    rw [permissions,external_permissions]
    decide
  · decide

theorem whole_public_writable : KeygenPublicEncodeReady077.WritableBytes (reference base).heap env.args.pubkey 2881 := by
  apply writable_span
  · change (memory heap).size 5=2881
    rw [sizes,external_sizes]
    decide
  · change (memory heap).writable 5=true
    rw [permissions,external_permissions]
    decide
  · decide

theorem stored_scratch : Load64 (reference base).heap (KeygenSearchContext.field env.ctx 432 8)
    (KeygenSearchContext.pointerWord env.ctx) :=
  load64_block _ _ _ _ (external_block 1 (by decide) (by decide) (by decide))
    (C99FiniteRead114.read64_sound externals (KeygenSearchContext.field env.ctx 432 8)
      (KeygenSearchContext.pointerWord env.ctx) (by decide +kernel))

theorem stored_scratch_length : Load64 (reference base).heap (KeygenSearchContext.field env.ctx 440 8) 286720 :=
  load64_block _ _ _ _ (external_block 1 (by decide) (by decide) (by decide))
    (C99FiniteRead114.read64_sound externals (KeygenSearchContext.field env.ctx 440 8) 286720 (by decide +kernel))

theorem actual_scratch_read : KeygenSearchContext.ReadTmp env.ctx
    (KeygenMakeArguments.entry (reference base) env.args) env.ctx.scratch :=
  .read rfl object_legal (by unfold KeygenSearchContext.PointerLegal; decide +kernel) stored_scratch

theorem initial_flag (flag : KeygenReadyFast.Flag) :
    KeygenReadyFast.Read env.ctx (KeygenMakeArguments.entry (reference base) env.args) flag 0 := by
  refine .load 0 rfl object_legal ?_
  apply KeygenMakeEntry.load32_block _ _ _ _ (external_block 1 (by decide) (by decide) (by decide))
  apply C99FiniteRead114.read32_sound
  cases flag <;> decide +kernel

end FT1536.Source3.KeygenCallerBuffers123
