import Source3.GsMapCall155
import Source3.SelectedGsContinuation154

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsStart155
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (element)

noncomputable def before := SelectedGsInvNorm154.after
def p := SelectedFftBuffer141.base
def q := SelectedFftGInput148.base
def r := SelectedGsBinding154.destination

theorem logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)) := SelectedGsBinding154.logn
theorem p_binding : before.arrays "rt1".toList=some p := SelectedGsBinding154.a_binding
theorem q_binding : before.arrays "rt2".toList=some q := SelectedGsBinding154.b_binding
theorem r_binding : before.arrays "rt3".toList=some r := SelectedGsBinding154.d_binding
theorem writable : before.heap.writable 31=true := (Classical.choose_spec SelectedGsInvNorm154.exists_body).2.1.writableD

theorem q_outside_p (i : Fin 1536) (j : Fin 8) :
    FftLoopFrame141.Outside p 1536 (element q i).block ((element q i).offset+j.val) := by
  simp only [FftLoopFrame141.Outside,p,q,SelectedFftBuffer141.base,SelectedFftGInput148.base,
    GeneratedFft140Middle16.pointer,element,ArrayPointer.offset,Nat.zero_add]
  omega
theorem p_outside_q (i : Fin 1536) (j : Fin 8) :
    FftLoopFrame141.Outside q 1536 (element p i).block ((element p i).offset+j.val) := by
  have a:=i.isLt
  have b:=j.isLt
  simp only [FftLoopFrame141.Outside,p,q,SelectedFftBuffer141.base,SelectedFftGInput148.base,
    GeneratedFft140Middle16.pointer,element,ArrayPointer.offset,Nat.zero_add]
  omega
theorem r_outside_p (i : Fin 768) (j : Fin 8) :
    FftLoopFrame141.Outside p 1536 (element r i).block ((element r i).offset+j.val) := by
  simp only [FftLoopFrame141.Outside,p,r,SelectedFftBuffer141.base,SelectedGsBinding154.destination,
    GeneratedFft140Middle16.pointer,element,ArrayPointer.offset,Nat.zero_add]
  omega
theorem r_outside_q (i : Fin 768) (j : Fin 8) :
    FftLoopFrame141.Outside q 1536 (element r i).block ((element r i).offset+j.val) := by
  simp only [FftLoopFrame141.Outside,q,r,SelectedFftBuffer141.base,SelectedFftGInput148.base,SelectedGsBinding154.destination,
    GeneratedFft140Middle16.pointer,element,ArrayPointer.offset,Nat.zero_add]
  omega

end FT1536.Source3.SelectedGsStart155
