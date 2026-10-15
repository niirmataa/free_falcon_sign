import Source3.FftTripleAddCalls146
import Source3.C99SmallLiteral146
import Source3.C99PointerNat141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleIndices146
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open FftTripleAddShape146 (realIndex imagIndex)

def realSlot (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) (i : Fin 3) : Fin n :=
  ⟨u+i.val,by have bound:=i.isLt; omega⟩
def imagSlot (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) (i : Fin 3) : Fin n :=
  ⟨u+i.val+hn,by have bound:=i.isLt; omega⟩

theorem real_eval (s : State) (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n)
    (wordBound : n<2^64) (uCell : Cell s "u".toList u) (i : Fin 3) :
    C99ArrayReference.scalar s (realIndex i) (.uint64 (word (u+i.val))) :=
  C99SmallLiteral146.add s (.var "u".toList) u ⟨i.val,by have bound:=i.isLt; omega⟩ (by omega)
    (C99LoopScalar141.read s "u".toList u uCell)

theorem imag_eval (s : State) (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n)
    (wordBound : n<2^64) (uCell : Cell s "u".toList u) (hnCell : Cell s "hn".toList hn) (i : Fin 3) :
    C99ArrayReference.scalar s (imagIndex i) (.uint64 (word (u+i.val+hn))) := by
  have bound:=i.isLt
  exact C99LoopScalar141.add s _ _ (u+i.val) hn (by omega) (by omega)
    (real_eval s n hn u inside length wordBound uCell i) (C99LoopScalar141.read s "hn".toList hn hnCell)

theorem real_address (s : State) (base : ArrayPointer) (n hn u : Nat)
    (inside : u+2<hn) (length : 2*hn≤n) (wordBound : n<2^64)
    (capacity : base.index+n≤base.count) (binding : s.arrays "a".toList=some base)
    (uCell : Cell s "u".toList u) (i : Fin 3) :
    C99ArrayReference.Pointer s "a".toList (realIndex i) (C99WordBuffer140.element base (realSlot n hn u inside length i)) := by
  have bound:=(realSlot n hn u inside length i).isLt
  exact C99PointerNat141.source s "a".toList (realIndex i) base _ (by omega) (by omega) binding
    (real_eval s n hn u inside length wordBound uCell i)

theorem imag_address (s : State) (base : ArrayPointer) (n hn u : Nat)
    (inside : u+2<hn) (length : 2*hn≤n) (wordBound : n<2^64)
    (capacity : base.index+n≤base.count) (binding : s.arrays "a".toList=some base)
    (uCell : Cell s "u".toList u) (hnCell : Cell s "hn".toList hn) (i : Fin 3) :
    C99ArrayReference.Pointer s "a".toList (imagIndex i) (C99WordBuffer140.element base (imagSlot n hn u inside length i)) := by
  have bound:=(imagSlot n hn u inside length i).isLt
  exact C99PointerNat141.source s "a".toList (imagIndex i) base _ (by omega) (by omega) binding
    (imag_eval s n hn u inside length wordBound uCell hnCell i)

end FT1536.Source3.FftTripleIndices146
