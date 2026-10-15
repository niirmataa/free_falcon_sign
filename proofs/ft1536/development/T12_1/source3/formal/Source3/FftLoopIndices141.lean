import Source3.FftLoopShape141
import Source3.C99PointerNat141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLoopIndices141
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)

def slots (n hn ht v : Nat) (inside : v+ht<hn) (length : 2*hn≤n) : Fin 4 → Fin n
  | ⟨0,_⟩ => ⟨v,by omega⟩
  | ⟨1,_⟩ => ⟨v+hn,by omega⟩
  | ⟨2,_⟩ => ⟨v+ht,by omega⟩
  | ⟨3,_⟩ => ⟨v+ht+hn,by omega⟩

/-- Natural bounds establish the original uint64 index expressions, with
    every sum below the word modulus before conversion to a pointer offset. -/
theorem evaluated (s : State) (n hn ht v : Nat) (inside : v+ht<hn) (length : 2*hn≤n)
    (wordBound : n<2^64) (vCell : Cell s "v".toList v) (hnCell : Cell s "hn".toList hn)
    (htCell : Cell s "ht".toList ht) (i : Fin 4) :
    C99ArrayReference.scalar s (FftLoadShape140.index i)
      (.uint64 (C99NatWord141.word ((slots n hn ht v inside length i).val))) := by
  fin_cases i
  · change C99ArrayReference.scalar s (.var "v".toList) (.uint64 (C99NatWord141.word v))
    exact C99LoopScalar141.read s "v".toList v vCell
  · change C99ArrayReference.scalar s (.bin .add (.var "v".toList) (.var "hn".toList)) (.uint64 (C99NatWord141.word (v+hn)))
    exact C99LoopScalar141.add s _ _ v hn (by omega) (by omega)
      (C99LoopScalar141.read s "v".toList v vCell) (C99LoopScalar141.read s "hn".toList hn hnCell)
  · change C99ArrayReference.scalar s (.bin .add (.var "v".toList) (.var "ht".toList)) (.uint64 (C99NatWord141.word (v+ht)))
    exact C99LoopScalar141.add s _ _ v ht (by omega) (by omega)
      (C99LoopScalar141.read s "v".toList v vCell) (C99LoopScalar141.read s "ht".toList ht htCell)
  · change C99ArrayReference.scalar s (.bin .add (.bin .add (.var "v".toList) (.var "ht".toList)) (.var "hn".toList)) (.uint64 (C99NatWord141.word (v+ht+hn)))
    exact C99LoopScalar141.add s _ _ (v+ht) hn (by omega) (by omega)
      (C99LoopScalar141.add s _ _ v ht (by omega) (by omega)
        (C99LoopScalar141.read s "v".toList v vCell) (C99LoopScalar141.read s "ht".toList ht htCell))
      (C99LoopScalar141.read s "hn".toList hn hnCell)

theorem addresses (s : State) (base : ArrayPointer) (n hn ht v : Nat)
    (inside : v+ht<hn) (length : 2*hn≤n) (wordBound : n<2^64)
    (capacity : base.index+n≤base.count) (binding : s.arrays "a".toList=some base)
    (vCell : Cell s "v".toList v) (hnCell : Cell s "hn".toList hn) (htCell : Cell s "ht".toList ht) :
    ∀ i, C99ArrayReference.Pointer s "a".toList (FftLoadShape140.index i)
      (C99WordBuffer140.element base (slots n hn ht v inside length i)) := by
  intro i
  have fit := (slots n hn ht v inside length i).isLt
  exact C99PointerNat141.source s "a".toList (FftLoadShape140.index i) base _
    (by omega) (by omega) binding (evaluated s n hn ht v inside length wordBound vCell hnCell htCell i)

end FT1536.Source3.FftLoopIndices141
