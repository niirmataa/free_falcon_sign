import Source3.SelectedGsBinding154

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsEntry154
open C99MemoryReference (ArrayPointer Allocated)
open C99WordBuffer140 (element)
open SelectedGsBinding154 (before bound destination)

noncomputable def initial := GsInvNormSetup154.initial bound

theorem full : bound.locals "full".toList=some (.uint32,some (.uint32 1)) := by rfl
theorem logn : bound.locals "logn".toList=some (.uint32,some (.uint32 10)) := by rfl

theorem size : before.heap.size 31=286720 := by
  change SelectedRawNorm151.after.heap.size 31=_
  rw [SelectedRawNorm151.heap,SelectedFftGFrame150.sizes,SelectedFftFFrame148.sizes]
  exact SelectedFftBuffer141.size

theorem writable : before.heap.writable 31=true := by
  change SelectedRawNorm151.after.heap.writable 31=_
  rw [SelectedRawNorm151.heap,SelectedFftGFrame150.permissions,SelectedFftFFrame148.permissions]
  exact SelectedFftBuffer141.writable

theorem allocated (i : Fin 768) : Allocated initial.heap (element destination i) := by
  have inside:=i.isLt
  change 0<8 ∧ 0%8=0 ∧ 3072+i.val<35840 ∧ 0+8*35840 ≤ before.heap.size 31 ∧ before.heap.size 31<2^64
  rw [size]
  exact ⟨by decide,by decide,by omega,by decide,by decide⟩

theorem separate_a (i : Fin 768) (j : Fin 1536) :
    C99WordRead140.Separate (element destination i) (element SelectedFftBuffer141.base j) := by
  have inside:=j.isLt
  simp only [C99WordRead140.Separate,element,destination,SelectedFftBuffer141.base,
    GeneratedFft140Middle16.pointer,ArrayPointer.offset,Nat.zero_add]
  omega

theorem separate_b (i : Fin 768) (j : Fin 1536) :
    C99WordRead140.Separate (element destination i) (element SelectedFftGInput148.base j) := by
  have inside:=j.isLt
  simp only [C99WordRead140.Separate,element,destination,SelectedFftBuffer141.base,SelectedFftGInput148.base,
    GeneratedFft140Middle16.pointer,ArrayPointer.offset,Nat.zero_add]
  omega

theorem fixed : GsInvNormInvariant154.Fixed initial SelectedFftBuffer141.base SelectedFftGInput148.base destination
    1536 768 GeneratedFftTree153FTriple.word GeneratedFftTree153GTriple.word :=
  ⟨by decide,by decide,by decide,by decide,by decide,rfl,rfl,rfl,rfl,GsInvNormSetup154.hn_cell bound,
    allocated,writable,SelectedNumericFft153.images.1,SelectedNumericFft153.images.2,separate_a,separate_b⟩

end FT1536.Source3.SelectedGsEntry154
