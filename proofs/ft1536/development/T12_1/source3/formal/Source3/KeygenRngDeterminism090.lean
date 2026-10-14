import Source3.RngTemporarySwap090

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRngDeterminism090
open C99ArrayReference (State)
open C99MemoryReference
open C99BlockRename090
open KeygenRngSource (Fresh allocated disposed)
open RngTemporarySwap090
open ShakeExtractSource (Layout)

/-- Relocate the executed temporary output object. The table-live and
    context-live conditions are input-memory properties, already present
    in the legal caller domain, not PRNG or source-correctness premises. -/
theorem relocate (ctx : Layout) (before after : State) (a b : Nat) (word : BitVec 64)
    (fa : Fresh before.heap a) (fb : Fresh before.heap b)
    (ctxLive : 0 < before.heap.size ctx.block) (tablesLive : TablesLive before)
    (extract : ShakeExtractFrame.Call ctx {before with heap := allocated before.heap a}
      (KeygenRngSource.bytes a) (.uint64 8) after)
    (read : Load64 after.heap (KeygenRngSource.object a) word) :
    ∃ moved : State,
      ShakeExtractFrame.Call ctx {before with heap := allocated before.heap b}
        (KeygenRngSource.bytes b) (.uint64 8) moved ∧
      Load64 moved.heap (KeygenRngSource.object b) word ∧
      disposed before.heap moved.heap b = disposed before.heap after.heap a := by
  by_cases same : a = b
  · subst b
    exact ⟨after, extract, read, rfl⟩
  have ctxOutside : ctx.block ≠ b := by
    intro equal
    rw [equal, fb.1] at ctxLive
    omega
  have keep := ShakeExtractFrame.call_frame ctx {before with heap := allocated before.heap a} after
    (KeygenRngSource.bytes a) (.uint64 8) b ctxOutside same extract
  have stillFresh : Fresh after.heap b := by
    refine ⟨?_, ?_, ?_⟩
    · rw [keep.1]
      simpa only [KeygenRngSource.allocated, Ne.symm same, ite_false] using fb.1
    · rw [keep.2.1]
      simpa only [KeygenRngSource.allocated, Ne.symm same, ite_false] using fb.2.1
    · intro offset
      rw [keep.2.2 offset]
      simpa only [KeygenRngSource.allocated, Ne.symm same, ite_false] using fb.2.2 offset
  have transformed := ShakeExtractRename090.call (Equiv.swap a b) ctx
    {before with heap := allocated before.heap a} after (KeygenRngSource.bytes a) (.uint64 8) extract
  rw [context_fixed ctx before a b fa fb ctxLive, bytes_swap] at transformed
  have heapEq : (state (Equiv.swap a b) {before with heap := allocated before.heap a}).heap =
      ({before with heap := allocated before.heap b} : State).heap := allocation_swap before.heap a b fa fb
  have globalsEq : (state (Equiv.swap a b) {before with heap := allocated before.heap a}).globals =
      ({before with heap := allocated before.heap b} : State).globals := rfl
  have tablesEq : (state (Equiv.swap a b) {before with heap := allocated before.heap a}).tables =
      ({before with heap := allocated before.heap b} : State).tables := tables_fixed before a b fa fb tablesLive
  have rebased := ShakeExtractRename090.call_rebase ctx
    (state (Equiv.swap a b) {before with heap := allocated before.heap a})
    (state (Equiv.swap a b) after) {before with heap := allocated before.heap b}
    (KeygenRngSource.bytes b) (.uint64 8) heapEq globalsEq tablesEq transformed
  have movedRead := C99BlockRename090.load64 (Equiv.swap a b) after.heap (KeygenRngSource.object a) word read
  rw [object_swap] at movedRead
  exact ⟨{before with heap := heap (Equiv.swap a b) after.heap}, rebased, movedRead,
    disposal_swap before.heap after.heap a b fa fb (Ne.symm same) stillFresh⟩

/-- The actual get_rng_u64 result and restored caller state are unique,
    even when two source derivations choose different fresh temporaries. -/
theorem call_unique (ctx : Layout) (before a b : State) (x y : BitVec 64)
    (ctxLive : 0 < before.heap.size ctx.block) (tablesLive : TablesLive before)
    (first : KeygenRngSource.Call ctx before a x) (second : KeygenRngSource.Call ctx before b y) :
    a = b ∧ x = y := by
  cases first with
  | run left firstOut x fresh1 extract1 read1 =>
      cases second with
      | run right secondOut y fresh2 extract2 read2 =>
          obtain ⟨moved, movedExtract, movedRead, disposedEq⟩ :=
            relocate ctx before firstOut left right x fresh1 fresh2 ctxLive tablesLive extract1 read1
          have equal := ShakeExtractDeterminism090.call ctx
            {before with heap := allocated before.heap right} (KeygenRngSource.bytes right) (.uint64 8)
            moved secondOut movedExtract extract2
          subst moved
          exact ⟨congrArg (fun h => ({before with heap := h} : State)) disposedEq.symm,
            load64_deterministic secondOut.heap (KeygenRngSource.object right) x y movedRead read2⟩

end FT1536.Source3.KeygenRngDeterminism090
