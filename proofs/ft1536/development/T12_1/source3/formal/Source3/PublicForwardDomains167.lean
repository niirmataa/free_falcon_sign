import Source3.PublicForwardMemory167

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicForwardDomains167
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenSmallOutput (element)
open PublicGenerateTable159 (WrittenRange)
open PublicForwardEntry159 (entryT)
open PublicForwardBody159 (gmPointer generateEntry aliasesBound)
open PublicForwardMemory167 (Data tableHeap)

theorem arrays (s : State) (a : ArrayPointer) (g i : Nat) (generated : State)
    (data : Data generated.heap a) (outside : g≠a.block)
    (table : WrittenRange generated.heap (gmPointer g) 0 1024) :
    PublicRoundContext163.Arrays (aliasesBound (entryT s a) g i generated) a (gmPointer g) := by
  refine ⟨PublicForwardMemory167.capacity generated.heap a data,(by change 0+1024 ≤ 2048; decide),rfl,rfl,?_,outside,
    PublicForwardMemory167.width generated.heap a data,data.writable,?_,data.written⟩
  · intro j hj
    exact table j (by omega) hj
  · intro j hj
    obtain ⟨w,read⟩ := data.written j hj
    exact (KeygenPublicRangeMemory.load_allocated _ _ _ read).1

theorem first_entry (s : State) (a : ArrayPointer) (g i : Nat) (generated : State)
    (data : Data generated.heap a) (different : g≠i)
    (table : WrittenRange generated.heap (gmPointer g) 0 1024)
    (memory : PublicInitializedFrame164.Frame (generateEntry (entryT s a) g i).heap generated.heap) :
    PublicTailFirst159.TailEntry (aliasesBound (entryT s a) g i generated) a (gmPointer g) := by
  have first := table 1 (by decide) (by decide)
  refine ⟨rfl,rfl,rfl,rfl,rfl,data.written,first,⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩,
    PublicForwardMemory167.width generated.heap a data,data.writable,?_,
    PublicForwardMemory167.capacity generated.heap a data,rfl,?_,?_,(by change 0+1 ≤ 2048; decide)⟩
  · intro j hj
    obtain ⟨w,read⟩ := data.written j hj
    exact (KeygenPublicRangeMemory.load_allocated _ _ _ read).1
  · change generated.heap.writable g=true
    rw [memory.writable]
    change (tableHeap s.heap g i).writable g=true
    simp [tableHeap,KeygenPublicExec.allocated,different]
  · obtain ⟨w,read⟩ := first
    exact (KeygenPublicRangeMemory.load_allocated _ _ _ read).1

theorem tail (s : State) (a : ArrayPointer) (g i : Nat) (generated : State)
    (data : Data generated.heap a) (different : g≠i) (outside : g≠a.block)
    (table : WrittenRange generated.heap (gmPointer g) 0 1024)
    (memory : PublicInitializedFrame164.Frame (generateEntry (entryT s a) g i).heap generated.heap) :
    ∃ after, KeygenPublicExec.Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.tail
      (aliasesBound (entryT s a) g i generated) ⟨after,.normal⟩ := by
  obtain ⟨after,run,_,_,_⟩ := PublicFullTail165.source (aliasesBound (entryT s a) g i generated)
    a (gmPointer g) (arrays s a g i generated data outside table)
    (first_entry s a g i generated data different table memory) rfl
    ⟨none,rfl⟩ ⟨none,rfl⟩ ⟨none,rfl⟩
  exact ⟨after,run⟩

end FT1536.Source3.PublicForwardDomains167
