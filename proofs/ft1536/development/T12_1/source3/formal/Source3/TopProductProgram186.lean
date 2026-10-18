import Source3.TopProductShape185

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopProductProgram186
open KeygenLevelExec (Stmt)
open KeygenMkgm3Program (mont cell)

def var (name : String) : CLogic.Expr := .var name.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def next (n : Nat) : CLogic.Expr := .bin .add (var "u") (num n)
def read (src : String) (index : CLogic.Expr) : C99ModularReference.Expr := .load32 src.toList index
def product (src : String) : C99ModularReference.Expr :=
  mont (cell "R3") (mont (read src (var "u")) (mont (read src (next 1)) (read src (next 2))))
def write (dst src : String) : Stmt := .modular (.store32 dst.toList (var "v") (product src))
def inner : Stmt := KeygenLevelExec.chain [write "fd" "fs",write "gd" "gs"]
def body : Stmt := .scope [] [] inner
def initCode : C99ModularReference.Stmt :=
  .seq (.assign "u".toList (.scalar (num 0))) (.assign "v".toList (.scalar (num 0)))
def stepCode : C99ModularReference.Stmt :=
  .seq (.base (.scalar (.update "u".toList .add (num 3)))) (.base (.scalar (.update "v".toList .add (num 1))))
def condition : CLogic.Expr := .cmp .lt (var "u") (var "n")
def loop : Stmt := .loop condition body (.modular stepCode)
def wholeLoop : Stmt := .seq (.modular initCode) loop

theorem loop_shape : TopProductShape185.loop=wholeLoop := by decide

def inverseBody : Stmt := match TopProductShape185.tail with
  | .seq (.branch _ yes _) _ => yes
  | _ => KeygenLevelExec.skip

theorem tail_shape : TopProductShape185.tail=
    .seq (.branch (.lnot (var "out_ntt")) inverseBody KeygenLevelExec.skip) KeygenLevelExec.skip := by decide

end FT1536.Source3.TopProductProgram186
