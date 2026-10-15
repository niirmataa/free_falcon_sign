import Source3.FftGroupsStep143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupsInduction143
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99WordBuffer140 (Represents)
open FftGroupsInvariant143 (Fixed)
open FftMiddleShape139

/-- Pure group recurrence; each group reuses the pure butterfly recurrence. -/
def values (n hn ht m t : Nat) (length : 2*hn≤n) : Nat → Nat → (Fin n → BitVec 64) → (Fin n → BitVec 64)
  | 0,_,input => input
  | count+1,u,input => values n hn ht m t length count (u+1)
      (FftGroupSource143.values n hn ht length m u (u*t) input)

theorem prefix_source (s : State) (base : ArrayPointer) (n hn m t ht hm u count : Nat)
    (input : Fin n → BitVec 64) (fixed : Fixed s base n hn m t ht hm)
    (counter : Cell s "u1".toList u) (offset : Cell s "v1".toList (u*t))
    (represented : Represents s.heap base input) (range : u+count≤hm) :
    ∃ after, C99ProcedureSegments136.Prefix KeygenSearchFft.program groupCondition groupBody groupIncrement count s after ∧
      Fixed after base n hn m t ht hm ∧ Cell after "u1".toList (u+count) ∧ Cell after "v1".toList ((u+count)*t) ∧
      Represents after.heap base (values n hn ht m t fixed.length count u input) ∧ FftGroupsFrame143.Frame base n s after := by
  induction count generalizing s u input with
  | zero => exact ⟨s,.done _,fixed,counter,offset,represented,FftGroupsFrame143.refl base n s⟩
  | succ count ih =>
    have remaining : u<hm := by omega
    obtain ⟨middle,next,body,update,nextFixed,nextCounter,nextOffset,nextImage,stepFrame⟩ :=
      FftGroupsStep143.source s base n hn m t ht hm u input fixed counter offset represented remaining
    obtain ⟨after,tail,lastFixed,lastCounter,lastOffset,lastImage,tailFrame⟩ :=
      ih next (u+1) _ nextFixed nextCounter nextOffset nextImage (by omega)
    have guard : C99ArrayReference.scalar s groupCondition (.int32 1) := by
      have source := FftGroupsInvariant143.guard s base n hn m t ht hm u fixed counter (by omega)
      simpa [remaining,C99ScalarReference.boolean] using source
    refine ⟨after,.next count s middle next after (.int32 1) guard (by decide) body update tail,lastFixed,?_,?_,lastImage,
      FftGroupsFrame143.trans base n s next after stepFrame tailFrame⟩
    · simpa only [Nat.add_assoc,Nat.add_comm 1] using lastCounter
    · simpa only [Nat.add_assoc,Nat.add_comm 1] using lastOffset

theorem source (s : State) (base : ArrayPointer) (n hn m t ht hm u : Nat)
    (input : Fin n → BitVec 64) (fixed : Fixed s base n hn m t ht hm)
    (counter : Cell s "u1".toList u) (offset : Cell s "v1".toList (u*t))
    (represented : Represents s.heap base input) (range : u≤hm) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program groupLoop s ⟨after,.normal⟩ ∧
      Fixed after base n hn m t ht hm ∧ Cell after "u1".toList hm ∧ Cell after "v1".toList (hm*t) ∧
      Represents after.heap base (values n hn ht m t fixed.length (hm-u) u input) ∧ FftGroupsFrame143.Frame base n s after := by
  obtain ⟨after,head,lastFixed,lastCounter,lastOffset,lastImage,frame⟩ :=
    prefix_source s base n hn m t ht hm u (hm-u) input fixed counter offset represented (by omega)
  have endCounter : Cell after "u1".toList hm := by simpa only [Nat.add_sub_of_le range] using lastCounter
  have endOffset : Cell after "v1".toList (hm*t) := by simpa only [Nat.add_sub_of_le range] using lastOffset
  have guard : C99ArrayReference.scalar after groupCondition (.int32 0) := by
    have source := FftGroupsInvariant143.guard after base n hn m t ht hm hm lastFixed endCounter (by omega)
    simpa [C99ScalarReference.boolean] using source
  refine ⟨after,?_,lastFixed,endCounter,endOffset,lastImage,frame⟩
  rw [group_shape]
  exact C99ProcedureSegments136.finish _ _ _ _ (hm-u) s after _ head
    (.loopFalse _ _ _ after (.int32 0) guard (by decide))

end FT1536.Source3.FftGroupsInduction143
