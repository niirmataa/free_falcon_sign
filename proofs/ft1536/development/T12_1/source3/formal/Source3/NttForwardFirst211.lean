import Source3.NttForwardFirstFrame211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardFirst211
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open MkgmParams198 (Level half count lognWord)
open NttForwardPrologue211 (ready)

def firstWords (l : Level) (fv : Fin (count l) → BitVec 32) (w p pi : BitVec 32) (j : Nat) :=
  if low : j < half l then StepNttFirst195.lowWordAt (half l) fv w p pi j low
  else if high : j-half l < half l then StepNttFirst195.highWordAt (half l) fv w p pi (j-half l) high else 0

 theorem image (l : Level) (s : State) (a : ArrayPointer) (fv : Fin (count l) → BitVec 32) (w p pi : BitVec 32)
    (input : StepNttFirst195.Image s a fv w p pi (half l)) : ZintNormWalkFlat208.Data s a (count l) (firstWords l fv w p pi) := by
  intro j bound
  have size : count l=2*half l := rfl
  by_cases low : j < half l
  · simpa only [firstWords,dite_eq_left low] using (input.1 ⟨j,low⟩ low).1
  · have high : j-half l < half l := by omega
    have read:=(input.1 ⟨j-half l,high⟩ high).2
    have index : half l+(j-half l)=j := by omega
    rw [index] at read
    simpa only [firstWords,dite_eq_right low,dite_eq_left high] using read

theorem source (l : Level) (s : State) (a gm : ArrayPointer) (fv gvs : Fin (count l) → BitVec 32) (p pi : BitVec 32)
    (logn : Slot s "logn" (lognWord l)) (full : Slot s "full" 0) (stride : Cell s "stride".toList 1)
    (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (ab : s.arrays "a".toList=some a) (gb : s.arrays "gm".toList=some gm)
    (width : a.elementBytes=4) (capacity : a.index+count l ≤ a.count) (writable : s.heap.writable a.block=true)
    (separate : ∀ i j : Fin (count l), Separate (elem gm i.val) (elem a j.val))
    (gloads : ∀ i : Fin (count l), Load32 s.heap (elem gm i.val) (gvs i))
    (data : ∀ j : Fin (count l), Load32 s.heap (elem a j.val) (fv j)) :
    ∃ out, Exec StepNttFirstLoop195.entryPrefix s ⟨out,.normal⟩ ∧
      StepNttFirst195.Fixed out a gm (half l) (count l) fv gvs (gvs ⟨1,by have h:=MkgmParams198.half_range l; unfold count; omega⟩) p pi ∧
      ZintNormWalkFlat208.Data out a (count l) (firstWords l fv (gvs ⟨1,by have h:=MkgmParams198.half_range l; unfold count; omega⟩) p pi) ∧
      Cell out "u".toList (half l) ∧ Cell out "n".toList (count l) ∧ Slot out "full" 0 ∧
      out.locals "m".toList=some (.uint64,none) ∧ out.locals "t".toList=some (.uint64,none) ∧
      NttWriteFrame182.Frame a (count l) s.heap out.heap := by
  have range:=MkgmParams198.half_range l
  have one : 1 < count l := by unfold count; omega
  let w:=gvs ⟨1,one⟩
  let ws:=CrtState205.set32 (ready l s) "w" w
  have gReady : (ready l s).arrays "gm".toList=some gm := (NttForwardPrologue211.arrays l s "gm".toList (by decide) (by decide)).trans gb
  have gmAlloc:=StepNttFirstLoop195.load_allocated (gloads ⟨1,one⟩)
  have gmCap : gm.index+1 ≤ gm.count := by have b:=gmAlloc.2.2.1; change gm.index+1 < gm.count at b; omega
  have wrun : Exec KeygenNttForwardPrograms.wAssign (ready l s) ⟨ws,.normal⟩ :=
    (StepNttPrologue195.w_run (ready l s) gm gvs one ⟨none,(NttForwardPrologue211.free l s).1⟩ gReady gmCap (gloads ⟨1,one⟩)).1
  have wp (name : String) (nw : name.toList≠"w".toList) : ws.locals name.toList=(ready l s).locals name.toList :=
    CrtState205.keep32 (ready l s) "w" name w nw
  have fixed : StepNttFirst195.Fixed ws a gm (half l) (count l) fv gvs w p pi := by
    refine ⟨by omega,by omega,range.1,width,capacity,writable,?_,?_,?_,?_,CrtState205.cell32 _ _ _,?_,?_,separate,gloads⟩
    · exact (NttForwardPrologue211.arrays l s "a".toList (by decide) (by decide)).trans ab
    · exact gReady
    · exact (wp "hn" (by decide)).trans (NttForwardPrologue211.hnCell l s)
    · exact (wp "stride" (by decide)).trans ((NttForwardPrologue211.locals l s "stride".toList (by decide)).trans stride)
    · exact (wp "p" (by decide)).trans ((NttForwardPrologue211.locals l s "p".toList (by decide)).trans pc)
    · exact (wp "p0i" (by decide)).trans ((NttForwardPrologue211.locals l s "p0i".toList (by decide)).trans ic)
  have pending : StepNttFirst195.Pending0 ws a fv := by
    intro j
    have b:=j.isLt
    exact ⟨data ⟨j.val,by change j.val < 2*half l; omega⟩,data ⟨half l+j.val,by change half l+j.val < 2*half l; omega⟩⟩
  have uFree : ∃ old, ws.locals "u".toList=some (.uint64,old) :=
    ⟨none,(wp "u" (by decide)).trans (NttForwardPrologue211.free l s).2.1⟩
  obtain ⟨out,first,finalFixed,finalImage,finalU,_,_,locals,_,firstFrame⟩:=NttForwardFirstFrame211.first_run ws a gm (half l) (count l) fv gvs w p pi fixed uFree pending
  have tail : Exec StepNttFirstLoop195.firstTail (ready l s) ⟨out,.normal⟩ := .seqNormal _ _ _ _ _ wrun first
  have prefixRun : Exec StepNttFirstLoop195.entryPrefix s ⟨out,.normal⟩ :=
    NttForwardCompose211.source C99ModularReference.ModCall [KeygenNttForwardPrograms.locals,KeygenNttForwardPrograms.word,
      KeygenNttForwardPrograms.pointers,KeygenNttForwardPrograms.earlyExit,KeygenNttForwardPrograms.nAssign,KeygenNttForwardPrograms.hnAssign]
      StepNttFirstLoop195.firstTail s (ready l s) ⟨out,.normal⟩ (NttForwardPrologue211.source l s logn full) tail
  refine ⟨out,prefixRun,finalFixed,image l out a fv w p pi finalImage,finalU,?_,?_,?_,?_,firstFrame⟩
  · exact (locals "n".toList (by decide)).trans ((wp "n" (by decide)).trans (NttForwardPrologue211.nCell l s))
  · exact (locals "full".toList (by decide)).trans ((wp "full" (by decide)).trans ((NttForwardPrologue211.locals l s "full".toList (by decide)).trans full))
  · exact (locals "m".toList (by decide)).trans ((wp "m" (by decide)).trans (NttForwardPrologue211.free l s).2.2.1)
  · exact (locals "t".toList (by decide)).trans ((wp "t" (by decide)).trans (NttForwardPrologue211.free l s).2.2.2)

end FT1536.Source3.NttForwardFirst211
