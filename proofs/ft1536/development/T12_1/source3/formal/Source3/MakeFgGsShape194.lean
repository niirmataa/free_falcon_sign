import Source3.MakeFgInverseShape192
import Source3.MakeFgProductShape191

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-bound statement naming for the gs path of the make_fg_step
   first-prime tail (statements s4-s8 after the assembled s0-s3 prefix):
   the gs-to-t1 copy loop (s4), the skipped !in_ntt forward branch (s5),
   the gd pair-product loop (s6), the gs inverse-call branch (s7) and the
   false !out_ntt branch (s8), whose body is the fd/gd inverse pair at
   logn-1 = 8 and tlen = 2. Every definition is a transcription of the
   original parsed syntax, checked by decide against the projections of
   MakeFgTailShape190; no execution or numerical property is claimed
   here. -/
namespace FT1536.Source3.MakeFgGsShape194
open KeygenMakeFgSource (Stmt skip)
open C99ModularReference (Expr)
open KeygenLevelCalls (Arg)

def var (name : String) : CLogic.Expr := .var name.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n

def varV : CLogic.Expr := var "v"
def varU : CLogic.Expr := var "u"
def varSlen : CLogic.Expr := var "slen"
def varTlen : CLogic.Expr := var "tlen"
def varLogn : CLogic.Expr := var "logn"
def varP : CLogic.Expr := var "p"
def varI : CLogic.Expr := var "p0i"
def ternary : CLogic.Expr := var "ter"
def inNtt : CLogic.Expr := var "in_ntt"

/- Original source index expression logn - 1 of the s8 pair calls. -/
def lognMinus1 : CLogic.Expr := .bin .sub varLogn (num 1)

/- s4: the original gs-to-t1 copy loop init and loop. -/
def copyInitGsCode : C99ModularReference.Stmt :=
  .seq (.assign "v".toList (.scalar (num 0))) (.base (.bindPtr "x".toList "gs".toList varU))
def copyInitGs : Stmt := .level (.modular copyInitGsCode)
def copyFGs : Stmt := .seq copyInitGs MakeFgTailShape190.copyLoop

theorem s4_shape : MakeFgTailShape190.s4=copyFGs := by decide

/- s5: the skipped !in_ntt forward branch (in_ntt = 1 at this step). -/
def s5Yes : Stmt := match MakeFgTailShape190.s5 with | .branch _ yes _ => yes | _ => skip

theorem s5_shape : MakeFgTailShape190.s5=.branch (.lnot inNtt) s5Yes skip := by decide

/- s6: the original gd pair-product loop init and loop. -/
def productInitGdCode : C99ModularReference.Stmt :=
  .seq (.assign "v".toList (.scalar (num 0))) (.base (.bindPtr "x".toList "gd".toList varU))
def productInitGd : Stmt := .level (.modular productInitGdCode)
def productFGd : Stmt := .seq productInitGd MakeFgProductShape191.productLoop

theorem s6_shape : MakeFgTailShape190.s6=productFGd := by decide

/- s7: the active inverse-call branch on gs; the call is the original
   modp_iNTT3_ext(gs + u, slen, igm, logn, 0, p, p0i). -/
def inverseArgsGs : List Arg :=
  [ .pointer "gs".toList varU,
    .scalar (.modular (.scalar varSlen)),
    .pointer "igm".toList C99ProcedureParser.zero,
    .scalar (.modular (.scalar varLogn)),
    .scalar (.modular (.scalar (num 0))),
    .scalar (.modular (.scalar varP)),
    .scalar (.modular (.scalar varI)) ]
def inverseCallGs : Stmt := .level (.call .inverse inverseArgsGs)

def s7Yes : Stmt := match MakeFgTailShape190.s7 with | .branch _ yes _ => yes | _ => skip
def inner7 : Stmt := match s7Yes with | .scope _ _ body => body | _ => skip
theorem s7Yes_shape : s7Yes=.scope [] [] inner7 := by decide

