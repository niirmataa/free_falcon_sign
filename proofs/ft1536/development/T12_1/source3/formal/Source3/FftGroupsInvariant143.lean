import Source3.FftGroupSource143
import Source3.C99ControlCells142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupsInvariant143
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)

structure Fixed (s : State) (base : ArrayPointer) (n hn m t ht hm : Nat) : Prop where
  width : base.elementBytes=8
  capacity : base.index+n≤base.count
  length : 2*hn≤n
  stepSize : t=ht+ht
  endBound : hm*t≤hn
  tableBound : m+hm≤1024
  wordBound : n<2^64
  binding : s.arrays "a".toList=some base
  tableBinding : s.arrays "fpr_gm3_square".toList=some (FftGlobalMemory.pointer .square)
  mCell : Cell s "m".toList m
  tCell : Cell s "t".toList t
  htCell : Cell s "ht".toList ht
  hmCell : Cell s "hm".toList hm
  hnCell : Cell s "hn".toList hn
  writable : s.heap.writable base.block=true
  pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap

theorem transfer (s after : State) (base : ArrayPointer) (n hn m t ht hm : Nat)
    (fixed : Fixed s base n hn m t ht hm) (frame : FftGroupFrame143.Frame base n s after)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment after.heap) :
    Fixed after base n hn m t ht hm := by
  refine ⟨fixed.width,fixed.capacity,fixed.length,fixed.stepSize,fixed.endBound,fixed.tableBound,fixed.wordBound,
    ?_,?_,?_,?_,?_,?_,?_,?_,pinned⟩
  · rw [frame.arrays]; exact fixed.binding
  · rw [frame.arrays]; exact fixed.tableBinding
  · change after.locals "m".toList=_; rw [frame.locals]; exact fixed.mCell
  · change after.locals "t".toList=_; rw [frame.locals]; exact fixed.tCell
  · change after.locals "ht".toList=_; rw [frame.locals]; exact fixed.htCell
  · change after.locals "hm".toList=_; rw [frame.locals]; exact fixed.hmCell
  · change after.locals "hn".toList=_; rw [frame.locals]; exact fixed.hnCell
  · rw [frame.writable]; exact fixed.writable

theorem put (s : State) (base : ArrayPointer) (n hn m t ht hm : Nat) (name : Name) (value : BitVec 64)
    (fixed : Fixed s base n hn m t ht hm)
    (notM : "m".toList≠name) (notT : "t".toList≠name) (notHt : "ht".toList≠name)
    (notHm : "hm".toList≠name) (notHn : "hn".toList≠name) :
    Fixed (FftLocalCells140.put s name value) base n hn m t ht hm :=
  ⟨fixed.width,fixed.capacity,fixed.length,fixed.stepSize,fixed.endBound,fixed.tableBound,fixed.wordBound,
    fixed.binding,fixed.tableBinding,
    (FftLocalCells140.outside s name _ value notM).trans fixed.mCell,
    (FftLocalCells140.outside s name _ value notT).trans fixed.tCell,
    (FftLocalCells140.outside s name _ value notHt).trans fixed.htCell,
    (FftLocalCells140.outside s name _ value notHm).trans fixed.hmCell,
    (FftLocalCells140.outside s name _ value notHn).trans fixed.hnCell,fixed.writable,fixed.pinned⟩

theorem guard (s : State) (base : ArrayPointer) (n hn m t ht hm u : Nat)
    (fixed : Fixed s base n hn m t ht hm) (counter : Cell s "u1".toList u) (range : u≤hm) :
    C99ArrayReference.scalar s FftMiddleShape139.groupCondition
      (C99ScalarReference.boolean (decide (u<hm))) := by
  rw [FftControlShape142.group_condition]
  have bound := fixed.tableBound
  exact C99LoopScalar141.less s _ _ u hm (by omega) (by omega)
    (C99LoopScalar141.read s _ u counter) (C99LoopScalar141.read s _ hm fixed.hmCell)

end FT1536.Source3.FftGroupsInvariant143
