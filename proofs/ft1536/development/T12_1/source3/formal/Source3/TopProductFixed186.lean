import Source3.TopProductMemory186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopProductFixed186
open C99ArrayReference (State)
open C99MemoryReference (Memory Allocated)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (fd gd fs gs)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)

structure Fixed (s : State) (p p0i r3 : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  rCell : Slot s "R3" r3
  outCell : s.locals "out_ntt".toList=some (.int32,some (.int32 1))
  nCell : USlot s "n" 1536
  fdBinding : s.arrays "fd".toList=some fd
  gdBinding : s.arrays "gd".toList=some gd
  fsBinding : s.arrays "fs".toList=some fs
  gsBinding : s.arrays "gs".toList=some gs
  fdAllocated : ∀ j<512, Allocated s.heap (element fd j)
  gdAllocated : ∀ j<512, Allocated s.heap (element gd j)
  writable : s.heap.writable 31=true
  fReads : TopProductMemory186.Reads s.heap fs
  gReads : TopProductMemory186.Reads s.heap gs

theorem heap (s : State) (after : Memory) (p p0i r3 : BitVec 32) (fixed : Fixed s p p0i r3)
    (frame : TopProductMemory186.Frame s.heap after) : Fixed {s with heap:=after} p p0i r3 := by
  refine ⟨fixed.pCell,fixed.iCell,fixed.rCell,fixed.outCell,fixed.nCell,fixed.fdBinding,fixed.gdBinding,
    fixed.fsBinding,fixed.gsBinding,?_,?_,?_,?_,?_⟩
  · intro j hj; simpa only [Allocated,frame.size] using fixed.fdAllocated j hj
  · intro j hj; simpa only [Allocated,frame.size] using fixed.gdAllocated j hj
  · rw [frame.writable]; exact fixed.writable
  · exact TopProductMemory186.f_transport s.heap after frame fixed.fReads
  · exact TopProductMemory186.g_transport s.heap after frame fixed.gReads

end FT1536.Source3.TopProductFixed186
