import Source3.SelectedFftFFrame148
import Source3.C99Load64Frame148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftGInput148
open C99CompactState115 (reference)
open C99MemoryReference
open C99WordBuffer140 (element Represents)

def base : ArrayPointer := ⟨31,0,35840,8,1536⟩
def values (i : Fin 1536) := C99InitializedBlock141.word SelectedFftBuffer141.data (element base i).offset

theorem allocated (i : Fin 1536) : Allocated (reference SelectedFftBuffer141.before).heap (element base i) := by
  have bound:=i.isLt
  change 0<8 ∧ 0%8=0 ∧ 1536+i.val<35840 ∧ 0+8*35840≤(reference SelectedFftBuffer141.before).heap.size 31 ∧
    (reference SelectedFftBuffer141.before).heap.size 31<2^64
  rw [SelectedFftBuffer141.size]
  exact ⟨by decide,by decide,by omega,by decide,by decide⟩

theorem snapshot (i : Fin 1536) : Load64 (reference SelectedFftBuffer141.before).heap (element base i) (values i) :=
  C99InitializedBlock141.load SelectedFftBuffer141.before.heap SelectedFftBuffer141.data (element base i) 0
    SelectedFftBuffer141.block_found SelectedFftBuffer141.initial_byte SelectedFftBuffer141.initialized (allocated i) rfl

theorem source (i : Fin 1536) : Load64 SelectedFftFComplete148.after.heap (element base i) (values i) := by
  apply C99Load64Frame148.source _ _ _ _ SelectedFftFFrame148.sizes _ (snapshot i)
  intro byte
  apply SelectedFftFFrame148.outside
  right; right
  change 0+8*1536≤0+8*(1536+i.val)+byte.val
  omega

theorem represented : Represents SelectedFftFComplete148.after.heap base values := source

theorem binding : SelectedFftFComplete148.after.arrays "rt2".toList=some base := by
  rw [SelectedFftFComplete148.arrays]
  decide +kernel

theorem writable : SelectedFftFComplete148.after.heap.writable base.block=true := by
  rw [SelectedFftFFrame148.permissions]
  exact SelectedFftBuffer141.writable

end FT1536.Source3.SelectedFftGInput148
