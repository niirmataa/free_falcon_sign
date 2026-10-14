import Source3.KeygenScalarCompute121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenStore16Compute121
open C99MemoryReference
open C99FiniteMemory114 (Heap memory)
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def write16 (heap : Heap) (pointer : ArrayPointer) (word : BitVec 16) : Heap :=
  C99FiniteWrite114.writeVec heap pointer.block pointer.offset 2 (KeygenSmallOutput.byte16 word)

theorem write16_sound (heap : Heap) (pointer : ArrayPointer) (word : BitVec 16)
    (allocated : Allocated (memory heap) pointer) (width : pointer.elementBytes=2)
    (writable : (memory heap).writable pointer.block=true) :
    KeygenSmallOutput.Store16 (memory heap) pointer word (memory (write16 heap pointer word)) := by
  have extent : pointer.offset+2 ≤ (memory heap).size pointer.block := by
    obtain ⟨_,_,index,size,_⟩ := allocated
    simp only [width] at size
    simp only [ArrayPointer.offset,width]
    omega
  have metadata := C99FiniteWrite114.writeVec_metadata heap pointer.block pointer.offset 2 (KeygenSmallOutput.byte16 word)
  exact ⟨allocated,width,writable,metadata.1,metadata.2,
    C99FiniteWrite114.writeVec_at heap pointer.block pointer.offset 2 (KeygenSmallOutput.byte16 word) extent,
    C99FiniteWrite114.writeVec_frame heap pointer.block pointer.offset 2 (KeygenSmallOutput.byte16 word)⟩

def Guard (state : State) (pointer : ArrayPointer) : Prop :=
  Allocated (memory state.heap) pointer ∧ pointer.elementBytes=2 ∧ (memory state.heap).writable pointer.block=true

instance guardDecidable (state : State) (pointer : ArrayPointer) : Decidable (Guard state pointer) := by
  unfold Guard
  infer_instance

def store (before : State) (dst : C99ArrayReference.Name) (index expression : CLogic.Expr) : Option State := do
  let pointer ← C99CompactPointer115.pointer noCalls before dst index
  let value ← C99CompactScalar115.evaluate noCalls before.locals expression
  if Guard before pointer then
    pure {before with heap := write16 before.heap pointer (BitVec.ofInt 16 value.integer)}
  else none

theorem store_sound (before after : State) (dst : C99ArrayReference.Name) (index expression : CLogic.Expr)
    (computed : store before dst index expression=some after) :
    KeygenSmallSource.Exec (.store16 dst index expression) (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨pointer,address,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨value,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  split at result
  next guard =>
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_heap]
    refine .store16 dst index expression (reference before) _ pointer (C99ValueBridge.value value)
      (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) before dst index pointer address)
      (C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls (C99CompactPointer115.noCalls_sound _)
        before.locals expression value evaluated) ?_
    simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using
      write16_sound before.heap pointer (BitVec.ofInt 16 value.integer) guard.1 guard.2.1 guard.2.2
  next rejected => cases result

end FT1536.Source3.KeygenStore16Compute121
