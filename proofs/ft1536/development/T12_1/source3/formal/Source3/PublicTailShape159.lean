import Source3.KeygenPublicForwardProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact parsed shapes of the mq_NTT_ternary tail (falcon-vrfy.c fragment
   1001 61): rSet, the 768-iteration X^2-X+1 first pass, the degree-doubling
   intermediate rounds (outer m/t, group u1/v1, inner v), and the 512-triple
   degree tripling. Value-free; the shape theorem is kernel-checked against
   the pinned parser. -/
namespace FT1536.Source3.PublicTailShape159
open C99ArrayReference (Name)
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal)
open KeygenWordExpr (Expr)

def q : Expr := literal 18433
def q0i : Expr := literal 18431
def addQ (x y : Expr) : Expr := .call3 (KeygenPublicScalar.name .add) x y q
def subQ (x y : Expr) : Expr := .call3 (KeygenPublicScalar.name .sub) x y q
def mont (x y : Expr) : Expr := KeygenPublicTableAtoms.mont x y
def sqr (x : Expr) : Expr := .call3 (KeygenPublicScalar.name .square) x q q0i
def load (n : String) (e : CLogic.Expr) : Expr := .load16 n.toList e
def cvar (n : String) : CLogic.Expr := .var n.toList
def clit (n : Nat) : CLogic.Expr := .literal .i32 n
def cadd (x y : CLogic.Expr) : CLogic.Expr := .bin .add x y
def caddW (n : String) (k : Nat) : CLogic.Expr := cadd (cvar n) (clit k)
def uStore (i : CLogic.Expr) (v : Expr) : Stmt := .store "a".toList i false v

/- r = gm_square[1]; -/
def rSet : Stmt := .assign "r".toList (load "gm_square" (clit 1))

/- first pass body: X^2-X+1 butterflies on a[u], a[u+hn]. -/
def firstBody : Stmt := .scope ["a0".toList,"a1".toList,"b".toList] [] (chain [
  .scalar (.declare .u32 ["a0".toList,"a1".toList,"b".toList]),
  .assign "a0".toList (load "a" (cvar "u")),
  .assign "a1".toList (load "a" (cadd (cvar "u") (cvar "hn"))),
  .assign "b".toList (mont (var "a1") (var "r")),
  uStore (cvar "u") (addQ (var "a0") (var "b")),
  uStore (cadd (cvar "u") (cvar "hn")) (subQ (addQ (var "a0") (var "a1")) (var "b"))])
def firstInc : Stmt := .scalar (.update "u".toList .add (clit 1))
def firstGuard : Expr := .cmp .lt (var "u") (var "hn")
def firstLoop : Stmt := .loop firstGuard firstBody firstInc
def uInit : Stmt := .assign "u".toList (literal 0)
def firstPass : Stmt := .seq uInit firstLoop

/- intermediate degree-doubling rounds. -/
def tSet : Stmt := .assign "t".toList (var "hn")
def mInit : Stmt := .assign "m".toList (literal 2)
def midGuard : Expr := .cmp .gt (var "t") (literal 3)
def midInc : Stmt := .assign "m".toList (.bin .shl (var "m") (literal 1))

def midInnerBody : Stmt := .scope ["a0".toList,"a1".toList] [] (chain [
  .scalar (.declare .u32 ["a0".toList,"a1".toList]),
  .assign "a0".toList (load "a" (cvar "v")),
  .assign "a1".toList (load "a" (cadd (cvar "v") (cvar "ht"))),
  .assign "a1".toList (mont (var "a1") (var "s")),
  uStore (cvar "v") (addQ (var "a0") (var "a1")),
  uStore (cadd (cvar "v") (cvar "ht")) (subQ (var "a0") (var "a1"))])
def midInnerInc : Stmt := .scalar (.update "v".toList .add (clit 1))
def midInnerGuard : Expr := .cmp .lt (var "v") (var "v2")
def midInnerLoop : Stmt := .loop midInnerGuard midInnerBody midInnerInc

def midGroupBody : Stmt := .scope ["v2".toList,"s".toList] [] (chain [
  .scalar (.declare .u64 ["v2".toList]),
  .scalar (.declare .u32 ["s".toList]),
  .assign "s".toList (load "gm_square" (cadd (cvar "m") (cvar "u1"))),
  .assign "v2".toList (.bin .add (var "v1") (var "ht")),
  .seq (.assign "v".toList (var "v1")) midInnerLoop])
