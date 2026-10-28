import Source3.SelectedBezoutInitStore217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact zero-byte snapshot and read frame for source memset. -/
namespace FT1536.Source3.BezoutMemzero217
open C99MemoryReference (Memory ArrayPointer Load32 Allocated)

def zero (before : Memory) (dst : ArrayPointer) (count : Nat) : Memory :=
  {before with bytes:=fun block offset =>
    if block=dst.block ∧ dst.offset≤offset ∧ offset<dst.offset+count then some 0 else before.bytes block offset}

theorem source (before : Memory) (dst : ArrayPointer) (count : Nat)
    (range : dst.offset+count≤before.size dst.block) (size : before.size dst.block<2^64)
    (writable : before.writable dst.block=true) : KeygenZintCall.Memzero before dst count (zero before dst count) := by
  refine ⟨range,size,writable,rfl,rfl,?_,?_⟩
  · intro i bound
    have inside : dst.block=dst.block ∧ dst.offset≤dst.offset+i ∧ dst.offset+i<dst.offset+count := by omega
    change (if dst.block=dst.block ∧ dst.offset≤dst.offset+i ∧ dst.offset+i<dst.offset+count then some 0 else before.bytes dst.block (dst.offset+i))=some 0
    rw [ite_eq_left inside]
  · intro block offset outside
    have absent : ¬(block=dst.block ∧ dst.offset≤offset ∧ offset<dst.offset+count) := by omega
    simp only [zero,absent,ite_false]

theorem outside (before : Memory) (dst q : ArrayPointer) (count : Nat) (w : BitVec 32)
    (apart : q.block≠dst.block ∨ q.offset+4≤dst.offset ∨ dst.offset+count≤q.offset)
    (read : Load32 before q w) : Load32 (zero before dst count) q w := by
  apply Gate00Memory.load32_transport before (zero before dst count) q w read rfl
  intro i
  have absent : ¬(q.block=dst.block ∧ dst.offset≤q.offset+i.val ∧ q.offset+i.val<dst.offset+count) := by
    have h:=i.isLt; omega
  simp only [zero,absent,ite_false]

theorem zero_word (before : Memory) (dst q : ArrayPointer) (count : Nat)
    (allocated : Allocated (zero before dst count) q) (width : q.elementBytes=4)
    (sameBlock : q.block=dst.block) (inside : dst.offset≤q.offset ∧ q.offset+4≤dst.offset+count) :
    Load32 (zero before dst count) q 0 := by
  have read : Load32 (zero before dst count) q (C99MemoryReference.le32 (fun _ => 0)) := by
    apply Load32.load _ _ (fun _ => 0) allocated width
    intro i
    have included : q.block=dst.block ∧ dst.offset≤q.offset+i.val ∧ q.offset+i.val<dst.offset+count := by
      have h:=i.isLt; omega
    change (if q.block=dst.block ∧ dst.offset≤q.offset+i.val ∧ q.offset+i.val<dst.offset+count then some 0 else before.bytes q.block (q.offset+i.val))=some 0
    rw [ite_eq_left included]
  simpa [C99MemoryReference.le32] using read

end FT1536.Source3.BezoutMemzero217
