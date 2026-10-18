import Source3.PublicReverseGroupBody173

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicReverseGroupInvariant173
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open PublicGenerateTable159 (Written)

structure Fixed (s : State) (a gm : ArrayPointer) (ht m : Nat) : Prop where
  total : m*(2*ht)=1536
  groupsBound : m ≤ 512
  capacity : a.index+1536 ≤ a.count
  tableCapacity : gm.index+1024 ≤ gm.count
  binding : s.arrays "a".toList=some a
  tableBinding : s.arrays "igm_square".toList=some gm
  half : USlot s "ht" ht
  stride : USlot s "t" (2*ht)
  groups : USlot s "m" m
  vCell : ∃ old, s.locals "v".toList=some (.uint64,old)
  tableWritten : ∀ j, j < 1024 → Written s.heap (element gm j)
  separate : gm.block≠a.block
  width : a.elementBytes=2
  writable : s.heap.writable a.block=true
  allocated : ∀ j, j < 1536 → Allocated s.heap (element a j)
  written : ∀ j, j < 1536 → Written s.heap (element a j)

theorem domain (s : State) (a gm : ArrayPointer) (ht m u : Nat)
    (fixed : Fixed s a gm ht m) (inside : u < m) :
    u*(2*ht)+ht+ht ≤ 1536 := by
  have bounded := Nat.mul_le_mul_right (2*ht) (show u+1 ≤ m by omega)
  rw [fixed.total,Nat.add_mul,Nat.one_mul] at bounded
  omega

theorem entry (s : State) (a gm : ArrayPointer) (ht m u : Nat)
    (fixed : Fixed s a gm ht m) (inside : u < m)
    (counter : USlot s "u1" u) (offset : USlot s "v1" (u*(2*ht))) :
    PublicReverseGroupHead173.Entry s a gm ht m u (u*(2*ht)) := by
  have groupsBound := fixed.groupsBound
  exact ⟨by omega,domain s a gm ht m u fixed inside,fixed.capacity,
    fixed.tableCapacity,fixed.binding,fixed.tableBinding,fixed.half,
    fixed.groups,counter,offset,fixed.vCell,fixed.tableWritten (m+u) (by omega),
    fixed.width,fixed.writable,fixed.allocated,fixed.written⟩

theorem fixed_after (s after : State) (a gm : ArrayPointer) (ht m stop : Nat)
    (fixed : Fixed s a gm ht m) (result : PublicGroupBody162.Result s after a stop) :
    Fixed after a gm ht m := by
  refine ⟨fixed.total,fixed.groupsBound,fixed.capacity,fixed.tableCapacity,?_,?_,?_,?_,?_,?_,?_,
    fixed.separate,fixed.width,?_,?_,?_⟩
  · rw [result.arrays]; exact fixed.binding
  · rw [result.arrays]; exact fixed.tableBinding
  · exact (result.locals _ (by decide)).trans fixed.half
  · exact (result.locals _ (by decide)).trans fixed.stride
  · exact (result.locals _ (by decide)).trans fixed.groups
  · exact ⟨some (KeygenNttLoopSupport.u64 stop),result.counter⟩
  · intro j hj
    obtain ⟨w,read⟩ := fixed.tableWritten j hj
    exact ⟨w,C99NarrowReads.load16_transport s.heap after.heap (element gm j) w read result.size
      (fun byte => result.outside gm.block fixed.separate ((element gm j).offset+byte.val))⟩
  · rw [result.writable]; exact fixed.writable
  · intro j hj
    simpa only [Allocated,result.size] using fixed.allocated j hj
  · intro j hj
    exact result.written j (fixed.written j hj)

end FT1536.Source3.PublicReverseGroupInvariant173
