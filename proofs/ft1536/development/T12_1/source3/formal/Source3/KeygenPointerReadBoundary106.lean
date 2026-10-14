import Source3.KeygenPublicExecution106

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPointerReadBoundary106
open C99MemoryReference
open KeygenMakeInvocation

/- A local interface counterexample only: legality on a declared finite
   set does not constrain a read descriptor outside that set. This is not
   an execution or counterexample of actual KeyGen or of lawful C pointers. -/
def heap : Memory where
  bytes block offset := if block < 3 ∧ offset < 8192 then some 0 else none
  size block := if block < 3 then 8192 else 0
  writable block := decide (block < 3)

def first : ArrayPointer := ⟨0,0,3072,2,0⟩
def second : ArrayPointer := ⟨1,0,3072,2,0⟩
def cell : ArrayPointer := ⟨2,0,1,8,0⟩
def bases (block : Nat) : Nat := if block = 2 then 16384 else 0

theorem finite_heap (block : Nat) (outside : 3 ≤ block) : heap.size block = 0 := by
  simp only [heap, ite_eq_right (show ¬ block < 3 by omega)]

theorem declared_legal : VirtualLegal [0,2] bases := by
  constructor
  · intro block member
    simp only [List.mem_cons, List.not_mem_nil, or_false] at member
    rcases member with rfl | rfl <;> decide
  · intro a b ha hb equal
    simp only [List.mem_cons, List.not_mem_nil, or_false] at ha hb
    rcases ha with rfl | rfl <;> rcases hb with rfl | rfl
    all_goals norm_num [bases] at *

theorem cell_read : Load64 heap cell 0 := by
  change Load64 heap cell (le64 (fun _ => 0))
  apply Load64.load heap cell (fun _ => 0)
  · norm_num [Allocated, heap, cell]
  · rfl
  · intro i
    have bound : i.val < 8192 := by have small := i.isLt; omega
    simp [heap, cell, ArrayPointer.offset, bound]

theorem first_read : ReadPointer bases heap cell first :=
  ⟨⟨rfl,rfl,rfl,rfl⟩, cell_read⟩

theorem second_read : ReadPointer bases heap cell second :=
  ⟨⟨rfl,rfl,rfl,rfl⟩, cell_read⟩

theorem incomplete_live_set : VirtualLegal [0,2] bases ∧
    ReadPointer bases heap cell first ∧ ReadPointer bases heap cell second ∧
    first ≠ second ∧ Allocated heap first ∧ Allocated heap second ∧ second.block ∉ [0,2] :=
  ⟨declared_legal, first_read, second_read, by decide,
    by norm_num [Allocated, heap, first], by norm_num [Allocated, heap, second], by decide⟩

end FT1536.Source3.KeygenPointerReadBoundary106
