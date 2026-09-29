import Mathlib.Basic.Logic.Basic
import Init.Data.BitVec.Lemmas

/-! A deliberately bounded C fragment. Signed shifts and representation are
the GCC LP64 two's-complement/arithmetic-right-shift model. No floating point,
compiler correctness, preprocessing, memory, or arbitrary C front end is
asserted here. Unsupported syntax fails parsing; ill-typed expressions fail
evaluation; invalid shift counts and signed negation overflow are rejected. -/
namespace B20.C

abbrev Name := List Char

inductive Ty where
  | u64 | i64 | i32 | u32
  deriving DecidableEq, Repr

inductive Val where
  | u64 (bits : BitVec 64)
  | i64 (bits : BitVec 64)
  | i32 (bits : BitVec 32)
  | u32 (bits : BitVec 32)
  deriving DecidableEq, Repr

def Val.ty : Val → Ty
  | .u64 _ => .u64
  | .i64 _ => .i64
  | .i32 _ => .i32
  | .u32 _ => .u32

def cast (ty : Ty) : Val → Val
  | .u64 x => match ty with
    | .u64 => .u64 x
    | .i64 => .i64 x
    | .i32 => .i32 (x.setWidth 32)
    | .u32 => .u32 (x.setWidth 32)
  | .i64 x => match ty with
    | .u64 => .u64 x
    | .i64 => .i64 x
    | .i32 => .i32 (x.setWidth 32)
    | .u32 => .u32 (x.setWidth 32)
  | .i32 x => match ty with
    | .u64 => .u64 (x.signExtend 64)
    | .i64 => .i64 (x.signExtend 64)
    | .i32 => .i32 x
    | .u32 => .u32 x
  | .u32 x => match ty with
    | .u64 => .u64 (x.setWidth 64)
    | .i64 => .i64 (x.setWidth 64)
    | .i32 => .i32 x
    | .u32 => .u32 x

inductive BinOp where
  | xor | band | bor | shr | shl
  | add | sub | mul
  deriving DecidableEq, Repr

inductive Expr where
  | literal (n : Nat)
  | var (name : Name)
  | cast (ty : Ty) (arg : Expr)
  | neg (arg : Expr)
  | bin (op : BinOp) (left right : Expr)
  deriving DecidableEq, Repr

inductive Stmt where
  | assign (name : Name) (value : Expr)
  | xorAssign (name : Name) (value : Expr)
  | ret (value : Expr)
  deriving DecidableEq, Repr

structure Function where
  result : Ty
  name : Name
  params : List (Ty × Name)
  body : List Stmt
  deriving DecidableEq, Repr

abbrev Env := Name → Option Val

def neg : Val → Option Val
  | .u64 x => some (.u64 (-x))
  | .i64 x => if x = 0x8000000000000000 then none else some (.i64 (-x))
  | .i32 x => if x = 0x80000000 then none else some (.i32 (-x))
  | .u32 x => some (.u32 (-x))

/-- The usual arithmetic conversion for the three supported integer types. -/
def commonTy : Ty → Ty → Ty
  | .u64, _ | _, .u64 => .u64
  | .i64, _ | _, .i64 => .i64
  | .u32, _ | _, .u32 => .u32
  | .i32, .i32 => .i32

def bitsOp (op : BinOp) (x y : BitVec n) : Option (BitVec n) :=
  match op with
  | .xor => some (x ^^^ y)
  | .band => some (x &&& y)
  | .bor => some (x ||| y)
  | .add => some (x + y)
  | .sub => some (x - y)
  | .mul => some (x * y)
  | _ => none

def shift (op : BinOp) (left : Val) (count : BitVec 32) : Option Val :=
  let n := count.toNat
  match left with
  | .u64 x => if n < 64 then
      if op = .shr then some (.u64 (x >>> n))
      else if op = .shl then some (.u64 (x <<< n)) else none
    else none
  | .i64 x => if n < 64 ∧ op = .shr then some (.i64 (x.sshiftRight n)) else none
  | .i32 x => if n < 32 ∧ op = .shr then some (.i32 (x.sshiftRight n)) else none
  | .u32 x => if n < 32 then
      if op = .shr then some (.u32 (x >>> n))
      else if op = .shl then some (.u32 (x <<< n)) else none
    else none

def signedSafe (op : BinOp) (x y : BitVec n) : Bool :=
  let z := match op with
    | .add => x.toInt + y.toInt
    | .sub => x.toInt - y.toInt
    | .mul => x.toInt * y.toInt
    | _ => 0
  decide (-(2^(n-1) : Int) ≤ z ∧ z < 2^(n-1))

def signedBitsOp (op : BinOp) (x y : BitVec n) : Option (BitVec n) :=
  if signedSafe op x y then bitsOp op x y else none

def bin (op : BinOp) (x y : Val) : Option Val :=
  if op = .shr ∨ op = .shl then
    match y with
    | .i32 n => shift op x n
    | .u32 n => shift op x n
    | _ => none
  else
    let ty := commonTy x.ty y.ty
    match cast ty x, cast ty y with
    | .u64 a, .u64 b => (bitsOp op a b).map Val.u64
    | .i64 a, .i64 b => (signedBitsOp op a b).map Val.i64
    | .i32 a, .i32 b => (signedBitsOp op a b).map Val.i32
    | .u32 a, .u32 b => (bitsOp op a b).map Val.u32
    | _, _ => none

def evalExpr (env : Env) : Expr → Option Val
  | .literal n => if n < 2147483648 then some (.i32 (BitVec.ofNat 32 n)) else none
  | .var name => env name
  | .cast ty arg => (evalExpr env arg).map (cast ty)
  | .neg arg => (evalExpr env arg).bind neg
  | .bin op l r => do bin op (← evalExpr env l) (← evalExpr env r)

def update (env : Env) (name : Name) (v : Val) : Env :=
  fun other => if other = name then some v else env other

/-- Assignment preserves the declared destination type. -/
def assign (env : Env) (name : Name) (value : Val) : Option Env := do
  let old ← env name
  pure (update env name (cast old.ty value))

def evalBody (result : Ty) : List Stmt → Env → Option Val
  | [], _ => none
  | .ret e :: _, env => (evalExpr env e).map (cast result)
  | .assign name e :: tail, env => do
    evalBody result tail (← assign env name (← evalExpr env e))
  | .xorAssign name e :: tail, env => do
    let v ← bin .xor (← env name) (← evalExpr env e)
    evalBody result tail (← assign env name v)

def bindArgs : List (Ty × Name) → List Val → Option Env
  | [], [] => some (fun _ => none)
  | (ty, name) :: ps, v :: vs => do
    let env ← bindArgs ps vs
    pure (update env name (cast ty v))
  | _, _ => none

def execute (f : Function) (args : List Val) : Option Val := do
  evalBody f.result f.body (← bindArgs f.params args)

/-- Successful, defined execution in this C integer fragment. `none` never
denotes a C return value. Fault classification beyond this fragment is open. -/
def CExec (f : Function) (args : List Val) (result : Val) : Prop :=
  execute f args = some result

theorem CExec_deterministic (f : Function) (args : List Val) (x y : Val)
    (hx : CExec f args x) (hy : CExec f args y) : x = y := by
  exact Option.some.inj (hx.symm.trans hy)

end B20.C
