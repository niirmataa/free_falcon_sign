import Source3.ActualProcess126
import Source3.ShakeExtractFragments126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ActualExtractTail126
open C99CompactState115 (State reference)
open ShakeExtractSource (Stmt chain)
open ActualExtractPrep126 (ctx)

def refillTail : List Stmt := (List.range 25).map ShakeExtractSource.enc ++
  [.scalar (.assign "dptr".toList (.literal .i32 0))]
def refillResult := ShakeExtractRun120.run ctx 256 (chain refillTail) ActualProcess126.after
theorem refill_defined : refillResult.isSome=true := by decide +kernel
def refillRaw : State := refillResult.get refill_defined
theorem refill_computed : ShakeExtractRun120.run ctx 256 (chain refillTail) ActualProcess126.after=some refillRaw :=
  SelectedInput124.option_get refillResult refill_defined
theorem refill_tail_source : ShakeExtractSource.Exec ctx (chain refillTail) (reference ActualProcess126.after) (reference refillRaw) :=
  ShakeExtractRun120.run_sound ctx 256 _ ActualProcess126.after refillRaw refill_computed

def refilled := C99CompactState115.restoreScope ActualExtractPrep126.iterationStart refillRaw [] ["dbuf".toList,"A".toList]

theorem process_call : ShakeExtractSource.Exec ctx (.process "A".toList)
    (reference ActualExtractPrep126.processBefore) (reference ActualProcess126.after) :=
  .process "A".toList _ _ ActualExtractPrep126.aPointer
    (C99CompactPointer115.pointer_sound C99CompactPointer115.noCalls (C99CompactPointer115.noCalls_sound _)
      ActualExtractPrep126.processBefore "A".toList ShakeExtractSource.zero ActualExtractPrep126.aPointer (by decide +kernel))
    ActualProcess126.source_process

theorem refill_source : ShakeExtractSource.Exec ctx ShakeExtractSource.refill
    (reference ActualExtractPrep126.iterationStart) (reference refilled) := by
  unfold refilled
  rw [C99CompactState115.reference_restoreScope]
  apply ShakeExtractSource.Exec.scope [] ["dbuf".toList,"A".toList] _
    (reference ActualExtractPrep126.iterationStart) (reference refillRaw)
  change ShakeExtractSource.Exec ctx (chain (ActualExtractPrep126.refillHead ++ .process "A".toList::refillTail)) _ _
  exact ShakeExtractFragments126.append ctx _ _ _ _ _ ActualExtractPrep126.process_head_source
    (.seq _ _ _ (reference ActualProcess126.after) _ process_call refill_tail_source)

def iterationTail : List Stmt := [
  .scalar (.assign "clen".toList (.bin .sub (.var "rate".toList) (.var "dptr".toList))),
  .branch (.cmp .gt (.var "clen".toList) (.var "len".toList))
    (.scope [] [] (chain [.scalar (.assign "clen".toList (.var "len".toList))])) .skip,
  .copy "buf".toList (.var "dptr".toList) (.var "clen".toList),
  .scalar (.update "dptr".toList .add (.var "clen".toList)),
  .pointer "buf".toList "buf".toList (.var "clen".toList),
  .scalar (.update "len".toList .sub (.var "clen".toList))]
def iterationResult := ShakeExtractRun120.run ctx 128 (chain iterationTail) refilled
theorem iteration_defined : iterationResult.isSome=true := by decide +kernel
def iterationRaw : State := iterationResult.get iteration_defined
theorem iteration_computed : ShakeExtractRun120.run ctx 128 (chain iterationTail) refilled=some iterationRaw :=
  SelectedInput124.option_get iterationResult iteration_defined
theorem iteration_tail_source : ShakeExtractSource.Exec ctx (chain iterationTail) (reference refilled) (reference iterationRaw) :=
  ShakeExtractRun120.run_sound ctx 128 _ refilled iterationRaw iteration_computed

def iterationDone := C99CompactState115.restoreScope ActualExtractPrep126.headed iterationRaw ["clen".toList] []

end FT1536.Source3.ActualExtractTail126
