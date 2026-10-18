import Source3.LevelPrefix177
import Source3.MakeFgTopParse177

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgTopShape177
open KeygenLevelExec (Stmt)
open LevelSequence177 (append arrayCode)

def scalars64 := ["n","dn","tn","u","v"].map String.toList
def scalars32 := ["p","p0i","R2","R3"].map String.toList
def pointers := ["gm","igm","fd","gd","fs","gs"].map String.toList
def declarationSteps : List Stmt := [arrayCode (.scalar (.declare .u64 scalars64)),
  .modular (DeepestDeclarations175.pointerCode pointers (.base .skip)),
  arrayCode (.scalar (.declare .u32 scalars32))]

def nExpr := C99ArrayParser.mkn (.var "logn".toList) (.literal .i32 1)
def dnExpr := C99ArrayParser.mkn (.var "logn".toList) (.literal .i32 0)
def tnExpr := C99ArrayParser.mkn (.bin .sub (.var "logn".toList) (.literal .i32 1)) (.literal .i32 0)
def assign (name : String) (e : CLogic.Expr) : Stmt := .modular (.assign name.toList (.scalar e))
def sizeSteps := [assign "n" nExpr,assign "dn" dnExpr,assign "tn" tnExpr]
def pointerSteps : List Stmt := [arrayCode (.bindPtr "fd".toList "data".toList C99ProcedureParser.zero),
  arrayCode (.bindPtr "gd".toList "fd".toList (.var "tn".toList)),
  arrayCode (.bindPtr "fs".toList "gd".toList (.var "tn".toList)),
  arrayCode (.bindPtr "gs".toList "fs".toList (.var "n".toList)),
  arrayCode (.bindPtr "gm".toList "gs".toList (.var "n".toList)),
  arrayCode (.bindPtr "igm".toList "gm".toList (.var "dn".toList))]
def countExpr : CLogic.Expr := .bin .mul (.bin .mul (.var "n".toList) (.literal .i32 2)) (.literal .u64 4)
def move : Stmt := .move "fs".toList "data".toList C99ProcedureParser.zero C99ProcedureParser.zero countExpr
def parsedCode := MakeFgTopParse177.parsed.getD KeygenLevelExec.skip
def remaining := LevelSequence177.drop 13 parsedCode

theorem front_checked : LevelPrefix177.take 13 parsedCode=
    declarationSteps++sizeSteps++pointerSteps++[move] := by decide

theorem shape : KeygenMakeFgTop.code=append declarationSteps
    (append sizeSteps (append pointerSteps (.seq move remaining))) :=
  MakeFgTopParse177.code.trans ((LevelPrefix177.partition 13 parsedCode).trans
    (congrArg (fun steps => append steps remaining) front_checked))

end FT1536.Source3.MakeFgTopShape177
