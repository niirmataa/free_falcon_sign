import Source3.MakeFgGsShape194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-bound statement naming for the make_fg_step additional-prime
   section (part 4: the remaining-words loop `for (u = slen; u < tlen;
   u ++)` at the selected instance slen = 1 / tlen = 2): the loop head,
   the p/p0i/R2/Rx prime prefix, the ter generator branch, the two
   zint_mod_small_signed walks over fs/gs with their modp_NTT3 branches,
   the fd/gd pair-product loops and the false !out_ntt branch whose body
   is the fd/gd inverse pair at logn - 1 and tlen. Every definition is a
   projection of the original parsed syntax or a transcription checked
   by decide against that syntax; the exact parse record is the retained
   diagnostic probe AddPrimeParseProbe194 (job keygen_publicforward159_553).
   No execution or numerical property is claimed here. -/
namespace FT1536.Source3.MakeFgAddPrimeShape194
open KeygenMakeFgSource (Stmt skip)
open C99ModularReference (Expr)
open C99ArrayReference (Arg)
open KeygenMkgm3Program (cell)

def var (name : String) : CLogic.Expr := .var name.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def at0 : CLogic.Expr := .literal .u64 0

def varU : CLogic.Expr := var "u"
def varV : CLogic.Expr := var "v"
def varN : CLogic.Expr := var "n"
def varSlen : CLogic.Expr := var "slen"
def varTlen : CLogic.Expr := var "tlen"
def varLogn : CLogic.Expr := var "logn"
def ternary : CLogic.Expr := var "ter"
def outNtt : CLogic.Expr := var "out_ntt"
def lognMinus1 : CLogic.Expr := .bin .sub varLogn (num 1)

/- The loop head: u = slen init, the u < tlen guard and the u += 1
   increment of the single-iteration loop (slen = 1, tlen = 2). -/
def part4 : Stmt := KeygenMakeFgSource.part .step 4
def aFor : Stmt := match part4 with | .seq a _ => a | _ => skip
def aTail : Stmt := match part4 with | .seq _ b => b | _ => skip
theorem part4_split : part4=.seq aFor aTail := by decide
theorem aTail_skip : aTail=skip := by decide

def initU : Stmt := KeygenMakeFgSource.modular (.assign "u".toList (.scalar varSlen))
def incU : Stmt := KeygenMakeFgSource.modular (.base (.scalar (.update "u".toList .add (num 1))))
def aInit : Stmt := match aFor with | .seq a _ => a | _ => skip
def aLoop : Stmt := match aFor with | .seq _ b => b | _ => skip
theorem aFor_split : aFor=.seq aInit aLoop := by decide
theorem init_shape : aInit=initU := by decide

def aBody : Stmt := match aLoop with | .loop _ b _ => b | _ => skip
def aInc : Stmt := match aLoop with | .loop _ _ i => i | _ => skip
theorem loop_shape : aLoop=.loop (.cmp .lt varU varTlen) aBody aInc := by decide
theorem inc_shape : aInc=incU := by decide

/- The loop body scope: locals p/p0i/R2/Rx/v and the walk pointer x. -/
def localNames : List C99ArrayReference.Name := ["p","p0i","R2","Rx","v"].map String.toList
def pointerNames : List C99ArrayReference.Name := ["x".toList]
def aInner : Stmt := match aBody with | .scope _ _ code => code | _ => skip
theorem body_shape : aBody=.scope localNames pointerNames aInner := by decide

/- Prime prefix: the block prime read p = primes[u].p, the executed-word
   calls p0i = modp_ninv31(p), R2 = modp_R2(p, p0i) and the new
   Rx = modp_Rx(slen, p, p0i, R2) of this section. The first three are
   the StepPrimeShape188 prefix statements verbatim. -/
def declP : Stmt := MakeFgDeclarations176.arrayCode
  (.scalar (.declare .u32 ["p".toList,"p0i".toList,"R2".toList,"Rx".toList]))
