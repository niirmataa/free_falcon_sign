import Source3.KeygenResultantInit130
import Source3.KeygenWordEndpoints130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenResultantRun130
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)

def profileWord (before : State) : Option (BitVec 32) := do
  let value ← C99CompactScalar115.evaluate noCalls before.locals (.var "logn".toList)
  match value with | .u32 word => some word | _ => none

theorem profile_sound (before : State) (word : BitVec 32)
    (computed : profileWord before=some word) :
    C99ArrayReference.scalar (reference before) (.var "logn".toList) (.uint32 word) := by
  obtain ⟨value,evaluated,rest⟩ := Option.bind_eq_some_iff.mp computed
  cases value with
  | u64 actual => cases rest
  | i64 actual => cases rest
  | i32 actual => cases rest
  | u32 actual =>
      have same := Option.some.inj rest
      subst word
      exact C99CompactScalar115.evaluate_sound FprPrefixCalls.calls noCalls
        (C99CompactPointer115.noCalls_sound _) before.locals (.var "logn".toList) (.u32 actual) evaluated

def run (fuel block : Nat) (before : State) (args : List C99ArrayReference.Arg) : Option (State×B20.C.Val) := do
  let bound ← C99CompactBinding115.bind noCalls before KeygenResultantSource.params args
  if C99FiniteAllocation115.fresh bound.heap block then
    let ready ← KeygenScalarCompute121.run 16 KeygenResultantSource.setup (KeygenResultantInit130.entry bound block)
    if KeygenResultantInit130.ZeroGuard ready block then
      let packed ← KeygenWordEndpoints130.normal fuel KeygenResultantSource.packing (KeygenResultantInit130.zeroed ready block)
      let word ← profileWord packed
      let reduced ← KeygenWordEndpoints130.normal fuel (KeygenResultantSource.switchCode word) packed
      let (last,value) ← KeygenWordEndpoints130.returned fuel KeygenResultantSource.tailCode reduced
      pure ({before with heap := C99FiniteAllocation115.restore before.heap last.heap block},B20.C.cast .u32 value)
    else none
  else none

end FT1536.Source3.KeygenResultantRun130
