import Source3.ShakeSeedBasic118

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeSeedStores118
open C99MemoryReference
open C99CompactState115 (State reference)
open ShakeExtractSource (Layout Field field)
open ShakeSeedRead118 (evaluate evaluate_sound)
open ShakeSeedBasic118 (write64 write64_sound write8 write8_sound)

def store (ctx : Layout) (before : State) (member : Field) (index expression : CLogic.Expr) : Option State := do
  let offset ← evaluate ctx before index
  let pointer ← C99CompactPointer115.advance (field ctx member) offset
  let value ← evaluate ctx before expression
  let heap ← match member with
    | .a => write64 before pointer (BitVec.ofInt 64 value.integer)
    | .dbuf => write8 before pointer (BitVec.ofInt 8 value.integer)
    | _ => none
  pure {before with heap := heap}

theorem store_sound (ctx : Layout) (before after : State) (member : Field) (index expression : CLogic.Expr)
    (computed : store ctx before member index expression=some after) :
    ShakeSeedReference.Exec ctx (.store member index expression) (reference before) (reference after) := by
  obtain ⟨offset,offsetValue,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨pointer,advanced,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp rest
  have address := C99CompactPointer115.advance_sound (field ctx member) pointer offset advanced
  cases member with
  | dptr | rate => cases rest
  | a =>
      obtain ⟨heap,written,result⟩ := Option.bind_eq_some_iff.mp rest
      have same := Option.some.inj result
      subst after
      rw [C99CompactState115.reference_heap]
      refine .store64 _ index expression (C99ValueBridge.value offset) (C99ValueBridge.value value) pointer _
        (evaluate_sound ctx before index offset offsetValue) address.1 address.2
        (evaluate_sound ctx before expression value evaluated) ?_
      simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using write64_sound before heap pointer _ written
  | dbuf =>
      obtain ⟨heap,written,result⟩ := Option.bind_eq_some_iff.mp rest
      have same := Option.some.inj result
      subst after
      rw [C99CompactState115.reference_heap]
      refine .store8 _ index expression (C99ValueBridge.value offset) (C99ValueBridge.value value) pointer _
        (evaluate_sound ctx before index offset offsetValue) address.1 address.2
        (evaluate_sound ctx before expression value evaluated) ?_
      simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using write8_sound before heap pointer _ written

def postByte (ctx : Layout) (before : State) (expression : CLogic.Expr) : Option State := do
  let old ← C99FiniteRead114.read64 before.heap (field ctx .dptr)
  let next ← B20.C.bin .add (.u64 old) (.i32 1)
  let incremented ← write64 before (field ctx .dptr) (BitVec.ofInt 64 next.integer)
  let pointer ← C99CompactPointer115.advance (field ctx .dbuf) (.u64 old)
  let value ← evaluate ctx before expression
  let heap ← write8 {before with heap := incremented} pointer (BitVec.ofInt 8 value.integer)
  pure {before with heap := heap}

theorem postByte_sound (ctx : Layout) (before after : State) (expression : CLogic.Expr)
    (computed : postByte ctx before expression=some after) :
    ShakeSeedReference.Exec ctx (.postByte expression) (reference before) (reference after) := by
  obtain ⟨old,read,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨next,addition,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨incremented,counter,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨pointer,advanced,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨heap,written,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_heap]
  refine .postByte _ expression old (C99ValueBridge.value next) (C99ValueBridge.value value) pointer
    (C99FiniteMemory114.memory incremented) (C99FiniteMemory114.memory heap)
    (C99FiniteRead114.read64_sound before.heap _ old read)
    (C99IntegerSound.arithmetic_sound .plus (.u64 old) (.i32 1) next addition) ?_
    (C99CompactPointer115.advance_sound (field ctx .dbuf) pointer (.u64 old) advanced).2
    (evaluate_sound ctx before expression value evaluated) ?_
  · simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using write64_sound before incremented (field ctx .dptr) _ counter
  · simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using
      write8_sound {before with heap := incremented} heap pointer _ written

end FT1536.Source3.ShakeSeedStores118
