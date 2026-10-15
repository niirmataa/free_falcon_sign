import Source3.FftShape138
import Source3.FftWordExpressions140
import Source3.FftPointerTransport140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstShape149
open C99ArrayReference (Name Expr)
open C99ProcedureReference (Stmt)

def names : List Name := ["a0".toList,"a1".toList]
def index0 : CLogic.Expr := .var "u".toList
def index1 : CLogic.Expr := .bin .add (.var "u".toList) (.var "hn".toList)
def varExpr (name : String) : Expr := .scalar (.var name.toList)
def realExpr : Expr := FftWordExpressions140.add (varExpr "a0")
  (FftWordExpressions140.mul (varExpr "a1") (varExpr "fpr_W1R"))
def imagExpr : Expr := FftWordExpressions140.mul (varExpr "a1") (varExpr "fpr_W1I")
def declaration : Stmt := .base (.scalar (.declare .u64 names))
def load0 : Stmt := .base (.assign "a0".toList (.load "a".toList index0))
def load1 : Stmt := .base (.assign "a1".toList (.load "a".toList index1))
def store0 : Stmt := .base (.store64 "a".toList index0 realExpr)
def store1 : Stmt := .base (.store64 "a".toList index1 imagExpr)
def parts : List Stmt := [declaration,load0,load1,store0,store1]

theorem body_shape : FftShape138.firstBody=.scope names [] (C99ProcedureParser.chain parts) := by rfl
theorem index0_reads : C99ExpressionEnvironment.readNames (C99Frontend.expression index0)=["u".toList] := by rfl
theorem index1_reads : C99ExpressionEnvironment.readNames (C99Frontend.expression index1)=["u".toList,"hn".toList] := by rfl

end FT1536.Source3.FftFirstShape149
