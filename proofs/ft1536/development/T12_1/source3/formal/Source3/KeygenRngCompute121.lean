import Source3.ShakeExtractInvoke120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRngCompute121
open C99CompactState115 (State reference)
open C99FiniteMemory114 (memory)
open C99FiniteAllocation115 (allocate restore fresh fresh_iff)
open ShakeExtractSource (Layout)

theorem allocate_bound (heap : C99FiniteMemory114.Heap) (block : Nat) :
    memory (allocate heap block 8)=KeygenRngSource.allocated (memory heap) block :=
  C99FiniteAllocation115.allocate_source heap block 8

/-- The caller supplies a checked fresh object identifier. Actual extraction
    fills the uint64 object; the SAME bytes are read before source disposal. -/
def draw (ctx : Layout) (fuel block : Nat) (before : State) : Option (State × BitVec 64) := do
  if fresh before.heap block then
    let entered := {before with heap := allocate before.heap block 8}
    let after ← ShakeExtractInvoke120.invoke ctx fuel entered (KeygenRngSource.bytes block) (.u64 8)
    let word ← C99FiniteRead114.read64 after.heap (KeygenRngSource.object block)
    pure ({before with heap := restore before.heap after.heap block},word)
  else none

theorem draw_sound (ctx : Layout) (fuel block : Nat) (before after : State) (word : BitVec 64)
    (computed : draw ctx fuel block before=some (after,word)) :
    KeygenRngSource.Call ctx (reference before) (reference after) word := by
  unfold draw at computed
  split at computed
  next unused =>
    obtain ⟨middle,extracted,rest⟩ := Option.bind_eq_some_iff.mp computed
    obtain ⟨value,read,result⟩ := Option.bind_eq_some_iff.mp rest
    have same := Option.some.inj result
    have sameState := congrArg Prod.fst same
    have sameWord := congrArg Prod.snd same
    dsimp only at sameState sameWord
    subst after
    subst word
    rw [C99CompactState115.reference_heap before (restore before.heap middle.heap block),
      C99FiniteAllocation115.restore_source]
    have source := ShakeExtractInvoke120.invoke_sound ctx fuel {before with heap := allocate before.heap block 8}
      middle (KeygenRngSource.bytes block) (.u64 8) extracted
    rw [C99CompactState115.reference_heap before (allocate before.heap block 8),allocate_bound] at source
    exact .run block (reference middle) value ((fresh_iff before.heap block).mp unused) source
      (C99FiniteRead114.read64_sound middle.heap (KeygenRngSource.object block) value read)
  next occupied => cases computed

end FT1536.Source3.KeygenRngCompute121
