import Source3.KeygenPublicTableRows

/- DIAGNOSTIC probe: compare the parsed afterRows with the hand-written
   shape definitions. Not proof evidence. -/
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicGenerateUpperProbe
open KeygenPublicExec (Stmt)
open KeygenPublicTableAtoms (var literal mont divide)

def kSet : Stmt := .assign "k".toList
  (.bin .sub (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 2))
def u2Init : Stmt := .assign "u".toList
  (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1)) (KeygenPublicTableAtoms.var "k"))
def upperGuard : KeygenWordExpr.Expr := .cmp .lt (KeygenPublicTableAtoms.var "u")
  (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1))
    (.bin .add (KeygenPublicTableAtoms.var "k") (KeygenPublicTableAtoms.literal 1)))
def upperBody : Stmt := .scope ["y".toList,"z".toList] [] (KeygenPublicExec.chain [
  .scalar (.declare .u32 ["y".toList,"z".toList]),
  .assign "y".toList (.load16 "gm".toList
    (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
  .assign "z".toList (.load16 "igm".toList
    (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
  .store "gm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y")
      (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y") (KeygenPublicTableAtoms.var "y"))),
  .store "igm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
      (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z")))])
def upperInc : Stmt := .scalar (.update "u".toList .add (CLogic.Expr.literal .i32 1))
def upperLoop : Stmt := .loop upperGuard upperBody upperInc
def u3Init : Stmt := .assign "u".toList (.bin .sub
  (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1)) (KeygenPublicTableAtoms.var "k"))
  (KeygenPublicTableAtoms.literal 1))
def squareGuard : KeygenWordExpr.Expr := .cmp .gt (KeygenPublicTableAtoms.var "u")
  (KeygenPublicTableAtoms.literal 0)
def squareBody : Stmt := .scope ["v".toList] [] (KeygenPublicExec.chain [
  .scalar (.declare .u64 ["v".toList]),
  .assign "v".toList (.bin .shl (KeygenPublicTableAtoms.var "u")
    (KeygenPublicTableAtoms.literal 1)),
  .store "gm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (.load16 "gm".toList (CLogic.Expr.var "v".toList))
      (.load16 "gm".toList (CLogic.Expr.var "v".toList))),
  .store "igm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (.load16 "igm".toList (CLogic.Expr.var "v".toList))
      (.load16 "igm".toList (CLogic.Expr.var "v".toList)))])
def squareInc : Stmt := .scalar (.update "u".toList .sub (CLogic.Expr.literal .i32 1))
def squareLoop : Stmt := .loop squareGuard squareBody squareInc
def finalTail : Stmt :=
  .seq (.store "gm".toList (CLogic.Expr.literal .i32 0) false
      (.load16 "gm".toList (CLogic.Expr.literal .i32 1)))
  (.seq (.assign "w".toList (.load16 "gm".toList (CLogic.Expr.literal .i32 1)))
  (.seq (.store "igm".toList (CLogic.Expr.literal .i32 0) true
    (KeygenPublicTableAtoms.divide (KeygenPublicTableAtoms.literal 4564)
      (.call3 (KeygenPublicScalar.name .sub)
        (.call3 (KeygenPublicScalar.name .add)
          (KeygenPublicTableAtoms.var "w") (KeygenPublicTableAtoms.var "w")
          (KeygenPublicTableAtoms.literal 18433))
        (KeygenPublicTableAtoms.literal 10237)
        (KeygenPublicTableAtoms.literal 18433))))
  .skip))

def myShape : Stmt :=
  .seq kSet (.seq (.seq u2Init upperLoop) (.seq (.seq u3Init squareLoop) finalTail))

end FT1536.Source3.PublicGenerateUpperProbe

#eval IO.println (repr (FT1536.Source3.KeygenPublicTableRows.afterRows))
#eval IO.println (repr FT1536.Source3.PublicGenerateUpperProbe.myShape)
