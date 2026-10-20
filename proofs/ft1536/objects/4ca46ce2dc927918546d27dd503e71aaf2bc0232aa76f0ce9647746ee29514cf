import Source3.KeygenMakeGrammar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Retained small diagnostics isolate the active bound expression. -/
namespace FT1536.Source3.KeygenMakeExpressionProbe
open KeygenMakeSyntax
theorem long_number : numeral "73732L".toList=some (.number .long 73732) := by rfl
run_cmd IO.FS.writeFile "../MAKE_EXPRESSION_PROGRESS.json" "{\"boundary\":\"long-number\"}\n"
def ofEight : Expr := .call .of (argumentTree [.number .i32 8])
def sqrtEight : Expr := .call .sqrt (argumentTree [ofEight])
def sqrtTokens : List B20.C.Token := ["fpr_sqrt","(","fpr_of","(","8",")",")"].map String.toList
theorem nested_sqrt : expression 24 0 sqrtTokens=some (sqrtEight,[]) := by rfl
run_cmd IO.FS.writeFile "../MAKE_EXPRESSION_PROGRESS.json" "{\"boundary\":\"nested-sqrt\"}\n"
def longProduct : Expr := .binary .mul (.number .long 73732) (.cast .long (.variable "n".toList))
def productTokens : List B20.C.Token := ["73732L","*","(","long",")","n"].map String.toList
theorem long_product : expression 24 0 productTokens=some (longProduct,[]) := by rfl

def boundExpr : Expr := .call .div (argumentTree [.call .of (argumentTree [longProduct]),sqrtEight])
def boundTokens : List B20.C.Token := ["fpr_div","(","fpr_of","(","73732L","*","(","long",")","n",")",",",
  "fpr_sqrt","(","fpr_of","(","8",")",")",")"].map String.toList
run_cmd IO.FS.writeFile "../BOUND_PARSER_DIAGNOSTIC.txt" (reprStr (expression 24 0 boundTokens))
theorem complete_bound : expression 24 0 boundTokens=some (boundExpr,[]) := by decide +kernel

end FT1536.Source3.KeygenMakeExpressionProbe
