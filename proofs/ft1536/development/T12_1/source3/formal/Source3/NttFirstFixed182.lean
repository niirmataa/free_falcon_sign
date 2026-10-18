import Source3.NttFirstBodyFrame182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttFirstFixed182
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenSmallOutput (element)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)

structure Fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  wCell : Slot s "w" w
  nCell : USlot s "n" 1536
  hnCell : USlot s "hn" 768
  stride : USlot s "stride" 1
  aBinding : s.arrays "a".toList=some a
  gmBinding : s.arrays "gm".toList=some gm
  width : a.elementBytes=4
  capacity : a.index+1536≤a.count
  allocated : ∀ j<1536, Allocated s.heap (element a j)
  writable : s.heap.writable a.block=true
  initialized : ∀ j<1536, Word32Initialized180.At s.heap (element a j)

theorem body (s : State) (a gm r1 r2 : ArrayPointer) (p p0i w a0 a1 : BitVec 32)
    (fixed : Fixed s a gm p p0i w) : Fixed (NttFirstBody182.after s r1 r2 a0 a1 w p p0i) a gm p p0i w := by
  have locals := NttFirstBodyFrame182.locals s r1 r2 a0 a1 w p p0i
  have arrays := NttFirstBodyFrame182.arrays s r1 r2 a0 a1 w p p0i
  have memory := NttFirstBodyFrame182.initialized s r1 r2 a0 a1 w p p0i
  refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,fixed.width,fixed.capacity,?_,?_,?_⟩
  · exact (congrFun locals _).trans fixed.pCell
  · exact (congrFun locals _).trans fixed.iCell
  · exact (congrFun locals _).trans fixed.wCell
  · exact (congrFun locals _).trans fixed.nCell
  · exact (congrFun locals _).trans fixed.hnCell
  · exact (congrFun locals _).trans fixed.stride
  · exact (congrFun arrays _).trans fixed.aBinding
  · exact (congrFun arrays _).trans fixed.gmBinding
  · intro j hj; simpa only [Allocated,memory.size] using fixed.allocated j hj
  · rw [memory.writable]; exact fixed.writable
  · intro j hj; exact Word32Initialized180.transported _ _ _ memory (fixed.initialized j hj)

end FT1536.Source3.NttFirstFixed182
