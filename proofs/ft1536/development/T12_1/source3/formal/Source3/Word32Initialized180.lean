import Source3.SelectedGeneratorRowFrame179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Word32Initialized180
open C99MemoryReference
open C99InitializationTrace (Initialized Preserves)

def At (heap : Memory) (pointer : ArrayPointer) : Prop := Initialized heap pointer.block pointer.offset 4

theorem write_preserves (heap : Memory) (pointer : ArrayPointer) (word : BitVec 32) :
    Preserves heap (Word32Memory176.write heap pointer word) := by
  refine ⟨rfl,rfl,?_⟩
  intro block offset old
  dsimp only [Word32Memory176.write]
  split
  · rfl
  · exact old

theorem write_initializes (heap : Memory) (pointer : ArrayPointer) (word : BitVec 32) :
    At (Word32Memory176.write heap pointer word) pointer := by
  intro i bound
  have inside : pointer.block=pointer.block ∧ pointer.offset≤pointer.offset+i ∧ pointer.offset+i<pointer.offset+4 := by omega
  dsimp only [Word32Memory176.write]
  rw [dite_eq_left inside]
  rfl

theorem transported (before after : Memory) (pointer : ArrayPointer)
    (frame : Preserves before after) (initialized : At before pointer) : At after pointer :=
  C99InitializationTrace.region_preserved before after frame pointer.block pointer.offset 4 initialized

theorem load (heap : Memory) (pointer : ArrayPointer) (allocated : Allocated heap pointer)
    (width : pointer.elementBytes=4) (initialized : At heap pointer) : ∃ word, Load32 heap pointer word := by
  let bytes : Fin 4 → Byte := fun i => (heap.bytes pointer.block (pointer.offset+i.val)).getD 0
  have values (i : Fin 4) : heap.bytes pointer.block (pointer.offset+i.val)=some (bytes i) := by
    have present := initialized i.val i.isLt
    cases value : heap.bytes pointer.block (pointer.offset+i.val) with
    | none => rw [value] at present; cases present
    | some byte => simp only [bytes,value,Option.getD_some]
  exact ⟨le32 bytes,.load heap pointer bytes allocated width values⟩

end FT1536.Source3.Word32Initialized180
