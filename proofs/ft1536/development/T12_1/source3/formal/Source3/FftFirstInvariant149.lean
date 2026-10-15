import Source3.FftFirstBody149
import Source3.C99PointerNat141
import Source3.C99LoopScalar141
import Source3.FftGroupFrame143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstInvariant149
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)

structure Fixed (s : State) (base : ArrayPointer) (n hn : Nat) (wr wi : BitVec 64) : Prop where
  width : base.elementBytes=8
  capacity : base.index+n≤base.count
  length : 2*hn≤n
  wordBound : n<2^64
  binding : s.arrays "a".toList=some base
  hnCell : Cell s "hn".toList hn
  realCell : s.locals "fpr_W1R".toList=some (.uint64,some (.uint64 wr))
  imagCell : s.locals "fpr_W1I".toList=some (.uint64,some (.uint64 wi))
  writable : s.heap.writable base.block=true

theorem transfer (s t : State) (base : ArrayPointer) (n hn : Nat) (wr wi : BitVec 64)
    (fixed : Fixed s base n hn wr wi) (frame : FftGroupFrame143.Frame base n s t) :
    Fixed t base n hn wr wi := by
  refine ⟨fixed.width,fixed.capacity,fixed.length,fixed.wordBound,?_,?_,?_,?_,?_⟩
  · exact (congrFun frame.arrays "a".toList).trans fixed.binding
  · exact (congrFun frame.locals "hn".toList).trans fixed.hnCell
  · exact (congrFun frame.locals "fpr_W1R".toList).trans fixed.realCell
  · exact (congrFun frame.locals "fpr_W1I".toList).trans fixed.imagCell
  · exact (congrFun frame.writable base.block).trans fixed.writable

theorem counter (s : State) (base : ArrayPointer) (n hn : Nat) (wr wi value : BitVec 64)
    (fixed : Fixed s base n hn wr wi) : Fixed (FftLocalCells140.put s "u".toList value) base n hn wr wi := by
  refine ⟨fixed.width,fixed.capacity,fixed.length,fixed.wordBound,fixed.binding,?_,?_,?_,fixed.writable⟩
  · exact (FftLocalCells140.outside s "u".toList "hn".toList value (by decide)).trans fixed.hnCell
  · exact (FftLocalCells140.outside s "u".toList "fpr_W1R".toList value (by decide)).trans fixed.realCell
  · exact (FftLocalCells140.outside s "u".toList "fpr_W1I".toList value (by decide)).trans fixed.imagCell

theorem guard (s : State) (base : ArrayPointer) (n hn u : Nat) (wr wi : BitVec 64)
    (fixed : Fixed s base n hn wr wi) (uCell : Cell s "u".toList u) (range : u≤hn) :
    C99ArrayReference.scalar s FftShape138.firstCondition (C99ScalarReference.boolean (decide (u<hn))) := by
  have length := fixed.length
  have bound := fixed.wordBound
  exact C99LoopScalar141.less s _ _ u hn (by omega) (by omega)
    (C99LoopScalar141.read s "u".toList u uCell) (C99LoopScalar141.read s "hn".toList hn fixed.hnCell)

theorem addresses (s : State) (base : ArrayPointer) (n hn u : Nat) (wr wi : BitVec 64)
    (fixed : Fixed s base n hn wr wi) (uCell : Cell s "u".toList u) (range : u<hn) :
    C99ArrayReference.Pointer s "a".toList FftFirstShape149.index0 {base with index := base.index+u} ∧
    C99ArrayReference.Pointer s "a".toList FftFirstShape149.index1 {base with index := base.index+(u+hn)} := by
  have length := fixed.length
  have bound := fixed.wordBound
  have capacity := fixed.capacity
  exact ⟨C99PointerNat141.source s _ _ base u (by omega) (by omega) fixed.binding
      (C99LoopScalar141.read s "u".toList u uCell),
    C99PointerNat141.source s _ _ base (u+hn) (by omega) (by omega) fixed.binding
      (C99LoopScalar141.add s _ _ u hn (by omega) (by omega)
        (C99LoopScalar141.read s "u".toList u uCell) (C99LoopScalar141.read s "hn".toList hn fixed.hnCell))⟩

end FT1536.Source3.FftFirstInvariant149
