import Source3.SelectedBezoutOutcome217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Nonoverlapping word memcpy from the existing byte-level snapshot model. -/
namespace FT1536.Source3.BezoutMemcpy217
open C99MemoryReference (Memory ArrayPointer Memcpy Load32 Allocated)
open KeygenSearchMemory (Memmove)
open KeygenSmallOutput (element)

theorem memcpy_of_move (before after : Memory) (dst src : ArrayPointer) (count : Nat)
    (move : Memmove before dst src count after)
    (apart : dst.block≠src.block ∨ dst.offset+count≤src.offset ∨ src.offset+count≤dst.offset) :
    Memcpy before dst src count after := by
  obtain ⟨dr,sr,do_,so_,ds,ss,writable,initialized,size,write,copied,frame⟩:=move
  exact ⟨by omega,by omega,ds,ss,writable,apart,initialized,size,write,copied,frame⟩

theorem source (before : Memory) (dst src : ArrayPointer) (n : Nat)
    (dstRange : dst.offset+4*n≤dst.base+dst.elementBytes*dst.count)
    (srcRange : src.offset+4*n≤src.base+src.elementBytes*src.count)
    (dstObject : dst.base+dst.elementBytes*dst.count≤before.size dst.block)
    (srcObject : src.base+src.elementBytes*src.count≤before.size src.block)
    (dstSize : before.size dst.block<2^64) (srcSize : before.size src.block<2^64)
    (writable : before.writable dst.block=true) (srcWidth : src.elementBytes=4)
    (words : ∀ j<n, ∃ w, Load32 before (element src j) w)
    (apart : dst.block≠src.block ∨ dst.offset+4*n≤src.offset ∨ src.offset+4*n≤dst.offset) :
    Memcpy before dst src (4*n) (MemmoveWord177.snapshot before dst src (4*n)) :=
  memcpy_of_move _ _ _ _ _
    (MemmoveWord177.source before dst src (4*n) dstRange srcRange dstObject srcObject dstSize srcSize writable
      (MemmoveWord177.initialized_bytes before src n srcWidth words)) apart

theorem copied_word (before : Memory) (dst src : ArrayPointer) (n j : Nat) (w : BitVec 32)
    (copy : Memmove before dst src (4*n) (MemmoveWord177.snapshot before dst src (4*n)))
    (inside : j<n) (dstWidth : dst.elementBytes=4) (srcWidth : src.elementBytes=4)
    (allocated : Allocated (MemmoveWord177.snapshot before dst src (4*n)) (element dst j))
    (read : Load32 before (element src j) w) :
    Load32 (MemmoveWord177.snapshot before dst src (4*n)) (element dst j) w :=
  MemmoveWord177.load_word _ _ _ _ _ _ _ copy inside dstWidth srcWidth allocated read

end FT1536.Source3.BezoutMemcpy217
