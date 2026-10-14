import Source3.C99FiniteMap114
import Source3.ShakeEncode

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99FiniteMemory114
open C99MemoryReference
open C99FiniteMap114 (lookup insert lookup_insert)

structure Block where
  size : Nat
  writable : Bool
  initial : Option Byte
  cells : C99FiniteMap114.Tree (Option Byte)
  deriving Repr, DecidableEq

structure Heap where
  blocks : C99FiniteMap114.Tree Block
  deriving Repr, DecidableEq

def Block.read (block : Block) (offset : Nat) : Option Byte :=
  if offset < block.size then (lookup block.cells offset).getD block.initial else none

def memory (heap : Heap) : Memory where
  size block := (lookup heap.blocks block).map Block.size |>.getD 0
  writable block := (lookup heap.blocks block).map Block.writable |>.getD false
  bytes block offset := (lookup heap.blocks block).bind (fun data => data.read offset)

def putBlock (heap : Heap) (block : Nat) (data : Block) : Heap :=
  ⟨insert heap.blocks block data⟩

theorem size_putBlock (heap : Heap) (block other : Nat) (data : Block) :
    (memory (putBlock heap block data)).size other = if other=block then data.size else (memory heap).size other := by
  simp only [memory, putBlock, lookup_insert]
  split <;> rfl

theorem writable_putBlock (heap : Heap) (block other : Nat) (data : Block) :
    (memory (putBlock heap block data)).writable other = if other=block then data.writable else (memory heap).writable other := by
  simp only [memory, putBlock, lookup_insert]
  split <;> rfl

theorem bytes_putBlock (heap : Heap) (block other offset : Nat) (data : Block) :
    (memory (putBlock heap block data)).bytes other offset = if other=block then data.read offset else (memory heap).bytes other offset := by
  simp only [memory, putBlock, lookup_insert]
  split <;> rfl

def Block.put (block : Block) (offset : Nat) (value : Byte) : Block :=
  {block with cells := insert block.cells offset (some value)}

theorem read_put (block : Block) (offset other : Nat) (value : Byte) :
    (block.put offset value).read other =
      if other=offset ∧ other<block.size then some value else block.read other := by
  by_cases same : other=offset
  · subst other
    by_cases inside : offset<block.size
    all_goals simp [Block.put, Block.read, lookup_insert, inside]
  · by_cases inside : other<block.size
    all_goals simp [Block.put, Block.read, lookup_insert, same, inside]

def putByte (heap : Heap) (block offset : Nat) (value : Byte) : Heap :=
  match lookup heap.blocks block with
  | none => heap
  | some data => putBlock heap block (data.put offset value)

theorem byte_metadata (heap : Heap) (block offset : Nat) (value : Byte) :
    (memory (putByte heap block offset value)).size = (memory heap).size ∧
    (memory (putByte heap block offset value)).writable = (memory heap).writable := by
  cases found : lookup heap.blocks block with
  | none => simp only [putByte, found, and_self]
  | some data =>
      constructor
      · funext other
        rw [putByte, found, size_putBlock]
        by_cases same : other=block
        · subst other
          simp [Block.put, memory, found]
        · simp [same]
      · funext other
        rw [putByte, found, writable_putBlock]
        by_cases same : other=block
        · subst other
          simp [Block.put, memory, found]
        · simp [same]

theorem byte_effect (heap : Heap) (block offset : Nat) (value : Byte)
    (data : Block) (found : lookup heap.blocks block = some data) (inside : offset<data.size)
    (other position : Nat) :
    (memory (putByte heap block offset value)).bytes other position =
      if other=block ∧ position=offset then some value else (memory heap).bytes other position := by
  rw [putByte, found, bytes_putBlock]
  by_cases same : other=block
  · subst other
    simp only [ite_true]
    rw [read_put]
    by_cases point : position=offset
    · subst position
      simp [inside]
    · simp [point, memory, found]
  · simp [same]

/-- An executable byte update satisfies the original source Store8 relation
    under its actual allocation/width/write guards, without a postcondition
    field or a native-execution premise. -/
theorem store8 (heap : Heap) (p : ArrayPointer) (value : Byte)
    (allocated : Allocated (memory heap) p) (width : p.elementBytes=1)
    (writable : (memory heap).writable p.block=true) :
    ShakeEncode.Store8 (memory heap) p value (memory (putByte heap p.block p.offset value)) := by
  cases found : lookup heap.blocks p.block with
  | none => simp [memory, found] at writable
  | some data =>
      have size : (memory heap).size p.block=data.size := by simp [memory, found]
      have inside : p.offset<data.size := by
        obtain ⟨_,_,index,extent,_⟩ := allocated
        rw [width, size] at extent
        simp only [ArrayPointer.offset, width]
        omega
      have metadata := byte_metadata heap p.block p.offset value
      refine ⟨allocated,width,writable,metadata.1,metadata.2,?_,?_⟩
      · simpa using byte_effect heap p.block p.offset value data found inside p.block p.offset
      · intro block offset outside
        rw [byte_effect heap p.block p.offset value data found inside block offset]
        have different : ¬(block=p.block ∧ offset=p.offset) := by omega
        simp [different]

end FT1536.Source3.C99FiniteMemory114
