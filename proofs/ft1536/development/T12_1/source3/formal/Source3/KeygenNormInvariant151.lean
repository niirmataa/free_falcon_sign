import Source3.KeygenNormBody151
import Source3.C99ScopeFrame147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenNormInvariant151
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)

def names : List Name := ["norm".toList,"u".toList]
def Norm (s : State) (word : BitVec 64) : Prop := s.locals "norm".toList=some (.uint64,some (.uint64 word))

structure Fixed (s : State) (p q : ArrayPointer) (n : Nat) (f g : Fin n → BitVec 64) : Prop where
  wordBound : n<2^64
  pCapacity : p.index+n≤p.count
  qCapacity : q.index+n≤q.count
  pBinding : s.arrays "rt1".toList=some p
  qBinding : s.arrays "rt2".toList=some q
  nCell : Cell s "n".toList n
  fImage : Represents s.heap p f
  gImage : Represents s.heap q g

theorem transfer (s t : State) (p q : ArrayPointer) (n : Nat) (f g : Fin n → BitVec 64)
    (fixed : Fixed s p q n f g) (frame : C99ScopeFrame147.Frame names s t) (heap : t.heap=s.heap) : Fixed t p q n f g := by
  refine ⟨fixed.wordBound,fixed.pCapacity,fixed.qCapacity,?_,?_,?_,?_,?_⟩
  · exact (congrFun frame.arrays "rt1".toList).trans fixed.pBinding
  · exact (congrFun frame.arrays "rt2".toList).trans fixed.qBinding
  · exact (frame.locals _ (by decide)).trans fixed.nCell
  · rw [heap]; exact fixed.fImage
  · rw [heap]; exact fixed.gImage

theorem put (s : State) (p q : ArrayPointer) (n : Nat) (f g : Fin n → BitVec 64)
    (fixed : Fixed s p q n f g) (name : Name) (word : BitVec 64) (inside : name∈names) :
    Fixed (FftLocalCells140.put s name word) p q n f g :=
  transfer _ _ p q n f g fixed (C99ScopeFrame147.put names s name word inside) rfl

theorem guard (s : State) (p q : ArrayPointer) (n u : Nat) (f g : Fin n → BitVec 64)
    (fixed : Fixed s p q n f g) (counter : Cell s "u".toList u) (range : u≤n) :
    C99ArrayReference.scalar s KeygenNormShape151.condition (C99ScalarReference.boolean (decide (u<n))) := by
  have bound := fixed.wordBound
  exact C99LoopScalar141.less s _ _ u n (by omega) bound
    (C99LoopScalar141.read s "u".toList u counter) (C99LoopScalar141.read s "n".toList n fixed.nCell)

end FT1536.Source3.KeygenNormInvariant151
