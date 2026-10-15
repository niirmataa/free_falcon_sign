import Source3.FftShape138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenNormShape151
open KeygenSearchExec (Expr Stmt skip)

def norm : Expr := .base (.scalar (.var "norm".toList))
def sample (name : String) : Expr := .base (.load name.toList (.var "u".toList))
def update (name : String) : Stmt := .assign "norm".toList
  (.binary "fpr_add".toList norm (.unary "fpr_sqr".toList (sample name)))
def zero : Stmt := .assign "norm".toList (.unary "fpr_of".toList (.base (.scalar (.literal .i32 0))))
def initial : Stmt := .procedure (.base (.scalar (.assign "u".toList (.literal .i32 0))))
def condition : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "n".toList)
def body : Stmt := .scope [] [] (.seq (update "rt1") (.seq (update "rt2") skip))
def increment : Stmt := .procedure (.base (.scalar (.update "u".toList .add (.literal .i32 1))))
def loop : Stmt := .loop condition body increment
def double : Stmt := .assign "norm".toList (.unary "fpr_double".toList norm)

theorem remaining_shape : FftShape138.remaining=.seq zero (.seq (.seq initial loop) (.seq double skip)) := by decide +kernel

end FT1536.Source3.KeygenNormShape151
