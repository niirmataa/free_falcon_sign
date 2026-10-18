import Source3.PublicGenerateComplete166
import Source3.PublicForwardBody159
import Source3.PublicFullTail165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicForwardMemory167
open C99ArrayReference (State)
open C99MemoryReference (Memory ArrayPointer Allocated)
open KeygenSmallOutput (element)
open PublicGenerateTable159 (Written Tables)
open KeygenPublicExec (allocated localPointer)
open PublicForwardBody159 (gmPointer igmPointer generateEntry)
open PublicForwardEntry159 (entryT)

structure Data (heap : Memory) (a : ArrayPointer) : Prop where
  writable : heap.writable a.block=true
  written : ∀ j, j < 1536 → Written heap (element a j)

theorem width (heap : Memory) (a : ArrayPointer) (data : Data heap a) : a.elementBytes=2 := by
  obtain ⟨w,read⟩ := data.written 0 (by decide)
  exact (KeygenPublicRangeMemory.load_allocated _ _ _ read).2

theorem capacity (heap : Memory) (a : ArrayPointer) (data : Data heap a) : a.index+1536 ≤ a.count := by
  obtain ⟨w,read⟩ := data.written 1535 (by decide)
  have info := (KeygenPublicRangeMemory.load_allocated _ _ _ read).1
  simp only [Allocated,element] at info
  omega

theorem live (heap : Memory) (a : ArrayPointer) (data : Data heap a) : 0 < heap.size a.block :=
  KeygenPublicForwardMemory.initialized_live heap a data.written

def tableHeap (heap : Memory) (g i : Nat) : Memory := allocated (allocated heap g 2048) i 2048

theorem distinct_tables (heap : Memory) (g i : Nat)
    (fresh : KeygenRngSource.Fresh (allocated heap g 2048) i) : g≠i := by
  intro equal
  have zero := fresh.1
  rw [← equal] at zero
  simp only [allocated,ite_true] at zero
  omega

theorem outside_g (heap : Memory) (a : ArrayPointer) (g : Nat) (data : Data heap a)
    (fresh : KeygenRngSource.Fresh heap g) : a.block≠g := by
  intro equal
  have positive := live heap a data
  rw [equal,fresh.1] at positive
  omega

theorem outside_i (heap : Memory) (a : ArrayPointer) (g i : Nat) (data : Data heap a)
    (freshG : KeygenRngSource.Fresh heap g)
    (freshI : KeygenRngSource.Fresh (allocated heap g 2048) i) : a.block≠i := by
  have same := KeygenPublicForwardMemory.allocated_other heap g 2048 a.block (outside_g heap a g data freshG)
  have positive : 0 < (allocated heap g 2048).size a.block := by rw [same.1]; exact live heap a data
  intro equal
  rw [equal,freshI.1] at positive
  omega

theorem retained (heap : Memory) (a : ArrayPointer) (g i : Nat) (data : Data heap a)
    (freshG : KeygenRngSource.Fresh heap g)
    (freshI : KeygenRngSource.Fresh (allocated heap g 2048) i) : Data (tableHeap heap g i) a := by
  have ag := outside_g heap a g data freshG
  have ai := outside_i heap a g i data freshG freshI
  have block := KeygenPublicForwardMemory.block_trans heap (allocated heap g 2048) (tableHeap heap g i) a.block
    (KeygenPublicForwardMemory.allocated_other heap g 2048 a.block ag)
    (KeygenPublicForwardMemory.allocated_other (allocated heap g 2048) i 2048 a.block ai)
  refine ⟨?_,?_⟩
  · simpa only [tableHeap,allocated,ag,ai,ite_false] using data.writable
  · intro j hj
    obtain ⟨w,read⟩ := data.written j hj
    exact ⟨w,KeygenPublicForwardMemory.load_block heap (tableHeap heap g i) (element a j) w block read⟩

theorem allocated_transport (before after : Memory) (p : ArrayPointer)
    (size : after.size p.block=before.size p.block) (old : Allocated before p) : Allocated after p := by
  simpa only [Allocated,size] using old

theorem local_allocated (heap : Memory) (block j : Nat) (inside : j < 1024) :
    Allocated (allocated heap block 2048) (element (localPointer block 2048) j) := by
  simp [Allocated,allocated,localPointer,element]
  omega

theorem gm_allocated (heap : Memory) (g i j : Nat) (different : g≠i) (inside : j < 1024) :
    Allocated (tableHeap heap g i) (element (gmPointer g) j) :=
  allocated_transport (allocated heap g 2048) (tableHeap heap g i) (element (gmPointer g) j)
    (KeygenPublicForwardMemory.allocated_other (allocated heap g 2048) i 2048 g different).1
    (local_allocated heap g j inside)

theorem igm_allocated (heap : Memory) (g i j : Nat) (inside : j < 1024) :
    Allocated (tableHeap heap g i) (element (igmPointer i) j) :=
  local_allocated (allocated heap g 2048) i j inside

theorem generate_tables (s : State) (a : ArrayPointer) (g i : Nat) (different : g≠i) :
    Tables (generateEntry (entryT s a) g i) (gmPointer g) (igmPointer i) := by
  refine ⟨rfl,rfl,rfl,rfl,(by change 0+1024 ≤ 2048; decide),(by change 0+1024 ≤ 2048; decide),?_,?_,?_,?_,different⟩
  · intro j hj
    exact gm_allocated s.heap g i j different hj
  · intro j hj
    exact igm_allocated s.heap g i j hj
  · change (tableHeap s.heap g i).writable g=true
    simp [tableHeap,allocated,different]
  · change (tableHeap s.heap g i).writable i=true
    simp [tableHeap,allocated]

theorem after_generator (before after : Memory) (a : ArrayPointer) (data : Data before a)
    (frame : PublicInitializedFrame164.Frame before after) : Data after a :=
  ⟨by rw [frame.writable]; exact data.writable,
    fun j hj => frame.written (element a j) (data.written j hj)⟩

end FT1536.Source3.PublicForwardMemory167
