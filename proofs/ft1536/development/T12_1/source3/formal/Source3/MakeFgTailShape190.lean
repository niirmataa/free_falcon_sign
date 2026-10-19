import Source3.StepPrimeShape188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-bound statement naming for the make_fg_step first-prime tail after
   the full0 generator call. Every statement is a projection of the original
   parsed syntax or a transcription checked by decide against that syntax;
   no execution or numerical property is claimed here. -/
namespace FT1536.Source3.MakeFgTailShape190
open KeygenMakeFgSource (Stmt skip)
open C99ModularReference (Expr)

def var (name : String) : CLogic.Expr := .var name.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def at0 : CLogic.Expr := .literal .u64 0

def r0 : Stmt := StepPrimeShape188.tail
def s0 : Stmt := match r0 with | .seq a _ => a | _ => skip
def r1 : Stmt := match r0 with | .seq _ b => b | _ => skip
def s1 : Stmt := match r1 with | .seq a _ => a | _ => skip
def r2 : Stmt := match r1 with | .seq _ b => b | _ => skip
def s2 : Stmt := match r2 with | .seq a _ => a | _ => skip
def r3 : Stmt := match r2 with | .seq _ b => b | _ => skip
def s3 : Stmt := match r3 with | .seq a _ => a | _ => skip
def r4 : Stmt := match r3 with | .seq _ b => b | _ => skip
def s4 : Stmt := match r4 with | .seq a _ => a | _ => skip
def r5 : Stmt := match r4 with | .seq _ b => b | _ => skip
def s5 : Stmt := match r5 with | .seq a _ => a | _ => skip
def r6 : Stmt := match r5 with | .seq _ b => b | _ => skip
def s6 : Stmt := match r6 with | .seq a _ => a | _ => skip
def r7 : Stmt := match r6 with | .seq _ b => b | _ => skip
def s7 : Stmt := match r7 with | .seq a _ => a | _ => skip
def r8 : Stmt := match r7 with | .seq _ b => b | _ => skip
def s8 : Stmt := match r8 with | .seq a _ => a | _ => skip
def r9 : Stmt := match r8 with | .seq _ b => b | _ => skip

theorem r0_split : r0=.seq s0 r1 := by decide
theorem r1_split : r1=.seq s1 r2 := by decide
theorem r2_split : r2=.seq s2 r3 := by decide
theorem r3_split : r3=.seq s3 r4 := by decide
theorem r4_split : r4=.seq s4 r5 := by decide
theorem r5_split : r5=.seq s5 r6 := by decide
theorem r6_split : r6=.seq s6 r7 := by decide
theorem r7_split : r7=.seq s7 r8 := by decide
theorem r8_split : r8=.seq s8 r9 := by decide
theorem r9_skip : r9=skip := by decide

/- First statement: the original fs-to-t1 copy loop. -/
def varV : CLogic.Expr := var "v"
def varU : CLogic.Expr := var "u"
def varN : CLogic.Expr := var "n"
def varSlen : CLogic.Expr := var "slen"
def copyInitCode : C99ModularReference.Stmt := .seq
  (.assign "v".toList (.scalar (num 0)))
  (.base (.bindPtr "x".toList "fs".toList varU))
def copyInit : Stmt := .level (.modular copyInitCode)
def copyStore : Stmt := .level (.modular (.store32 "t1".toList varV (.load32 "x".toList at0)))
def copyBody : Stmt := .scope [] [] (.seq copyStore skip)
def copyIncCode : C99ModularReference.Stmt := .seq
  (.base (.scalar (.update "v".toList .add (num 1))))
  (.base (.bindPtr "x".toList "x".toList varSlen))
def copyInc : Stmt := .level (.modular copyIncCode)
def copyCondition : CLogic.Expr := .cmp .lt varV varN
def copyLoop : Stmt := .loop copyCondition copyBody copyInc
def copyF : Stmt := .seq copyInit copyLoop
theorem s0_shape : s0=copyF := by decide

/- The skipped forward branches and the later loops are named by their
   projections; explicit product/inverse syntax is bound in later modules. -/
def inNtt : CLogic.Expr := var "in_ntt"
def outNtt : CLogic.Expr := var "out_ntt"
def ternary : CLogic.Expr := var "ter"

def s1Yes : Stmt := match s1 with | .branch _ yes _ => yes | _ => skip
def s3Yes : Stmt := match s3 with | .branch _ yes _ => yes | _ => skip
def s8Yes : Stmt := match s8 with | .branch _ yes _ => yes | _ => skip

theorem s1_shape : s1=.branch (.lnot inNtt) s1Yes skip := by decide
theorem s3_shape : s3=.branch inNtt s3Yes skip := by decide
theorem s8_shape : s8=.branch (.lnot outNtt) s8Yes skip := by decide

end FT1536.Source3.MakeFgTailShape190
