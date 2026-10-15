import Source3.FftFirstFrame149

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstStep149
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open FftFirstInvariant149 (Fixed)

def advance (n hn u : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (input : Fin n → BitVec 64) : Fin n → BitVec 64 :=
  if range : u<hn then FftFirstBuffer149.values input ⟨u,by omega⟩ ⟨u+hn,by omega⟩ wr wi else input

theorem source (s : State) (base : ArrayPointer) (n hn u : Nat) (wr wi : BitVec 64)
    (input : Fin n → BitVec 64) (fixed : Fixed s base n hn wr wi)
    (uCell : Cell s "u".toList u) (represented : Represents s.heap base input) (range : u<hn) :
    ∃ middle after, C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstBody s ⟨middle,.normal⟩ ∧
      C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstIncrement middle ⟨after,.normal⟩ ∧
      Fixed after base n hn wr wi ∧ Cell after "u".toList (u+1) ∧
      Represents after.heap base (advance n hn u fixed.length wr wi input) ∧ FftFirstFrame149.Frame base n s after := by
  have length := fixed.length
  have bound := fixed.wordBound
  obtain ⟨middle,body,image,frame⟩ := FftFirstBuffer149.source s base n hn u wr wi input fixed uCell represented range
    ⟨u,by omega⟩ ⟨u+hn,by omega⟩ rfl rfl
  have middleFixed := FftFirstInvariant149.transfer s middle base n hn wr wi fixed frame
  have middleU : Cell middle "u".toList u := (congrFun frame.locals "u".toList).trans uCell
  let after := FftLocalCells140.put middle "u".toList (C99NatWord141.word (u+1))
  refine ⟨middle,after,body,?_,FftFirstInvariant149.counter middle base n hn wr wi _ middleFixed,?_,?_,?_⟩
  · exact C99LoopScalar141.increment _ middle "u".toList u (by omega) middleU
  · exact FftLocalCells140.cell_at middle "u".toList _
  · change Represents middle.heap base (advance n hn u fixed.length wr wi input)
    rw [advance,dite_eq_left range]
    exact image
  · exact FftFirstFrame149.trans base n s middle after (FftFirstFrame149.body base n s middle frame)
      (FftFirstFrame149.counter base n middle _)

end FT1536.Source3.FftFirstStep149
