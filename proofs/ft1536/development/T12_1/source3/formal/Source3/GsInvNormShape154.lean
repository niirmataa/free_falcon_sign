import Source3.FftFirstShape149
import Source3.FftMulStates140
import Source3.FprInvFast154

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsInvNormShape154
open C99ArrayReference (Name Expr)
open C99ProcedureReference (Stmt Function)

def names : List Name := ["a_re".toList,"a_im".toList,"b_re".toList,"b_im".toList]
def name : Fin 4 → Name
  | ⟨0,_⟩ => "a_re".toList | ⟨1,_⟩ => "a_im".toList
  | ⟨2,_⟩ => "b_re".toList | ⟨3,_⟩ => "b_im".toList
def buffer : Fin 4 → Name
  | ⟨0,_⟩ | ⟨1,_⟩ => "a".toList
  | ⟨2,_⟩ | ⟨3,_⟩ => "b".toList
def index (i : Fin 4) : CLogic.Expr :=
  if i.val%2=0 then FftFirstShape149.index0 else FftFirstShape149.index1
def varExpr (i : Fin 4) : Expr := .scalar (.var (name i))
def sqr (e : Expr) : Expr := .call1 "fpr_sqr".toList e
def inverse (e : Expr) : Expr := .call1 "fpr_inv".toList e
def expression : Expr := inverse (FftWordExpressions140.add
  (FftWordExpressions140.add (sqr (varExpr 0)) (sqr (varExpr 1)))
  (FftWordExpressions140.add (sqr (varExpr 2)) (sqr (varExpr 3))))
def declarationA : Stmt := .base (.scalar (.declare .u64 [name 0,name 1]))
def declarationB : Stmt := .base (.scalar (.declare .u64 [name 2,name 3]))
def load (i : Fin 4) : Stmt := .base (.assign (name i) (.load (buffer i) (index i)))
def store : Stmt := .base (.store64 "d".toList FftFirstShape149.index0 expression)
def parts : List Stmt := [declarationA,declarationB,load 0,load 1,load 2,load 3,store]
def body : Stmt := .scope names [] (C99ProcedureParser.chain parts)
def loop : Stmt := .loop FftShape138.firstCondition body FftShape138.firstIncrement
def declaration : Stmt := .base (.scalar (.declare .u64 ["n".toList,"hn".toList,"u".toList]))
def function : Function :=
  ⟨(KeygenSearchFft.header .invnorm).parameters.map C99ArrayParser.Parameter.value,none,
    C99ProcedureParser.chain [declaration,FftShape138.size,FftShape138.halfSize,
      .seq FftShape138.firstInitial loop]⟩

theorem source : KeygenSearchFft.program "falcon_poly_invnorm2_fft3".toList=some function := by decide +kernel

theorem name_member (i : Fin 4) : name i∈names := by fin_cases i <;> decide
theorem index_reads (i : Fin 4) (key : Name)
    (read : key∈C99ExpressionEnvironment.readNames (C99Frontend.expression (index i))) : key∉names := by
  by_cases even : i.val%2=0
  · rw [index,ite_eq_left even,FftFirstShape149.index0_reads] at read
    have same := List.mem_singleton.mp read
    subst key
    decide
  · rw [index,ite_eq_right even,FftFirstShape149.index1_reads] at read
    simp only [List.mem_cons,List.not_mem_nil,or_false] at read
    rcases read with rfl|rfl <;> decide

def denominator (x : FftMulStates140.Words) : BitVec 64 :=
  FprAddFast137.word (FprAddFast137.word (FprHeadersFast137.sqr x.ar) (FprHeadersFast137.sqr x.ai))
    (FprAddFast137.word (FprHeadersFast137.sqr x.br) (FprHeadersFast137.sqr x.bi))
def value (x : FftMulStates140.Words) : BitVec 64 := FprInvFast154.word (denominator x)

theorem expression_source (s : C99ArrayReference.State) (x : FftMulStates140.Words)
    (ar : C99ArrayReference.Eval s (varExpr 0) (.uint64 x.ar))
    (ai : C99ArrayReference.Eval s (varExpr 1) (.uint64 x.ai))
    (br : C99ArrayReference.Eval s (varExpr 2) (.uint64 x.br))
    (bi : C99ArrayReference.Eval s (varExpr 3) (.uint64 x.bi)) :
    C99ArrayReference.Eval s expression (.uint64 (value x)) := by
  have squared (e : Expr) (w : BitVec 64) (h : C99ArrayReference.Eval s e (.uint64 w)) :
      C99ArrayReference.Eval s (sqr e) (.uint64 (FprHeadersFast137.sqr w)) :=
    .call1 _ _ _ _ h (FprHeadersFast137.sqr_source w)
  exact .call1 _ _ _ _
    (FftWordExpressions140.add_source _ _ _ _ _
      (FftWordExpressions140.add_source _ _ _ _ _ (squared _ _ ar) (squared _ _ ai))
      (FftWordExpressions140.add_source _ _ _ _ _ (squared _ _ br) (squared _ _ bi)))
    (FprInvFast154.source (denominator x))

end FT1536.Source3.GsInvNormShape154
