import Source3.KeygenPublicEncodeCertified077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeStore077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077

def overwrite (heap : Memory) (ptr : ArrayPointer) (byte : BitVec 8) : Memory :=
  ⟨fun block offset => if block=ptr.block ∧ offset=ptr.offset then some byte else heap.bytes block offset,
    heap.size,heap.writable⟩

theorem exists_store (heap : Memory) (ptr : ArrayPointer) (byte : BitVec 8)
    (allocated : Allocated heap ptr) (width : ptr.elementBytes=1) (writable : heap.writable ptr.block=true) :
    StoreByte heap ptr byte (overwrite heap ptr byte) := by
  refine ⟨allocated,width,writable,rfl,rfl,?_,?_⟩
  · simp only [overwrite,and_self,ite_true]
  · intro block offset outside
    have away : ¬(block=ptr.block ∧ offset=ptr.offset) := by omega
    simp only [overwrite,away,ite_false]

theorem unique (heap a b : Memory) (ptr : ArrayPointer) (byte : BitVec 8)
    (first : StoreByte heap ptr byte a) (second : StoreByte heap ptr byte b) : a=b := by
  have bytes : a.bytes=b.bytes := by
    funext block offset
    by_cases location : block=ptr.block ∧ offset=ptr.offset
    · obtain ⟨rfl,rfl⟩ := location
      exact first.2.2.2.2.2.1.trans second.2.2.2.2.2.1.symm
    · have away : block≠ptr.block ∨ offset≠ptr.offset := by omega
      exact (first.2.2.2.2.2.2 _ _ away).trans (second.2.2.2.2.2.2 _ _ away).symm
  have size := first.2.2.2.1.trans second.2.2.2.1.symm
  have writable := first.2.2.2.2.1.trans second.2.2.2.2.1.symm
  cases a; cases b
  cases bytes; cases size; cases writable
  rfl

theorem store (args : Args) (s : State) (index rhs : Expr) (middle last : Locals)
    (ptr : ArrayPointer) (offset value : IV)
    (buffer : s.buf=some (some ptr))
    (indexValue : Computes args s.heap s.buf index s.locals offset middle) (nonnegative : 0≤offset.integer)
    (rhsValue : Computes args s.heap s.buf rhs middle value last)
    (allocated : Allocated s.heap (byteOff ptr offset.integer.toNat))
    (writable : s.heap.writable ptr.block=true) :
    Checked args (.write (.index (.variable "buf".toList) index) .set rhs) s
      ⟨overwrite s.heap (byteOff ptr offset.integer.toNat) (BitVec.ofInt 8 value.integer),last,s.buf⟩ .normal := by
  let heap := overwrite s.heap (byteOff ptr offset.integer.toNat) (BitVec.ofInt 8 value.integer)
  have write : StoreByte s.heap (byteOff ptr offset.integer.toNat) (BitVec.ofInt 8 value.integer) heap :=
    exists_store _ _ _ allocated rfl writable
  refine ⟨.store args s index rhs middle last ptr offset value heap buffer
    (computes_exists _ _ _ _ _ _ _ indexValue) nonnegative (computes_exists _ _ _ _ _ _ _ rhsValue) write,?_⟩
  intro after flow source
  cases source with
  | store s index rhs actualMiddle actualLast actualPtr actualOffset actualValue actualHeap actualBuffer actualIndex actualNonnegative actualRhs actualWrite =>
    have samePtr := Option.some.inj (Option.some.inj (actualBuffer.symm.trans buffer))
    subst actualPtr
    obtain ⟨sameOffset,sameMiddle⟩ := computes_eval _ _ _ _ _ _ _ _ _ indexValue actualIndex
    cases sameOffset; subst actualMiddle
    obtain ⟨sameValue,sameLast⟩ := computes_eval _ _ _ _ _ _ _ _ _ rhsValue actualRhs
    cases sameValue; subst actualLast
    have sameHeap := unique s.heap actualHeap heap _ _ actualWrite write
    subst actualHeap
    exact ⟨rfl,rfl⟩

end FT1536.Source3.KeygenPublicEncodeStore077
