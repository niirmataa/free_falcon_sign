import Source3.SelectedSamplerWords158
import Source3.NormProtected158
import Source3.SelectedPublicStart157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPublicInputs158
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99CompactState115 (reference)
open Word16Memory158 (element Represents)
open SelectedPublicBinding157 (f g h)
open SelectedPublicStart157 (ready t)
open SelectedSamplerWords158 (old fValues gValues)

theorem f_protected : KeygenAttemptNorm133.Protected KeygenFullData127.env.ctx (reference old) f.block :=
  NormProtected158.source _ old f.block (by decide) (by decide +kernel) (by decide +kernel)
theorem g_protected : KeygenAttemptNorm133.Protected KeygenFullData127.env.ctx (reference old) g.block :=
  NormProtected158.source _ old g.block (by decide) (by decide +kernel) (by decide +kernel)

theorem stable : KeygenMemoryStability.Stable (memory old.heap) SelectedGsNorm155.after.heap :=
  KeygenAttemptNorm133.stable _ (reference old) ⟨SelectedGsNorm155.after,.normal⟩ SelectedGsGate156.norm_prefix

theorem size_unchanged (block : Nat) (different : block≠SelectedPublicMemory157.temporary) :
    ready.heap.size block=(memory old.heap).size block := by
  change (if block=SelectedPublicMemory157.temporary then 2*3072 else SelectedGsNorm155.after.heap.size block)=_
  rw [ite_eq_right different]
  exact congrFun stable.size block
theorem writable_unchanged (block : Nat) (different : block≠SelectedPublicMemory157.temporary) :
    ready.heap.writable block=(memory old.heap).writable block := by
  change (if block=SelectedPublicMemory157.temporary then true else SelectedGsNorm155.after.heap.writable block)=_
  rw [ite_eq_right different]
  exact congrFun stable.writable block
theorem bytes_unchanged (block offset : Nat) (different : block≠SelectedPublicMemory157.temporary)
    (protectedBlock : KeygenAttemptNorm133.Protected KeygenFullData127.env.ctx (reference old) block) :
    ready.heap.bytes block offset=(memory old.heap).bytes block offset := by
  change (if block=SelectedPublicMemory157.temporary then none else SelectedGsNorm155.after.heap.bytes block offset)=_
  rw [ite_eq_right different]
  exact KeygenAttemptNorm133.bytes _ (reference old) ⟨SelectedGsNorm155.after,.normal⟩ SelectedGsGate156.norm_prefix block protectedBlock offset

theorem f_image : Represents ready.heap f fValues := by
  intro i
  exact KeygenMakeEntry.load16_block (memory old.heap) ready.heap (element f i) (fValues i)
    ⟨size_unchanged f.block (by decide),writable_unchanged f.block (by decide),
      fun offset => bytes_unchanged f.block offset (by decide) f_protected⟩ (SelectedSamplerWords158.f_image i)
theorem g_image : Represents ready.heap g gValues := by
  intro i
  exact KeygenMakeEntry.load16_block (memory old.heap) ready.heap (element g i) (gValues i)
    ⟨size_unchanged g.block (by decide),writable_unchanged g.block (by decide),
      fun offset => bytes_unchanged g.block offset (by decide) g_protected⟩ (SelectedSamplerWords158.g_image i)

theorem h_size : ready.heap.size h.block=6144 := (size_unchanged h.block (by decide)).trans (by decide +kernel)
theorem h_writable : ready.heap.writable h.block=true := (writable_unchanged h.block (by decide)).trans (by decide +kernel)
theorem t_size : ready.heap.size t.block=6144 := by rfl
theorem t_writable : ready.heap.writable t.block=true := by rfl

theorem h_allocated (i : Fin 1536) : Allocated ready.heap (element h i) := by
  have inside:=i.isLt
  change 0<2 ∧ 0%2=0 ∧ 0+i.val<3072 ∧ 0+2*3072 ≤ ready.heap.size h.block ∧ ready.heap.size h.block<2^64
  rw [h_size]
  exact ⟨by decide,by decide,by omega,by decide,by decide⟩
theorem t_allocated (i : Fin 1536) : Allocated ready.heap (element t i) := by
  have inside:=i.isLt
  change 0<2 ∧ 0%2=0 ∧ 0+i.val<3072 ∧ 0+2*3072 ≤ ready.heap.size t.block ∧ ready.heap.size t.block<2^64
  rw [t_size]
  exact ⟨by decide,by decide,by omega,by decide,by decide⟩

end FT1536.Source3.SelectedPublicInputs158
