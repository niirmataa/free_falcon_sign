import Source3.KeygenPublicInverseMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Literal reverse-radix partition of the SAME remaining inverse execution.
   The first-root and normalization suffix is retained, not assumed correct. -/
namespace FT1536.Source3.KeygenPublicReverseProgram
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal mont)
open KeygenPublicValueExpr (add sub)

def lowIndex : CLogic.Expr := .var "v".toList
def highIndex : CLogic.Expr := .bin .add lowIndex (.var "ht".toList)
def names : List C99ArrayReference.Name := ["a0".toList,"a1".toList]
def declaration : Stmt := .scalar (.declare .u32 names)
def readLow : Stmt := .assign "a0".toList (.load16 "a".toList lowIndex)
def readHigh : Stmt := .assign "a1".toList (.load16 "a".toList highIndex)
def storeLow : Stmt := .store "a".toList lowIndex false (add (var "a0") (var "a1"))
def storeHigh : Stmt := .store "a".toList highIndex false (mont (sub (var "a0") (var "a1")) (var "s"))
def inner : Stmt := chain [declaration,readLow,readHigh,storeLow,storeHigh]
def body : Stmt := .scope names [] inner
def guard : KeygenWordExpr.Expr := KeygenPublicRadixFold.guard
def increment : Stmt := KeygenPublicRadixFold.increment
def loop : Stmt := .loop guard body increment
def pass : Stmt := .seq (.assign "v".toList (var "v1")) loop

def rowNames : List C99ArrayReference.Name := ["v2".toList,"s".toList]
def rowInner : Stmt := chain [
  .scalar (.declare .u64 ["v2".toList]),
  .scalar (.declare .u32 ["s".toList]),
  .assign "s".toList (.load16 "igm_square".toList (.bin .add (.var "m".toList) (.var "u1".toList))),
  .assign "v2".toList (.bin .add (var "v1") (var "ht")),pass]
def rowBody : Stmt := .scope rowNames [] rowInner
def rowGuard : KeygenWordExpr.Expr := KeygenPublicRadixProgram.rowGuard
def rowStep : Stmt := KeygenPublicRadixProgram.rowStep
def rowLoop : Stmt := .loop rowGuard rowBody rowStep
def initRows : Stmt := KeygenPublicRadixProgram.initRows
def rows : Stmt := .seq initRows rowLoop
def stageNames : List C99ArrayReference.Name := KeygenPublicRadixProgram.stageNames
def htSet : Stmt := KeygenPublicRadixProgram.htSet
def tSet : Stmt := .scalar (.update "t".toList .shl (.literal .i32 1))
def stageInner : Stmt := chain [.scalar (.declare .u64 stageNames),htSet,rows,tSet]
def stageBody : Stmt := .scope stageNames [] stageInner
def stageGuard : KeygenWordExpr.Expr := .cmp .lt (var "t") (var "n")
def stageStep : Stmt := .assign "m".toList (.bin .shr (var "m") (literal 1))
def initM : Stmt := .assign "m".toList (.bin .shl (.cast .uint64 (literal 1))
  (.bin .sub (var "logn") (literal 2)))
def stages : Stmt := .seq initM (.loop stageGuard stageBody stageStep)
def stageLoop : Stmt := .loop stageGuard stageBody stageStep
def start : Stmt := .assign "t".toList (literal 6)
def remaining : Stmt := KeygenPublicInverseProgram.fragment 1140 19

theorem source_inner : KeygenPublicInverseProgram.fragment 1125 7=inner := by decide
theorem source_row : KeygenPublicInverseProgram.fragment 1119 14=rowInner := by decide
theorem source_stage : KeygenPublicInverseProgram.fragment 1115 20=stageInner := by decide
theorem source_remaining : KeygenPublicInverseProgram.remaining=.seq start (.seq stages remaining) := by decide
theorem body_supported : KeygenPublicTableControl.supported body=true := by decide
theorem row_supported : KeygenPublicTableControl.supported rowBody=true := by decide
theorem stage_supported : KeygenPublicTableControl.supported stageBody=true := by decide
theorem remaining_normal : KeygenPublicTableRows.noReturn remaining=true := by decide

end FT1536.Source3.KeygenPublicReverseProgram
