import Source3.ActualExtractPrep126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeBlockNormalize126
open C99MemoryReference
open C99FiniteMemory114 (Heap Block memory putBlock)
open C99CompactState115 (State reference)

theorem globals_tables (code : ShakeBlock.Stmt) (before after : C99ArrayReference.State)
    (source : ShakeBlock.Exec code before after) : after.globals=before.globals ∧ after.tables=before.tables := by
  induction source with
  | scalar | store | skip | loopFalse => exact ⟨rfl,rfl⟩
  | seq _ _ _ _ _ _ _ first second => exact ⟨second.1.trans first.1,second.2.trans first.2⟩
  | scope _ _ _ _ _ inner => exact inner
  | loopNext _ _ _ _ _ _ _ _ _ _ _ _ _ first second third =>
      exact ⟨third.1.trans (second.1.trans first.1),third.2.trans (second.2.trans first.2)⟩

def normalize (before : State) (root : ArrayPointer) (context : Block) (locals : C99CompactCells115.Locals) : State :=
  {before with heap := putBlock before.heap root.block context,locals := locals}

/-- Exact reference-memory equality follows from the checked changed
    block and the ORIGINAL source frame. No untouched byte is assumed. -/
theorem heap_equal (code : ShakeBlock.Stmt) (before after : State) (root : ArrayPointer) (context : Block)
    (source : ShakeBlock.Exec code (reference before) (reference after))
    (binding : (reference before).arrays "A".toList=some root)
    (writes : ShakeBlock.writesOnly "A".toList code=true)
    (found : C99FiniteMap114.lookup after.heap.blocks root.block=some context) :
    memory after.heap=memory (putBlock before.heap root.block context) := by
  have frame := ShakeBlock.memory_frame code (reference before) (reference after) root source binding writes
  apply C99FiniteAllocation115.memory_ext
  · intro block offset
    rw [C99FiniteMemory114.bytes_putBlock]
    by_cases same : block=root.block
    · subst block
      simp [memory,found]
    · rw [ite_eq_right same]
      exact frame.2.2 block offset (Or.inl same)
  · intro block
    rw [C99FiniteMemory114.size_putBlock]
    by_cases same : block=root.block
    · subst block
      simp [memory,found]
    · rw [ite_eq_right same]
      exact congrFun frame.1 block
  · intro block
    rw [C99FiniteMemory114.writable_putBlock]
    by_cases same : block=root.block
    · subst block
      simp [memory,found]
    · rw [ite_eq_right same]
      exact congrFun frame.2.1 block

theorem reference_equal (code : ShakeBlock.Stmt) (before after : State) (root : ArrayPointer) (context : Block)
    (locals : C99CompactCells115.Locals)
    (source : ShakeBlock.Exec code (reference before) (reference after))
    (binding : (reference before).arrays "A".toList=some root)
    (writes : ShakeBlock.writesOnly "A".toList code=true)
    (found : C99FiniteMap114.lookup after.heap.blocks root.block=some context)
    (localValues : after.locals=locals) :
    reference after=reference (normalize before root context locals) := by
  have heap := heap_equal code before after root context source binding writes found
  have arrays := ShakeBlock.pointers_frame code (reference before) (reference after) source
  have globals := globals_tables code (reference before) (reference after) source
  change C99NameMap115.lookup after.arrays=C99NameMap115.lookup before.arrays at arrays
  change C99CompactCells115.environment after.globals=C99CompactCells115.environment before.globals ∧
    C99NameMap115.lookup after.tables=C99NameMap115.lookup before.tables at globals
  unfold reference normalize
  rw [heap,localValues,arrays,globals.1,globals.2]

/-- The two finite checks identify the actual successful run's locals and
    changed block; source semantics supplies the rest of the state. -/
theorem certified (fuel : Nat) (code : ShakeBlock.Stmt) (before : State) (root : ArrayPointer) (context : Block)
    (locals : C99CompactCells115.Locals)
    (binding : (reference before).arrays "A".toList=some root)
    (writes : ShakeBlock.writesOnly "A".toList code=true)
    (localValues : (ShakeBlockCompute116.run fuel code before).map State.locals=some locals)
    (blockValue : (ShakeBlockCompute116.run fuel code before).map
      (fun state => C99FiniteMap114.lookup state.heap.blocks root.block)=some (some context)) :
    ShakeBlock.Exec code (reference before) (reference (normalize before root context locals)) := by
  obtain ⟨after,computed,localValues⟩ := Option.map_eq_some_iff.mp localValues
  have source := ShakeBlockCompute116.run_sound fuel code before after computed
  rw [computed] at blockValue
  have found := Option.some.inj blockValue
  have equal := reference_equal code before after root context locals source binding writes found localValues
  rw [← equal]
  exact source

end FT1536.Source3.ShakeBlockNormalize126
