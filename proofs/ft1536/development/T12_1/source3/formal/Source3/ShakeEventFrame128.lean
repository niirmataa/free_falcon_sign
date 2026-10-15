import Source3.ShakeProcessEvents128
import Source3.C99FiniteAllocation115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeEventFrame128
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open C99CompactState115 (State reference)
open ShakeProcessEvents128 (Event)

theorem pairs_frame (pairs : List (BitVec 64 × Nat)) (heap : Heap) (pointer : ArrayPointer) :
    ShakeEncode.BlockFrame (memory heap)
      (memory (pairs.foldl (fun h pair => C99FiniteWrite114.write64 h (KeygenSmallOutput.element pointer pair.2) pair.1) heap))
      pointer.block := by
  induction pairs generalizing heap with
  | nil => exact ⟨rfl,rfl,fun _ _ _ => rfl⟩
  | cons head tail ih =>
      rcases head with ⟨word,index⟩
      let p := KeygenSmallOutput.element pointer index
      have first := C99FiniteWrite114.writeVec_metadata heap p.block p.offset 8 (byte64 word)
      have rest := ih (C99FiniteWrite114.write64 heap p word)
      refine ⟨rest.1.trans first.1,rest.2.1.trans first.2,?_⟩
      intro block offset outside
      exact (rest.2.2 block offset outside).trans
        (C99FiniteWrite114.writeVec_frame heap p.block p.offset 8 (byte64 word) block offset (Or.inl outside))

theorem event_frame (event : Event) :
    ShakeEncode.BlockFrame (reference event.before).heap (reference event.after).heap event.pointer.block :=
  pairs_frame event.words.zipIdx event.before.heap event.pointer

theorem process_slots (before after : C99ArrayReference.State) (pointer : ArrayPointer)
    (source : ShakeExtractSource.Process before pointer after) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.globals=before.globals ∧ after.tables=before.tables := by
  cases source
  exact ⟨rfl,rfl,rfl,rfl⟩

/-- Exact equality of the changed block plus two proved complete frames
    identifies every byte. This never assumes correctness of proposed words. -/
theorem heap_equal (event : Event) (actual : State)
    (source : ShakeExtractSource.Process (reference event.before) event.pointer (reference actual))
    (blockEqual : C99FiniteMap114.lookup actual.heap.blocks event.pointer.block=
      C99FiniteMap114.lookup event.after.heap.blocks event.pointer.block) :
    memory actual.heap=memory event.after.heap := by
  have original := ShakeExtractSource.process_frame (reference event.before) (reference actual) event.pointer source
  have proposed := event_frame event
  apply C99FiniteAllocation115.memory_ext
  · intro block offset
    by_cases same : block=event.pointer.block
    · subst block
      exact congrArg (fun value => value.bind (fun data : C99FiniteMemory114.Block => data.read offset)) blockEqual
    · exact (original.2.2 block offset same).trans (proposed.2.2 block offset same).symm
  · intro block
    exact congrFun (original.1.trans proposed.1.symm) block
  · intro block
    exact congrFun (original.2.1.trans proposed.2.1.symm) block

theorem valid (ctx : ShakeExtractSource.Layout) (event : Event) (actual : State)
    (source : ShakeExtractSource.Process (reference event.before) event.pointer (reference actual))
    (blockEqual : C99FiniteMap114.lookup actual.heap.blocks event.pointer.block=
      C99FiniteMap114.lookup event.after.heap.blocks event.pointer.block) :
    ShakeProcessEvents128.Valid ctx event := by
  have heap := heap_equal event actual source blockEqual
  obtain ⟨locals,arrays,globals,tables⟩ := process_slots _ _ _ source
  have equal : reference actual=reference event.after := by
    change C99CompactCells115.environment actual.locals=C99CompactCells115.environment event.before.locals at locals
    change C99NameMap115.lookup actual.arrays=C99NameMap115.lookup event.before.arrays at arrays
    change C99CompactCells115.environment actual.globals=C99CompactCells115.environment event.before.globals at globals
    change C99NameMap115.lookup actual.tables=C99NameMap115.lookup event.before.tables at tables
    unfold reference Event.after
    rw [heap,locals,arrays,globals,tables]
    rfl
  exact .process event.name _ _ event.pointer event.resolution (equal ▸ source)

end FT1536.Source3.ShakeEventFrame128
