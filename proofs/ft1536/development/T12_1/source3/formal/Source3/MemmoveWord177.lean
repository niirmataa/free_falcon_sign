import Source3.SelectedMakeFgTopEntry176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MemmoveWord177
open C99MemoryReference
open KeygenSearchMemory (Memmove)

def snapshot (before : Memory) (dst src : ArrayPointer) (count : Nat) : Memory :=
  {before with bytes := fun block offset =>
    if block=dst.block ∧ dst.offset≤offset ∧ offset<dst.offset+count then
      before.bytes src.block (src.offset+(offset-dst.offset))
    else before.bytes block offset}

theorem source (before : Memory) (dst src : ArrayPointer) (count : Nat)
    (dstRange : dst.offset+count≤dst.base+dst.elementBytes*dst.count)
    (srcRange : src.offset+count≤src.base+src.elementBytes*src.count)
    (dstObject : dst.base+dst.elementBytes*dst.count≤before.size dst.block)
    (srcObject : src.base+src.elementBytes*src.count≤before.size src.block)
    (dstSize : before.size dst.block<2^64) (srcSize : before.size src.block<2^64)
    (writable : before.writable dst.block=true)
    (initialized : ∀ i<count, (before.bytes src.block (src.offset+i)).isSome) :
    Memmove before dst src count (snapshot before dst src count) := by
  refine ⟨dstRange,srcRange,dstObject,srcObject,dstSize,srcSize,writable,initialized,rfl,rfl,?_,?_⟩
  · intro i hi
    have inside : dst.block=dst.block ∧ dst.offset≤dst.offset+i ∧ dst.offset+i<dst.offset+count := by omega
    simp only [snapshot]
    split
    · congr 1
      omega
    · rename_i impossible
      exact (impossible ⟨trivial,inside.2⟩).elim
  · intro block offset outside
    have notInside : ¬(block=dst.block ∧ dst.offset≤offset ∧ offset<dst.offset+count) := by omega
    simp only [snapshot,notInside,ite_false]

theorem initialized_bytes (before : Memory) (src : ArrayPointer) (n : Nat)
    (width : src.elementBytes=4)
    (words : ∀ j<n, ∃ w, Load32 before (KeygenSmallOutput.element src j) w) :
    ∀ i<4*n, (before.bytes src.block (src.offset+i)).isSome := by
  intro i inside
  have jBound : i/4<n := by omega
  obtain ⟨w,read⟩ := words (i/4) jBound
  cases read with
  | load bytes _ _ initialized =>
    have h := initialized ⟨i%4,by omega⟩
    have offset : (KeygenSmallOutput.element src (i/4)).offset+i%4=src.offset+i := by
      simp only [KeygenSmallOutput.element,ArrayPointer.offset,width]
      omega
    change before.bytes src.block ((KeygenSmallOutput.element src (i/4)).offset+i%4)=some _ at h
    rw [offset] at h
    rw [h]
    rfl

theorem load_word (before after : Memory) (dst src : ArrayPointer) (n j : Nat) (w : BitVec 32)
    (copy : Memmove before dst src (4*n) after) (inside : j<n)
    (dstWidth : dst.elementBytes=4) (srcWidth : src.elementBytes=4)
    (allocated : Allocated after (KeygenSmallOutput.element dst j))
    (read : Load32 before (KeygenSmallOutput.element src j) w) :
    Load32 after (KeygenSmallOutput.element dst j) w := by
  cases read with
  | load bytes _ _ initialized =>
    apply Load32.load after (KeygenSmallOutput.element dst j) bytes allocated dstWidth
    intro b
    have bound : 4*j+b.val<4*n := by omega
    have copied := copy.2.2.2.2.2.2.2.2.2.2.1 (4*j+b.val) bound
    have dstOffset : (KeygenSmallOutput.element dst j).offset+b.val=dst.offset+(4*j+b.val) := by
      simp only [KeygenSmallOutput.element,ArrayPointer.offset,dstWidth]
      omega
    have srcOffset : (KeygenSmallOutput.element src j).offset+b.val=src.offset+(4*j+b.val) := by
      simp only [KeygenSmallOutput.element,ArrayPointer.offset,srcWidth]
      omega
    change after.bytes dst.block ((KeygenSmallOutput.element dst j).offset+b.val)=some (bytes b)
    rw [dstOffset,copied,←srcOffset]
    exact initialized b

end FT1536.Source3.MemmoveWord177
