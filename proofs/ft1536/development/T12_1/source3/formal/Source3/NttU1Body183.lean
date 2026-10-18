import Source3.NttU1Setup183
import Source3.NttGlue182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttU1Body183
open C99ArrayReference (State restoreScope)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open NttFirstFixed182 (Fixed)

def code := KeygenNttForwardPrograms.block KeygenNttForwardPrograms.u1Inner

theorem source (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (m j l h : Nat)
    (fixed : Fixed s a gm p p0i w) (range : l+2*h≤1536) (hb : h≤768) (tableBound : m+j<1024)
    (mc : USlot s "m" m) (jc : USlot s "u1" j) (lc : USlot s "v1" l) (hc : USlot s "ht" h)
    (reads : NttMiddleTable183.Reads s.heap gm) :
    ∃ out, Exec code s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧
      NttWriteFrame182.Frame a 1536 s.heap out.heap ∧ out.locals=s.locals := by
  obtain ⟨tw,read⟩ := reads (m+j) tableBound
  let prepared := NttU1Setup183.after s a l h tw
  have setup := NttU1Setup183.source s a gm p p0i w tw m j l h fixed range tableBound mc jc lc hc read
  obtain ⟨vo,vRun,vFixed,hv,frame⟩ := NttVLoop183.full h l range hb prepared a gm p p0i w tw
    (NttU1Setup183.fixed s a gm p p0i w tw l h fixed) (NttU1Setup183.limit s a l h tw hc)
    (NttU1Setup183.twiddle s a l h tw) rfl rfl none rfl
  have inner : Exec KeygenNttForwardPrograms.u1Inner s ⟨vo,.normal⟩ :=
    NttGlue182.source NttU1Setup183.code s prepared setup
      (.seq KeygenNttForwardPrograms.vLoop (.base .skip)) ⟨vo,.normal⟩
      (.seqNormal _ _ prepared vo _ vRun (.base .skip vo vo (.skip vo)))
  let out := restoreScope s vo ["v".toList,"s".toList] []
  have run : Exec code s ⟨out,.normal⟩ := .scope ["v".toList,"s".toList] _ s ⟨vo,.normal⟩ inner
  have control := KeygenNttControl.frame code s ⟨out,.normal⟩ (by decide) run
  have noLocals : KeygenNttControl.localsWritten code=[] := by decide
  have locals : out.locals=s.locals := by
    funext name
    apply control.2.1 name
    rw [noLocals]
    exact List.not_mem_nil
  have fo : Fixed out a gm p p0i w := by
    refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,fixed.width,fixed.capacity,vFixed.allocated,vFixed.writable,vFixed.initialized⟩
    · exact (congrFun locals _).trans fixed.pCell
    · exact (congrFun locals _).trans fixed.iCell
    · exact (congrFun locals _).trans fixed.wCell
    · exact (congrFun locals _).trans fixed.nCell
    · exact (congrFun locals _).trans fixed.hnCell
    · exact (congrFun locals _).trans fixed.stride
    · exact (control.2.2 "a".toList (by decide)).trans fixed.aBinding
    · exact (control.2.2 "gm".toList (by decide)).trans fixed.gmBinding
  exact ⟨out,run,fo,frame,locals⟩

end FT1536.Source3.NttU1Body183
