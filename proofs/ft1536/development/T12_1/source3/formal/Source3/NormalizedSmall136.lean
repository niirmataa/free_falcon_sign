import Source3.SelectedSmallCalls136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NormalizedSmall136
open C99CompactState115 (State reference)
open C99MemoryReference
open C99ProcedureReference (Exec Result)

/-- The completed pair changes only its one scratch block. This compact
    endpoint is equated with the entire actual state, not assumed as input. -/
def after : State := {SelectedBound135.after with
  heap := C99LazyBlock129.putBlock SelectedBound135.after.heap 31 GeneratedConversion136G23.dataBlock}

theorem small_writes : C99ProcedureFrame136.only ["x".toList] KeygenSearchLeaves.smallBody=true := by decide +kernel

theorem initial_arrays (bound declared sized ready : C99ArrayReference.State)
    (declaration : Exec KeygenSearchFft.program KeygenSmallShape136.declaration bound ⟨declared,.normal⟩)
    (size : Exec KeygenSearchFft.program KeygenSmallShape136.size declared ⟨sized,.normal⟩)
    (initial : Exec KeygenSearchFft.program KeygenSmallShape136.initial sized ⟨ready,.normal⟩) :
    ready.arrays=bound.arrays :=
  (KeygenAttemptSlots.procedure _ _ _ _ initial (by decide +kernel)).1.trans
    ((KeygenAttemptSlots.procedure _ _ _ _ size (by decide +kernel)).1.trans
      (KeygenAttemptSlots.procedure _ _ _ _ declaration (by decide +kernel)).1)

theorem f_pointer : (reference SelectedSmallFStart136.bound).arrays "x".toList=some GeneratedConversion136F00.pointer := by
  have found := GeneratedConversion136F00.pointer_binding
  change (reference SelectedSmallFStart136.initial).arrays "x".toList=_ at found
  rw [initial_arrays _ _ _ _ SelectedSmallFStart136.declaration SelectedSmallFStart136.size SelectedSmallFStart136.initialization] at found
  exact found

theorem g_pointer : (reference SelectedSmallGStart136.bound).arrays "x".toList=some GeneratedConversion136G00.pointer := by
  have found := GeneratedConversion136G00.pointer_binding
  change (reference SelectedSmallGStart136.initial).arrays "x".toList=_ at found
  rw [initial_arrays _ _ _ _ SelectedSmallGStart136.declaration SelectedSmallGStart136.size SelectedSmallGStart136.initialization] at found
  exact found

theorem body_outside (before out : C99ArrayReference.State) (pointer : ArrayPointer)
    (source : Exec KeygenSearchFft.program KeygenSearchLeaves.smallBody before ⟨out,.normal⟩)
    (binding : before.arrays "x".toList=some pointer) (block offset : Nat) (different : block≠pointer.block) :
    out.heap.bytes block offset=before.heap.bytes block offset := by
  apply (C99ProcedureFrame136.frame _ _ _ _ source ["x".toList] small_writes block offset ?_).2
  intro name member found read
  have named := List.mem_singleton.mp member
  subst name
  have same : found=pointer := Option.some.inj (read.symm.trans binding)
  subst found
  exact Or.inl different

theorem f_bytes (block offset : Nat) (different : block≠31) :
    (reference SelectedSmallFComplete136.after).heap.bytes block offset=
      (reference SelectedBound135.after).heap.bytes block offset := by
  have keep := body_outside _ _ _ SelectedSmallFComplete136.body f_pointer block offset different
  have bound := C99ArrayReference.bind_heap _ _ _ _ SelectedSmallFStart136.binding
  change (reference SelectedSmallFComplete136.after).heap.bytes block offset=
    (reference SelectedSmallFStart136.bound).heap.bytes block offset at keep
  rw [bound] at keep
  exact keep

