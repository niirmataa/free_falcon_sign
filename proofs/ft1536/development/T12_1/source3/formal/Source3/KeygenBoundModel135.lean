import Source3.FprBoundCalls135
import Source3.C99ScalarCompute130
import Source3.KeygenSearchExtended133
import Source3.C99CompactState115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBoundModel135
open B20.C (Val)
open C99CompactCells115 (Locals)
open C99ValueBridge (value)

def wordOnly (result : Option Val) : Option Val := do
  match ← result with
  | .u64 word => some (.u64 word)
  | _ => none

def calls (name : B20.C.Name) (args : List Val) : Option Val :=
  if name="fpr_of".toList then
    match args with
    | [arg] => wordOnly (FprBoundCalls135.ofModel arg)
    | _ => none
  else if name="fpr_sqrt".toList then
    match args with
    | [arg] => FprSqrtCompute132.execute GeneratedSqrt132.code 55 arg
    | _ => none
  else if name="fpr_mul".toList then
    match args with
    | [x,y] =>
        match x,y with
        | .u64 x,.u64 y => wordOnly (FprPrimitives.execute FprAST.mulCode [.u64 x,.u64 y])
        | _,_ => none
    | _ => none
  else if name="fpr_div".toList then
    match args with
    | [x,y] =>
        match x,y with
        | .u64 x,.u64 y => wordOnly (FprPrimitives.execute FprAST.divCode [.u64 x,.u64 y])
        | _,_ => none
    | _ => none
  else none

def eval (mc : B20.C.Scalar.Calls) (locals : Locals) : KeygenSearchExec.Expr → Option Val
  | .base (.scalar expr) => C99ScalarCompute130.evaluate locals expr
  | .unary name arg => do mc name [← eval mc locals arg]
  | .binary name left right => do mc name [← eval mc locals left,← eval mc locals right]
  | .cast ty expr => do
      let x ← eval mc locals expr
      pure (C99ValueBridge.encode (C99IntegerReference.convert ty (value x).integer))
  | _ => none

def assign (mc : B20.C.Scalar.Calls) (before : C99CompactState115.State) (name : B20.C.Name) (expr : KeygenSearchExec.Expr) : Option C99CompactState115.State := do
  let cell ← C99NameMap115.lookup before.locals name
  let out ← eval mc before.locals expr
  pure (C99CompactState115.bindValue before name cell.ty out)

def run (mc : B20.C.Scalar.Calls) : Nat → KeygenSearchExec.Stmt → C99CompactState115.State → Option C99CompactState115.State
  | 0, _, _ => none
  | _+1, .procedure (.base .skip), before => some before
  | _+1, .assign name expr, before => assign mc before name expr
  | fuel+1, .seq first second, before => do run mc fuel second (← run mc fuel first before)
  | _, _, _ => none

end FT1536.Source3.KeygenBoundModel135
