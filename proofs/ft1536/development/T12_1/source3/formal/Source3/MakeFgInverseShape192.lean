import Source3.MakeFgTailShape190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-bound statement naming for the make_fg_step first-prime inverse
   call (statement s3 of the tail after the full0 generator call). Every
   definition is a transcription of the original parsed syntax, checked by
   decide against the projections of MakeFgTailShape190.s3; no execution or
   numerical property is claimed here. -/
namespace FT1536.Source3.MakeFgInverseShape192
open KeygenMakeFgSource (Stmt skip)
open KeygenLevelCalls (Arg)

def var (name : String) : CLogic.Expr := .var name.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n

def varU : CLogic.Expr := var "u"
def varSlen : CLogic.Expr := var "slen"
def varLogn : CLogic.Expr := var "logn"
def varP : CLogic.Expr := var "p"
def varI : CLogic.Expr := var "p0i"
def ternary : CLogic.Expr := var "ter"

/- Original source call modp_iNTT3_ext(fs + u, slen, igm, logn, 0, p, p0i);
   the argument fs + u is the fs pointer at index u, the bare igm argument is
   the igm pointer at the parser's zero index, and the full argument is the
   original zero literal. -/
def inverseArgs : List Arg :=
  [ .pointer "fs".toList varU,
    .scalar (.modular (.scalar varSlen)),
    .pointer "igm".toList C99ProcedureParser.zero,
    .scalar (.modular (.scalar varLogn)),
    .scalar (.modular (.scalar (num 0))),
    .scalar (.modular (.scalar varP)),
    .scalar (.modular (.scalar varI)) ]
def inverseCall : KeygenMakeFgSource.Stmt := .level (.call .inverse inverseArgs)

def inner : Stmt := match MakeFgTailShape190.s3Yes with | .scope _ _ body => body | _ => skip
theorem s3Yes_shape : MakeFgTailShape190.s3Yes=.scope [] [] inner := by decide

def terBranch : Stmt := match inner with | .seq first _ => first | _ => skip
theorem inner_shape : inner=.seq terBranch skip := by decide

def terYes : Stmt := match terBranch with | .branch _ yes _ => yes | _ => skip
def terNo : Stmt := match terBranch with | .branch _ _ no => no | _ => skip
theorem terBranch_shape : terBranch=.branch ternary terYes terNo := by decide

theorem terYes_shape : terYes=.scope [] [] (.seq inverseCall skip) := by decide

/- The false ter alternative keeps its original projection only; it is the
   modp_iNTT2_ext branch and never executes in this iteration (ter=1). -/
def terNoCall : Stmt := match terNo with | .scope _ _ (.seq first _) => first | _ => skip
theorem terNo_shape : terNo=.scope [] [] (.seq terNoCall skip) := by decide

end FT1536.Source3.MakeFgInverseShape192
