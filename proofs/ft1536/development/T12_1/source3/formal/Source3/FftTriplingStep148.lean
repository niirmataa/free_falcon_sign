import Source3.FftTriplingInvariant148
import Source3.FftTriplingFrame148
import Source3.FftTriplingBody148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTriplingStep148
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open FftTripleBody147 (Constants)
open FftTriplingInvariant148 (Fixed)

def advance (c : Constants) (k : Nat) (input : Fin 1536 → BitVec 64) : Fin 1536 → BitVec 64 :=
  if range : k<256 then FftTripleBody147.values 1536 768 (3*k) (512+k) (by omega) (by decide) input c else input

theorem source (s : State) (base : ArrayPointer) (c : Constants) (k : Nat)
    (input : Fin 1536 → BitVec 64) (fixed : Fixed s base c)
    (uCell : Cell s "u".toList (3*k)) (vCell : Cell s "v".toList (2*(512+k)))
    (represented : Represents s.heap base input) (range : k<256) :
    ∃ middle after, C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.loopBody s ⟨middle,.normal⟩ ∧
      C99ProcedureReference.Exec KeygenSearchFft.program (FftMiddleShape139.increment FftTripleShape145.loop) middle ⟨after,.normal⟩ ∧
      Fixed after base c ∧ Cell after "u".toList (3*(k+1)) ∧ Cell after "v".toList (2*(512+(k+1))) ∧
      Represents after.heap base (advance c k input) ∧ FftTriplingFrame148.Frame base s after := by
  let context := FftTriplingInvariant148.context s base c k fixed uCell vCell range
  obtain ⟨middle,body,image,frame⟩ := FftTriplingBody148.source s base (3*k) (512+k) input c context represented
  have middleFixed : Fixed middle base c := FftTriplingInvariant148.transfer s middle base c fixed frame
    (FftPinned139.procedure _ _ _ _ body fixed.pinned)
  have middleU : Cell middle "u".toList (3*k) := (congrFun frame.locals "u".toList).trans uCell
  have middleV : Cell middle "v".toList (2*(512+k)) := (congrFun frame.locals "v".toList).trans vCell
  let one := FftLocalCells140.put middle "u".toList (word (3*k+3))
  let after := FftLocalCells140.put one "v".toList (word (2*(512+k)+2))
  have first : C99ProcedureReference.Exec KeygenSearchFft.program (.base (.scalar (.update "u".toList .add (.literal .i32 3)))) middle ⟨one,.normal⟩ :=
    C99SmallLiteral146.update _ middle "u".toList (3*k) ⟨3,by decide⟩ (by omega) middleU
  have oneV : Cell one "v".toList (2*(512+k)) := (FftLocalCells140.outside _ _ _ _ (by decide)).trans middleV
  have second : C99ProcedureReference.Exec KeygenSearchFft.program (.base (.scalar (.update "v".toList .add (.literal .i32 2)))) one ⟨after,.normal⟩ :=
    C99SmallLiteral146.update _ one "v".toList (2*(512+k)) ⟨2,by decide⟩ (by omega) oneV
  have oneFixed : Fixed one base c := FftTriplingInvariant148.put middle base c middleFixed _ _ (Or.inl rfl)
  refine ⟨middle,after,body,?_,?_,?_,?_,?_,?_⟩
  · rw [FftTripleShape145.loop_increment]
    exact .seqNormal _ _ middle one _ first second
  · exact FftTriplingInvariant148.put one base c oneFixed _ _ (Or.inr rfl)
  · have cell : Cell after "u".toList (3*k+3) :=
      (FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _)
    have equal : 3*k+3=3*(k+1) := by omega
    rw [equal] at cell
    exact cell
  · have cell : Cell after "v".toList (2*(512+k)+2) := FftLocalCells140.cell_at _ _ _
    have equal : 2*(512+k)+2=2*(512+(k+1)) := by omega
    rw [equal] at cell
    exact cell
  · change Represents middle.heap base (advance c k input)
    rw [advance,dite_eq_left range]
    exact image
  · exact FftTriplingFrame148.trans base s middle after (FftTriplingFrame148.body base s middle frame)
      (FftTriplingFrame148.counters base middle _ _)

end FT1536.Source3.FftTriplingStep148
