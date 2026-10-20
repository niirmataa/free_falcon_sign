import Source3.C99ScalarReference
import Source3.C99ValueBridge
import Source3.FprASTBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99Frontend
open C99ScalarReference

def binary (op : B20.C.BinOp) (a b : Expr) : Expr :=
  match op with
  | .add => .arithmetic .plus a b
  | .sub => .arithmetic .minus a b
  | .mul => .arithmetic .times a b
  | .band => .bitwise .and a b
  | .bor => .bitwise .or a b
  | .xor => .bitwise .xor a b
  | .shr => .shift .right a b
  | .shl => .shift .left a b

def comparison : CLogic.Cmp → C99IntegerReference.Comparison
  | .eq => .eq | .ne => .ne | .lt => .lt | .le => .le | .gt => .gt | .ge => .ge

def expression : CLogic.Expr → Expr
  | .literal t n => .literal (C99ValueBridge.type t) n
  | .var name => .variable name
  | .cast t e => .cast (C99ValueBridge.type t) (expression e)
  | .neg e => .neg (expression e)
  | .bitNot e => .complement (expression e)
  | .bin op a b => binary op (expression a) (expression b)
  | .cmp op a b => .compare (comparison op) (expression a) (expression b)
  | .land a b => .logicalAnd (expression a) (expression b)
  | .lor a b => .logicalOr (expression a) (expression b)
  | .lnot e => .logicalNot (expression e)
  | .call1 name a => .call1 name (expression a)
  | .call2 name a b => .call2 name (expression a) (expression b)
  | .call3 name a b c => .call3 name (expression a) (expression b) (expression c)

def declarations (t : C99IntegerReference.Ty) : List Name → Stmt
  | [] => .skip
  | name::rest => .seq (.declare t name) (declarations t rest)

def scalar : CLogic.Stmt → Stmt
  | .declare t names => declarations (C99ValueBridge.type t) names
  | .assign name e => .assign name (expression e)
  | .update name op e => .assign name (binary op (.variable name) (expression e))
  | .ret e => .ret (expression e)

def scalars : List CLogic.Stmt → Stmt
  | [] => .skip
  | s::rest => .seq (scalar s) (scalars rest)

/- Syntax-directed lowering. The reference for-loop is an unbounded while
   with an explicit C int counter/increment; it is NOT a fold over range n.
   Local b is allocated in the body block and goes out of scope each time.
   Option here describes macro PARSING, not definedness of C execution. -/
def lowerBody : (body : List FprPrimitives.Instr) → Option Stmt
  | [] => some .skip
  | .scalar s::rest => do pure (.seq (scalar s) (← lowerBody rest))
  | .norm m e::rest => do
      let expanded ← FprPrimitives.normStatements m e
      pure (.seq (.block (FprPrimitives.scalarDecls expanded) (scalars expanded)) (← lowerBody rest))
  | .forInc i n inner::rest => do
      let body ← lowerBody inner
      let tail ← lowerBody rest
      pure (.seq (.assign i (.literal .int32 0))
        (.seq (.while (.compare .lt (.variable i) (.literal .int32 n))
          (.seq (.block (FprPrimitives.blockDecls inner) body)
            (.assign i (.arithmetic .plus (.variable i) (.literal .int32 1))))) tail))
termination_by body => sizeOf body

def function (f : FprPrimitives.Function) : Option Function := do
  pure ⟨f.params.map (fun (t,name) => (C99ValueBridge.type t,name)),
    C99ValueBridge.type f.result,← lowerBody f.body⟩

def headerFunction (f : CLogic.Function) : Function :=
  ⟨f.params.map (fun (t,name) => (C99ValueBridge.type t,name)),
    C99ValueBridge.type f.result,scalars f.body⟩

/- Function table obtained from kernel-bound M0 ASTs. Completeness of the
   source judgments for this table is a separate theorem, not a hypothesis
   silently attached to these definitions. -/
def lookup (name : Name) : Option Function :=
  if name=['f','p','r','_','a','d','d'] then function FprAST.addCode
  else if name=['f','p','r','_','m','u','l'] then function FprAST.mulCode
  else if name=['f','p','r','_','d','i','v'] then function FprAST.divCode
  else if name=['f','p','r','_','u','l','s','h'] then some (headerFunction FprAST.ulshCode)
  else if name=['f','p','r','_','u','r','s','h'] then some (headerFunction FprAST.urshCode)
  else if name=['F','P','R'] then some (headerFunction FprAST.packCode)
  else none

def noCalls : CallRelation := fun _ _ _ => False
def headerCalls (name : Name) (args : List C99IntegerReference.Value) (result : C99IntegerReference.Value) : Prop :=
  ∃ f, lookup name=some f ∧ C99ScalarReference.FunctionExec noCalls f args result
def primitiveCall (name : Name) (args : List C99IntegerReference.Value) (result : C99IntegerReference.Value) : Prop :=
  ∃ f, lookup name=some f ∧ C99ScalarReference.FunctionExec headerCalls f args result

theorem add_lowered : (function FprAST.addCode).isSome := by
  simp [function,lowerBody,FprAST.addCode,FprAST.norm_binding]
theorem mul_lowered : (function FprAST.mulCode).isSome := by
  simp [function,lowerBody,FprAST.mulCode]
theorem div_lowered : (function FprAST.divCode).isSome := by
  simp [function,lowerBody,FprAST.divCode]

end FT1536.Source3.C99Frontend

#check @FT1536.Source3.C99Frontend.primitiveCall
#print axioms FT1536.Source3.C99Frontend.add_lowered
#print axioms FT1536.Source3.C99Frontend.mul_lowered
#print axioms FT1536.Source3.C99Frontend.div_lowered
