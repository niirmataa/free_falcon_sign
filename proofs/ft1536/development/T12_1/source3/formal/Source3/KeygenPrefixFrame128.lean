import Source3.KeygenSamplerPrefix128
import Source3.KeygenSamplerOuter091
import Source3.KeygenSamplerFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPrefixFrame128
open C99ArrayReference (State)
open C99MemoryReference
open KeygenSamplerPrefix128 (Prefix)

theorem stable (ctx : ShakeExtractSource.Layout) (count : Nat) (before after : State)
    (source : Prefix ctx count before after) : C99Metadata091.Stable before after := by
  induction source with
  | done => exact C99Metadata091.refl _
  | next count before declared sampled updated after value guard nonzero declaration inner increment rest ih =>
      have first := C99Metadata091.modular _ _ _ _ declaration
      have second := KeygenSamplerInner091.inner_stable ctx declared sampled inner
      have scopeFrame : C99Metadata091.Stable sampled (C99ArrayReference.restoreScope before sampled ["x".toList] []) :=
        ⟨rfl,rfl,rfl,rfl⟩
      have third := C99Metadata091.modular _ _ _ _ increment
      exact C99Metadata091.trans _ _ _ first (C99Metadata091.trans _ _ _ second
        (C99Metadata091.trans _ _ _ scopeFrame (C99Metadata091.trans _ _ _ third ih)))

theorem arrays (ctx : ShakeExtractSource.Layout) (count : Nat) (before after : State)
    (source : Prefix ctx count before after) : after.arrays=before.arrays := by
  induction source with
  | done => rfl
  | next count before declared sampled updated after value guard nonzero declaration inner increment rest ih =>
      have first := C99ModularFrame.source_frame KeygenSamplerSource.declareX before ⟨declared,.normal⟩ declaration (by decide)
      have second := (KeygenSamplerInner.inner_control ctx declared sampled inner).2.2
      have third := C99ModularFrame.source_frame KeygenSamplerSource.increment _ ⟨updated,.normal⟩ increment (by decide)
      exact ih.trans (third.2.trans (second.trans first.2))

theorem outside (ctx : ShakeExtractSource.Layout) (count : Nat) (before after : State) (dst : ArrayPointer) (block : Nat)
    (contextOutside : ctx.block≠block) (destinationOutside : dst.block≠block)
    (source : Prefix ctx count before after) (live : 0<before.heap.size block)
    (binding : before.arrays "v".toList=some dst) : ShakeExtractFrame.SameBlock before.heap after.heap block := by
  induction source with
  | done => exact ⟨rfl,rfl,fun _ => rfl⟩
  | next count before declared sampled updated after value guard nonzero declaration inner increment rest ih =>
      have hd := KeygenSamplerBounds.declaration_result before declared declaration
      subst declared
      have one := KeygenSamplerFrame.inner_frame ctx (KeygenSamplerBounds.declaredX before) sampled dst block
        contextOutside destinationOutside inner live binding
      have pointerFrame := (KeygenSamplerInner.inner_control ctx _ sampled inner).2.2
      have inc := C99ModularFrame.source_frame KeygenSamplerSource.increment
        (KeygenSamplerSource.closedScope before sampled) ⟨updated,.normal⟩ increment (by decide)
      have heap : updated.heap=sampled.heap := inc.1
      have current : ShakeExtractFrame.SameBlock before.heap updated.heap block := by rw [heap]; exact one
      have alive : 0<updated.heap.size block := by rw [current.1]; exact live
      have ptr : updated.arrays "v".toList=some dst := (congrFun inc.2 _).trans ((congrFun pointerFrame _).trans binding)
      exact ShakeExtractFrame.same_trans _ _ _ block current (ih alive ptr)

end FT1536.Source3.KeygenPrefixFrame128
