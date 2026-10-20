import Source3.C99ModularParser
import Source3.KeygenFinalCheck

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenCheckProgram
open C99ModularReference (Expr Stmt)

def cell (name : String) : Expr := .scalar (.var name.toList)
def load (name : String) : Expr := .load32 name.toList (.var "u".toList)
def product (a b : String) : Expr := .call4 "modp_montymul".toList (load a) (load b) (cell "p") (cell "p0i")
def expression : Expr := .call3 "modp_sub".toList (product "ft" "Gt") (product "gt" "Ft") (cell "p")
def skip : Stmt := .base .skip
def zeroReturn : Stmt := .ret (.scalar (.literal .i32 0))
def oneReturn : Stmt := .ret (.scalar (.literal .i32 1))
def rejected : Stmt := .scope [] (.seq zeroReturn skip)
def condition : CLogic.Expr := .cmp .ne (.var "z".toList) (.var "r".toList)
def gate : Stmt := .branch condition rejected skip
def declaration : C99ArrayReference.Stmt := .scalar (.declare .u32 ["z".toList])
def iteration : Stmt := .scope ["z".toList]
  (.seq (.base declaration) (.seq (.assign "z".toList expression) (.seq gate skip)))
def guard : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "n".toList)
def increment : Stmt := .base (.scalar (.update "u".toList .add (.literal .i32 1)))
def loop : Stmt := .loop guard iteration increment
def counter : Stmt := .assign "u".toList (.scalar (.literal .i32 0))
def code : Stmt := .seq (.seq counter loop) (.seq oneReturn skip)

theorem source_bound : C99ModularParser.region 7386 11=some code := by decide
theorem source_pointer_types : Pinned.keygenLines[7283]?=some "\tuint32_t *ft, *gt, *Ft, *Gt, *gm;\n" := by decide
theorem source_scalar_types : Pinned.keygenLines[7284]?=some "\tuint32_t p, p0i, r;\n" := by decide
theorem source_counter_types : Pinned.keygenLines[7282]?=some "\tsize_t n, u;\n" := by decide

end FT1536.Source3.KeygenCheckProgram
