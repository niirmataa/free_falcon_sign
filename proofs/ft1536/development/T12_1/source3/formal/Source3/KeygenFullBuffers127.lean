import Source3.KeygenFullDomain127

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenFullBuffers127
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99CompactState115 (reference)
open KeygenFullData127
open KeygenFullMemory127
open KeygenFullFacts127

theorem private_capacity : Load64 (reference base).heap env.args.privkeyLen 12289 :=
  KeygenCallerShape123.load64_block _ _ _ _ (external_frame 4 (by decide))
    (C99FiniteRead114.read64_sound externals env.args.privkeyLen 12289 (by decide +kernel))

theorem private_writable : KeygenPublicEncodeReady077.WritableBytes (reference base).heap env.args.privkey 12289 := by
  apply KeygenCallerBuffers123.writable_span
  · change (memory heap).size 3=12289
    rw [sizes,external_sizes]
    decide
  · change (memory heap).writable 3=true
    rw [permissions,external_permissions]
    decide
  · decide

theorem stored_scratch : Load64 (reference base).heap (KeygenSearchContext.field env.ctx 432 8)
    (KeygenSearchContext.pointerWord env.ctx) :=
  KeygenCallerShape123.load64_block _ _ _ _ (external_frame 30 (by decide))
    (C99FiniteRead114.read64_sound externals (KeygenSearchContext.field env.ctx 432 8)
      (KeygenSearchContext.pointerWord env.ctx) (by decide +kernel))

theorem stored_scratch_length : Load64 (reference base).heap (KeygenSearchContext.field env.ctx 440 8) 286720 :=
  KeygenCallerShape123.load64_block _ _ _ _ (external_frame 30 (by decide))
    (C99FiniteRead114.read64_sound externals (KeygenSearchContext.field env.ctx 440 8) 286720 (by decide +kernel))

theorem actual_scratch_read : KeygenSearchContext.ReadTmp env.ctx
    (KeygenMakeArguments.entry (reference base) env.args) env.ctx.scratch :=
  .read rfl KeygenFullDomain127.object_legal (by unfold KeygenSearchContext.PointerLegal; decide +kernel) stored_scratch

theorem initial_flag (flag : KeygenReadyFast.Flag) :
    KeygenReadyFast.Read env.ctx (KeygenMakeArguments.entry (reference base) env.args) flag 0 := by
  refine .load 0 rfl KeygenFullDomain127.object_legal ?_
  apply KeygenMakeEntry.load32_block _ _ _ _ (external_frame 30 (by decide))
  apply C99FiniteRead114.read32_sound
  cases flag <;> decide +kernel

theorem rc_object : ShakeExtractSource.StaticRC (memory heap) ⟨20,0,24,8,0⟩ := by
  have pFrame := C99FiniteInit123.outside (withRC externals) 21 (4*(3*KeygenStaticTables.rowCount .ternary)) false
    (C99FiniteInit123.words32 (KeygenPrimeObjects123.words .ternary)) 20 (by decide)
  have rFrame := C99FiniteInit123.outside (withPrimes3 externals) 22 (2*1024) false
    (C99FiniteWords123.words16 KeygenRevObject123.words) 20 (by decide)
  have eFrame := extras_frame (primary externals) 20 (by decide)
  have same := KeygenMakeObjects.block_trans _ _ _ 20 pFrame (KeygenMakeObjects.block_trans _ _ _ 20 rFrame eFrame)
  refine ⟨same.2.1.trans (KeygenTableObjects127.readonly64 externals 20 ShakeExtractSource.rc),rfl,?_⟩
  intro i
  have loaded := KeygenTableObjects127.read64 externals 20 ShakeExtractSource.rc (by decide) ⟨i.val,by have := i.isLt; exact this⟩
  have full := KeygenCallerShape123.load64_block _ _ _ _ same loaded
  rw [getElem!_pos ShakeExtractSource.rc i.val (show i.val<ShakeExtractSource.rc.length from i.isLt)]
  simpa only [heap,KeygenTableObjects127.pointer64,KeygenSmallOutput.element,Nat.zero_add,
    show ShakeExtractSource.rc.length=24 from rfl] using full

end FT1536.Source3.KeygenFullBuffers127
