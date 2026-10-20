import Source3.KeygenPublicReverseMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Literal first-root inverse and LIVE normalization suffix of the SAME
   retained execution. The conditional ni assignment is a source branch. -/
namespace FT1536.Source3.KeygenPublicRootInverseProgram
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal mont)
open KeygenPublicValueExpr (add sub)

def lowIndex : CLogic.Expr := KeygenPublicFirstValues.lowIndex
def highIndex : CLogic.Expr := KeygenPublicFirstValues.highIndex
def names : List C99ArrayReference.Name := KeygenPublicFirstValues.names
def declaration : Stmt := KeygenPublicFirstValues.declaration
def readLow : Stmt := KeygenPublicFirstValues.readLow
def readHigh : Stmt := KeygenPublicFirstValues.readHigh
def multiply : Stmt := .assign "b".toList (mont (var "r") (sub (var "a0") (var "a1")))
def storeLow : Stmt := .store "a".toList lowIndex false (sub (add (var "a0") (var "a1")) (var "b"))
def storeHigh : Stmt := .store "a".toList highIndex false (add (var "b") (var "b"))
def inner : Stmt := chain [declaration,readLow,readHigh,multiply,storeLow,storeHigh]
def body : Stmt := .scope names [] inner
def increment : Stmt := .scalar (.update "u".toList .add (.literal .i32 1))
def loop : Stmt := .loop (.cmp .lt (var "u") (var "hn")) body increment
def initU : Stmt := .assign "u".toList (literal 0)
def pass : Stmt := .seq initU loop
def seed : Stmt := .assign "r".toList (.load16 "igm_square".toList (.literal .i32 0))
def remaining : Stmt := KeygenPublicInverseProgram.fragment 1155 4

theorem source_inner : KeygenPublicInverseProgram.fragment 1142 7=inner := by decide
theorem source_remaining : KeygenPublicReverseProgram.remaining=.seq seed (.seq pass remaining) := by decide
theorem body_supported : KeygenPublicTableControl.supported body=true := by decide
theorem pass_supported : KeygenPublicTableControl.supported pass=true := by decide
theorem remaining_normal : KeygenPublicTableRows.noReturn remaining=true := by decide

end FT1536.Source3.KeygenPublicRootInverseProgram
