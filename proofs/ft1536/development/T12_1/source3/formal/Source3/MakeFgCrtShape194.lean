import Source3.KeygenZintCall098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-bound statement naming for the two zint_rebuild_CRT calls of the
   make_fg_step part 3 (`zint_rebuild_CRT(fs/gs, slen, slen, n, primes, 1,
   gm)` after the loop exit state) and for the consumed callee bodies
   (zint_rebuild_CRT / zint_norm_zero / zint_sub at the selected instance
   xlen = slen = 1). Every definition is a projection of the original
   parsed syntax checked by decide; no execution or numerical property is
   claimed here. The full parse record is the retained diagnostic probe
   ZintCrtParseProbe194 (job keygen_publicforward159_510). -/
namespace FT1536.Source3.MakeFgCrtShape194
open KeygenMakeFgSource (Stmt skip)
open C99ArrayReference (Arg)
open KeygenZintCall (Callee)

def var (name : String) : CLogic.Expr := .var name.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n

/- Original call arguments: the walk source, the xlen/xstride words both
   read from the slen cell, the num word from the n cell, the primes
   table pointer, the i32 literal 1 and the gm scratch pointer. -/
def crtArgs (src : String) : List Arg :=
  [ .pointer src.toList C99ProcedureParser.zero,
    .scalar (var "slen"),
    .scalar (var "slen"),
    .scalar (var "n"),
    .pointer "primes".toList C99ProcedureParser.zero,
    .scalar (num 1),
    .pointer "gm".toList C99ProcedureParser.zero ]

def crtCall (src : String) : Stmt := .zint (.call .rebuildCrt (crtArgs src) .discard)

/- Part 3: the fs call, the gs call and the trailing skip. -/
def part3 : Stmt := KeygenMakeFgSource.part .step 3
def first3 : Stmt := match part3 with | .seq a _ => a | _ => skip
def rest3 : Stmt := match part3 with | .seq _ b => b | _ => skip
def second3 : Stmt := match rest3 with | .seq a _ => a | _ => skip
def tail3 : Stmt := match rest3 with | .seq _ b => b | _ => skip

theorem part3_split : part3=.seq first3 rest3 := by decide
theorem rest3_split : rest3=.seq second3 tail3 := by decide
theorem first3_shape : first3=crtCall "fs" := by decide
theorem second3_shape : second3=crtCall "gs" := by decide
theorem tail3_skip : tail3=skip := by decide

/- zint_rebuild_CRT body spine at xlen = 1: the u and x declarations, the
   tmp[0] = primes[0].p prime-member store, the u = 1 init, the
   co-reduction loop (empty at xlen = 1) and the normalize_signed branch
   whose body is the 512-step zint_norm_zero walk. -/
def crtBody : KeygenZintCall.Stmt := KeygenZintCall.calleeBody .rebuildCrt
def crtDeclU : KeygenZintCall.Stmt := match crtBody with | .seq a _ => a | _ => KeygenZintCall.skip
def crtRest1 : KeygenZintCall.Stmt := match crtBody with | .seq _ b => b | _ => KeygenZintCall.skip
def crtDeclX : KeygenZintCall.Stmt := match crtRest1 with | .seq a _ => a | _ => KeygenZintCall.skip
def crtRest2 : KeygenZintCall.Stmt := match crtRest1 with | .seq _ b => b | _ => KeygenZintCall.skip
def crtStore : KeygenZintCall.Stmt := match crtRest2 with | .seq a _ => a | _ => KeygenZintCall.skip
def crtRest3 : KeygenZintCall.Stmt := match crtRest2 with | .seq _ b => b | _ => KeygenZintCall.skip
def crtCore : KeygenZintCall.Stmt := match crtRest3 with | .seq a _ => a | _ => KeygenZintCall.skip
def crtNormalize : KeygenZintCall.Stmt := match crtRest3 with | .seq _ b => b | _ => KeygenZintCall.skip

theorem crt_split1 : crtBody=.seq crtDeclU crtRest1 := by decide
theorem crt_split2 : crtRest1=.seq crtDeclX crtRest2 := by decide
theorem crt_split3 : crtRest2=.seq crtStore crtRest3 := by decide
theorem crt_split4 : crtRest3=.seq crtCore crtNormalize := by decide

/- zint_norm_zero body spine at len = 1: the cc/u declarations and
   initializations, the u > 0 loop whose body decrements u first (the
   post-decrement of `u -- > 0`), the two comparison branches with their
   returns (and the zint_sub call of the second branch) and the trailing
   u decrement of the final guard evaluation. -/
def normBody : KeygenZintCall.Stmt := KeygenZintCall.calleeBody .normZero
def normDeclC : KeygenZintCall.Stmt := match normBody with | .seq a _ => a | _ => KeygenZintCall.skip
def normRest1 : KeygenZintCall.Stmt := match normBody with | .seq _ b => b | _ => KeygenZintCall.skip
def normDeclU : KeygenZintCall.Stmt := match normRest1 with | .seq a _ => a | _ => KeygenZintCall.skip
def normRest2 : KeygenZintCall.Stmt := match normRest1 with | .seq _ b => b | _ => KeygenZintCall.skip
def normCC0 : KeygenZintCall.Stmt := match normRest2 with | .seq a _ => a | _ => KeygenZintCall.skip
def normRest3 : KeygenZintCall.Stmt := match normRest2 with | .seq _ b => b | _ => KeygenZintCall.skip
def normSetU : KeygenZintCall.Stmt := match normRest3 with | .seq a _ => a | _ => KeygenZintCall.skip
def normRest4 : KeygenZintCall.Stmt := match normRest3 with | .seq _ b => b | _ => KeygenZintCall.skip
def normLoopDec : KeygenZintCall.Stmt := match normRest4 with | .seq a _ => a | _ => KeygenZintCall.skip
def normFinalSkip : KeygenZintCall.Stmt := match normRest4 with | .seq _ b => b | _ => KeygenZintCall.skip

theorem norm_split1 : normBody=.seq normDeclC normRest1 := by decide
theorem norm_split2 : normRest1=.seq normDeclU normRest2 := by decide
theorem norm_split3 : normRest2=.seq normCC0 normRest3 := by decide
theorem norm_split4 : normRest3=.seq normSetU normRest4 := by decide
theorem norm_split5 : normRest4=.seq normLoopDec normFinalSkip := by decide

/- zint_sub body spine at len = 1: the u/cc declarations and the cc = 0
   initialization shared with the sealed leaf record. -/
def subBody : KeygenZintCall.Stmt := KeygenZintCall.calleeBody (.leaf .sub)

end FT1536.Source3.MakeFgCrtShape194
