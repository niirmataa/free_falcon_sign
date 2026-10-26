import Source3.SecondExtraWalk212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraForward212
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open SecondStepBasic203 (Basic)
open SecondStepLayout197 (t1 gm)
open StepCopyBody190 (elem)
open ZintNormWalkFlat208 (Data)

theorem source (s : State) (p pi r2 : BitVec 32) (fv gvs : Fin 256 → BitVec 32)
    (h : Basic s 2 p pi r2)
    (data : ∀ i, Load32 s.heap (elem t1 i.val) (fv i))
    (gloads : ∀ i, Load32 s.heap (elem gm i.val) (gvs i)) :
    ∃ out, Exec MakeFgAddPrimeShape194.nttBranch s ⟨out,.normal⟩ ∧ Basic out 2 p pi r2 ∧
      Data out t1 256 (NttForwardWhole211.words 7 fv gvs p pi) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ q old, (∀ i : Fin 4, MakeFgConversionFrame176.Outside t1 256 q.block (q.offset+i.val)) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  have apart (i j : Fin 256) : Word32Memory176.Separate (elem gm i.val) (elem t1 j.val) :=
    SecondStepGeometry203.ordered _ _ (by change 2462+i.val<2974+j.val; have b:=i.isLt; omega)
  obtain ⟨out,_,run,image,ls,ars,keep⟩:=NttForwardCall211.source 7 s t1 gm fv gvs p pi
    h.lognCell h.pCell h.iCell h.t1Binding h.gmBinding rfl (by decide) h.writable apart gloads data
  have branch:=NttForwardBranch211.source s out h.terCell run
  exact ⟨out,branch,SecondStepBasic203.transport h branch (fun name _ => congrFun ls name)
    (fun name _ => congrFun ars name),image,ls,ars,keep⟩

end FT1536.Source3.SecondExtraForward212