theorem g_bytes (block offset : Nat) (different : block≠31) :
    (reference SelectedSmallGComplete136.after).heap.bytes block offset=
      (reference SelectedSmallFComplete136.after).heap.bytes block offset := by
  have keep := body_outside _ _ _ SelectedSmallGComplete136.body g_pointer block offset different
  have bound := C99ArrayReference.bind_heap _ _ _ _ SelectedSmallGStart136.binding
  change (reference SelectedSmallGComplete136.after).heap.bytes block offset=
    (reference SelectedSmallGStart136.bound).heap.bytes block offset at keep
  rw [bound] at keep
  exact keep

theorem small_metadata (before after : C99ArrayReference.State) (args : List C99ArrayReference.Arg)
    (source : KeygenSearchLeaves.SmallCall before args after) : C99Metadata091.Stable before after := by
  cases source with
  | run entry out binding body returned =>
    have keep := C99ProcedureFrame136.metadata _ _ _ _ body
    have heap := C99ArrayReference.bind_heap _ _ _ _ binding
    exact ⟨keep.sizes.trans (congrArg Memory.size heap),keep.writable.trans (congrArg Memory.writable heap),rfl,rfl⟩

theorem metadata : C99Metadata091.Stable (reference SelectedBound135.after) (reference SelectedSmallGComplete136.after) :=
  C99Metadata091.trans _ _ _ (small_metadata _ _ _ SelectedSmallCalls136.first) (small_metadata _ _ _ SelectedSmallCalls136.second)

theorem block_found : C99FiniteMap114.lookup SelectedSmallGComplete136.after.heap.blocks 31=
    some GeneratedConversion136G23.dataBlock := by
  change C99FiniteMap114.lookup (C99LazyBlock129.putBlock GeneratedConversion136G23.before.heap
    GeneratedConversion136G23.pointer.block GeneratedConversion136G23.dataBlock).blocks 31=_
  rw [C99LazyBlock129.lookup_put]
  rfl

theorem heap_equal : C99FiniteMemory114.memory SelectedSmallGComplete136.after.heap=
    C99FiniteMemory114.memory after.heap := by
  change C99FiniteMemory114.memory SelectedSmallGComplete136.after.heap=
    C99FiniteMemory114.memory (C99LazyBlock129.putBlock SelectedBound135.after.heap 31 GeneratedConversion136G23.dataBlock)
  rw [C99LazyBlock129.memory_equal]
  apply C99FiniteAllocation115.memory_ext
  · intro block offset
    rw [C99FiniteMemory114.bytes_putBlock]
    by_cases same : block=31
    · subst block
      simp [C99FiniteMemory114.memory,block_found]
    · rw [ite_eq_right same]
      exact (g_bytes block offset same).trans (f_bytes block offset same)
  · intro block
    rw [C99FiniteMemory114.size_putBlock]
    by_cases same : block=31
    · subst block
      simp [C99FiniteMemory114.memory,block_found]
    · rw [ite_eq_right same]
      exact congrFun metadata.sizes block
  · intro block
    rw [C99FiniteMemory114.writable_putBlock]
    by_cases same : block=31
    · subst block
      simp [C99FiniteMemory114.memory,block_found]
    · rw [ite_eq_right same]
      exact congrFun metadata.writable block

theorem reference_equal : reference SelectedSmallGComplete136.after=reference after := by
  change {reference SelectedBound135.after with heap := C99FiniteMemory114.memory SelectedSmallGComplete136.after.heap}=
    {reference SelectedBound135.after with heap := C99FiniteMemory114.memory after.heap}
  rw [heap_equal]

theorem second : KeygenSearchLeaves.SmallCall (reference SelectedSmallFComplete136.after)
    (KeygenSmallShape136.args "rt2" "g") (reference after) := by
  rw [← reference_equal]
  exact SelectedSmallCalls136.second

theorem continue_raw (out : Result)
    (continuation : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenSmallShape136.remaining (reference after) out) :
    KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormFrame.code (reference SelectedBound135.after) out := by
  apply SelectedSmallCalls136.continue_raw out
  rw [reference_equal]
  exact continuation

end FT1536.Source3.NormalizedSmall136
