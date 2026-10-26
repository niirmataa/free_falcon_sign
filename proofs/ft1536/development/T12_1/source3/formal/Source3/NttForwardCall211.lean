import Source3.NttForwardWhole211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardCall211
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open MkgmParams198 (Level count lognWord)
open StepNttEntry195 (entry entryP0i entryP entryFull entryLogn entryGm entryStride nttFresh)
open ZintNormWalkFlat208 (Data)

theorem cells (l : Level) (s : State) (a gm : ArrayPointer) (p pi : BitVec 32) :
    Slot (entry s a gm (lognWord l) p pi) "logn" (lognWord l) ∧ Slot (entry s a gm (lognWord l) p pi) "full" 0 ∧
      Cell (entry s a gm (lognWord l) p pi) "stride".toList 1 ∧
      Slot (entry s a gm (lognWord l) p pi) "p" p ∧ Slot (entry s a gm (lognWord l) p pi) "p0i" pi ∧
      (entry s a gm (lognWord l) p pi).arrays "a".toList=some a ∧
      (entry s a gm (lognWord l) p pi).arrays "gm".toList=some gm := by
  have ss (name : Name) (ns : name≠"stride".toList) :
      (entry s a gm (lognWord l) p pi).locals name=(entryLogn s (lognWord l) p pi).locals name :=
    SelectedStepAddPrime195.locals_keep (entryGm s gm (lognWord l) p pi) "stride".toList .uint64 (.int32 1) name ns
  have fp : Slot (entryFull s p pi) "p" p :=
    (SelectedStepAddPrime195.locals_keep (entryP s p pi) "full".toList .uint32 (.int32 0) "p".toList (by decide)).trans
      (CrtState205.cell32 (entryP0i s pi) "p" p)
  have fi : Slot (entryFull s p pi) "p0i" pi :=
    (SelectedStepAddPrime195.locals_keep (entryP s p pi) "full".toList .uint32 (.int32 0) "p0i".toList (by decide)).trans
      ((CrtState205.keep32 (entryP0i s pi) "p" "p0i" p (by decide)).trans (CrtState205.cell32 (nttFresh s) "p0i" pi))
  refine ⟨(ss "logn".toList (by decide)).trans (CrtState205.cell32 (entryFull s p pi) "logn" (lognWord l)),?_,rfl,?_,?_,rfl,rfl⟩
  · exact (ss "full".toList (by decide)).trans
      ((CrtState205.keep32 (entryFull s p pi) "logn" "full" (lognWord l) (by decide)).trans (show Slot (entryFull s p pi) "full" 0 from rfl))
  · exact (ss "p".toList (by decide)).trans ((CrtState205.keep32 (entryFull s p pi) "logn" "p" (lognWord l) (by decide)).trans fp)
  · exact (ss "p0i".toList (by decide)).trans ((CrtState205.keep32 (entryFull s p pi) "logn" "p0i" (lognWord l) (by decide)).trans fi)

theorem read_frame (before after : C99MemoryReference.Memory) (a q : ArrayPointer) (n : Nat) (w : BitVec 32)
    (frame : NttWriteFrame182.Frame a n before after) (read : Load32 before q w)
    (outside : ∀ i : Fin 4, MakeFgConversionFrame176.Outside a n q.block (q.offset+i.val)) : Load32 after q w := by
  apply Gate00Memory.load32_transport before after q w read frame.size
  intro i
  exact frame.bytes q.block (q.offset+i.val) (outside i)

theorem source (l : Level) (s : State) (a gm : ArrayPointer) (fv gvs : Fin (count l) → BitVec 32) (p pi : BitVec 32)
    (logn : Slot s "logn" (lognWord l)) (pc : Slot s "p" p) (ic : Slot s "p0i" pi)
    (ab : s.arrays "t1".toList=some a) (gb : s.arrays "gm".toList=some gm)
    (width : a.elementBytes=4) (capacity : a.index+count l ≤ a.count) (writable : s.heap.writable a.block=true)
    (separate : ∀ i j : Fin (count l), Separate (elem gm i.val) (elem a j.val))
    (gloads : ∀ i : Fin (count l), Load32 s.heap (elem gm i.val) (gvs i))
    (data : ∀ j : Fin (count l), Load32 s.heap (elem a j.val) (fv j)) :
    ∃ out, KeygenLevelCalls.Call .forward s MakeFgAddPrimeShape194.forwardArgs out ∧
      KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.forwardCall s ⟨out,.normal⟩ ∧
      Data out a (count l) (NttForwardWhole211.words l fv gvs p pi) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ q old, (∀ i : Fin 4, MakeFgConversionFrame176.Outside a (count l) q.block (q.offset+i.val)) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  have h:=cells l s a gm p pi
  obtain ⟨result,run,image,frame,_,_,_⟩:=NttForwardWhole211.source l (entry s a gm (lognWord l) p pi) a gm fv gvs p pi
    h.1 h.2.1 h.2.2.1 h.2.2.2.1 h.2.2.2.2.1 h.2.2.2.2.2.1 h.2.2.2.2.2.2 width capacity writable separate gloads data
  have one : 1 < count l := by have range:=MkgmParams198.half_range l; unfold count; omega
  have gmCap : gm.index ≤ gm.count := by
    have alloc:=StepNttFirstLoop195.load_allocated (gloads ⟨1,one⟩)
    have bound:=alloc.2.2.1
    change gm.index+1 < gm.count at bound
    omega
  have binding:=StepNttEntry195.bind_forward s a gm (lognWord l) p pi ab (by omega) gb gmCap logn pc ic
  let out : State := {s with heap:=result.heap}
  have call : KeygenLevelCalls.Call .forward s MakeFgAddPrimeShape194.forwardArgs out :=
    .run _ ⟨result,.normal⟩ binding run .voidEnd
  exact ⟨out,call,.level _ _ _ (.call .forward _ _ _ call),image,rfl,rfl,
    fun q old outside read => read_frame _ _ a q (count l) old frame read outside⟩

end FT1536.Source3.NttForwardCall211
