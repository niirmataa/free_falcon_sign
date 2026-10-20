import Source3.KeygenCheckProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenCheckMutations
open C99ModularReference (Stmt Expr)
open KeygenCheckProgram

def withExpression (e : Expr) : Stmt :=
  .seq (.seq counter (.loop guard
    (.scope ["z".toList] (.seq (.base declaration) (.seq (.assign "z".toList e) (.seq gate skip)))) increment))
    (.seq oneReturn skip)
def swappedG : Expr := .call3 "modp_sub".toList (product "ft" "Ft") (product "gt" "Gt") (cell "p")
def omittedLast : Stmt :=
  .seq (.seq counter (.loop (.cmp .lt (.var "u".toList) (.literal .i32 1535)) iteration increment)) (.seq oneReturn skip)
def earlyAccept : Stmt := .seq (.seq counter (.loop guard oneReturn increment)) (.seq oneReturn skip)

theorem swapped_material_rejected : C99ModularParser.region 7386 11≠some (withExpression swappedG) := by
  rw [source_bound]
  decide
theorem missing_last_check_rejected : C99ModularParser.region 7386 11≠some omittedLast := by
  rw [source_bound]
  decide
theorem early_success_rejected : C99ModularParser.region 7386 11≠some earlyAccept := by
  rw [source_bound]
  decide

end FT1536.Source3.KeygenCheckMutations
