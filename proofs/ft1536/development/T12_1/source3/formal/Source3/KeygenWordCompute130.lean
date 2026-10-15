import Source3.C99Read16Compute130
import Source3.KeygenWordExec
import Source3.KeygenScalarCompute121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordCompute130
open C99CompactState115 (State)
open C99CompactPointer115 (noCalls)
open KeygenWordExpr (Expr)
open B20.C (Val)

/-- Checked finite word expressions. Unsupported calls produce no certificate;
    arithmetic remains the existing UB-aware model, not host arithmetic. -/
def evaluate (before : State) : Expr → Option Val
  | .scalar expr => C99CompactScalar115.evaluate noCalls before.locals expr
  | .load32 name index => do
      let pointer ← C99CompactPointer115.pointer noCalls before name index
      (C99FiniteRead114.read32 before.heap pointer).map Val.u32
  | .load16 name index => do
      let pointer ← C99CompactPointer115.pointer noCalls before name index
      (C99Read16Compute130.read before.heap pointer).map (fun word => Val.i32 (BitVec.ofInt 32 word.toInt))
  | .cast ty expr => (evaluate before expr).map (B20.C.cast (C99CompactBinding115.modelType ty))
  | .neg expr => (evaluate before expr).bind B20.C.neg
  | .bitNot expr => (evaluate before expr).map B20.C.notBits
  | .lnot expr => (evaluate before expr).map (fun value => CLogic.boolean (decide (value.integer=0)))
  | .bin op left right => do
      let x ← evaluate before left
      let y ← evaluate before right
      B20.C.bin op x y
  | .cmp op left right => do
      let x ← evaluate before left
      let y ← evaluate before right
      pure (CLogic.compare op x y)
  | .land left right => do
      let x ← evaluate before left
      if x.integer=0 then pure (CLogic.boolean false)
      else (evaluate before right).map (fun y => CLogic.boolean (decide (y.integer≠0)))
  | .lor left right => do
      let x ← evaluate before left
      if x.integer=0 then (evaluate before right).map (fun y => CLogic.boolean (decide (y.integer≠0)))
      else pure (CLogic.boolean true)
  | .call1 _ _ | .call2 _ _ _ | .call3 _ _ _ _ | .call4 _ _ _ _ _ | .call5 _ _ _ _ _ _ => none

end FT1536.Source3.KeygenWordCompute130
