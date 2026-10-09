import Source3.KeygenPublicLastRow

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicUpperProgram
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal mont divide)
open KeygenPublicLastProgram (scalarVar)

def u : CLogic.Expr := scalarVar "u"
def doubleU : CLogic.Expr := .bin .shl u (.literal .i32 1)
def cubeSteps : List Stmt := [.scalar (.declare .u32 ["y".toList,"z".toList]),
  .assign "y".toList (.load16 "gm".toList doubleU),
  .assign "z".toList (.load16 "igm".toList doubleU),
  .store "gm".toList u true (mont (var "y") (mont (var "y") (var "y"))),
  .store "igm".toList u true (mont (var "z") (mont (var "z") (var "z")))]
def cubeBody : Stmt := .scope ["y".toList,"z".toList] [] (chain cubeSteps)
def powerK : KeygenWordExpr.Expr := .bin .shl (.cast .uint64 (literal 1)) (var "k")
def upper : KeygenWordExpr.Expr := .bin .shl (.cast .uint64 (literal 1)) (.bin .add (var "k") (literal 1))
def cubeCondition : KeygenWordExpr.Expr := .cmp .lt (var "u") upper
def cubeIncrement : Stmt := .scalar (.update "u".toList .add (.literal .i32 1))
def cubeLoop : Stmt := .loop cubeCondition cubeBody cubeIncrement
def squareSteps : List Stmt := [.scalar (.declare .u64 ["v".toList]),
  .assign "v".toList (.bin .shl (var "u") (literal 1)),
  .store "gm".toList u true (mont (.load16 "gm".toList (scalarVar "v")) (.load16 "gm".toList (scalarVar "v"))),
  .store "igm".toList u true (mont (.load16 "igm".toList (scalarVar "v")) (.load16 "igm".toList (scalarVar "v")))]
def squareBody : Stmt := .scope ["v".toList] [] (chain squareSteps)
def squareCondition : KeygenWordExpr.Expr := .cmp .gt (var "u") (literal 0)
def squareIncrement : Stmt := .scalar (.update "u".toList .sub (.literal .i32 1))
def squareLoop : Stmt := .loop squareCondition squareBody squareIncrement
def initK : Stmt := .assign "k".toList (.bin .sub (var "logn") (literal 2))
def initCube : Stmt := .assign "u".toList powerK
def initSquare : Stmt := .assign "u".toList (.bin .sub powerK (literal 1))
def finish : Stmt := KeygenPublicTableRows.fragment 881 4
def afterRows : Stmt := .seq initK (.seq (.seq initCube cubeLoop) (.seq (.seq initSquare squareLoop) finish))
theorem source_after_rows : KeygenPublicTableRows.afterRows=afterRows := by decide
theorem cube_supported : KeygenPublicTableControl.supported cubeBody=true := by decide
theorem square_supported : KeygenPublicTableControl.supported squareBody=true := by decide

end FT1536.Source3.KeygenPublicUpperProgram
