import Source3.FftOuterFrame144
import Source3.FftGroupsInvariant143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterInvariant144
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)

structure Context (s : State) (base : ArrayPointer) (n hn : Nat) : Prop where
  width : base.elementBytes=8
  capacity : base.index+n≤base.count
  length : 2*hn≤n
  wordBound : n<2^64
  binding : s.arrays "a".toList=some base
  tableBinding : s.arrays "fpr_gm3_square".toList=some (FftGlobalMemory.pointer .square)
  hnCell : Cell s "hn".toList hn
  writable : s.heap.writable base.block=true
  pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap

structure Valid (hn t m : Nat) : Prop where
  tBound : t<2^64
  mBound : m<2^64
  half : t=t/2+t/2
  groups : (m/2)*t≤hn
  table : m+m/2≤1024

theorem transfer (s after : State) (base : ArrayPointer) (n hn : Nat)
    (context : Context s base n hn) (frame : FftOuterFrame144.Frame base n s after)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment after.heap) : Context after base n hn := by
  refine ⟨context.width,context.capacity,context.length,context.wordBound,?_,?_,?_,?_,pinned⟩
  · rw [frame.arrays]; exact context.binding
  · rw [frame.arrays]; exact context.tableBinding
  · exact (frame.locals "hn".toList (by decide) (by decide)).trans context.hnCell
  · rw [frame.writable]; exact context.writable

theorem groups (s : State) (base : ArrayPointer) (n hn t m : Nat)
    (context : Context s base n hn) (valid : Valid hn t m)
    (tCell : Cell s "t".toList t) (mCell : Cell s "m".toList m) :
    FftGroupsInvariant143.Fixed (FftOuterStates144.initial s t m) base n hn m t (t/2) (m/2) :=
  ⟨context.width,context.capacity,context.length,valid.half,valid.groups,valid.table,context.wordBound,
    context.binding,context.tableBinding,
    FftOuterStates144.cell s t m _ m (by decide) mCell,
    FftOuterStates144.cell s t m _ t (by decide) tCell,
    FftOuterStates144.ht s t m,FftOuterStates144.hm s t m,
    FftOuterStates144.cell s t m _ hn (by decide) context.hnCell,context.writable,context.pinned⟩

end FT1536.Source3.FftOuterInvariant144
