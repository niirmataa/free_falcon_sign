import Source3.SelectedMakeFgSetup176
import Source3.MakeFgConversionInvariant176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMakeFgDomains176
open C99MemoryReference (Allocated)
open KeygenFullData127 (env)
open SelectedMakeFgSetup176 (after ft gt)
open SelectedSamplerWords158 (fValues gValues)

theorem extent : 4*71680≤after.heap.size 31 := SelectedRootEntry175.source.scratch.2.2.2.1
theorem size_bound : after.heap.size 31<2^64 := SelectedRootEntry175.source.scratch.2.2.2.2.1
theorem writable : after.heap.writable 31=true := SelectedRootEntry175.source.scratch.2.2.2.2.2

theorem allocated (index : Nat) (inside : index<71680) :
    Allocated after.heap {env.ctx.scratch with index:=index} := by
  change 0<4 ∧ 0%4=0 ∧ index<71680 ∧ 0+4*71680≤after.heap.size 31 ∧ after.heap.size 31<2^64
  exact ⟨by decide,by decide,inside,extent,size_bound⟩

theorem heap : after.heap=SelectedMakeFgEntry175.entry.heap := by
  calc
    after.heap=SelectedMakeFgSetup176.before.heap := by
      dsimp only [SelectedMakeFgSetup176.after,SelectedMakeFgSetup176.withPrimes,
        SelectedMakeFgSetup176.withGt,SelectedMakeFgSetup176.withFt,SelectedMakeFgSetup176.sized,
        C99ArrayReference.bindValue,C99ArrayReference.bindPointer]
    _=SelectedMakeFgEntry175.entry.heap := MakeFgDeclarations176.heap SelectedMakeFgEntry175.entry

theorem ft_shape : ft=⟨31,0,71680,4,670⟩ := rfl
theorem gt_shape : gt=⟨31,0,71680,4,2206⟩ := rfl

theorem f_words : Word16Memory158.Represents after.heap (SelectedRootEntry175.inputs 0) fValues := by
  rw [heap]
  exact SelectedMakeFgEntry175.f_words

theorem g_words : Word16Memory158.Represents after.heap (SelectedRootEntry175.inputs 1) gValues := by
  rw [heap]
  exact SelectedMakeFgEntry175.g_words

theorem fixed : MakeFgConversionInvariant176.Fixed after (SelectedRootEntry175.inputs 0) (SelectedRootEntry175.inputs 1)
    ft gt 1536 fValues gValues := by
  refine ⟨by decide,by decide,by decide,by decide,by decide,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,
    ?_,?_,writable,writable,f_words,g_words,
    by decide,by decide,by decide,by decide,?_⟩
  · intro i
    exact allocated (670+i.val) (by have h:=i.isLt; omega)
  · intro i
    exact allocated (2206+i.val) (by have h:=i.isLt; omega)
  · intro i j
    right; left
    have hi:=i.isLt
    rw [ft_shape,gt_shape]
    change 0+4*(670+i.val)+4≤0+4*(2206+j.val)
    omega

end FT1536.Source3.SelectedMakeFgDomains176
