import Source3.ShakeSeedStores118
import Source3.C99FiniteCopy114

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeSeedMemory118
open C99MemoryReference
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeExtractSource (Layout Field field)
open ShakeSeedRead118 (evaluate evaluate_sound)

def fill (ctx : Layout) (before : State) (member : Field) (start count : CLogic.Expr) : Option State := do
  let index ← evaluate ctx before start
  let length ← evaluate ctx before count
  let pointer ← C99CompactPointer115.advance (field ctx member) index
  if 0 ≤ length.integer then
    let heap ← C99FiniteCopy114.fill before.heap pointer length.integer.toNat 0
    pure {before with heap := heap}
  else none

theorem fill_sound (ctx : Layout) (before after : State) (member : Field) (start count : CLogic.Expr)
    (computed : fill ctx before member start count=some after) :
    ShakeSeedReference.Exec ctx (.fill member start count) (reference before) (reference after) := by
  obtain ⟨index,offset,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨length,size,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨pointer,advanced,rest⟩ := Option.bind_eq_some_iff.mp rest
  split at rest
  next nonnegative =>
    obtain ⟨heap,filled,result⟩ := Option.bind_eq_some_iff.mp rest
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_heap]
    have address := C99CompactPointer115.advance_sound (field ctx member) pointer index advanced
    refine .fill _ member start count (C99ValueBridge.value index) (C99ValueBridge.value length) pointer _
      (evaluate_sound ctx before start index offset) (evaluate_sound ctx before count length size) address.1
      (by simpa only [C99ValueBridge.integer_matches] using nonnegative) address.2 ?_
    simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using
      C99FiniteCopy114.fill_sound before.heap heap pointer length.integer.toNat 0 filled
  next rejected => cases rest

def copyData (ctx : Layout) (before : State) (start count : CLogic.Expr) : Option State := do
  let index ← evaluate ctx before start
  let length ← evaluate ctx before count
  let destination ← C99CompactPointer115.advance (field ctx .dbuf) index
  let source ← C99CompactPointer115.pointer noCalls before "buf".toList ShakeSeedProgram.zero
  if 0 ≤ length.integer ∧
      destination.offset+length.integer.toNat ≤ destination.base+destination.elementBytes*destination.count ∧
      source.offset+length.integer.toNat ≤ source.base+source.elementBytes*source.count then
    let heap ← C99FiniteCopy114.copy before.heap destination source length.integer.toNat
    pure {before with heap := heap}
  else none

theorem copyData_sound (ctx : Layout) (before after : State) (start count : CLogic.Expr)
    (computed : copyData ctx before start count=some after) :
    ShakeSeedReference.Exec ctx (.copyData start count) (reference before) (reference after) := by
  obtain ⟨index,offset,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨length,size,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨destination,advanced,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨source,src,rest⟩ := Option.bind_eq_some_iff.mp rest
  split at rest
  next guard =>
    obtain ⟨heap,copied,result⟩ := Option.bind_eq_some_iff.mp rest
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_heap]
    have address := C99CompactPointer115.advance_sound (field ctx .dbuf) destination index advanced
    refine .copyData _ start count (C99ValueBridge.value index) (C99ValueBridge.value length) destination source _
      (evaluate_sound ctx before start index offset) (evaluate_sound ctx before count length size) address.1
      (by simpa only [C99ValueBridge.integer_matches] using guard.1) address.2
      (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before _ _ source src)
      (by simpa only [C99ValueBridge.integer_matches] using guard.2.1)
      (by simpa only [C99ValueBridge.integer_matches] using guard.2.2) ?_
    simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using
      C99FiniteCopy114.copy_sound before.heap heap destination source length.integer.toNat copied
  next rejected => cases rest

end FT1536.Source3.ShakeSeedMemory118
