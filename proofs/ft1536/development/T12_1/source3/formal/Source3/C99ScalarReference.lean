import Source3.C99IntegerReference

/- Unbounded natural semantics for the value-only C99 closure of FPEMU.
   Provenance: author formalization of C99 6.5 (expressions/sequence points),
   6.5.2.2 (calls), 6.7 (declarations), 6.8.2 (block), 6.8.5 (iteration),
   6.8.6.4 (return), with the GCC/LP64 integer choices in the companion file.
   Arguments here are scalar values: an expression cannot name or write a
   caller-owned object. The pointer-taking helper needs its own reference
   memory/control judgment; it is not defined by this value-only module.
   The definitions below DO NOT use B20/CLogic/FprPrimitives evaluators. -/
namespace FT1536.Source3.C99ScalarReference
open C99IntegerReference
abbrev Name := List Char

inductive Expr where
  | literal (ty : Ty) (n : Nat)
  | variable (name : Name)
  | cast (ty : Ty) (expr : Expr)
  | neg (expr : Expr)
  | complement (expr : Expr)
  | arithmetic (op : Arithmetic) (left right : Expr)
  | bitwise (op : Bitwise) (left right : Expr)
  | shift (op : Shift) (left right : Expr)
  | compare (op : Comparison) (left right : Expr)
  | logicalNot (expr : Expr)
  | logicalAnd (left right : Expr)
  | logicalOr (left right : Expr)
  | call1 (name : Name) (a : Expr)
  | call2 (name : Name) (a b : Expr)
  | call3 (name : Name) (a b c : Expr)

abbrev Env := Name → Option (Ty × Option Value)
def set (env : Env) (name : Name) (cell : Ty × Option Value) : Env :=
  fun other => if other=name then some cell else env other
