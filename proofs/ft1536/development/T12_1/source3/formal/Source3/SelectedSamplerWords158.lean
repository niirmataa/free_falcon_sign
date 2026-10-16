import Source3.InitializedRange158
import Source3.SelectedPublicBinding157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSamplerWords158
open C99MemoryReference
open C99FiniteMemory114 (memory)
open C99FiniteMap114 (lookup)
open Word16Memory158 (element Represents)
open SelectedPublicBinding157 (f g)

def old := SelectedBound135.before
def fData := GeneratedSampler129F24.coefficientBlock
def gData := GeneratedSampler129G24.coefficientBlock

theorem f_found : lookup old.heap.blocks f.block=some fData := by
  have first : lookup NormalizedSamples129.middle.heap.blocks 10=some fData := by
    change lookup (C99LazyBlock129.putBlock _ 10 fData).blocks 10=some fData
    rw [C99LazyBlock129.lookup_put]
    rfl
  change lookup (C99LazyBlock129.putBlock (C99LazyBlock129.putBlock NormalizedSamples129.middle.heap 30
    GeneratedSampler129G24.contextBlock) 11 gData).blocks 10=some fData
  rw [C99LazyBlock129.lookup_put,ite_eq_right (by decide : (10 : Nat)≠11),
    C99LazyBlock129.lookup_put,ite_eq_right (by decide : (10 : Nat)≠30)]
  exact first
theorem g_found : lookup old.heap.blocks g.block=some gData := by
  change lookup (C99LazyBlock129.putBlock _ 11 gData).blocks 11=some gData
  rw [C99LazyBlock129.lookup_put]
  rfl

theorem f_initialized : InitializedRange158.check fData 3072=true := by decide +kernel
theorem g_initialized : InitializedRange158.check gData 3072=true := by decide +kernel

def fValues (i : Fin 1536) : BitVec 16 := InitializedRange158.word fData (element f i).offset
def gValues (i : Fin 1536) : BitVec 16 := InitializedRange158.word gData (element g i).offset

theorem f_size : (memory old.heap).size f.block=6144 := by simp only [memory,f_found]; rfl
theorem g_size : (memory old.heap).size g.block=6144 := by simp only [memory,g_found]; rfl
theorem f_allocated (i : Fin 1536) : Allocated (memory old.heap) (element f i) := by
  have inside:=i.isLt
  change 0<2 ∧ 0%2=0 ∧ 0+i.val<3072 ∧ 0+2*3072 ≤ (memory old.heap).size f.block ∧ (memory old.heap).size f.block<2^64
  rw [f_size]
  exact ⟨by decide,by decide,by omega,by decide,by decide⟩
theorem g_allocated (i : Fin 1536) : Allocated (memory old.heap) (element g i) := by
  have inside:=i.isLt
  change 0<2 ∧ 0%2=0 ∧ 0+i.val<3072 ∧ 0+2*3072 ≤ (memory old.heap).size g.block ∧ (memory old.heap).size g.block<2^64
  rw [g_size]
  exact ⟨by decide,by decide,by omega,by decide,by decide⟩

/-- These are the same normalized sampler bytes, not an injected native snapshot. -/
theorem f_image : Represents (memory old.heap) f fValues := by
  intro i
  apply InitializedRange158.load old.heap fData (element f i) 3072 f_found f_initialized (f_allocated i) rfl
  intro j
  have a:=i.isLt
  have b:=j.isLt
  change 0+2*(0+i.val)+j.val<3072
  omega
theorem g_image : Represents (memory old.heap) g gValues := by
  intro i
  apply InitializedRange158.load old.heap gData (element g i) 3072 g_found g_initialized (g_allocated i) rfl
  intro j
  have a:=i.isLt
  have b:=j.isLt
  change 0+2*(0+i.val)+j.val<3072
  omega

end FT1536.Source3.SelectedSamplerWords158