def midGroupInc : Stmt := .seq (.scalar (.update "u1".toList .add (clit 1)))
  (.assign "v1".toList (.bin .add (var "v1") (var "t")))
def midGroupGuard : Expr := .cmp .lt (var "u1") (var "m")
def midGroupLoop : Stmt := .loop midGroupGuard midGroupBody midGroupInc

def midRoundBody : Stmt := .scope ["ht".toList,"u1".toList,"v1".toList] [] (chain [
  .scalar (.declare .u64 ["ht".toList,"u1".toList,"v1".toList]),
  .assign "ht".toList (.bin .shr (var "t") (literal 1)),
  .seq (.seq (.assign "u1".toList (literal 0)) (.assign "v1".toList (literal 0))) midGroupLoop,
  .assign "t".toList (var "ht")])
def midLoop : Stmt := .loop midGuard midRoundBody midInc
def midPasses : Stmt := .seq mInit midLoop

/- degree tripling: w = montysqr(gm_square[1]); 512 triples. -/
def wSet : Stmt := .assign "w".toList
  (mont (load "gm_square" (clit 1)) (load "gm_square" (clit 1)))
def vInit : Stmt := .assign "v".toList
  (.bin .shl (.cast .uint64 (literal 1))
    (.bin .sub (var "logn") (literal 1)))
def tripleInit : Stmt := .seq (.assign "u".toList (literal 0)) vInit
def tripleGuard : Expr := .cmp .lt (var "u") (var "n")
def tripleInc : Stmt := .seq (.assign "u".toList (.bin .add (var "u") (literal 3)))
  (.scalar (.update "v".toList .add (clit 1)))

def tripleBody : Stmt :=
  .scope ["fA".toList,"fB".toList,"fC".toList,"x".toList,"x2".toList,
    "fB0".toList,"fB1".toList,"fB2".toList,"fC0".toList,"fC1".toList,"fC2".toList] []
    (chain [
  .scalar (.declare .u32 ["fA".toList,"fB".toList,"fC".toList,"x".toList,"x2".toList]),
  .scalar (.declare .u32 ["fB0".toList,"fB1".toList,"fB2".toList,
    "fC0".toList,"fC1".toList,"fC2".toList]),
  .assign "fA".toList (load "a" (caddW "u" 0)),
  .assign "fB".toList (load "a" (caddW "u" 1)),
  .assign "fC".toList (load "a" (caddW "u" 2)),
  .assign "x".toList (load "gm_cubic" (cvar "v")),
  .assign "x2".toList (sqr (var "x")),
  .assign "fB0".toList (mont (var "fB") (var "x")),
  .assign "fB1".toList (mont (var "fB0") (var "w")),
  .assign "fB2".toList (mont (var "fB1") (var "w")),
  .assign "fC0".toList (mont (var "fC") (var "x2")),
  .assign "fC1".toList (mont (var "fC0") (var "w")),
  .assign "fC2".toList (mont (var "fC1") (var "w")),
  uStore (caddW "u" 0) (addQ (var "fA") (addQ (var "fB0") (var "fC0"))),
  uStore (caddW "u" 1) (addQ (var "fA") (addQ (var "fB1") (var "fC2"))),
  uStore (caddW "u" 2) (addQ (var "fA") (addQ (var "fB2") (var "fC1")))])
def tripleLoop : Stmt := .loop tripleGuard tripleBody tripleInc
def tripling : Stmt := .seq wSet (.seq (.seq tripleInit tripleLoop) .skip)

/- Full tail = rSet; firstPass; tSet; (mInit; midLoop); tripling. -/
def midSection : Stmt := .seq tSet (.seq midPasses tripling)
def tail : Stmt := .seq rSet (.seq firstPass midSection)

theorem tail_shape : KeygenPublicForwardProgram.tail = tail := by decide

theorem firstPass_shape : firstPass = .seq uInit firstLoop := rfl
theorem midPasses_shape : midPasses = .seq mInit midLoop := rfl
theorem tripling_shape : tripling = .seq wSet (.seq (.seq tripleInit tripleLoop) .skip) := rfl

end FT1536.Source3.PublicTailShape159
