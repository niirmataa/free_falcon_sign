import Source3.MakeFgSpine188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepPrimeShape188
open KeygenMakeFgSource (Stmt modular skip)
open MakeFgDeclarations176 (arrayCode)
open FirstStepEntry187 (var num)

def initial : Stmt := modular (.assign "u".toList (.scalar (num 0)))
def condition : CLogic.Expr := .cmp .lt (var "u") (var "slen")
def increment : Stmt := modular (.base (.scalar (.update "u".toList .add (num 1))))
def body : Stmt := match KeygenMakeFgSource.part .step 2 with
  | .seq (.seq _ (.loop _ body _)) _ => body
  | _ => skip
def inner : Stmt := match body with | .scope _ _ code => code | _ => skip
def localNames := ["p","p0i","R2","v"].map String.toList
def pointerNames := ["x".toList]
def loop : Stmt := .loop condition body increment

theorem loop_shape : KeygenMakeFgSource.part .step 2=.seq (.seq initial loop) skip := by decide
theorem body_shape : body=.scope localNames pointerNames inner := by decide

def declarations : List Stmt := [arrayCode (.scalar (.declare .u32 ["p".toList,"p0i".toList,"R2".toList])),
  arrayCode (.scalar (.declare .u64 ["v".toList])),
  modular (DeepestDeclarations175.pointerCode ["x".toList] (.base .skip))]
def pSet : Stmt := .level (.prime "p".toList "primes".toList (var "u") .p)
def iSet : Stmt := modular (.assign "p0i".toList (.call1 "modp_ninv31".toList (KeygenMkgm3Program.cell "p")))
def rSet : Stmt := modular (.assign "R2".toList (.call2 "modp_R2".toList (KeygenMkgm3Program.cell "p") (KeygenMkgm3Program.cell "p0i")))
def prefixSteps := declarations++[pSet,iSet,rSet]
def args : List KeygenLevelCalls.Arg := [.pointer "gm".toList C99ProcedureParser.zero,
  .pointer "igm".toList C99ProcedureParser.zero,.scalar (.modular (.scalar (var "logn"))),
  .scalar (.modular (.scalar (num 0))),.scalar (.prime "primes".toList (var "u") .g),
  .scalar (.modular (KeygenMkgm3Program.cell "p")),.scalar (.modular (KeygenMkgm3Program.cell "p0i"))]
def generate : Stmt := .level (.call .generate args)
def remaining := MakeFgSpine188.drop 6 inner
def binary : Stmt := match remaining with | .seq (.branch _ _ no) _ => no | _ => skip
def tail := MakeFgSpine188.drop 1 remaining
def generateBranch : Stmt := .branch (var "ter") (.scope [] [] (.seq generate skip)) binary

theorem front : MakeFgSpine188.take 6 inner=prefixSteps := by decide

theorem prefix_shape : inner=MakeFgSequence187.append prefixSteps remaining :=
  (MakeFgSpine188.partition 6 inner).trans (congrArg (fun xs => MakeFgSequence187.append xs remaining) front)

theorem remaining_shape : remaining=.seq generateBranch tail := by decide

end FT1536.Source3.StepPrimeShape188
