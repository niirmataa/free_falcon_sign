import Source3.ShakeSeedInvoke118

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractBasic120
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open ShakeExtractSource (Layout Field field)
open ShakeBlockComputeRead116 (calls calls_sound evaluate evaluate_sound)

theorem scalar_sound (ctx : Layout) (before after : State) (code : CLogic.Stmt)
    (computed : ShakeBlockCompute116.scalar before code=some after) :
    ShakeExtractSource.Exec ctx (.scalar code) (reference before) (reference after) := by
  obtain ⟨locals,step,result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_locals]
  exact .scalar code (reference before) (C99CompactCells115.environment locals)
    (C99CompactScalar115.step_sound (ShakeBlock.ReadCall (reference before)) (calls before)
      (calls_sound before) before.locals locals code step)

theorem pointer_sound (ctx : Layout) (before after : State) (dst src : C99ArrayReference.Name) (index : CLogic.Expr)
    (computed : ShakeSeedBasic118.pointer before dst src index=some after) :
    ShakeExtractSource.Exec ctx (.pointer dst src index) (reference before) (reference after) := by
  obtain ⟨address,located,result⟩ := Option.bind_eq_some_iff.mp computed
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindPointer]
  exact .pointer dst src index _ address (C99CompactPointer115.pointer_sound noCalls
    (C99CompactPointer115.noCalls_sound _) before src index address located)

theorem fieldRead_sound (ctx : Layout) (before after : State) (dst : C99ArrayReference.Name) (member : Field)
    (computed : ShakeSeedBasic118.readLocal ctx before dst member=some after) :
    ShakeExtractSource.Exec ctx (.fieldRead dst member) (reference before) (reference after) := by
  obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨word,read,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_bindValue]
  refine .fieldRead dst member _ (C99ValueBridge.type cell.ty) (cell.value.map C99ValueBridge.value) word ?_
    (C99FiniteRead114.read64_sound before.heap _ word read)
  change (C99NameMap115.lookup before.locals dst).map C99CompactCells115.Cell.reference = _
  rw [declared]
  rfl

def fieldStore (ctx : Layout) (before : State) (member : Field) (expression : CLogic.Expr) : Option State := do
  let value ← evaluate before expression
  let heap ← ShakeSeedBasic118.write64 before (field ctx member) (BitVec.ofInt 64 value.integer)
  pure {before with heap := heap}

theorem fieldStore_sound (ctx : Layout) (before after : State) (member : Field) (expression : CLogic.Expr)
    (computed : fieldStore ctx before member expression=some after) :
    ShakeExtractSource.Exec ctx (.fieldStore member expression) (reference before) (reference after) := by
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨heap,written,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactState115.reference_heap]
  refine .fieldStore member expression _ _ (C99ValueBridge.value value) (evaluate_sound before expression value evaluated) ?_
  simpa only [C99ValueBridge.integer_matches,C99CompactState115.reference] using
    ShakeSeedBasic118.write64_sound before heap (field ctx member) _ written

end FT1536.Source3.ShakeExtractBasic120
