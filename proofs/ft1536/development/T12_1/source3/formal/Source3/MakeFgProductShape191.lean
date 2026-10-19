import Source3.MakeFgTailShape190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-bound statement naming for the make_fg_step first-prime pair
   product loop (statement s2 of the tail after the full0 generator call).
   Every definition is a transcription of the original parsed syntax,
   checked by decide against the projection MakeFgTailShape190.s2; no
   execution or numerical property is claimed here. -/
namespace FT1536.Source3.MakeFgProductShape191
open KeygenMakeFgSource (Stmt skip)
open C99ModularReference (Expr)
open KeygenMkgm3Program (mont cell)

def var (name : String) : CLogic.Expr := .var name.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def at0 : CLogic.Expr := .literal .u64 0

def varV : CLogic.Expr := var "v"
def varU : CLogic.Expr := var "u"
def varHn : CLogic.Expr := var "hn"
def varTlen : CLogic.Expr := var "tlen"

/- Original source indices t1[(v << 1) + 0] and t1[(v << 1) + 1]. -/
def twice : CLogic.Expr := .bin .shl varV (num 1)
def index (k : Nat) : CLogic.Expr := .bin .add twice (num k)

def w0Name : C99ArrayReference.Name := "w0".toList
def w1Name : C99ArrayReference.Name := "w1".toList

def declareLocals : Stmt := .level (.modular (KeygenMkgm3Program.wordDecl ["w0","w1"]))
def readT1 (k : Nat) : Expr := KeygenMkgm3Program.load "t1" (index k)
def w0Assign : Stmt := .level (.modular (.assign w0Name (readT1 0)))
def w1Assign : Stmt := .level (.modular (.assign w1Name (readT1 1)))
def productExpr : Expr := mont (mont (cell "w0") (cell "w1")) (cell "R2")
def storeX : Stmt := .level (.modular (.store32 "x".toList at0 productExpr))
def productInner : Stmt := KeygenMakeFgSource.chain [declareLocals,w0Assign,w1Assign,storeX]
def productBody : Stmt := .scope [w0Name,w1Name] [] productInner

def productInitCode : C99ModularReference.Stmt :=
  .seq (.assign "v".toList (.scalar (num 0))) (.base (.bindPtr "x".toList "fd".toList varU))
def productInit : Stmt := .level (.modular productInitCode)

def productIncCode : C99ModularReference.Stmt :=
  .seq (.base (.scalar (.update "v".toList .add (num 1))))
    (.base (.bindPtr "x".toList "x".toList varTlen))
def productInc : Stmt := .level (.modular productIncCode)

def productCondition : CLogic.Expr := .cmp .lt varV varHn
def productLoop : Stmt := .loop productCondition productBody productInc
def productF : Stmt := .seq productInit productLoop

theorem s2_shape : MakeFgTailShape190.s2=productF := by decide

end FT1536.Source3.MakeFgProductShape191
