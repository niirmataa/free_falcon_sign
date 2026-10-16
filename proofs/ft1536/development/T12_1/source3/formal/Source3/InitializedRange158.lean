import Source3.C99FiniteMemory114
import Source3.Word16Memory158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.InitializedRange158
open C99FiniteMemory114 (Block Heap memory)
open C99MemoryReference

def check (data : Block) (count : Nat) : Bool := (List.range count).all (fun offset => (data.read offset).isSome)
def byte (data : Block) (offset : Nat) : Byte := (data.read offset).getD 0
def word (data : Block) (offset : Nat) : BitVec 16 := C99NarrowReads.le16 (fun i => byte data (offset+i.val))

theorem initialized (data : Block) (count offset : Nat) (checked : check data count=true) (inside : offset<count) :
    data.read offset=some (byte data offset) := by
  have present := List.all_eq_true.mp checked offset (List.mem_range.mpr inside)
  obtain ⟨value,found⟩ := Option.isSome_iff_exists.mp present
  simp only [byte,found,Option.getD_some]

theorem load (heap : Heap) (data : Block) (p : ArrayPointer) (count : Nat)
    (found : C99FiniteMap114.lookup heap.blocks p.block=some data) (checked : check data count=true)
    (allocated : Allocated (memory heap) p) (width : p.elementBytes=2)
    (range : ∀ i : Fin 2, p.offset+i.val<count) :
    C99NarrowReads.Load16 (memory heap) p (word data p.offset) := by
  apply C99NarrowReads.Load16.load _ _ (fun i => byte data (p.offset+i.val)) allocated width
  intro i
  change (C99FiniteMap114.lookup heap.blocks p.block).bind (fun block => block.read (p.offset+i.val))=_
  rw [found]
  exact initialized data count _ checked (range i)

end FT1536.Source3.InitializedRange158
