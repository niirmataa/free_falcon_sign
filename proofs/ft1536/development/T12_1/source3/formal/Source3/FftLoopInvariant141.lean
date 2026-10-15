import Source3.FftLoopIndices141
import Source3.FftButterflyBuffer140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLoopInvariant141
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)

structure Fixed (s : State) (base : ArrayPointer) (n hn ht stop : Nat) (sr si : BitVec 64) : Prop where
  width : base.elementBytes=8
  capacity : base.index+n≤base.count
  length : 2*hn≤n
  stopBound : stop+ht≤hn
  wordBound : n<2^64
  binding : s.arrays "a".toList=some base
  hnCell : Cell s "hn".toList hn
  htCell : Cell s "ht".toList ht
  stopCell : Cell s "v2".toList stop
  realCell : s.locals "sr".toList=some (.uint64,some (.uint64 sr))
  imagCell : s.locals "si".toList=some (.uint64,some (.uint64 si))
  writable : s.heap.writable base.block=true

theorem transfer (s t : State) (base : ArrayPointer) (n hn ht stop : Nat) (sr si : BitVec 64)
    (fixed : Fixed s base n hn ht stop sr si) (locals : t.locals=s.locals)
    (arrays : t.arrays=s.arrays) (permissions : t.heap.writable=s.heap.writable) :
    Fixed t base n hn ht stop sr si := by
  refine ⟨fixed.width,fixed.capacity,fixed.length,fixed.stopBound,fixed.wordBound,?_,?_,?_,?_,?_,?_,?_⟩
  · rw [arrays]; exact fixed.binding
  · change t.locals "hn".toList=_
    rw [locals]; exact fixed.hnCell
  · change t.locals "ht".toList=_
    rw [locals]; exact fixed.htCell
  · change t.locals "v2".toList=_
    rw [locals]; exact fixed.stopCell
  · rw [locals]; exact fixed.realCell
  · rw [locals]; exact fixed.imagCell
  · rw [permissions]; exact fixed.writable

theorem counter_update (s : State) (base : ArrayPointer) (n hn ht stop : Nat) (sr si : BitVec 64)
    (fixed : Fixed s base n hn ht stop sr si) (value : BitVec 64) :
    Fixed (FftLocalCells140.put s "v".toList value) base n hn ht stop sr si := by
  refine ⟨fixed.width,fixed.capacity,fixed.length,fixed.stopBound,fixed.wordBound,fixed.binding,?_,?_,?_,?_,?_,fixed.writable⟩
  · exact (FftLocalCells140.outside s "v".toList "hn".toList value (by decide)).trans fixed.hnCell
  · exact (FftLocalCells140.outside s "v".toList "ht".toList value (by decide)).trans fixed.htCell
  · exact (FftLocalCells140.outside s "v".toList "v2".toList value (by decide)).trans fixed.stopCell
  · exact (FftLocalCells140.outside s "v".toList "sr".toList value (by decide)).trans fixed.realCell
  · exact (FftLocalCells140.outside s "v".toList "si".toList value (by decide)).trans fixed.imagCell

theorem guard (s : State) (base : ArrayPointer) (n hn ht stop v : Nat) (sr si : BitVec 64)
    (fixed : Fixed s base n hn ht stop sr si) (counter : Cell s "v".toList v) (range : v≤stop) :
    C99ArrayReference.scalar s FftMiddleShape139.butterflyCondition
      (C99ScalarReference.boolean (decide (v<stop))) := by
  rw [FftLoopShape141.condition]
  have endBound := fixed.stopBound
  have length := fixed.length
  have wordBound := fixed.wordBound
  exact C99LoopScalar141.less s _ _ v stop (by omega) (by omega)
    (C99LoopScalar141.read s "v".toList v counter) (C99LoopScalar141.read s "v2".toList stop fixed.stopCell)

end FT1536.Source3.FftLoopInvariant141
