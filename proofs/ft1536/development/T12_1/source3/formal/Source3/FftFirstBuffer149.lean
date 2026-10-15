import Source3.FftFirstInvariant149
import Source3.C99TwoWordBuffer146

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstBuffer149
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents element)
open FftFirstInvariant149 (Fixed)

def values {n : Nat} (input : Fin n → BitVec 64) (r q : Fin n) (wr wi : BitVec 64) : Fin n → BitVec 64 :=
  C99TwoWordBuffer146.values input r q (FftFirstBody149.real (input r) (input q) wr) (FftFirstBody149.imag (input q) wi)

theorem store_outside (heap : C99MemoryReference.Memory) (p : ArrayPointer) (w : BitVec 64) (block offset : Nat)
    (outside : block≠p.block ∨ offset<p.offset ∨ p.offset+8≤offset) :
    (C99WordStore140.write heap p w).bytes block offset=heap.bytes block offset := by
  have absent : ¬(block=p.block ∧ p.offset≤offset ∧ offset<p.offset+8) := by omega
  simp only [C99WordStore140.write,dite_eq_right absent]

theorem output_frame {n : Nat} (s : State) (base : ArrayPointer) (r q : Fin n) (x y : BitVec 64)
    (width : base.elementBytes=8) :
    FftGroupFrame143.Frame base n s (FftFirstBody149.output s (element base r) (element base q) x y) := by
  refine ⟨rfl,rfl,rfl,rfl,rfl,rfl,?_⟩
  intro block offset outside
  exact (store_outside _ (element base q) y block offset (FftLoopFrame141.outside_element base width q block offset outside)).trans
    (store_outside _ (element base r) x block offset (FftLoopFrame141.outside_element base width r block offset outside))

theorem source (s : State) (base : ArrayPointer) (n hn u : Nat) (wr wi : BitVec 64)
    (input : Fin n → BitVec 64) (fixed : Fixed s base n hn wr wi)
    (uCell : C99LoopScalar141.Cell s "u".toList u) (represented : Represents s.heap base input)
    (range : u<hn) (r q : Fin n) (rValue : r.val=u) (qValue : q.val=u+hn) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstBody s ⟨after,.normal⟩ ∧
      Represents after.heap base (values input r q wr wi) ∧ FftGroupFrame143.Frame base n s after := by
  have addresses := FftFirstInvariant149.addresses s base n hn u wr wi fixed uCell range
  have rAddress : C99ArrayReference.Pointer s "a".toList FftFirstShape149.index0 (element base r) := by
    simpa only [element,rValue] using addresses.1
  have qAddress : C99ArrayReference.Pointer s "a".toList FftFirstShape149.index1 (element base q) := by
    simpa only [element,qValue] using addresses.2
  let x := FftFirstBody149.real (input r) (input q) wr
  let y := FftFirstBody149.imag (input q) wi
  refine ⟨FftFirstBody149.output s (element base r) (element base q) x y,?_,?_,output_frame s base r q x y fixed.width⟩
  · exact FftFirstBody149.source s _ _ (input r) (input q) wr wi rAddress qAddress
      (represented r) (represented q) fixed.writable fixed.writable fixed.realCell fixed.imagCell
  · exact C99TwoWordBuffer146.preserves s.heap base input represented fixed.width fixed.writable r q x y

end FT1536.Source3.FftFirstBuffer149
