import Source3.KeygenMakeGrammar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Small retained diagnostics for the complete caller's fixed-call grammar. -/
namespace FT1536.Source3.KeygenMakeAtomProbe
open KeygenMakeSyntax
def readyExpr : Expr := .unary .logicalNot (.call .ready (argumentTree [.variable "fk".toList]))
def readyTokens : List B20.C.Token := ["!","rng_ready","(","fk",")"].map String.toList
theorem ready_source : expression 24 0 readyTokens=some (readyExpr,[]) := by rfl
def countCode : Stmt := .write (.variable "local_attempts".toList) .set (.number .i32 0)
def countTokens : List B20.C.Token := ["local_attempts","=","0",";"].map String.toList
theorem count_source : simple countTokens=some (countCode,[]) := by rfl

end FT1536.Source3.KeygenMakeAtomProbe
