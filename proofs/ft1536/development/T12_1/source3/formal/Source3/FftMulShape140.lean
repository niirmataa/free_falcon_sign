import Source3.FftMiddleShape139
import Source3.FftLocalCells140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMulShape140
open C99ArrayReference (Name Expr Stmt)

def varExpr (name : String) : Expr := .scalar (.var name.toList)
def aNames : List Name := ["fpct_a_re".toList,"fpct_a_im".toList]
def bNames : List Name := ["fpct_b_re".toList,"fpct_b_im".toList]
def dNames : List Name := ["fpct_d_re".toList,"fpct_d_im".toList]
def temporaries : List Name := aNames++bNames++dNames

def operations : List Stmt := [
  .scalar (.declare .u64 aNames),.scalar (.declare .u64 bNames),.scalar (.declare .u64 dNames),
  .assign "fpct_a_re".toList (varExpr "a1r"),
  .assign "fpct_a_im".toList (varExpr "a1i"),
  .assign "fpct_b_re".toList (varExpr "sr"),
  .assign "fpct_b_im".toList (varExpr "si"),
  .assign "fpct_d_re".toList (FftWordExpressions140.sub
    (FftWordExpressions140.mul (varExpr "fpct_a_re") (varExpr "fpct_b_re"))
    (FftWordExpressions140.mul (varExpr "fpct_a_im") (varExpr "fpct_b_im"))),
  .assign "fpct_d_im".toList (FftWordExpressions140.add
    (FftWordExpressions140.mul (varExpr "fpct_a_re") (varExpr "fpct_b_im"))
    (FftWordExpressions140.mul (varExpr "fpct_a_im") (varExpr "fpct_b_re"))),
  .assign "a1r".toList (varExpr "fpct_d_re"),
  .assign "a1i".toList (varExpr "fpct_d_im")]

def code : Stmt := .scope temporaries [] (FpcSourceExpansion.sequence operations)

def sourcePart : C99ProcedureReference.Stmt :=
  ((FftMiddleShape139.spine (FftMiddleShape139.unscoped FftMiddleShape139.butterflyBody))[5]?).getD (.base .skip)

theorem source_bound : sourcePart=.base code := by rfl

end FT1536.Source3.FftMulShape140
