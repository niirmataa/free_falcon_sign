import Source3.ShakeExtractCalls120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractCopy120
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeExtractSource (Layout field)

def word (state : State) (expression : CLogic.Expr) : Option (BitVec 64) := do
  let value ← C99CompactScalar115.evaluate noCalls state.locals expression
  match value with | .u64 bits => some bits | _ => none

theorem word_sound (state : State) (expression : CLogic.Expr) (bits : BitVec 64)
    (computed : word state expression=some bits) : C99ArrayReference.scalar (reference state) expression (.uint64 bits) := by
  obtain ⟨value,evaluated,result⟩ := Option.bind_eq_some_iff.mp computed
  cases value with
  | i64 value | u32 value | i32 value => cases result
  | u64 value =>
      have same := Option.some.inj result
      subst bits
      exact C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
        state.locals expression (.u64 value) evaluated

def copy (ctx : Layout) (before : State) (dst : C99ArrayReference.Name) (index count : CLogic.Expr) : Option State := do
  let destination ← C99CompactPointer115.pointer noCalls before dst ShakeExtractSource.zero
  let offset ← word before index
  let length ← word before count
  let source ← C99CompactPointer115.advance (field ctx .dbuf) (.u64 offset)
  if destination.offset+length.toNat ≤ destination.base+destination.elementBytes*destination.count ∧
      source.offset+length.toNat ≤ source.base+source.elementBytes*source.count then
    let heap ← C99FiniteCopy114.copy before.heap destination source length.toNat
    pure {before with heap := heap}
  else none

theorem copy_sound (ctx : Layout) (before after : State) (dst : C99ArrayReference.Name) (index count : CLogic.Expr)
    (computed : copy ctx before dst index count=some after) :
    ShakeExtractSource.Exec ctx (.copy dst index count) (reference before) (reference after) := by
  obtain ⟨destination,address,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨offset,indexValue,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨length,countValue,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨source,advanced,rest⟩ := Option.bind_eq_some_iff.mp rest
  split at rest
  next guard =>
    obtain ⟨heap,copied,result⟩ := Option.bind_eq_some_iff.mp rest
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_heap]
    exact .copy dst index count (reference before) (C99FiniteMemory114.memory heap) destination source offset length
      (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before dst _ destination address)
      (word_sound before index offset indexValue) (word_sound before count length countValue)
      (C99CompactPointer115.advance_sound (field ctx .dbuf) source (.u64 offset) advanced).2
      guard.1 guard.2 (C99FiniteCopy114.copy_sound before.heap heap destination source length.toNat copied)
  next rejected => cases rest

end FT1536.Source3.ShakeExtractCopy120