def boolean (b : Bool) : Value := .int32 (if b then 1#32 else 0#32)

/- A call relation is an explicit semantic parameter of generic expression
   metatheorems. A final source theorem must instantiate it from FunctionExec
   on the pinned function table, rather than postulating its outputs. -/
abbrev CallRelation := Name → List Value → Value → Prop

inductive Eval (calls : CallRelation) (env : Env) : Expr → Value → Prop where
  | literal (t : Ty) (n : Nat) : Eval calls env (.literal t n) (convert t n)
  | variable (name : Name) (ty : Ty) (v : Value)
      (bound : env name=some (ty,some v)) : Eval calls env (.variable name) v
  | cast (t : Ty) (e : Expr) (v : Value) (h : Eval calls env e v) :
      Eval calls env (.cast t e) (convert t v.integer)
  | neg (e : Expr) (v z : Value) (h : Eval calls env e v) (op : NegExec v z) :
      Eval calls env (.neg e) z
  | complement (e : Expr) (v z : Value) (h : Eval calls env e v) (op : ComplementExec v z) :
      Eval calls env (.complement e) z
  | arithmetic (op : Arithmetic) (a b : Expr) (x y z : Value)
      (ha : Eval calls env a x) (hb : Eval calls env b y) (hop : ArithmeticExec op x y z) :
      Eval calls env (.arithmetic op a b) z
  | bitwise (op : Bitwise) (a b : Expr) (x y z : Value)
      (ha : Eval calls env a x) (hb : Eval calls env b y) (hop : BitwiseExec op x y z) :
      Eval calls env (.bitwise op a b) z
  | shift (op : Shift) (a b : Expr) (x y z : Value)
      (ha : Eval calls env a x) (hb : Eval calls env b y) (hop : ShiftExec op x y z) :
      Eval calls env (.shift op a b) z
  | compare (op : Comparison) (a b : Expr) (x y z : Value)
      (ha : Eval calls env a x) (hb : Eval calls env b y) (hop : CompareExec op x y z) :
      Eval calls env (.compare op a b) z
  | logicalNot (e : Expr) (v : Value) (h : Eval calls env e v) :
      Eval calls env (.logicalNot e) (boolean (decide (v.integer=0)))
  | andFalse (a b : Expr) (v : Value) (h : Eval calls env a v) (hz : v.integer=0) :
      Eval calls env (.logicalAnd a b) (boolean false)
  | andTrue (a b : Expr) (x y : Value) (ha : Eval calls env a x) (hn : x.integer≠0)
      (hb : Eval calls env b y) : Eval calls env (.logicalAnd a b) (boolean (decide (y.integer≠0)))
  | orTrue (a b : Expr) (v : Value) (h : Eval calls env a v) (hn : v.integer≠0) :
      Eval calls env (.logicalOr a b) (boolean true)
  | orFalse (a b : Expr) (x y : Value) (ha : Eval calls env a x) (hz : x.integer=0)
      (hb : Eval calls env b y) : Eval calls env (.logicalOr a b) (boolean (decide (y.integer≠0)))
  | call1 (name : Name) (e : Expr) (a z : Value)
      (he : Eval calls env e a) (hc : calls name [a] z) : Eval calls env (.call1 name e) z
  | call2 (name : Name) (e f : Expr) (a b z : Value)
      (he : Eval calls env e a) (hf : Eval calls env f b) (hc : calls name [a,b] z) :
      Eval calls env (.call2 name e f) z
  | call3 (name : Name) (e f g : Expr) (a b c z : Value)
      (he : Eval calls env e a) (hf : Eval calls env f b) (hg : Eval calls env g c)
      (hc : calls name [a,b,c] z) : Eval calls env (.call3 name e f g) z

/- Ordinary operands and arguments are pure in this scalar fragment. These
   two derived rules make the permitted reverse evaluation order explicit;
   no total order of these side-effect-free evaluations is assumed. -/
theorem arithmetic_right_first (calls : CallRelation) (env : Env)
    (op : Arithmetic) (a b : Expr) (x y z : Value)
    (hb : Eval calls env b y) (ha : Eval calls env a x) (hop : ArithmeticExec op x y z) :
    Eval calls env (.arithmetic op a b) z := Eval.arithmetic op a b x y z ha hb hop

theorem call2_right_first (calls : CallRelation) (env : Env) (name : Name)
    (e f : Expr) (a b z : Value) (hf : Eval calls env f b) (he : Eval calls env e a)
    (hc : calls name [a,b] z) : Eval calls env (.call2 name e f) z :=
  Eval.call2 name e f a b z he hf hc

inductive Stmt where
  | declare (ty : Ty) (name : Name)
  | assign (name : Name) (rhs : Expr)
  | seq (first second : Stmt)
  | block (locals : List Name) (body : Stmt)
  | while (condition : Expr) (body : Stmt)
  | ret (value : Expr)
  | skip

inductive Result where
  | normal (env : Env)
  | returned (v : Value)

def restore (outer inner : Env) (names : List Name) : Env :=
  fun name => if names.contains name then outer name else inner name

inductive Exec (calls : CallRelation) : Env → Stmt → Result → Prop where
  | skip (env : Env) : Exec calls env .skip (.normal env)
  | declare (env : Env) (ty : Ty) (name : Name) :
      Exec calls env (.declare ty name) (.normal (set env name (ty,none)))
  | assign (env : Env) (name : Name) (rhs : Expr) (ty : Ty) (old : Option Value) (v : Value)
      (declared : env name=some (ty,old)) (evaluated : Eval calls env rhs v) :
      Exec calls env (.assign name rhs) (.normal (set env name (ty,some (convert ty v.integer))))
  | seqNormal (env middle : Env) (a b : Stmt) (out : Result)
      (first : Exec calls env a (.normal middle)) (second : Exec calls middle b out) :
      Exec calls env (.seq a b) out
  | seqReturn (env : Env) (a b : Stmt) (v : Value) (first : Exec calls env a (.returned v)) :
      Exec calls env (.seq a b) (.returned v)
  | blockNormal (env inner : Env) (names : List Name) (body : Stmt)
      (h : Exec calls env body (.normal inner)) :
      Exec calls env (.block names body) (.normal (restore env inner names))
  | blockReturn (env : Env) (names : List Name) (body : Stmt) (v : Value)
      (h : Exec calls env body (.returned v)) : Exec calls env (.block names body) (.returned v)
  | whileFalse (env : Env) (cond : Expr) (body : Stmt) (v : Value)
      (evaluated : Eval calls env cond v) (falseValue : v.integer=0) :
      Exec calls env (.while cond body) (.normal env)
  | whileTrue (env middle : Env) (cond : Expr) (body : Stmt) (v : Value) (out : Result)
      (evaluated : Eval calls env cond v) (trueValue : v.integer≠0)
      (iteration : Exec calls env body (.normal middle))
      (rest : Exec calls middle (.while cond body) out) : Exec calls env (.while cond body) out
  | whileReturn (env : Env) (cond : Expr) (body : Stmt) (v z : Value)
      (evaluated : Eval calls env cond v) (trueValue : v.integer≠0)
      (iteration : Exec calls env body (.returned z)) : Exec calls env (.while cond body) (.returned z)
  | ret (env : Env) (e : Expr) (v : Value) (evaluated : Eval calls env e v) :
      Exec calls env (.ret e) (.returned v)

structure Function where
  params : List (Ty × Name)
  result : Ty
  body : Stmt

inductive BindArgs : List (Ty × Name) → List Value → Env → Prop where
  | nil : BindArgs [] [] (fun _ => none)
  | cons (ty : Ty) (name : Name) (ps : List (Ty × Name)) (v : Value) (vs : List Value) (env : Env)
      (h : BindArgs ps vs env) :
      BindArgs ((ty,name)::ps) (v::vs) (set env name (ty,some (convert ty v.integer)))

inductive FunctionExec (calls : CallRelation) (f : Function) : List Value → Value → Prop where
  | call (args : List Value) (locals : Env) (result : Value)
      (parameters : BindArgs f.params args locals)
      (body : Exec calls locals f.body (.returned result)) :
      FunctionExec calls f args (convert f.result result.integer)

end FT1536.Source3.C99ScalarReference

#check FT1536.Source3.C99ScalarReference.FunctionExec
#print axioms FT1536.Source3.C99ScalarReference.arithmetic_right_first
