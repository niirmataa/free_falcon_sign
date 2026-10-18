import Source3.SelectedRootEntry175
import Source3.NormProtected158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedRootContext175
open C99CompactState115 (reference)
open KeygenFullData127 (env)
open SelectedPublicSuccess174 (after)

def old := SelectedBound135.before

theorem norm_protected : KeygenAttemptNorm133.Protected env.ctx (reference old) env.ctx.object.block :=
  NormProtected158.source env.ctx old env.ctx.object.block (by decide) (by decide +kernel) (by decide +kernel)

theorem public_block : ShakeExtractFrame.SameBlock SelectedPublicBinding157.before.heap after.heap env.ctx.object.block :=
  KeygenPublicSource.frame SelectedPublicBinding157.before after (.int32 1) SelectedPublicSuccess174.source
    env.ctx.object.block SelectedRootEntry175.public_outside SelectedRootEntry175.before_public.contextProtected.2
    (KeygenCallerTransport.context_live env.ctx _ SelectedRootEntry175.before_public.profile)

theorem block : KeygenMakeObjects.Block (reference old).heap after.heap env.ctx.object.block := by
  refine ⟨(congrFun public_block.1 _).trans (congrFun SelectedPublicMemory157.stable.size _),
    (congrFun public_block.2.1 _).trans (congrFun SelectedPublicMemory157.stable.writable _),?_⟩
  intro offset
  exact (public_block.2.2 offset).trans
    (KeygenAttemptNorm133.bytes env.ctx (reference old) ⟨SelectedGsNorm155.after,.normal⟩
      SelectedGsGate156.norm_prefix env.ctx.object.block norm_protected offset)

theorem old_object : KeygenSearchContext.ObjectLegal (reference old).heap env.ctx := by
  unfold KeygenSearchContext.ObjectLegal
  decide +kernel

theorem object : KeygenSearchContext.ObjectLegal after.heap env.ctx := by
  simpa only [KeygenSearchContext.ObjectLegal,block.1] using old_object

theorem pointer : KeygenSearchContext.PointerLegal env.ctx := by
  unfold KeygenSearchContext.PointerLegal
  decide +kernel

theorem old_tmp : C99MemoryReference.Load64 (reference old).heap (KeygenSearchContext.field env.ctx 432 8)
    (KeygenSearchContext.pointerWord env.ctx) :=
  C99FiniteRead114.read64_sound old.heap _ _ (by decide +kernel)

theorem tmp : C99MemoryReference.Load64 after.heap (KeygenSearchContext.field env.ctx 432 8)
    (KeygenSearchContext.pointerWord env.ctx) :=
  KeygenCallerShape123.load64_block _ _ _ _ block old_tmp

end FT1536.Source3.SelectedRootContext175
