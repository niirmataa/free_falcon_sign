import Source3.C99InitializedBlock141
import Source3.GeneratedFft140Middle16

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftBuffer141
open C99CompactState115 (reference)
open C99MemoryReference
open C99FiniteMemory114 (memory)

def before := GeneratedFft140Middle16.after
def data := GeneratedFft140Middle16.dataBlock
def base := GeneratedFft140Middle16.pointer

theorem block_found : C99FiniteMap114.lookup before.heap.blocks 31=some data := by
  change C99FiniteMap114.lookup (C99LazyBlock129.putBlock GeneratedFft140Middle16.before.heap 31 data).blocks 31=_
  rw [C99LazyBlock129.lookup_put]
  rfl

theorem initialized : C99InitializedBlock141.valid data.cells=true := by decide +kernel

theorem initial_byte : data.initial=some 0 := rfl

theorem size : (reference before).heap.size 31=286720 := by
  change (memory before.heap).size 31=286720
  simp only [memory,block_found]
  rfl

theorem writable : (reference before).heap.writable 31=true := by
  change (memory before.heap).writable 31=true
  simp only [memory,block_found]
  rfl

def values (i : Fin 1536) : BitVec 64 :=
  C99InitializedBlock141.word data (C99WordBuffer140.element base i).offset

theorem allocated (i : Fin 1536) : Allocated (reference before).heap (C99WordBuffer140.element base i) := by
  have bound := i.isLt
  change 0<8 ∧ 0%8=0 ∧ 0+i.val<35840 ∧ 0+8*35840≤(reference before).heap.size 31 ∧
    (reference before).heap.size 31<2^64
  rw [size]
  exact ⟨by decide,by decide,by omega,by decide,by decide⟩

/-- Entire actual buffer image, from the checked captured block and metadata. -/
theorem represented : C99WordBuffer140.Represents (reference before).heap base values := by
  intro i
  exact C99InitializedBlock141.load before.heap data (C99WordBuffer140.element base i) 0
    block_found initial_byte initialized (allocated i) rfl

end FT1536.Source3.SelectedFftBuffer141
