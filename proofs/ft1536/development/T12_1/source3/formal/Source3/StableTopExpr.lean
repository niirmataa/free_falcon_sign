import Source3.StableTopSyntax
import Source3.C99PrimitiveExists

namespace FT1536.Source3.StableTopExpr
open StableTopSyntax
abbrev Word := BitVec 64
abbrev Env := B20.C.Name → Option Word
def put (env : Env) (name : B20.C.Name) (w : Word) : Env := fun n => if n=name then some w else env n
def operation : Op → Word → Word → Option Word
  | .add => FprPrimitives.add | .mul => FprPrimitives.mul | .div => FprPrimitives.div
def eval (env : Env) : Expr → Option Word
  | .var n => env n
  | .bin op a b => do operation op (← eval env a) (← eval env b)

inductive Eval (env : Env) : Expr → Word → Prop where
  | var (n : B20.C.Name) (w : Word) (read : env n=some w) : Eval env (.var n) w
  | bin (op : Op) (a b : Expr) (x y z : Word) (left : Eval env a x) (right : Eval env b y)
      (call : C99Frontend.primitiveCall (opName op) [.uint64 x,.uint64 y] (.uint64 z)) : Eval env (.bin op a b) z

theorem operation_complete (op : Op) (x y z : Word)
    (h : C99Frontend.primitiveCall (opName op) [.uint64 x,.uint64 y] (.uint64 z)) : operation op x y=some z := by
  cases op with
  | add => exact C99AddProof.pinned_add_complete x y z h
  | mul => exact C99MulProof.pinned_mul_complete x y z h
  | div => exact C99DivProof.pinned_div_complete x y z h
theorem operation_sound (op : Op) (x y z : Word) (h : operation op x y=some z) :
    C99Frontend.primitiveCall (opName op) [.uint64 x,.uint64 y] (.uint64 z) := by
  cases op with
  | add => exact C99PrimitiveExists.add_sound x y z h
  | mul => exact C99PrimitiveExists.mul_sound x y z h
  | div => exact C99PrimitiveExists.div_sound x y z h
theorem operation_total (op : Op) (x y : Word) : (operation op x y).isSome := by
  cases op with
  | add => exact FprAddTotal.add_total x y
  | mul => exact FprMulTotal.mul_total x y
  | div => exact FprDivTotal.div_total x y

theorem complete (env : Env) (e : Expr) (w : Word) (h : Eval env e w) : eval env e=some w := by
  induction h with
  | var n w h => exact h
  | bin op a b x y z _ _ hc iha ihb => simp [eval,iha,ihb,operation_complete op x y z hc]
theorem sound (env : Env) (e : Expr) (w : Word) (h : eval env e=some w) : Eval env e w := by
  induction e generalizing w with
  | var n => exact Eval.var n w h
  | bin op a b iha ihb =>
      obtain ⟨x,hx,hr⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨y,hy,hc⟩ := Option.bind_eq_some_iff.mp hr
      exact Eval.bin op a b x y w (iha x hx) (ihb y hy) (operation_sound op x y w hc)

def vars : Expr → List B20.C.Name
  | .var n => [n]
  | .bin _ a b => vars a ++ vars b
theorem total (env : Env) (e : Expr) (h : ∀ n∈vars e, (env n).isSome) : (eval env e).isSome := by
  induction e with
  | var n => exact h n (by simp [vars])
  | bin op a b iha ihb =>
      obtain ⟨x,hx⟩ := Option.isSome_iff_exists.mp (iha (fun n hn => h n (by simp [vars,hn])))
      obtain ⟨y,hy⟩ := Option.isSome_iff_exists.mp (ihb (fun n hn => h n (by simp [vars,hn])))
      simpa [eval,hx,hy] using operation_total op x y

def toC : Expr → CLogic.Expr
  | .var n => .var n
  | .bin op a b => .call2 (opName op) (toC a) (toC b)
def referenceEnv (env : Env) : C99ScalarReference.Env :=
  fun n => (env n).map (fun w => (.uint64,some (.uint64 w)))

theorem source_expr_binding (e : Expr) : wordExpr (toC e)=some e := by
  induction e with
  | var _ => rfl
  | bin op a b iha ihb => cases op <;> simp [toC,wordExpr,opName,parseOp,iha,ihb]

theorem independent_scalar (env : Env) (e : Expr) (w : Word) (h : Eval env e w) :
    C99ScalarReference.Eval C99Frontend.primitiveCall (referenceEnv env)
      (C99Frontend.expression (toC e)) (.uint64 w) := by
  induction h with
  | var n w hr => exact C99ScalarReference.Eval.variable n .uint64 (.uint64 w) (by simp [referenceEnv,hr])
  | bin op a b x y z _ _ hc iha ihb => exact C99ScalarReference.Eval.call2 _ _ _ _ _ _ iha ihb hc

end FT1536.Source3.StableTopExpr

#print axioms FT1536.Source3.StableTopExpr.complete
#print axioms FT1536.Source3.StableTopExpr.total
#print axioms FT1536.Source3.StableTopExpr.independent_scalar
