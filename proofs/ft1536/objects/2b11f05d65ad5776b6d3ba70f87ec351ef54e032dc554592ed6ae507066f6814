import Source3.KeygenPublicRadixInvocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Literal public triple pass, including its Montgomery-scaled x2 and the
   physical fC2/fC1 ordering of the final two stores. -/
namespace FT1536.Source3.KeygenPublicTripleProgram
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal mont)
open KeygenPublicValueExpr (add)

def index (k : Nat) : CLogic.Expr := .bin .add (.var "u".toList) (.literal .i32 k)
def names1 : List C99ArrayReference.Name := ["fA","fB","fC","x","x2"].map String.toList
def names2 : List C99ArrayReference.Name := ["fB0","fB1","fB2","fC0","fC1","fC2"].map String.toList
def square (e : KeygenWordExpr.Expr) : KeygenWordExpr.Expr :=
  .call3 (KeygenPublicScalar.name .square) e (literal 18433) (literal 18431)
def declarations : Stmt := .seq (.scalar (.declare .u32 names1)) (.scalar (.declare .u32 names2))
def assignments : List Stmt := [
  .assign "fA".toList (.load16 "a".toList (index 0)),
  .assign "fB".toList (.load16 "a".toList (index 1)),
  .assign "fC".toList (.load16 "a".toList (index 2)),
  .assign "x".toList (.load16 "gm_cubic".toList (.var "v".toList)),
  .assign "x2".toList (square (var "x")),
  .assign "fB0".toList (mont (var "fB") (var "x")),
  .assign "fB1".toList (mont (var "fB0") (var "w")),
  .assign "fB2".toList (mont (var "fB1") (var "w")),
  .assign "fC0".toList (mont (var "fC") (var "x2")),
  .assign "fC1".toList (mont (var "fC0") (var "w")),
  .assign "fC2".toList (mont (var "fC1") (var "w"))]
def stores : List Stmt := [
  .store "a".toList (index 0) false (add (var "fA") (add (var "fB0") (var "fC0"))),
  .store "a".toList (index 1) false (add (var "fA") (add (var "fB1") (var "fC2"))),
  .store "a".toList (index 2) false (add (var "fA") (add (var "fB2") (var "fC1")))]
def inner : Stmt := .seq (.scalar (.declare .u32 names1))
  (.seq (.scalar (.declare .u32 names2)) (chain (assignments++stores)))
def body : Stmt := .scope (names1++names2) [] inner
def guard : KeygenWordExpr.Expr := .cmp .lt (var "u") (var "n")
def step : Stmt := .seq (.assign "u".toList (.bin .add (var "u") (literal 3)))
  (.scalar (.update "v".toList .add (.literal .i32 1)))
def loop : Stmt := .loop guard body step
def initU : Stmt := .assign "u".toList (literal 0)
def initV : Stmt := .assign "v".toList (.bin .shl (.cast .uint64 (literal 1)) (.bin .sub (var "logn") (literal 1)))
def seed : Stmt := .assign "w".toList
  (mont (.load16 "gm_square".toList (.literal .i32 1)) (.load16 "gm_square".toList (.literal .i32 1)))
def pass : Stmt := .seq (.seq initU initV) loop
theorem source_triple : KeygenPublicRadixProgram.triple=.seq seed (.seq pass .skip) := by decide
theorem source_inner : KeygenPublicForwardProgram.fragment 1044 17=inner := by decide
theorem body_supported : KeygenPublicTableControl.supported body=true := by decide

end FT1536.Source3.KeygenPublicTripleProgram
