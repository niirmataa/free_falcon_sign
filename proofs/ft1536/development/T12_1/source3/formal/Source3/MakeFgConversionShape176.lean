import Source3.MakeFgDeclarations176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgConversionShape176
open KeygenMakeFgSource (Stmt chain)
open MakeFgDeclarations176 (arrayCode)

def index : CLogic.Expr := .var "u".toList
def converted (name : String) : KeygenWordExpr.Expr :=
  .call2 "modp_set".toList (.load16 name.toList index) (.scalar (.var "p0".toList))
def first : Stmt := .word (.store "ft".toList index (converted "f"))
def second : Stmt := .word (.store "gt".toList index (converted "g"))
def body : Stmt := .scope [] [] (chain [first,second])
def condition : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "n".toList)
def increment : Stmt := arrayCode (.scalar (.update "u".toList .add (.literal .i32 1)))
def loop : Stmt := .loop condition body increment
def initial : Stmt := .level (.modular (.assign "u".toList (.scalar (.literal .i32 0))))
def conversion : Stmt := .seq initial loop
def nSet : Stmt := .level (.modular (.assign "n".toList (.scalar KeygenRootSearch.sizeExpr)))
def ftSet : Stmt := arrayCode (.bindPtr "ft".toList "data".toList C99ProcedureParser.zero)
def gtSet : Stmt := arrayCode (.bindPtr "gt".toList "ft".toList (.var "n".toList))
def primeSelect : Stmt := .branch (.var "ter".toList)
  (arrayCode (.bindPtr "primes".toList "PRIMES3".toList C99ProcedureParser.zero))
  (arrayCode (.bindPtr "primes".toList "PRIMES2".toList C99ProcedureParser.zero))
def pSet : Stmt := .level (.prime "p0".toList "primes".toList (.literal .i32 0) .p)
def setupSteps : List Stmt := [nSet,ftSet,gtSet,primeSelect,pSet]
def setup : Stmt := chain setupSteps

theorem shape : KeygenMakeFgSource.part .make 1=chain (setupSteps++[conversion]) := by decide

end FT1536.Source3.MakeFgConversionShape176
