import Source3.GeneratedResultantSyntax130
import Source3.KeygenResultantRunSound130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenResultantCached130
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open KeygenResultantRun130 (profileWord)

def run (fuel block : Nat) (before : State) (args : List C99ArrayReference.Arg) : Option (State×B20.C.Val) := do
  let bound ← C99CompactBinding115.bind noCalls before KeygenResultantSource.params args
  if C99FiniteAllocation115.fresh bound.heap block then
    let ready ← C99ScalarSteps130.run 16 GeneratedResultantSyntax130.setup (KeygenResultantInit130.entry bound block)
    if KeygenResultantInit130.ZeroGuard ready block then
      let packed ← KeygenWordEndpoints130.normal fuel GeneratedResultantSyntax130.packing (KeygenResultantInit130.zeroed ready block)
      let word ← profileWord packed
      let reduced ← KeygenWordEndpoints130.normal fuel (GeneratedResultantSyntax130.reduction word) packed
      let (last,value) ← KeygenWordEndpoints130.returned fuel GeneratedResultantSyntax130.ending reduced
      pure ({before with heap := C99FiniteAllocation115.restore before.heap last.heap block},B20.C.cast .u32 value)
    else none
  else none


/-- Exact code identity, not a refinement premise or alternative algorithm. -/
theorem run_eq (fuel block : Nat) (before : State) (args : List C99ArrayReference.Arg) :
    run fuel block before args=KeygenResultantRun130.run fuel block before args := by
  unfold run KeygenResultantRun130.run
  simp only [← GeneratedResultantSyntax130.setup_eq,← GeneratedResultantSyntax130.packing_eq,
    ← GeneratedResultantSyntax130.reduction_eq,← GeneratedResultantSyntax130.ending_eq]

theorem sound (fuel block : Nat) (before after : State) (args : List C99ArrayReference.Arg)
    (outValue : B20.C.Val) (computed : run fuel block before args=some (after,outValue)) :
    KeygenResultantSource.Call (reference before) args (reference after) (C99ValueBridge.value outValue) := by
  rw [run_eq] at computed
  exact KeygenResultantRunSound130.sound fuel block before after args outValue computed

end FT1536.Source3.KeygenResultantCached130
