import Source3.PublicInverseBody172
import Source3.PublicForwardMemory167

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicInverseDomains172
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenSmallOutput (element)
open PublicForwardMemory167 (Data)
open PublicGenerateTable159 (Written WrittenRange)
open KeygenPublicExec (Exec allocated)
open PublicForwardEntry159 (entryT)
open PublicInverseBody172 (gmPointer igmPointer generateEntry aliasesBound)

structure Arrays (s : State) (a table : ArrayPointer) : Prop where
  data : Data s.heap a
  aBinding : s.arrays "a".toList=some a
  square : s.arrays "igm_square".toList=some table
  cubic : s.arrays "igm_cubic".toList=some table
  tableWritten : ∀ j, j<1024 → Written s.heap (element table j)
  separate : table.block≠a.block

structure TailEntry (s : State) (a table : ArrayPointer) : Prop extends Arrays s a table where
  profile : KeygenPublicTableAtoms.Slot s "logn" 10
  nCell : KeygenNttLoopSupport.USlot s "n" 1536
  hnCell : KeygenNttLoopSupport.USlot s "hn" 768
  uType : KeygenPublicSizeOps.Declared s "u"
  vType : KeygenPublicSizeOps.Declared s "v"
  tType : KeygenPublicSizeOps.Declared s "t"
  mType : KeygenPublicSizeOps.Declared s "m"
  rType : PublicU32Locals165.Declared s "r"
  wType : PublicU32Locals165.Declared s "w"
  niType : PublicU32Locals165.Declared s "ni"

theorem table_capacity (s : State) (a table : ArrayPointer) (arrays : Arrays s a table) :
    table.index+1024≤table.count := by
  obtain ⟨w,read⟩ := arrays.tableWritten 1023 (by decide)
  have allocated := (KeygenPublicRangeMemory.load_allocated _ _ _ read).1
  simp only [Allocated,element] at allocated
  omega

theorem table_width (s : State) (a table : ArrayPointer) (arrays : Arrays s a table) : table.elementBytes=2 := by
  obtain ⟨w,read⟩ := arrays.tableWritten 0 (by decide)
  exact (KeygenPublicRangeMemory.load_allocated _ _ _ read).2

theorem generated (s : State) (a : ArrayPointer) (g i : Nat) (data : Data s.heap a)
    (freshG : KeygenRngSource.Fresh s.heap g) (freshI : KeygenRngSource.Fresh (allocated s.heap g 2048) i) :
    ∃ generated, Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate)
      (generateEntry (entryT s a) g i) ⟨generated,.normal⟩ ∧
      TailEntry (aliasesBound (entryT s a) g i generated) a (igmPointer i) := by
  have different := PublicForwardMemory167.distinct_tables s.heap g i freshI
  have tables := PublicForwardMemory167.generate_tables s a g i different
  obtain ⟨generated,run,_,written,memory⟩ := PublicGenerateComplete166.source
    (PublicForwardBody159.generateEntry (entryT s a) g i) (gmPointer g) (igmPointer i) tables rfl
  have input := PublicForwardMemory167.retained s.heap a g i data freshG freshI
  have afterData := PublicForwardMemory167.after_generator _ generated.heap a input memory
  refine ⟨generated,?_,⟨⟨afterData,rfl,rfl,rfl,?_,?_⟩,rfl,rfl,rfl,
    ⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩,⟨none,rfl⟩⟩⟩
  · rw [PublicInverseBody172.generator_entry_equal]
    exact run
  · intro j hj
    exact written j (by omega) hj
  · exact (PublicForwardMemory167.outside_i s.heap a g i data freshG freshI).symm

end FT1536.Source3.PublicInverseDomains172
