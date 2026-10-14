import Source3.C99FiniteCopy114
import Source3.KeygenMakeObjects

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99FiniteAllocation115
open C99MemoryReference
open C99FiniteMemory114
open C99FiniteMap114 (lookup)

theorem lookup_empty (name : Nat) : lookup (.empty : C99FiniteMap114.Tree α) name = none := by
  unfold C99FiniteMap114.lookup
  cases C99FiniteMap114.digits name <;> rfl

theorem memory_ext (first second : Memory)
    (bytes : ∀ block offset, first.bytes block offset = second.bytes block offset)
    (sizes : ∀ block, first.size block = second.size block)
    (permissions : ∀ block, first.writable block = second.writable block) : first=second := by
  have hb : first.bytes=second.bytes := funext (fun block => funext (bytes block))
  have hs : first.size=second.size := funext sizes
  have hw : first.writable=second.writable := funext permissions
  cases first
  cases second
  cases hb
  cases hs
  cases hw
  rfl

def allocate (heap : Heap) (block size : Nat) : Heap :=
  putBlock heap block ⟨size,true,none,.empty⟩

theorem allocate_source (heap : Heap) (block size : Nat) :
    memory (allocate heap block size) = KeygenMakeObjects.allocated (memory heap) block size := by
  apply memory_ext
  · intro other offset
    rw [allocate, bytes_putBlock]
    by_cases same : other=block
    · simp [same, Block.read, lookup_empty, KeygenMakeObjects.allocated]
    · simp [same, KeygenMakeObjects.allocated]
  · intro other
    exact size_putBlock heap block other ⟨size,true,none,.empty⟩
  · intro other
    exact writable_putBlock heap block other ⟨size,true,none,.empty⟩

def fresh (heap : Heap) (block : Nat) : Bool :=
  match lookup heap.blocks block with
  | none => true
  | some data => decide (data.size=0) && !data.writable

theorem fresh_iff (heap : Heap) (block : Nat) :
    fresh heap block = true ↔ KeygenRngSource.Fresh (memory heap) block := by
  cases found : lookup heap.blocks block with
  | none => simp [fresh, found, KeygenRngSource.Fresh, memory]
  | some data =>
      constructor
      · intro accepted
        have facts : data.size=0 ∧ data.writable=false := by simpa [fresh, found] using accepted
        refine ⟨by simp [memory, found, facts.1],by simp [memory, found, facts.2],?_⟩
        intro offset
        simp [memory, found, Block.read, facts.1]
      · intro source
        have size : data.size=0 := by simpa [memory, found] using source.1
        have permission : data.writable=false := by simpa [memory, found] using source.2.1
        simp [fresh, found, size, permission]

def emptyBlock : Block := ⟨0,false,none,.empty⟩

def restore (before after : Heap) (block : Nat) : Heap :=
  putBlock after block ((lookup before.blocks block).getD emptyBlock)

theorem restore_source (before after : Heap) (block : Nat) :
    memory (restore before after block) = KeygenRngSource.disposed (memory before) (memory after) block := by
  apply memory_ext
  · intro other offset
    rw [restore, bytes_putBlock]
    by_cases same : other=block
    · subst other
      cases found : lookup before.blocks block with
      | none => simp [found, emptyBlock, Block.read, KeygenRngSource.disposed, memory]
      | some data => simp [found, KeygenRngSource.disposed, memory]
    · simp [same, KeygenRngSource.disposed]
  · intro other
    rw [restore, size_putBlock]
    by_cases same : other=block
    · subst other
      cases found : lookup before.blocks block <;> simp [found, emptyBlock, KeygenRngSource.disposed, memory]
    · simp [same, KeygenRngSource.disposed]
  · intro other
    rw [restore, writable_putBlock]
    by_cases same : other=block
    · subst other
      cases found : lookup before.blocks block <;> simp [found, emptyBlock, KeygenRngSource.disposed, memory]
    · simp [same, KeygenRngSource.disposed]

end FT1536.Source3.C99FiniteAllocation115
