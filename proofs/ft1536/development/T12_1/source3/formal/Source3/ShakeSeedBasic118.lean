import Source3.ShakeSeedRead118

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeSeedBasic118
open C99MemoryReference
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeExtractSource (Layout Field field)
open ShakeSeedRead118 (calls calls_sound evaluate evaluate_sound)

def scalar (ctx : Layout) (state : State) (code : CLogic.Stmt) : Option State :=
  (C99CompactScalar115.step (calls ctx state) state.locals code).map (fun locals => {state with locals := locals})

theorem scalar_sound (ctx : Layout) (before after : State) (code : CLogic.Stmt)
    (computed : scalar ctx before code=some after) :
    ShakeSeedReference.Exec ctx (.scalar code) (reference before) (reference after) := by
  obtain ⟨locals,step,result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_locals]
  exact .scalar code (reference before) (C99CompactCells115.environment locals)
    (C99CompactScalar115.step_sound (ShakeSeedReference.ReadCall ctx (reference before)) (calls ctx before)
      (calls_sound ctx before) before.locals locals code step)

def pointer (before : State) (dst src : C99ArrayReference.Name) (index : CLogic.Expr) : Option State := do
  let address ← C99CompactPointer115.pointer noCalls before src index
  pure (C99CompactState115.bindPointer before dst address)

theorem pointer_sound (ctx : Layout) (before after : State) (dst src : C99ArrayReference.Name) (index : CLogic.Expr)
    (computed : pointer before dst src index=some after) :
    ShakeSeedReference.Exec ctx (.pointer dst src index) (reference before) (reference after) := by
  obtain ⟨address,located,result⟩ := Option.bind_eq_some_iff.mp computed
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindPointer]
  exact .pointer _ _ _ _ address (C99CompactPointer115.pointer_sound noCalls
    (C99CompactPointer115.noCalls_sound _) before src index address located)

def readLocal (ctx : Layout) (before : State) (dst : C99ArrayReference.Name) (member : Field) : Option State := do
  let cell ← C99NameMap115.lookup before.locals dst
  let word ← C99FiniteRead114.read64 before.heap (field ctx member)
  pure (C99CompactState115.bindValue before dst cell.ty (.u64 word))

theorem readLocal_sound (ctx : Layout) (before after : State) (dst : C99ArrayReference.Name) (member : Field)
    (computed : readLocal ctx before dst member=some after) :
    ShakeSeedReference.Exec ctx (.readLocal dst member) (reference before) (reference after) := by
  obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨word,read,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindValue]
  refine .readLocal _ dst member (C99ValueBridge.type cell.ty) (cell.value.map C99ValueBridge.value) word ?_
    (C99FiniteRead114.read64_sound before.heap _ word read)
  change (C99NameMap115.lookup before.locals dst).map C99CompactCells115.Cell.reference = _
  rw [declared]
  rfl

def write64 (state : State) (pointer : ArrayPointer) (word : BitVec 64) : Option C99FiniteMemory114.Heap :=
  if ShakeBlockCompute116.WriteGuard state pointer then some (C99FiniteWrite114.write64 state.heap pointer word) else none

theorem write64_sound (state : State) (after : C99FiniteMemory114.Heap) (pointer : ArrayPointer) (word : BitVec 64)
    (computed : write64 state pointer word=some after) :
    Store64 (reference state).heap pointer word (C99FiniteMemory114.memory after) := by
  unfold write64 at computed
  split at computed
  next guard =>
    have same := Option.some.inj computed
    subst after
    exact C99FiniteWrite114.write64_sound state.heap pointer word guard.1 guard.2.1 guard.2.2
  next rejected => cases computed

def write8 (state : State) (pointer : ArrayPointer) (byte : Byte) : Option C99FiniteMemory114.Heap :=
  if ShakeEncodeCompute117.WriteGuard state pointer then
    some (C99FiniteMemory114.putByte state.heap pointer.block pointer.offset byte)
  else none

theorem write8_sound (state : State) (after : C99FiniteMemory114.Heap) (pointer : ArrayPointer) (byte : Byte)
    (computed : write8 state pointer byte=some after) :
    ShakeEncode.Store8 (reference state).heap pointer byte (C99FiniteMemory114.memory after) := by
  unfold write8 at computed
  split at computed
  next guard =>
    have same := Option.some.inj computed
    subst after
    exact C99FiniteMemory114.store8 state.heap pointer byte guard.1 guard.2.1 guard.2.2
  next rejected => cases computed

def writeField (ctx : Layout) (before : State) (member : Field) (expression : CLogic.Expr) : Option State := do
  let value ← evaluate ctx before expression
  let heap ← write64 before (field ctx member) (BitVec.ofInt 64 value.integer)
  pure {before with heap := heap}

theorem writeField_sound (ctx : Layout) (before after : State) (member : Field) (expression : CLogic.Expr)
    (computed : writeField ctx before member expression=some after) :
    ShakeSeedReference.Exec ctx (.write member expression) (reference before) (reference after) := by
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨heap,written,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_heap]
  refine .write _ member expression (C99ValueBridge.value value) _ (evaluate_sound ctx before expression value evaluated) ?_
  simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using write64_sound before heap (field ctx member) _ written

end FT1536.Source3.ShakeSeedBasic118
