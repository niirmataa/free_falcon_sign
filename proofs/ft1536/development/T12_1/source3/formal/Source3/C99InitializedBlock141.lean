import Source3.C99FiniteMemory114
import Source3.C99WordBuffer140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99InitializedBlock141
open C99MemoryReference
open C99FiniteMap114 (lookup)
open C99FiniteMemory114 (Block Heap memory)

def entryValid : Option (Option Byte) → Bool
  | some none => false | _ => true

def valid : C99FiniteMap114.Tree (Option Byte) → Bool
  | .empty => true
  | .node entry zero one => (entryValid entry && valid zero) && valid one

theorem get_initialized (tree : C99FiniteMap114.Tree (Option Byte)) (checked : valid tree=true) (key : List Bool) :
    C99FiniteMap114.get tree key≠some none := by
  induction tree generalizing key with
  | empty => cases key <;> simp [C99FiniteMap114.get]
  | node entry zero one left right =>
    obtain ⟨head,oneValid⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨entryChecked,zeroValid⟩ := Bool.and_eq_true_iff.mp head
    cases key with
    | nil =>
      change entry≠some none
      intro same
      subst entry
      cases entryChecked
    | cons bit rest =>
      cases bit
      · exact left zeroValid rest
      · exact right oneValid rest

def byte (data : Block) (offset : Nat) : Byte := (data.read offset).getD 0

theorem read_initialized (data : Block) (defaultByte : Byte) (initial : data.initial=some defaultByte)
    (checked : valid data.cells=true) (offset : Nat) (inside : offset<data.size) :
    data.read offset=some (byte data offset) := by
  have found := get_initialized data.cells checked (C99FiniteMap114.digits offset)
  change lookup data.cells offset≠some none at found
  unfold byte Block.read
  rw [ite_eq_left inside]
  cases read : lookup data.cells offset with
  | none => simp [initial]
  | some cell =>
    cases cell with
    | none => exact (found read).elim
    | some value => rfl

def word (data : Block) (offset : Nat) : BitVec 64 := le64 (fun i => byte data (offset+i.val))

theorem load (heap : Heap) (data : Block) (pointer : ArrayPointer) (defaultByte : Byte)
    (found : lookup heap.blocks pointer.block=some data) (initial : data.initial=some defaultByte)
    (checked : valid data.cells=true) (allocated : Allocated (memory heap) pointer) (width : pointer.elementBytes=8) :
    Load64 (memory heap) pointer (word data pointer.offset) := by
  apply Load64.load _ _ (fun i => byte data (pointer.offset+i.val)) allocated width
  intro i
  have size : (memory heap).size pointer.block=data.size := by simp [memory,found]
  have index := allocated.2.2.1
  have extent := allocated.2.2.2.1
  rw [width,size] at extent
  have inside : pointer.offset+i.val<data.size := by
    have bound := i.isLt
    unfold ArrayPointer.offset
    rw [width]
    omega
  change (lookup heap.blocks pointer.block).bind (fun block => block.read (pointer.offset+i.val))=_
  rw [found]
  exact read_initialized data defaultByte initial checked _ inside

end FT1536.Source3.C99InitializedBlock141