def declV : Stmt := MakeFgDeclarations176.arrayCode (.scalar (.declare .u64 ["v".toList]))
def declX : Stmt := KeygenMakeFgSource.modular (DeepestDeclarations175.pointerCode ["x".toList] (.base .skip))
def pSet : Stmt := StepPrimeShape188.pSet
def iSet : Stmt := StepPrimeShape188.iSet
def rSet : Stmt := StepPrimeShape188.rSet
def rxSet : Stmt := KeygenMakeFgSource.modular
  (.assign "Rx".toList (.call4 "modp_Rx".toList (cell "slen") (cell "p") (cell "p0i") (cell "R2")))

def prefixSteps : List Stmt := [declP,declV,declX,pSet,iSet,rSet,rxSet]
def remaining : Stmt := MakeFgSpine188.drop 7 aInner
theorem front : MakeFgSpine188.take 7 aInner=prefixSteps := by decide
theorem prefix_shape : aInner=MakeFgSequence187.append prefixSteps remaining :=
  (MakeFgSpine188.partition 7 aInner).trans
    (congrArg (fun xs => MakeFgSequence187.append xs remaining) front)

/- The zint_mod_small_signed walk statement: the per-word call over the
   walked pointer x with the section words p/p0i/R2/Rx and the store of
   the executed word into t1[v]. -/
def modArgs : List Arg :=
  [ .pointer "x".toList C99ProcedureParser.zero,
    .scalar varSlen,
    .scalar (var "p"),
    .scalar (var "p0i"),
    .scalar (var "R2"),
    .scalar (var "Rx") ]
def modCall : KeygenZintCall.Stmt := .call .modSigned modArgs (.store "t1".toList varV)

def walkInit (src : String) : Stmt := KeygenMakeFgSource.modular
  (.seq (.assign "v".toList (.scalar (num 0))) (.base (.bindPtr "x".toList src.toList at0)))
def walkBody : Stmt := .scope [] [] (.seq (.zint modCall) skip)
def walkInc : Stmt := MakeFgTailShape190.copyInc
def walkLoop : Stmt := .loop (.cmp .lt varV varN) walkBody walkInc
def walkF (src : String) : Stmt := .seq (walkInit src) walkLoop

/- The modp_NTT3 branch of each walk (ter = 1 at this step): the wrapper
   call modp_NTT3(t1, gm, logn, 0, p, p0i) over the expanded stride-1
   argument list; the false ter alternative is the modp_NTT2 binary. -/
def forwardArgs : List KeygenLevelCalls.Arg :=
  [ KeygenLevelCalls.Arg.pointer "t1".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (num 1))),
    KeygenLevelCalls.Arg.pointer "gm".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar varLogn)),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (num 0))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p"))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p0i"))) ]
def binaryForwardArgs : List KeygenLevelCalls.Arg :=
  [ KeygenLevelCalls.Arg.pointer "t1".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (num 1))),
    KeygenLevelCalls.Arg.pointer "gm".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar varLogn)),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p"))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p0i"))) ]
def forwardCall : Stmt := .level (.call .forward forwardArgs)
def binaryForwardCall : Stmt := .binary .forward binaryForwardArgs
def nttYes : Stmt := .scope [] [] (.seq forwardCall skip)
def nttNo : Stmt := .scope [] [] (.seq binaryForwardCall skip)
def nttBranch : Stmt := .branch ternary nttYes nttNo

/- The ter generator branch pinned by both exact parsed argument lists:
   the modp_mkgm3 wrapper call and the modp_mkgm2 binary alternative
   (never taken at ter = 1). -/
def generateArgs : List KeygenLevelCalls.Arg :=
  [ KeygenLevelCalls.Arg.pointer "gm".toList at0,
    KeygenLevelCalls.Arg.pointer "igm".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar varLogn)),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (num 0))),
    KeygenLevelCalls.Arg.scalar (.prime "primes".toList varU KeygenLevelCalls.Field.g),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p"))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p0i"))) ]
def binaryGenerateArgs : List KeygenLevelCalls.Arg :=
  [ KeygenLevelCalls.Arg.pointer "gm".toList at0,
    KeygenLevelCalls.Arg.pointer "igm".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar varLogn)),
    KeygenLevelCalls.Arg.scalar (.prime "primes".toList varU KeygenLevelCalls.Field.g),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p"))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p0i"))) ]
