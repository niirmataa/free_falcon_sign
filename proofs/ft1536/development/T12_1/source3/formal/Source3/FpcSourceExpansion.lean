import Source3.C99ArrayParser
import FftBind.FftSemantics

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Consume the existing pinned macro ASTs, not their parametric FftCalls
   evaluator. Expanded expressions use the fixed source FPR call relation
   in C99ArrayReference. Macro locals retain their C block scope. -/
namespace FT1536.Source3.FpcSourceExpansion
open C99ArrayReference
open FT1536.FftBind.FftSem

inductive Kind where
  | add | sub | mul | sqr | inv | div
  deriving DecidableEq, Repr

def name : Kind → Name
  | .add => "FPC_ADD".toList | .sub => "FPC_SUB".toList | .mul => "FPC_MUL".toList
  | .sqr => "FPC_SQR".toList | .inv => "FPC_INV".toList | .div => "FPC_DIV".toList
def parameters : Kind → List Name
  | .sqr | .inv => ["d_re".toList,"d_im".toList,"a_re".toList,"a_im".toList]
  | _ => ["d_re".toList,"d_im".toList,"a_re".toList,"a_im".toList,"b_re".toList,"b_im".toList]
def region : Kind → Nat×Nat
  | .add => (56,6) | .sub => (67,6) | .mul => (78,16)
  | .sqr => (99,9) | .inv => (113,11) | .div => (129,20)
def raw (kind : Kind) : Option Macro :=
  parseMacro (FT1536.FftBind.FftPin.fftSlice (region kind).1 (region kind).2)
def expected : Kind → Macro
  | .add => fpcAddMacro | .sub => fpcSubMacro | .mul => fpcMulMacro
  | .sqr => fpcSqrMacro | .inv => fpcInvMacro | .div => fpcDivMacro

theorem source_bound (kind : Kind) : raw kind=some (expected kind) := by
  cases kind
  · exact add_parses
  · exact sub_parses
  · exact mul_parses
  · exact sqr_parses
  · exact inv_parses
  · exact div_parses

abbrev Substitution := Name → Option Expr
def substitution (names : List Name) (args : List Expr) : Substitution := fun n =>
  ((names.zip args).find? (fun p => p.1==n)).map Prod.snd

def expression (subst : Substitution) : CLogic.Expr → Option Expr
  | .var n => some ((subst n).getD (.scalar (.var n)))
  | .literal t n => some (.scalar (.literal t n))
  | .call1 n a => do pure (.call1 n (← expression subst a))
  | .call2 n a b => do pure (.call2 n (← expression subst a) (← expression subst b))
  | _ => none

def destination (target : Expr) (value : Expr) : Option Stmt :=
  match target with
  | .scalar (.var n) => some (.assign n value)
  | .load a i => some (.store64 a i value)
  | _ => none

def operation (subst : Substitution) : MacroOp → Option Stmt
  | .stmt (.declare ty names) => some (.scalar (.declare ty names))
  | .stmt (.assign n e) => do pure (.assign n (← expression subst e))
  | .passign dst src => do destination (← subst dst) (.scalar (.var src))
  | _ => none

def sequence : List Stmt → Stmt
  | [] => .skip
  | s::ss => .seq s (sequence ss)

def expandCode (kind : Kind) (args : List Expr) (code : Macro) : Option Stmt := do
  if args.length≠(parameters kind).length then none else do
    let body := sequence (← code.mapM (operation (substitution (parameters kind) args)))
    pure (.scope (C99ArrayParser.declarations body) [] body)

def expand (kind : Kind) (args : List Expr) : Option Stmt :=
  (raw kind).bind (expandCode kind args)
def cached (kind : Kind) (args : List Expr) : Option Stmt := expandCode kind args (expected kind)

theorem cached_bound (kind : Kind) (args : List Expr) : cached kind args=expand kind args := by
  rw [expand,source_bound]
  rfl

def lookup (n : Name) : Option Kind :=
  [Kind.add,.sub,.mul,.sqr,.inv,.div].find? (fun kind => name kind==n)

theorem variable_arguments_expand (kind : Kind) :
    (expand kind ((parameters kind).map (fun n => Expr.scalar (.var n)))).isSome := by
  cases kind <;> simp only [expand,source_bound,Option.bind_some]
  all_goals decide

end FT1536.Source3.FpcSourceExpansion
