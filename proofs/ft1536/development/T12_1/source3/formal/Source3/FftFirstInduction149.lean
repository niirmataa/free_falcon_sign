import Source3.FftFirstStep149
import Source3.C99ProcedureSegments136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstInduction149
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open FftFirstInvariant149 (Fixed)

def values (n hn : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) : Nat → Nat → (Fin n → BitVec 64) → (Fin n → BitVec 64)
  | 0,_,input => input
  | count+1,u,input => values n hn length wr wi count (u+1) (FftFirstStep149.advance n hn u length wr wi input)

theorem prefix_source (s : State) (base : ArrayPointer) (n hn u count : Nat) (wr wi : BitVec 64)
    (input : Fin n → BitVec 64) (fixed : Fixed s base n hn wr wi)
    (uCell : Cell s "u".toList u) (represented : Represents s.heap base input) (range : u+count≤hn) :
    ∃ after, C99ProcedureSegments136.Prefix KeygenSearchFft.program FftShape138.firstCondition
      FftShape138.firstBody FftShape138.firstIncrement count s after ∧
      Fixed after base n hn wr wi ∧ Cell after "u".toList (u+count) ∧
      Represents after.heap base (values n hn fixed.length wr wi count u input) ∧ FftFirstFrame149.Frame base n s after := by
  induction count generalizing s u input with
  | zero => exact ⟨s,.done _,fixed,uCell,represented,FftFirstFrame149.refl base n s⟩
  | succ count ih =>
    have remaining : u<hn := by omega
    obtain ⟨middle,next,body,increment,nextFixed,nextU,nextImage,stepFrame⟩ :=
      FftFirstStep149.source s base n hn u wr wi input fixed uCell represented remaining
    obtain ⟨after,tail,lastFixed,lastU,lastImage,tailFrame⟩ := ih next (u+1) _ nextFixed nextU nextImage (by omega)
    have guard : C99ArrayReference.scalar s FftShape138.firstCondition (.int32 1) := by
      have source := FftFirstInvariant149.guard s base n hn u wr wi fixed uCell (by omega)
      simpa [remaining,C99ScalarReference.boolean] using source
    refine ⟨after,.next count s middle next after (.int32 1) guard (by decide) body increment tail,lastFixed,?_,lastImage,
      FftFirstFrame149.trans base n s next after stepFrame tailFrame⟩
    simpa only [Nat.add_assoc,Nat.add_comm 1] using lastU

/-- The original first loop terminates after exactly hn-u source iterations. -/
theorem source (s : State) (base : ArrayPointer) (n hn u : Nat) (wr wi : BitVec 64)
    (input : Fin n → BitVec 64) (fixed : Fixed s base n hn wr wi)
    (uCell : Cell s "u".toList u) (represented : Represents s.heap base input) (range : u≤hn) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstLoop s ⟨after,.normal⟩ ∧
      Fixed after base n hn wr wi ∧ Cell after "u".toList hn ∧
      Represents after.heap base (values n hn fixed.length wr wi (hn-u) u input) ∧ FftFirstFrame149.Frame base n s after := by
  obtain ⟨after,head,lastFixed,lastU,lastImage,frame⟩ := prefix_source s base n hn u (hn-u) wr wi input fixed uCell represented (by omega)
  have endU : Cell after "u".toList hn := by simpa only [Nat.add_sub_of_le range] using lastU
  have guard : C99ArrayReference.scalar after FftShape138.firstCondition (.int32 0) := by
    have source := FftFirstInvariant149.guard after base n hn hn wr wi lastFixed endU (Nat.le_refl _)
    simpa [C99ScalarReference.boolean] using source
  refine ⟨after,?_,lastFixed,endU,lastImage,frame⟩
  rw [FftShape138.first_loop_shape]
  exact C99ProcedureSegments136.finish _ _ _ _ (hn-u) s after _ head
    (.loopFalse _ _ _ after (.int32 0) guard (by decide))

end FT1536.Source3.FftFirstInduction149
