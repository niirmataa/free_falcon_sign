import Source3.BezoutCopySource217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutCopyFrame217
open C99MemoryReference (Memory ArrayPointer Load32 Allocated)
open KeygenSmallOutput (element)

theorem outside (before : Memory) (dst src q : ArrayPointer) (count : Nat) (w : BitVec 32)
    (apart : q.block≠dst.block ∨ q.offset+4≤dst.offset ∨ dst.offset+count≤q.offset)
    (read : Load32 before q w) : Load32 (MemmoveWord177.snapshot before dst src count) q w := by
  apply Gate00Memory.load32_transport before (MemmoveWord177.snapshot before dst src count) q w read rfl
  intro i
  have absent : ¬(q.block=dst.block ∧ dst.offset≤q.offset+i.val ∧ q.offset+i.val<dst.offset+count) := by
    have h:=i.isLt
    omega
  simp only [MemmoveWord177.snapshot,absent,ite_false]

theorem copied (before : Memory) (dst src : ArrayPointer) (n j : Nat) (w : BitVec 32)
    (dstRange : dst.offset+4*n≤dst.base+dst.elementBytes*dst.count)
    (srcRange : src.offset+4*n≤src.base+src.elementBytes*src.count)
    (dstObject : dst.base+dst.elementBytes*dst.count≤before.size dst.block)
    (srcObject : src.base+src.elementBytes*src.count≤before.size src.block)
    (dstSize : before.size dst.block<2^64) (srcSize : before.size src.block<2^64)
    (writable : before.writable dst.block=true) (dstWidth : dst.elementBytes=4) (srcWidth : src.elementBytes=4)
    (words : ∀ k<n, ∃ z, Load32 before (element src k) z) (inside : j<n)
    (allocated : Allocated (MemmoveWord177.snapshot before dst src (4*n)) (element dst j))
    (read : Load32 before (element src j) w) :
    Load32 (MemmoveWord177.snapshot before dst src (4*n)) (element dst j) w := by
  have move := MemmoveWord177.source before dst src (4*n) dstRange srcRange dstObject srcObject dstSize srcSize writable
    (MemmoveWord177.initialized_bytes before src n srcWidth words)
  exact MemmoveWord177.load_word _ _ _ _ _ _ _ move inside dstWidth srcWidth allocated read

end FT1536.Source3.BezoutCopyFrame217
