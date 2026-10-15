import Source3.GsInvNormInvariant154
import Source3.C99ProcedureSegments136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsInvNormLoop154
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open GsInvNormInvariant154

theorem prefix_source (s : State) (a b d : ArrayPointer) (n hn u count : Nat) (f g : Fin n → BitVec 64)
    (fixed : Fixed s a b d n hn f g) (uCell : Cell s "u".toList u) (range : u+count ≤ hn)
    (image : PrefixImage s d (result fixed.length f g) u) :
    ∃ after, C99ProcedureSegments136.Prefix KeygenSearchFft.program FftShape138.firstCondition
      GsInvNormShape154.body FftShape138.firstIncrement count s after ∧
      Fixed after a b d n hn f g ∧ Cell after "u".toList (u+count) ∧
      PrefixImage after d (result fixed.length f g) (u+count) := by
  induction count generalizing s u with
  | zero => exact ⟨s,.done _,fixed,uCell,image⟩
  | succ count ih =>
    have inside : u<hn := by omega
    let slot : Fin hn := ⟨u,inside⟩
    let middle := GsInvNormBody154.output s (C99WordBuffer140.element d slot) (sample fixed.length f g slot)
    let afterStep := next s d fixed.length f g slot
    have body := body_source s a b d n hn f g fixed slot uCell
    have length:=fixed.length
    have bound:=fixed.wordBound
    have increment : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstIncrement middle ⟨afterStep,.normal⟩ :=
      C99LoopScalar141.increment _ middle "u".toList u (by omega) uCell
    have nextFixed := next_fixed s a b d n hn f g fixed slot
    have nextU : Cell afterStep "u".toList (u+1) := FftLocalCells140.cell_at middle "u".toList _
    have nextImage := next_image s a b d n hn f g fixed slot image
    obtain ⟨after,tail,lastFixed,lastU,lastImage⟩ := ih afterStep (u+1) nextFixed nextU (by omega) nextImage
    have guard : C99ArrayReference.scalar s FftShape138.firstCondition (.int32 1) := by
      have source : C99ArrayReference.scalar s FftShape138.firstCondition (C99ScalarReference.boolean (decide (u<hn))) := C99LoopScalar141.less s _ _ u hn (by omega) (by omega)
        (C99LoopScalar141.read s "u".toList u uCell) (C99LoopScalar141.read s "hn".toList hn fixed.hnCell)
      simpa [inside,C99ScalarReference.boolean] using source
    refine ⟨after,.next count s middle afterStep after (.int32 1) guard (by decide) body increment tail,lastFixed,?_,?_⟩
    · simpa only [Nat.add_assoc,Nat.add_comm 1] using lastU
    · simpa only [Nat.add_assoc,Nat.add_comm 1] using lastImage

/-- The original inverse-norm loop fills its complete output without requiring initial output words. -/
theorem source (s : State) (a b d : ArrayPointer) (n hn : Nat) (f g : Fin n → BitVec 64)
    (fixed : Fixed s a b d n hn f g) (uCell : Cell s "u".toList 0) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program GsInvNormShape154.loop s ⟨after,.normal⟩ ∧
      Fixed after a b d n hn f g ∧ Cell after "u".toList hn ∧
      Represents after.heap d (result fixed.length f g) := by
  have empty : PrefixImage s d (result fixed.length f g) 0 := by intro i impossible; omega
  obtain ⟨after,head,lastFixed,lastU,image⟩ := prefix_source s a b d n hn 0 hn f g fixed uCell (by omega) empty
  have endU : Cell after "u".toList hn := by simpa only [Nat.zero_add] using lastU
  have length:=fixed.length
  have bound:=fixed.wordBound
  have guard : C99ArrayReference.scalar after FftShape138.firstCondition (.int32 0) := by
    have source : C99ArrayReference.scalar after FftShape138.firstCondition (C99ScalarReference.boolean (decide (hn<hn))) := C99LoopScalar141.less after _ _ hn hn (by omega) (by omega)
      (C99LoopScalar141.read after "u".toList hn endU) (C99LoopScalar141.read after "hn".toList hn lastFixed.hnCell)
    simpa [C99ScalarReference.boolean] using source
  refine ⟨after,?_,lastFixed,endU,?_⟩
  · exact C99ProcedureSegments136.finish _ _ _ _ hn s after _ head
      (.loopFalse _ _ _ after (.int32 0) guard (by decide))
  · intro i
    exact image i (by have inside:=i.isLt; omega)

end FT1536.Source3.GsInvNormLoop154
