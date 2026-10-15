import Source3.FftTriplingStep148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTriplingInduction148
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open FftTripleBody147 (Constants)
open FftTriplingInvariant148 (Fixed)

def values (c : Constants) : Nat → Nat → (Fin 1536 → BitVec 64) → (Fin 1536 → BitVec 64)
  | 0,_,input => input
  | count+1,k,input => values c count (k+1) (FftTriplingStep148.advance c k input)

theorem loop_shape : FftTripleShape145.loop=.loop (FftMiddleShape139.condition FftTripleShape145.loop)
    FftTripleShape145.loopBody (FftMiddleShape139.increment FftTripleShape145.loop) := by rfl

theorem prefix_source (s : State) (base : ArrayPointer) (c : Constants) (k count : Nat)
    (input : Fin 1536 → BitVec 64) (fixed : Fixed s base c)
    (uCell : Cell s "u".toList (3*k)) (vCell : Cell s "v".toList (2*(512+k)))
    (represented : Represents s.heap base input) (range : k+count≤256) :
    ∃ after, C99ProcedureSegments136.Prefix KeygenSearchFft.program (FftMiddleShape139.condition FftTripleShape145.loop)
      FftTripleShape145.loopBody (FftMiddleShape139.increment FftTripleShape145.loop) count s after ∧
      Fixed after base c ∧ Cell after "u".toList (3*(k+count)) ∧ Cell after "v".toList (2*(512+(k+count))) ∧
      Represents after.heap base (values c count k input) ∧ FftTriplingFrame148.Frame base s after := by
  induction count generalizing s k input with
  | zero => exact ⟨s,.done _,fixed,uCell,vCell,represented,FftTriplingFrame148.refl base s⟩
  | succ count ih =>
    have remaining : k<256 := by omega
    obtain ⟨middle,next,body,increment,nextFixed,nextU,nextV,nextImage,stepFrame⟩ :=
      FftTriplingStep148.source s base c k input fixed uCell vCell represented remaining
    obtain ⟨after,tail,lastFixed,lastU,lastV,lastImage,tailFrame⟩ :=
      ih next (k+1) _ nextFixed nextU nextV nextImage (by omega)
    have guard : C99ArrayReference.scalar s (FftMiddleShape139.condition FftTripleShape145.loop) (.int32 1) := by
      have source := FftTriplingInvariant148.guard s base c k fixed uCell (by omega)
      simpa [remaining,C99ScalarReference.boolean] using source
    refine ⟨after,.next count s middle next after (.int32 1) guard (by decide) body increment tail,lastFixed,?_,?_,lastImage,
      FftTriplingFrame148.trans base s next after stepFrame tailFrame⟩
    · simpa only [Nat.add_assoc,Nat.add_comm 1] using lastU
    · simpa only [Nat.add_assoc,Nat.add_comm 1] using lastV

theorem source (s : State) (base : ArrayPointer) (c : Constants) (k : Nat)
    (input : Fin 1536 → BitVec 64) (fixed : Fixed s base c)
    (uCell : Cell s "u".toList (3*k)) (vCell : Cell s "v".toList (2*(512+k)))
    (represented : Represents s.heap base input) (range : k≤256) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.loop s ⟨after,.normal⟩ ∧
      Fixed after base c ∧ Cell after "u".toList 768 ∧ Cell after "v".toList 1536 ∧
      Represents after.heap base (values c (256-k) k input) ∧ FftTriplingFrame148.Frame base s after := by
  obtain ⟨after,head,lastFixed,lastU,lastV,lastImage,frame⟩ :=
    prefix_source s base c k (256-k) input fixed uCell vCell represented (by omega)
  have endU : Cell after "u".toList 768 := by simpa only [Nat.add_sub_of_le range] using lastU
  have endV : Cell after "v".toList 1536 := by simpa only [Nat.add_sub_of_le range] using lastV
  have guard : C99ArrayReference.scalar after (FftMiddleShape139.condition FftTripleShape145.loop) (.int32 0) := by
    have source := FftTriplingInvariant148.guard after base c 256 lastFixed endU (Nat.le_refl _)
    simpa [C99ScalarReference.boolean] using source
  refine ⟨after,?_,lastFixed,endU,endV,lastImage,frame⟩
  rw [loop_shape]
  exact C99ProcedureSegments136.finish _ _ _ _ (256-k) s after _ head
    (.loopFalse _ _ _ after (.int32 0) guard (by decide))

end FT1536.Source3.FftTriplingInduction148
