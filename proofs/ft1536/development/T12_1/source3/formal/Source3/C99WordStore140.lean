import Source3.C99HeapDeterminism089
import Source3.C99FiniteWrite114

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99WordStore140
open C99MemoryReference

/-- Exact byte update used by the parametric source rule, with unchanged
    object metadata. Legality is proved separately before each source store. -/
def write (before : Memory) (pointer : ArrayPointer) (word : BitVec 64) : Memory where
  bytes := fun block offset =>
    if inside : block=pointer.block ∧ pointer.offset≤offset ∧ offset<pointer.offset+8 then
      some (byte64 word ⟨offset-pointer.offset,by omega⟩)
    else before.bytes block offset
  size := before.size
  writable := before.writable

theorem source (before : Memory) (pointer : ArrayPointer) (word : BitVec 64)
    (allocated : Allocated before pointer) (width : pointer.elementBytes=8)
    (writable : before.writable pointer.block=true) :
    Store64 before pointer word (write before pointer word) := by
  refine ⟨allocated,width,writable,rfl,rfl,?_,?_⟩
  · intro i
    have inside : pointer.block=pointer.block ∧ pointer.offset≤pointer.offset+i.val ∧
        pointer.offset+i.val<pointer.offset+8 := by have bound := i.isLt; omega
    dsimp only [write]
    rw [dite_eq_left inside]
    congr 2
    apply Fin.ext
    change pointer.offset+i.val-pointer.offset=i.val
    omega
  · intro block offset outside
    have absent : ¬(block=pointer.block ∧ pointer.offset≤offset ∧ offset<pointer.offset+8) := by omega
    simp only [write,dite_eq_right absent]

theorem finite (before : C99FiniteMemory114.Heap) (pointer : ArrayPointer) (word : BitVec 64)
    (allocated : Allocated (C99FiniteMemory114.memory before) pointer) (width : pointer.elementBytes=8)
    (writable : (C99FiniteMemory114.memory before).writable pointer.block=true) :
    C99FiniteMemory114.memory (C99FiniteWrite114.write64 before pointer word)=
      write (C99FiniteMemory114.memory before) pointer word :=
  C99HeapDeterminism089.store64 _ pointer word _ _
    (C99FiniteWrite114.write64_sound before pointer word allocated width writable)
    (source _ pointer word allocated width writable)

end FT1536.Source3.C99WordStore140
