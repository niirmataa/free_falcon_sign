import Source3.ActualExtractTail126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ActualExtractBody126
open C99CompactState115 (State reference)
open ShakeExtractSource (Stmt Exec chain)
open ActualExtractPrep126 (ctx headed iterationStart loopCondition refillCondition)
open ActualExtractTail126 (refilled iterationRaw iterationDone)

theorem iteration_source : Exec ctx ShakeExtractSource.iteration (reference headed) (reference iterationDone) := by
  unfold ActualExtractTail126.iterationDone
  rw [C99CompactState115.reference_restoreScope]
  apply Exec.scope ["clen".toList] [] _ (reference headed) (reference iterationRaw)
  change Exec ctx (chain (ActualExtractPrep126.declaration ::
    .branch refillCondition ShakeExtractSource.refill .skip :: ActualExtractTail126.iterationTail)) _ _
  refine .seq _ _ (reference headed) (reference iterationStart) (reference iterationRaw)
    ActualExtractPrep126.declaration_source ?_
  refine .seq _ _ (reference iterationStart) (reference refilled) (reference iterationRaw) ?_
    ActualExtractTail126.iteration_tail_source
  exact .branchTrue refillCondition ShakeExtractSource.refill .skip _ _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound iterationStart refillCondition (.i32 1) ActualExtractPrep126.refill_guard_computed)
    (by decide +kernel) ActualExtractTail126.refill_source

theorem exit_computed : ShakeBlockComputeRead116.evaluate iterationDone loopCondition=some (.i32 0) := by decide +kernel

theorem loop_source : Exec ctx (.loop loopCondition ShakeExtractSource.iteration) (reference headed) (reference iterationDone) :=
  .loopNext loopCondition ShakeExtractSource.iteration (reference headed) (reference iterationDone) (reference iterationDone) (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound headed loopCondition (.i32 1) ActualExtractPrep126.loop_guard_computed)
    (by decide +kernel) iteration_source
    (.loopFalse loopCondition ShakeExtractSource.iteration (reference iterationDone) (.int32 0)
      (ShakeBlockComputeRead116.evaluate_sound iterationDone loopCondition (.i32 0) exit_computed) rfl)

def finalCode : Stmt := .fieldStore .dptr (.var "dptr".toList)
def finalResult := ShakeExtractRun120.run ctx 16 finalCode iterationDone
theorem final_defined : finalResult.isSome=true := by decide +kernel
def finalState : State := finalResult.get final_defined
theorem final_computed : ShakeExtractRun120.run ctx 16 finalCode iterationDone=some finalState :=
  SelectedInput124.option_get finalResult final_defined
theorem final_source : Exec ctx finalCode (reference iterationDone) (reference finalState) :=
  ShakeExtractRun120.run_sound ctx 16 finalCode iterationDone finalState final_computed

theorem body : Exec ctx ShakeExtractSource.code (reference ActualExtractPrep126.entered) (reference finalState) := by
  change Exec ctx (chain (ActualExtractPrep126.headStatements ++ [.loop loopCondition ShakeExtractSource.iteration,finalCode])) _ _
  exact ShakeExtractFragments126.append ctx _ _ _ _ _ ActualExtractPrep126.head_source
    (.seq _ _ _ (reference iterationDone) _ loop_source
      (.seq _ _ _ (reference finalState) _ final_source (.skip _)))

def extracted : State := {ActualExtractPrep126.allocated with heap := finalState.heap}

theorem call : ShakeExtractFrame.Call ctx (reference ActualExtractPrep126.allocated)
    (KeygenRngSource.bytes 7) (.uint64 8) (reference extracted) := by
  unfold extracted
  rw [C99CompactState115.reference_heap ActualExtractPrep126.allocated finalState.heap]
  refine .run (reference finalState) ?_
  have source := body
  change Exec ctx ShakeExtractSource.code
    (reference (ShakeExtractInvoke120.entry ActualExtractPrep126.allocated (KeygenRngSource.bytes 7) (.u64 8))) _ at source
  rw [ShakeExtractInvoke120.entry_bound] at source
  exact source

end FT1536.Source3.ActualExtractBody126
