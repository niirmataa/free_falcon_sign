import Source3.KeygenPublicTripleOrder

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact outer radix syntax of the public uint16 transform. The row and
   stage increments retain the parser's distinction between ++ and +=. -/
namespace FT1536.Source3.KeygenPublicRadixProgram
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal)

def rowNames : List C99ArrayReference.Name := ["v2".toList,"s".toList]
def rowInner : Stmt := chain [
  .scalar (.declare .u64 ["v2".toList]),
  .scalar (.declare .u32 ["s".toList]),
  .assign "s".toList (.load16 "gm_square".toList (.bin .add (.var "m".toList) (.var "u1".toList))),
  .assign "v2".toList (.bin .add (var "v1") (var "ht")),
  KeygenPublicRadixFold.pass]
def rowBody : Stmt := .scope rowNames [] rowInner
def rowGuard : KeygenWordExpr.Expr := .cmp .lt (var "u1") (var "m")
def nextRow : Stmt := .scalar (.update "u1".toList .add (.literal .i32 1))
def nextBase : Stmt := .assign "v1".toList (.bin .add (var "v1") (var "t"))
def rowStep : Stmt := .seq nextRow nextBase
def rowLoop : Stmt := .loop rowGuard rowBody rowStep
def initRows : Stmt := .seq (.assign "u1".toList (literal 0)) (.assign "v1".toList (literal 0))
def rows : Stmt := .seq initRows rowLoop
def stageNames : List C99ArrayReference.Name := ["ht".toList,"u1".toList,"v1".toList]
def htSet : Stmt := .assign "ht".toList (.bin .shr (var "t") (literal 1))
def tSet : Stmt := .assign "t".toList (var "ht")
def stageInner : Stmt := chain [.scalar (.declare .u64 stageNames),htSet,rows,tSet]
def stageBody : Stmt := .scope stageNames [] stageInner
def stageGuard : KeygenWordExpr.Expr := .cmp .gt (var "t") (literal 3)
def stageStep : Stmt := .assign "m".toList (.bin .shl (var "m") (literal 1))
def stageLoop : Stmt := .loop stageGuard stageBody stageStep
def stages : Stmt := .seq (.assign "m".toList (literal 2)) stageLoop
def start : Stmt := .assign "t".toList (var "hn")
def triple : Stmt := KeygenPublicForwardProgram.fragment 1042 20

theorem source_row : KeygenPublicForwardProgram.fragment 1021 14=rowInner := by decide
theorem source_stage : KeygenPublicForwardProgram.fragment 1017 20=stageInner := by decide
theorem source_remaining : KeygenPublicFirstValues.remaining=.seq start (.seq stages triple) := by decide
theorem row_supported : KeygenPublicTableControl.supported rowBody=true := by decide
theorem stage_supported : KeygenPublicTableControl.supported stageBody=true := by decide

end FT1536.Source3.KeygenPublicRadixProgram