def generateCall : Stmt := .level (.call .generate generateArgs)
def binaryGenerateCall : Stmt := .binary .generate binaryGenerateArgs
def genYes : Stmt := .scope [] [] (.seq generateCall skip)
def genNo : Stmt := .scope [] [] (.seq binaryGenerateCall skip)
def generateBranchT : Stmt := .branch ternary genYes genNo

/- Statement chain of the loop body after the seven-statement prefix:
   the ter generator branch, the fs walk, its NTT branch, the fd product
   loop, the gs walk, its NTT branch, the gd product loop and the false
   !out_ntt branch. -/
def gBranch : Stmt := match remaining with | .seq a _ => a | _ => skip
def r1 : Stmt := match remaining with | .seq _ b => b | _ => skip
def walkFs : Stmt := match r1 with | .seq a _ => a | _ => skip
def r2 : Stmt := match r1 with | .seq _ b => b | _ => skip
def nttFs : Stmt := match r2 with | .seq a _ => a | _ => skip
def r3 : Stmt := match r2 with | .seq _ b => b | _ => skip
def productFd : Stmt := match r3 with | .seq a _ => a | _ => skip
def r4 : Stmt := match r3 with | .seq _ b => b | _ => skip
def walkGs : Stmt := match r4 with | .seq a _ => a | _ => skip
def r5 : Stmt := match r4 with | .seq _ b => b | _ => skip
def nttGs : Stmt := match r5 with | .seq a _ => a | _ => skip
def r6 : Stmt := match r5 with | .seq _ b => b | _ => skip
def productGd : Stmt := match r6 with | .seq a _ => a | _ => skip
def r7 : Stmt := match r6 with | .seq _ b => b | _ => skip
def outBranch : Stmt := match r7 with | .seq a _ => a | _ => skip
def r8 : Stmt := match r7 with | .seq _ b => b | _ => skip

theorem r0_split : remaining=.seq gBranch r1 := by decide
theorem r1_split : r1=.seq walkFs r2 := by decide
theorem r2_split : r2=.seq nttFs r3 := by decide
theorem r3_split : r3=.seq productFd r4 := by decide
theorem r4_split : r4=.seq walkGs r5 := by decide
theorem r5_split : r5=.seq nttGs r6 := by decide
theorem r6_split : r6=.seq productGd r7 := by decide
theorem r7_split : r7=.seq outBranch r8 := by decide
theorem r8_skip : r8=skip := by decide

/- The false !out_ntt branch (out_ntt = 1 at this step) pinned by its
   exact parsed argument lists: the fd/gd inverse pair at logn - 1 and
   tlen (modp_iNTT3_ext) and the modp_iNTT2_ext binary pair of the
   false ter alternative. -/
def pairFdArgs : List KeygenLevelCalls.Arg :=
  [ KeygenLevelCalls.Arg.pointer "fd".toList varU,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar varTlen)),
    KeygenLevelCalls.Arg.pointer "igm".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar lognMinus1)),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (num 0))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p"))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p0i"))) ]
def pairGdArgs : List KeygenLevelCalls.Arg :=
  [ KeygenLevelCalls.Arg.pointer "gd".toList varU,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar varTlen)),
    KeygenLevelCalls.Arg.pointer "igm".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar lognMinus1)),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (num 0))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p"))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p0i"))) ]
def pairBinFdArgs : List KeygenLevelCalls.Arg :=
  [ KeygenLevelCalls.Arg.pointer "fd".toList varU,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar varTlen)),
    KeygenLevelCalls.Arg.pointer "igm".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar lognMinus1)),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p"))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p0i"))) ]
def pairBinGdArgs : List KeygenLevelCalls.Arg :=
  [ KeygenLevelCalls.Arg.pointer "gd".toList varU,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar varTlen)),
    KeygenLevelCalls.Arg.pointer "igm".toList at0,
    KeygenLevelCalls.Arg.scalar (.modular (.scalar lognMinus1)),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p"))),
    KeygenLevelCalls.Arg.scalar (.modular (.scalar (var "p0i"))) ]
