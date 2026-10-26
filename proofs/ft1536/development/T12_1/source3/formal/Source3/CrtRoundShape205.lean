import Source3.CrtMulCall205
import Source3.ZintRebuildCrt194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtRoundShape205
open C99ArrayReference (Name)
open KeygenZintCall (Stmt)
open KeygenWordExpr (Expr)

def cell (name : String) : Expr := .scalar (.var name.toList)
 def localNames : List Name := ["p".toList,"p0i".toList,"s".toList,"R2".toList,"v".toList]
 def coeffNames : List Name := ["xp".toList,"xq".toList,"xr".toList]
 def declare (ty : B20.C.Ty) (names : List Name) : Stmt := .word (.modular (.base (.scalar (.declare ty names))))
 def skip : Stmt := .word KeygenWordExec.skip
 def setXp : Stmt := .word (.assign "xp".toList (.load32 "x".toList (.var "u".toList)))
 def correction : Expr := .call4 "modp_montymul".toList (cell "s")
  (.call3 "modp_sub".toList (cell "xp") (cell "xq") (cell "p")) (cell "p") (cell "p0i")
 def setXr : Stmt := .word (.assign "xr".toList correction)
 def reduceCall : Stmt := .call (.leaf .reduce) CrtReduceCall205.args (.into "xq".toList)
 def addCall : Stmt := .call (.leaf .addMul) CrtAddMulCall205.args .discard
 def coeffBody : Stmt := .seq (declare .u32 coeffNames)
  (.seq setXp (.seq reduceCall (.seq setXr (.seq addCall skip))))
 def coeff : Stmt := .scope coeffNames [] coeffBody
 def guard : Expr := .cmp .lt (cell "v") (cell "num")
 def increment : Stmt := .seq (.word (.modular (.base (.scalar (.update "v".toList .add (.literal .i32 1))))))
  (.word (.modular (.base (.bindPtr "x".toList "x".toList (.var "xstride".toList)))))
 def walk : Stmt := .loop guard coeff increment
 def walkInit : Stmt := .seq (.word (.assign "v".toList (.scalar (.literal .i32 0))))
  (.word (.modular (.base (.bindPtr "x".toList "xx".toList C99ProcedureParser.zero))))
 def mulCall : Stmt := .call (.leaf .mul) CrtMulCall205.args (.store "tmp".toList (.var "u".toList))
 def inner : Stmt := .seq (declare .u32 ["p".toList,"p0i".toList,"s".toList,"R2".toList])
  (.seq (declare .u64 ["v".toList])
  (.seq (.prime "p".toList "primes".toList (.var "u".toList) .p)
  (.seq (.prime "s".toList "primes".toList (.var "u".toList) .s)
  (.seq (.word (.assign "p0i".toList (.call1 "modp_ninv31".toList (cell "p"))))
  (.seq (.word (.assign "R2".toList (.call2 "modp_R2".toList (cell "p") (cell "p0i"))))
  (.seq (.seq walkInit walk) (.seq mulCall skip)))))))
 def round : Stmt := .scope localNames [] inner

theorem shape : ZintRebuildCrt194.coBody=round := by decide

end FT1536.Source3.CrtRoundShape205
