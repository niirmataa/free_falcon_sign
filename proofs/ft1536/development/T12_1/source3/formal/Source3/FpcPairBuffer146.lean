import Source3.C99TwoWordBuffer146
import Source3.FpcAddStore146
import Source3.FftGroupFrame143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcPairBuffer146
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents element)
open FftMulStates140 (Words)

theorem image {n : Nat} (kind : FftPairShape140.Kind) (s : State) (base : ArrayPointer)
    (input : Fin n → BitVec 64) (represented : Represents s.heap base input) (width : base.elementBytes=8)
    (writable : s.heap.writable base.block=true) (r q : Fin n) (x : Words) :
    Represents (FftPairStates140.output kind s x (element base r) (element base q)).heap base
      (C99TwoWordBuffer146.values input r q (FftPairStates140.real kind x) (FftPairStates140.imag kind x)) :=
  C99TwoWordBuffer146.preserves s.heap base input represented width writable r q _ _

theorem frame {n : Nat} (kind : FftPairShape140.Kind) (s : State) (base : ArrayPointer)
    (width : base.elementBytes=8) (r q : Fin n) (x : Words) :
    FftGroupFrame143.Frame base n s (FftPairStates140.output kind s x (element base r) (element base q)) := by
  refine ⟨rfl,rfl,rfl,rfl,rfl,rfl,?_⟩
  intro block offset outside
  exact FftPairClosed140.other_byte kind s x (element base r) (element base q) block offset
    (FftLoopFrame141.outside_element base width r block offset outside)
    (FftLoopFrame141.outside_element base width q block offset outside)

end FT1536.Source3.FpcPairBuffer146
