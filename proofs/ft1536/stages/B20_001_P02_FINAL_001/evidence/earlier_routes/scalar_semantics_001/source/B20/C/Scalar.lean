import B20.C.Integer

namespace B20.C.Scalar

inductive Expr where
  | literal (ty : Ty) (n : Nat)
  | var (name : Name)
  | cast (ty : Ty) (arg : Expr)
  | neg (arg : Expr)
  | bitNot (arg : Expr)
  | bin (op : BinOp) (left right : Expr)
  | call (name : Name) (args : List Expr)
  deriving DecidableEq, Repr

abbrev Calls := Name → List Val → Option Val

def evalExpr (calls : Calls) (env : Env) : Nat → Expr → Option Val
  | 0, _ => none
  | _ + 1, .literal ty n => some (literalValue ty n)
  | _ + 1, .var name => env name
  | fuel + 1, .cast ty arg => (evalExpr calls env fuel arg).map (cast ty)
  | fuel + 1, .neg arg => (evalExpr calls env fuel arg).bind B20.C.neg
  | fuel + 1, .bitNot arg => (evalExpr calls env fuel arg).map notBits
  | fuel + 1, .bin op a b => do
    B20.C.bin op (← evalExpr calls env fuel a) (← evalExpr calls env fuel b)
  | fuel + 1, .call name args => do
    calls name (← args.mapM (evalExpr calls env fuel))

inductive Stmt where
  | declare (ty : Ty) (names : List Name)
  | assign (name : Name) (expr : Expr)
  | update (name : Name) (op : BinOp) (expr : Expr)
  | ret (expr : Expr)
  deriving DecidableEq, Repr

structure State where
  types : Name → Option Ty
  values : Env

def emptyState : State := ⟨fun _ => none, fun _ => none⟩

def declareOne (s : State) (ty : Ty) (name : Name) : Option State :=
  if (s.types name).isSome then none else
    some { s with types := fun x => if x = name then some ty else s.types x }

def declareMany : State → Ty → List Name → Option State
  | s, _, [] => some s
  | s, ty, name :: names => do declareMany (← declareOne s ty name) ty names

def assign (s : State) (name : Name) (v : Val) : Option State := do
  let ty ← s.types name
  pure { s with values := update s.values name (cast ty v) }

def step (calls : Calls) (s : State) : Stmt → Option State
  | .declare ty names => declareMany s ty names
  | .assign name expr => do assign s name (← evalExpr calls s.values 32 expr)
  | .update name op expr => do
    assign s name (← bin op (← s.values name) (← evalExpr calls s.values 32 expr))
  | .ret _ => none

def evalBody (calls : Calls) (result : Ty) : List Stmt → State → Option Val
  | [], _ => none
  | .ret expr :: _, s => (evalExpr calls s.values 32 expr).map (cast result)
  | stmt :: rest, s => do evalBody calls result rest (← step calls s stmt)

structure Function where
  name : Name
  result : Ty
  params : List (Ty × Name)
  body : List Stmt
  deriving DecidableEq, Repr

def bindArgs : List (Ty × Name) → List Val → Option State
  | [], [] => some emptyState
  | (ty, name) :: ps, value :: args => do
    let s ← bindArgs ps args
    let declared ← declareOne s ty name
    assign declared name value
  | _, _ => none

def execute (calls : Calls) (f : Function) (args : List Val) : Option Val := do
  evalBody calls f.result f.body (← bindArgs f.params args)

/-- `none` is a rejected/undefined model execution, not a C return0.
The expression depth32 is a syntactic evaluation bound; successful concrete
refinements must establish it for their own parsed ASTs. -/
def CExec (calls : Calls) (f : Function) (args : List Val) (result : Val) : Prop :=
  execute calls f args = some result

theorem CExec_deterministic (calls : Calls) (f : Function) (args : List Val) (x y : Val)
    (hx : CExec calls f args x) (hy : CExec calls f args y) : x = y :=
  Option.some.inj (hx.symm.trans hy)

end B20.C.Scalar