def pairCallFd : Stmt := .level (.call .inverse pairFdArgs)
def pairCallGd : Stmt := .level (.call .inverse pairGdArgs)
def pairBinFd : Stmt := .binary .inverse pairBinFdArgs
def pairBinGd : Stmt := .binary .inverse pairBinGdArgs
def pairYes : Stmt := .scope [] [] (.seq pairCallFd (.seq pairCallGd skip))
def pairNo : Stmt := .scope [] [] (.seq pairBinFd (.seq pairBinGd skip))
def terPair : Stmt := .branch ternary pairYes pairNo
def outYes : Stmt := .scope [] [] (.seq terPair skip)
def outBranchT : Stmt := .branch (.lnot outNtt) outYes skip

/- Shape bindings: the walks are the fs/gs instantiations of the same
   zint_mod_small_signed walk, the NTT branches share one wrapper call,
   the product loops are the already named first-prime shapes verbatim,
   and the generator / !out_ntt branches are pinned by their exact
   argument lists in split form (guard, then each side). -/
theorem walkFs_shape : walkFs=walkF "fs" := by decide
theorem walkGs_shape : walkGs=walkF "gs" := by decide
theorem nttFs_shape : nttFs=nttBranch := by decide
theorem nttGs_shape : nttGs=nttBranch := by decide

def gbYes : Stmt := match gBranch with | .branch _ yes _ => yes | _ => skip
def gbNo : Stmt := match gBranch with | .branch _ _ no => no | _ => skip
theorem generateBranch_guard : gBranch=.branch ternary gbYes gbNo := by decide
theorem genYes_shape : gbYes=genYes := by decide
theorem genNo_shape : gbNo=genNo := by decide

theorem productFd_shape : productFd=MakeFgProductShape191.productF := by decide
theorem productGd_shape : productGd=MakeFgGsShape194.productFGd := by decide

def obYes : Stmt := match outBranch with | .branch _ yes _ => yes | _ => skip
theorem outBranch_guard : outBranch=.branch (.lnot outNtt) obYes skip := by decide
theorem outYes_shape : obYes=outYes := by decide

/- zint_mod_small_signed callee spine at the selected instance (dlen =
   slen = 1): the z declaration, the dlen = 0 early return branch, the
   zint_mod_small_unsigned leaf call into z, the modp_sub correction with
   the sign word Rx & -(d[dlen-1] >> 30) and the z return. -/
def msBody : KeygenZintCall.Stmt := KeygenZintCall.calleeBody .modSigned
def msDeclZ : KeygenZintCall.Stmt := match msBody with | .seq a _ => a | _ => KeygenZintCall.skip
def msRest1 : KeygenZintCall.Stmt := match msBody with | .seq _ b => b | _ => KeygenZintCall.skip
def msZeroBranch : KeygenZintCall.Stmt := match msRest1 with | .seq a _ => a | _ => KeygenZintCall.skip
def msRest2 : KeygenZintCall.Stmt := match msRest1 with | .seq _ b => b | _ => KeygenZintCall.skip
def msReduceCall : KeygenZintCall.Stmt := match msRest2 with | .seq a _ => a | _ => KeygenZintCall.skip
def msRest3 : KeygenZintCall.Stmt := match msRest2 with | .seq _ b => b | _ => KeygenZintCall.skip
def msSubAssign : KeygenZintCall.Stmt := match msRest3 with | .seq a _ => a | _ => KeygenZintCall.skip
def msRest4 : KeygenZintCall.Stmt := match msRest3 with | .seq _ b => b | _ => KeygenZintCall.skip
def msRetZ : KeygenZintCall.Stmt := match msRest4 with | .seq a _ => a | _ => KeygenZintCall.skip
def msRest5 : KeygenZintCall.Stmt := match msRest4 with | .seq _ b => b | _ => KeygenZintCall.skip

theorem ms_split1 : msBody=.seq msDeclZ msRest1 := by decide
theorem ms_split2 : msRest1=.seq msZeroBranch msRest2 := by decide
theorem ms_split3 : msRest2=.seq msReduceCall msRest3 := by decide
theorem ms_split4 : msRest3=.seq msSubAssign msRest4 := by decide
theorem ms_split5 : msRest4=.seq msRetZ msRest5 := by decide
theorem ms_tail : msRest5=KeygenZintCall.skip := by decide

end FT1536.Source3.MakeFgAddPrimeShape194