def terBranch7 : Stmt := match inner7 with | .seq first _ => first | _ => skip
theorem inner7_shape : inner7=.seq terBranch7 skip := by decide

def terYes7 : Stmt := match terBranch7 with | .branch _ yes _ => yes | _ => skip
def terNo7 : Stmt := match terBranch7 with | .branch _ _ no => no | _ => skip
theorem terBranch7_shape : terBranch7=.branch ternary terYes7 terNo7 := by decide

theorem terYes7_shape : terYes7=.scope [] [] (.seq inverseCallGs skip) := by decide

/- The false ter alternative keeps its original projection only; it is the
   modp_iNTT2_ext branch and never executes in this iteration (ter=1). -/
def terNo7Call : Stmt := match terNo7 with | .scope _ _ (.seq first _) => first | _ => skip
theorem terNo7_shape : terNo7=.scope [] [] (.seq terNo7Call skip) := by decide

theorem s7_shape : MakeFgTailShape190.s7=.branch inNtt s7Yes skip := by decide

/- s8: the false !out_ntt branch (out_ntt = 1 at this step); its body is
   the fd/gd inverse pair at logn - 1 = 8 and tlen = 2 —
   modp_iNTT3_ext(fd + u, tlen, igm, logn - 1, 0, p, p0i) followed by
   modp_iNTT3_ext(gd + u, tlen, igm, logn - 1, 0, p, p0i). -/
def fdArgs : List Arg :=
  [ .pointer "fd".toList varU,
    .scalar (.modular (.scalar varTlen)),
    .pointer "igm".toList C99ProcedureParser.zero,
    .scalar (.modular (.scalar lognMinus1)),
    .scalar (.modular (.scalar (num 0))),
    .scalar (.modular (.scalar varP)),
    .scalar (.modular (.scalar varI)) ]
def gdArgs : List Arg :=
  [ .pointer "gd".toList varU,
    .scalar (.modular (.scalar varTlen)),
    .pointer "igm".toList C99ProcedureParser.zero,
    .scalar (.modular (.scalar lognMinus1)),
    .scalar (.modular (.scalar (num 0))),
    .scalar (.modular (.scalar varP)),
    .scalar (.modular (.scalar varI)) ]
def pairCallFd : Stmt := .level (.call .inverse fdArgs)
def pairCallGd : Stmt := .level (.call .inverse gdArgs)

def inner8 : Stmt := match MakeFgTailShape190.s8Yes with | .scope _ _ body => body | _ => skip
theorem s8Yes_shape : MakeFgTailShape190.s8Yes=.scope [] [] inner8 := by decide

def terBranch8 : Stmt := match inner8 with | .seq first _ => first | _ => skip
theorem inner8_shape : inner8=.seq terBranch8 skip := by decide

def terYes8 : Stmt := match terBranch8 with | .branch _ yes _ => yes | _ => skip
def terNo8 : Stmt := match terBranch8 with | .branch _ _ no => no | _ => skip
theorem terBranch8_shape : terBranch8=.branch ternary terYes8 terNo8 := by decide

def pairFirst : Stmt := match terYes8 with | .scope _ _ (.seq first _) => first | _ => skip
def pairRest : Stmt := match terYes8 with | .scope _ _ (.seq _ rest) => rest | _ => skip
theorem terYes8_split : terYes8=.scope [] [] (.seq pairFirst pairRest) := by decide

theorem pairFirst_shape : pairFirst=pairCallFd := by decide
theorem pairRest_shape : pairRest=.seq pairCallGd skip := by decide

/- The false ter alternative of s8 keeps its original projection only; it
   is the modp_iNTT2_ext pair and never executes in this iteration. -/
def terNo8First : Stmt := match terNo8 with | .scope _ _ (.seq first _) => first | _ => skip
def terNo8Rest : Stmt := match terNo8 with | .scope _ _ (.seq _ rest) => rest | _ => skip
theorem terNo8_shape : terNo8=.scope [] [] (.seq terNo8First terNo8Rest) := by decide

end FT1536.Source3.MakeFgGsShape194
