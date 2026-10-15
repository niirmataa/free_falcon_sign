import Source3.FftLoopStep141
import Source3.C99ProcedureSegments136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLoopInduction141
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99WordBuffer140 (Represents)
open FftLoopInvariant141 (Fixed)

/-- A pure vector recurrence, independent of statement interpretation. -/
def values (n hn ht : Nat) (length : 2*hn≤n) (sr si : BitVec 64) :
    Nat → Nat → (Fin n → BitVec 64) → (Fin n → BitVec 64)
  | 0,_,input => input
  | count+1,start,input => values n hn ht length sr si count (start+1)
      (FftLoopStep141.advance n hn ht start length sr si input)

theorem prefix_source (s : State) (base : ArrayPointer) (n hn ht stop start count : Nat) (sr si : BitVec 64)
    (input : Fin n → BitVec 64) (fixed : Fixed s base n hn ht stop sr si)
    (counter : Cell s "v".toList start) (represented : Represents s.heap base input) (range : start+count≤stop) :
    ∃ after, C99ProcedureSegments136.Prefix KeygenSearchFft.program FftMiddleShape139.butterflyCondition
      FftMiddleShape139.butterflyBody FftMiddleShape139.butterflyIncrement count s after ∧
      Fixed after base n hn ht stop sr si ∧ Cell after "v".toList (start+count) ∧
      Represents after.heap base (values n hn ht fixed.length sr si count start input) ∧ FftLoopFrame141.Frame base n s after := by
  induction count generalizing s start input with
  | zero => exact ⟨s,.done _,fixed,counter,represented,FftLoopFrame141.refl base n s⟩
  | succ count ih =>
    have remaining : start<stop := by omega
    obtain ⟨middle,next,body,update,nextFixed,nextCounter,nextImage,stepFrame⟩ :=
      FftLoopStep141.source s base n hn ht stop start sr si input fixed counter represented remaining
    obtain ⟨after,tail,lastFixed,lastCounter,lastImage,tailFrame⟩ :=
      ih next (start+1) _ nextFixed nextCounter nextImage (by omega)
    have guard : C99ArrayReference.scalar s FftMiddleShape139.butterflyCondition (.int32 1) := by
      have source := FftLoopInvariant141.guard s base n hn ht stop start sr si fixed counter (by omega)
      simpa [remaining,C99ScalarReference.boolean] using source
    refine ⟨after,.next count s middle next after (.int32 1) guard (by decide) body update tail,lastFixed,?_,?_,FftLoopFrame141.trans base n s next after stepFrame tailFrame⟩
    · simpa only [Nat.add_assoc,Nat.add_comm 1] using lastCounter
    · exact lastImage

theorem source (s : State) (base : ArrayPointer) (n hn ht stop start : Nat) (sr si : BitVec 64)
    (input : Fin n → BitVec 64) (fixed : Fixed s base n hn ht stop sr si)
    (counter : Cell s "v".toList start) (represented : Represents s.heap base input) (range : start≤stop) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.butterflyLoop s ⟨after,.normal⟩ ∧
      Fixed after base n hn ht stop sr si ∧ Cell after "v".toList stop ∧
      Represents after.heap base (values n hn ht fixed.length sr si (stop-start) start input) ∧ FftLoopFrame141.Frame base n s after := by
  obtain ⟨after,head,lastFixed,lastCounter,lastImage,frame⟩ :=
    prefix_source s base n hn ht stop start (stop-start) sr si input fixed counter represented (by omega)
  have endCounter : Cell after "v".toList stop := by
    simpa only [Nat.add_sub_of_le range] using lastCounter
  have guard : C99ArrayReference.scalar after FftMiddleShape139.butterflyCondition (.int32 0) := by
    have source := FftLoopInvariant141.guard after base n hn ht stop stop sr si lastFixed endCounter (by omega)
    simpa [C99ScalarReference.boolean] using source
  refine ⟨after,?_,lastFixed,endCounter,lastImage,frame⟩
  rw [FftMiddleShape139.butterfly_shape]
  exact C99ProcedureSegments136.finish _ _ _ _ (stop-start) s after _ head
    (.loopFalse _ _ _ after (.int32 0) guard (by decide))

end FT1536.Source3.FftLoopInduction141
