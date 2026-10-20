import B20.C.Scalar

/- Project Niirmata; pinned Falcon Project / Thomas Pornin source is kept
with its original licence. Extension of the P02 integer C fragment with
comparisons and actual short-circuit Boolean evaluation. No floating-point
rounding rule, whole-function correctness or KeyGen postcondition is an
axiom of this semantics. Unsupported/undefined evaluation returns none. -/
namespace FT1536.Source3.CLogic
open B20.C

inductive Cmp where
  | eq | ne | lt | le | gt | ge
  deriving DecidableEq, Repr

def boolean (b : Bool) : Val := .i32 (if b then 1#32 else 0#32)
def truth (v : Val) : Bool := decide (v.integer≠0)

theorem truth_boolean (b : Bool) : truth (boolean b)=b := by
  cases b <;> rfl

def compare (op : Cmp) (x y : Val) : Val :=
  let ty:=commonTy x.ty y.ty
  let a:=B20.C.cast ty x
  let b:=B20.C.cast ty y
  boolean (match op with
    | .eq => decide (a=b)
    | .ne => decide (a≠b)
    | .lt => decide (a.integer<b.integer)
    | .le => decide (a.integer≤b.integer)
    | .gt => decide (b.integer<a.integer)
    | .ge => decide (b.integer≤a.integer))

theorem equal_u64 (x y : BitVec 64) : compare .eq (.u64 x) (.u64 y)=boolean (x==y) := by
  simp only [compare,commonTy,Val.ty,B20.C.cast,Val.u64.injEq,Bool.beq_eq_decide_eq]

theorem ne_u64 (x y : BitVec 64) : compare .ne (.u64 x) (.u64 y)=boolean (x != y) := by
  simp only [compare,commonTy,Val.ty,B20.C.cast,ne_eq,Val.u64.injEq,bne_eq,Bool.beq_eq_decide_eq,decide_not]

inductive Expr where
  | literal (ty : Ty) (n : Nat)
  | var (name : B20.C.Name)
  | cast (ty : Ty) (arg : Expr)
  | neg (arg : Expr)
  | bitNot (arg : Expr)
  | bin (op : BinOp) (left right : Expr)
  | cmp (op : Cmp) (left right : Expr)
  | land (left right : Expr)
  | lor (left right : Expr)
  | lnot (arg : Expr)
  | call1 (name : B20.C.Name) (arg : Expr)
  | call2 (name : B20.C.Name) (arg1 arg2 : Expr)
  | call3 (name : B20.C.Name) (arg1 arg2 arg3 : Expr)
  deriving DecidableEq, Repr

/- Fuel decreases at every expression edge. Calls here are pure word
callees; helpers with memory effects need their separate heap semantics. -/
def eval (calls : B20.C.Scalar.Calls) (env : Env) : Nat → Expr → Option Val
  | 0,_ => none
  | _+1,.literal ty n => some (literalValue ty n)
  | _+1,.var name => env name
  | fuel+1,.cast ty arg => (eval calls env fuel arg).map (B20.C.cast ty)
  | fuel+1,.neg arg => (eval calls env fuel arg).bind B20.C.neg
  | fuel+1,.bitNot arg => (eval calls env fuel arg).map notBits
  | fuel+1,.bin op a b => do B20.C.bin op (← eval calls env fuel a) (← eval calls env fuel b)
  | fuel+1,.cmp op a b => do pure (compare op (← eval calls env fuel a) (← eval calls env fuel b))
  | fuel+1,.land a b => do
      let x ← eval calls env fuel a
      if truth x then (eval calls env fuel b).map (boolean ∘ truth) else pure (boolean false)
  | fuel+1,.lor a b => do
      let x ← eval calls env fuel a
      if truth x then pure (boolean true) else (eval calls env fuel b).map (boolean ∘ truth)
  | fuel+1,.lnot a => (eval calls env fuel a).map (fun v => boolean (!truth v))
  | fuel+1,.call1 name arg => do calls name [← eval calls env fuel arg]
  | fuel+1,.call2 name a b => do calls name [← eval calls env fuel a, ← eval calls env fuel b]
  | fuel+1,.call3 name a b c => do calls name [← eval calls env fuel a, ← eval calls env fuel b, ← eval calls env fuel c]

inductive Stmt where
  | declare (ty : Ty) (names : List B20.C.Name)
  | assign (name : B20.C.Name) (expr : Expr)
  | update (name : B20.C.Name) (op : BinOp) (expr : Expr)
  | ret (expr : Expr)
  deriving DecidableEq, Repr

def step (calls : B20.C.Scalar.Calls) (s : B20.C.Scalar.State) : Stmt → Option B20.C.Scalar.State
  | .declare ty names => B20.C.Scalar.declareMany s ty names
  | .assign name expr => do B20.C.Scalar.assign s name (← eval calls s.values 32 expr)
  | .update name op expr => do
      B20.C.Scalar.assign s name (← B20.C.bin op (← s.values name) (← eval calls s.values 32 expr))
  | .ret _ => none

def evalBody (calls : B20.C.Scalar.Calls) (result : Ty) : List Stmt → B20.C.Scalar.State → Option Val
  | [],_ => none
  | .ret expr::_,s => (eval calls s.values 32 expr).map (B20.C.cast result)
  | stmt::rest,s => do evalBody calls result rest (← step calls s stmt)

structure Function where
  name : B20.C.Name
  result : Ty
  params : List (Ty × B20.C.Name)
  body : List Stmt
  deriving DecidableEq, Repr

def execute (calls : B20.C.Scalar.Calls) (f : Function) (args : List Val) : Option Val := do
  evalBody calls f.result f.body (← B20.C.Scalar.bindArgs f.params args)

def CExec (calls : B20.C.Scalar.Calls) (f : Function) (args : List Val) (out : Val) : Prop :=
  execute calls f args=some out

theorem deterministic (calls : B20.C.Scalar.Calls) (f : Function) (args : List Val) (x y : Val)
    (hx : CExec calls f args x) (hy : CExec calls f args y) : x=y := Option.some.inj (hx.symm.trans hy)

theorem short_circuit_and (calls : B20.C.Scalar.Calls) (env : Env) (fuel : Nat) (a b : Expr) (x : Val)
    (ha : eval calls env fuel a=some x) (hx : truth x=false) :
    eval calls env (fuel+1) (.land a b)=some (boolean false) := by
  simp [eval,ha,hx]

theorem short_circuit_or (calls : B20.C.Scalar.Calls) (env : Env) (fuel : Nat) (a b : Expr) (x : Val)
    (ha : eval calls env fuel a=some x) (hx : truth x=true) :
    eval calls env (fuel+1) (.lor a b)=some (boolean true) := by
  simp [eval,ha,hx]

end FT1536.Source3.CLogic

#print axioms FT1536.Source3.CLogic.deterministic
#print axioms FT1536.Source3.CLogic.short_circuit_and
#print axioms FT1536.Source3.CLogic.short_circuit_or
