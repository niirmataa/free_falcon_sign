import Source3.FftGroupsInvariant143
import Source3.FftGroupsFrame143
import Source3.FftPinned139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupsStep143
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open FftLocalCells140 (put)
open C99WordBuffer140 (Represents)
open FftGroupsInvariant143 (Fixed)

theorem source (s : State) (base : ArrayPointer) (n hn m t ht hm u : Nat)
    (input : Fin n → BitVec 64) (fixed : Fixed s base n hn m t ht hm)
    (counter : Cell s "u1".toList u) (offset : Cell s "v1".toList (u*t))
    (represented : Represents s.heap base input) (range : u<hm) :
    ∃ middle after, C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.groupBody s ⟨middle,.normal⟩ ∧
      C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.groupIncrement middle ⟨after,.normal⟩ ∧
      Fixed after base n hn m t ht hm ∧ Cell after "u1".toList (u+1) ∧ Cell after "v1".toList ((u+1)*t) ∧
      Represents after.heap base (FftGroupSource143.values n hn ht fixed.length m u (u*t) input) ∧
      FftGroupsFrame143.Frame base n s after := by
  have following : (u+1)*t≤hn := (Nat.mul_le_mul_right t (show u+1≤hm by omega)).trans fixed.endBound
  have expanded : u*t+t≤hn := by simpa only [Nat.add_mul,Nat.one_mul] using following
  have length := fixed.length
  have stepSize := fixed.stepSize
  have wordBound := fixed.wordBound
  have tableBound := fixed.tableBound
  have entry : FftGroupExec143.Entry s m u (u*t) ht :=
    ⟨fixed.mCell,counter,offset,fixed.htCell,by omega,by omega,fixed.tableBinding,fixed.pinned⟩
  obtain ⟨middle,body,image,frame⟩ := FftGroupSource143.source s base n hn m u (u*t) ht input entry
    fixed.width fixed.capacity fixed.length (by omega) fixed.wordBound fixed.binding fixed.hnCell fixed.writable represented
  have middleFixed := FftGroupsInvariant143.transfer s middle base n hn m t ht hm fixed frame
    (FftPinned139.procedure _ _ _ _ body fixed.pinned)
  have middleCounter : Cell middle "u1".toList u := by change middle.locals "u1".toList=_; rw [frame.locals]; exact counter
  have middleOffset : Cell middle "v1".toList (u*t) := by change middle.locals "v1".toList=_; rw [frame.locals]; exact offset
  let one := put middle "u1".toList (word (u+1))
  let after := put one "v1".toList (word ((u+1)*t))
  have oneFixed : Fixed one base n hn m t ht hm :=
    FftGroupsInvariant143.put middle base n hn m t ht hm _ _ middleFixed (by decide) (by decide) (by decide) (by decide) (by decide)
  have oneOffset : Cell one "v1".toList (u*t) :=
    (FftLocalCells140.outside _ _ _ _ (by decide)).trans middleOffset
  have increment : C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.groupIncrement middle ⟨after,.normal⟩ := by
    rw [FftControlShape142.group_increment]
    refine .seqNormal _ _ _ one _ (C99LoopScalar141.increment _ middle "u1".toList u (by omega) middleCounter) ?_
    have second := C99LoopAssign142.add KeygenSearchFft.program one "v1".toList "t".toList (u*t) t
      (by omega) (by omega) oneOffset oneFixed.tCell
    dsimp only [after]
    simpa only [Nat.add_mul,Nat.one_mul] using second
  refine ⟨middle,after,body,increment,?_,?_,?_,image,?_⟩
  · exact FftGroupsInvariant143.put one base n hn m t ht hm _ _ oneFixed (by decide) (by decide) (by decide) (by decide) (by decide)
  · exact (FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _)
  · exact FftLocalCells140.cell_at _ _ _
  · exact FftGroupsFrame143.trans base n s middle after (FftGroupsFrame143.body base n s middle frame)
      (FftGroupsFrame143.counters base n middle _ _)

end FT1536.Source3.FftGroupsStep143
