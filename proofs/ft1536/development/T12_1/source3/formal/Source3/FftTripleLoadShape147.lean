import Source3.FftTripleDeclare147
import Source3.FftTripleIndices146

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleLoadShape147
open C99ArrayReference (Name)
open FftTripleIndices146 (realSlot imagSlot)

def name (i : Fin 6) : Name := FftTripleDeclare147.inputNames[i.val]'(by change i.val<6; exact i.isLt)
def index : Fin 6 → CLogic.Expr
  | ⟨0,_⟩ => .var "u".toList
  | ⟨1,_⟩ => .bin .add (.var "u".toList) (.var "hn".toList)
  | ⟨2,_⟩ => FftTripleAddShape146.realIndex 1
  | ⟨3,_⟩ => FftTripleAddShape146.imagIndex 1
  | ⟨4,_⟩ => FftTripleAddShape146.realIndex 2
  | ⟨5,_⟩ => FftTripleAddShape146.imagIndex 2

def slot (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) : Fin 6 → Fin n
  | ⟨0,_⟩ => realSlot n hn u inside length 0
  | ⟨1,_⟩ => imagSlot n hn u inside length 0
  | ⟨2,_⟩ => realSlot n hn u inside length 1
  | ⟨3,_⟩ => imagSlot n hn u inside length 1
  | ⟨4,_⟩ => realSlot n hn u inside length 2
  | ⟨5,_⟩ => imagSlot n hn u inside length 2

theorem shape (i : Fin 6) : FftTripleShape145.part (4+i.val)=.base (.assign (name i) (.load "a".toList (index i))) := by
  fin_cases i <;> rfl

theorem member (i : Fin 6) : name i∈FftTripleDeclare147.inputNames := by fin_cases i <;> decide +kernel

theorem scope_member (i : Fin 6) : name i∈FftTripleDeclare147.names :=
  List.mem_append_left _ (member i)

theorem injective : Function.Injective name := by
  unfold Function.Injective
  decide +kernel

theorem addresses (s : C99ArrayReference.State) (base : C99MemoryReference.ArrayPointer)
    (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) (wordBound : n<2^64)
    (capacity : base.index+n≤base.count) (binding : s.arrays "a".toList=some base)
    (uCell : C99LoopScalar141.Cell s "u".toList u) (hnCell : C99LoopScalar141.Cell s "hn".toList hn) (i : Fin 6) :
    C99ArrayReference.Pointer s "a".toList (index i) (C99WordBuffer140.element base (slot n hn u inside length i)) := by
  fin_cases i
  · exact C99PointerNat141.source s "a".toList (.var "u".toList) base u (by omega) (by omega) binding
      (C99LoopScalar141.read s "u".toList u uCell)
  · exact C99PointerNat141.source s "a".toList (.bin .add (.var "u".toList) (.var "hn".toList)) base (u+hn)
      (by omega) (by omega) binding (C99LoopScalar141.add s _ _ u hn (by omega) (by omega)
        (C99LoopScalar141.read s "u".toList u uCell) (C99LoopScalar141.read s "hn".toList hn hnCell))
  · exact FftTripleIndices146.real_address s base n hn u inside length wordBound capacity binding uCell 1
  · exact FftTripleIndices146.imag_address s base n hn u inside length wordBound capacity binding uCell hnCell 1
  · exact FftTripleIndices146.real_address s base n hn u inside length wordBound capacity binding uCell 2
  · exact FftTripleIndices146.imag_address s base n hn u inside length wordBound capacity binding uCell hnCell 2

end FT1536.Source3.FftTripleLoadShape147
