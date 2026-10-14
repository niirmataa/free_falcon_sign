import Source3.SelectedSamplerStart126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ActualExtractPrep126
open C99CompactState115 (State reference)
open ShakeExtractSource (Stmt chain)

def ctx := KeygenSamplerContext.rng KeygenCallerData123.env.ctx
def caller := SelectedSamplerStart126.firstRead
def allocated : State := {caller with heap := C99FiniteAllocation115.allocate caller.heap 7 8}
def entered := ShakeExtractInvoke120.entry allocated (KeygenRngSource.bytes 7) (.u64 8)

theorem fresh : KeygenRngSource.Fresh (reference caller).heap 7 :=
  (C99FiniteAllocation115.fresh_iff caller.heap 7).mp (by decide +kernel)

def headStatements : List Stmt := [
  .declarePointer "buf".toList,.scalar (.declare .u64 ["dptr".toList,"rate".toList]),
  .pointer "buf".toList "out".toList ShakeExtractSource.zero,
  .fieldRead "dptr".toList .dptr,.fieldRead "rate".toList .rate]
def headResult := ShakeExtractRun120.run ctx 64 (chain headStatements) entered
theorem head_defined : headResult.isSome=true := by decide +kernel
def headed : State := headResult.get head_defined
theorem head_computed : ShakeExtractRun120.run ctx 64 (chain headStatements) entered=some headed :=
  SelectedInput124.option_get headResult head_defined
theorem head_source : ShakeExtractSource.Exec ctx (chain headStatements) (reference entered) (reference headed) :=
  ShakeExtractRun120.run_sound ctx 64 _ entered headed head_computed

def loopCondition : CLogic.Expr := .cmp .gt (.var "len".toList) (.literal .i32 0)
theorem loop_guard_computed : ShakeBlockComputeRead116.evaluate headed loopCondition=some (.i32 1) := by decide +kernel

def declaration : Stmt := .scalar (.declare .u64 ["clen".toList])
def declarationResult := ShakeExtractRun120.run ctx 16 declaration headed
theorem declaration_defined : declarationResult.isSome=true := by decide +kernel
def iterationStart : State := declarationResult.get declaration_defined
theorem declaration_computed : ShakeExtractRun120.run ctx 16 declaration headed=some iterationStart :=
  SelectedInput124.option_get declarationResult declaration_defined
theorem declaration_source : ShakeExtractSource.Exec ctx declaration (reference headed) (reference iterationStart) :=
  ShakeExtractRun120.run_sound ctx 16 _ headed iterationStart declaration_computed

def refillCondition : CLogic.Expr := .cmp .eq (.var "dptr".toList) (.var "rate".toList)
theorem refill_guard_computed : ShakeBlockComputeRead116.evaluate iterationStart refillCondition=some (.i32 1) := by decide +kernel

def refillHead : List Stmt := [
  .declarePointer "dbuf".toList,.declarePointer "A".toList,
  .fieldPointer "A".toList .a,.fieldPointer "dbuf".toList .dbuf]
def processResult := ShakeExtractRun120.run ctx 64 (chain refillHead) iterationStart
theorem process_defined : processResult.isSome=true := by decide +kernel
def processBefore : State := processResult.get process_defined
theorem process_computed : ShakeExtractRun120.run ctx 64 (chain refillHead) iterationStart=some processBefore :=
  SelectedInput124.option_get processResult process_defined
theorem process_head_source : ShakeExtractSource.Exec ctx (chain refillHead) (reference iterationStart) (reference processBefore) :=
  ShakeExtractRun120.run_sound ctx 64 _ iterationStart processBefore process_computed

def aPointer := ShakeExtractSource.field ctx .a
def rcPointer := KeygenCallerData123.rcPointer
def blockEntry := ShakeProcessCompute116.entry processBefore aPointer rcPointer

end FT1536.Source3.ActualExtractPrep126
