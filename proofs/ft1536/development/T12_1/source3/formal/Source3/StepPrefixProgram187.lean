import Source3.StepStaticInputs187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepPrefixProgram187
open KeygenMakeFgSource (Stmt modular)
open MakeFgDeclarations176 (arrayCode)
open FirstStepEntry187 (var num)

def nExpr : CLogic.Expr := .bin .shl (.cast .u64 (num 1)) (var "logn")
def nSet : Stmt := modular (.assign "n".toList (.scalar nExpr))
def hnSet : Stmt := modular (.assign "hn".toList (.scalar (.bin .shr (var "n") (num 1))))
def lengthSet (dst table : String) (index : CLogic.Expr) : Stmt := arrayCode (.assign dst.toList (.load table.toList index))
def primesSet (table : String) : Stmt := arrayCode (.bindPtr "primes".toList table.toList C99ProcedureParser.zero)
def lengths (table primes : String) : Stmt := .scope [] [] (KeygenMakeFgSource.chain
  [lengthSet "slen" table (var "depth"),lengthSet "tlen" table (.bin .add (var "depth") (num 1)),primesSet primes])
def choice : Stmt := .branch (var "ter") (lengths "MAX_BL_SMALL3" "PRIMES3") (lengths "MAX_BL_SMALL2" "PRIMES2")
def bind (dst src : String) (index : CLogic.Expr) : Stmt := arrayCode (.bindPtr dst.toList src.toList index)
def product (a b : String) : CLogic.Expr := .bin .mul (var a) (var b)
def pointers : List Stmt := [bind "fd" "data" C99ProcedureParser.zero,
  bind "gd" "fd" (product "hn" "tlen"),bind "fs" "gd" (product "hn" "tlen"),
  bind "gs" "fs" (product "n" "slen"),bind "gm" "gs" (product "n" "slen"),
  bind "igm" "gm" (var "n"),bind "t1" "igm" (var "n")]
def count : CLogic.Expr := .bin .mul (.bin .mul (.bin .mul (num 2) (var "n")) (var "slen")) (.literal .u64 4)
def move : Stmt := .level (.move "fs".toList "data".toList C99ProcedureParser.zero C99ProcedureParser.zero count)
def steps : List Stmt := [nSet,hnSet,choice]++pointers++[move]
def code : Stmt := KeygenMakeFgSource.chain steps

theorem shape : KeygenMakeFgSource.part .step 1=code := by decide

end FT1536.Source3.StepPrefixProgram187
