import Source3.KeygenLevelNtt

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete pinned modp_iNTT3_ext inverse body (region 3147 98) split
   into its source parts like the forward KeygenNttForwardPrograms: the
   prologue with the mixed declarations and the logn0 return, the three
   inverse passes (divide-by-three, intermediate doubling, degree-1 final)
   and the corrective 1/n scaling. Each part is source-bound to its own
   contiguous region through the accepted KeygenLevelNtt.part projections
   by decide; every guard is retained, including the void logn0 return and
   the full-only divide-by-three pass. No execution or numerical property
   is claimed here. -/
namespace FT1536.Source3.NttInversePrograms192
open C99ModularReference (Expr Stmt)
open B20.C (BinOp)

def var (s : String) : CLogic.Expr := .var s.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def zero : CLogic.Expr := C99ProcedureParser.zero
def scalar (e : CLogic.Expr) : Expr := .scalar e
def read (src : String) (index : CLogic.Expr) : Expr := .load32 src.toList index
def call1 (name : String) (a : Expr) : Expr := .call1 name.toList a
def call3 (name : String) (a b c : Expr) : Expr := .call3 name.toList a b c
def call4 (name : String) (a b c d : Expr) : Expr := .call4 name.toList a b c d
def call5 (name : String) (a b c d e : Expr) : Expr := .call5 name.toList a b c d e
def update (name : String) (op : BinOp) (e : CLogic.Expr) : Stmt :=
  .base (.scalar (.update name.toList op e))
def assign (name : String) (e : Expr) : Stmt := .assign name.toList e
def bind (target source : String) (index : CLogic.Expr) : Stmt :=
  .base (.bindPtr target.toList source.toList index)
def write (name : String) (index : CLogic.Expr) (e : Expr) : Stmt := .store32 name.toList index e
def declareU64 (names : List String) : Stmt := .base (.scalar (.declare .u64 (names.map String.toList)))
def declareU32 (names : List String) : Stmt := .base (.scalar (.declare .u32 (names.map String.toList)))
def declarePtr (name : String) : Stmt := .base (.declarePtr name.toList)
def block (code : Stmt) : Stmt := .scope (C99ModularParser.declarations code) code
def chain : List Stmt → Stmt := C99ModularParser.chain

/- Prologue: the size_t/uint32/pointer declarations, the logn0 void return
   and the MKN macro expansion assigning n and hn. -/
def sizeDecl : Stmt := declareU64 ["n","hn","u","r","m","t"]
def sizeCode : Stmt := .seq sizeDecl (.base .skip)
def mixedCode : Stmt := chain [declareU32 ["w"],declareU32 ["ni"],declareU32 ["R"],
  declarePtr "r1",declarePtr "r2"]
def lognZero : CLogic.Expr := .cmp .eq (var "logn") (num 0)
def earlyExit : Stmt := .branch lognZero (.scope [] (.seq .retVoid (.base .skip))) (.base .skip)
def nAssign : Stmt := assign "n" (.scalar (C99ArrayParser.mkn (var "logn") (var "full")))
def hnAssign : Stmt := assign "hn" (.scalar (.bin .shr (var "n") (num 1)))
def guardPart : Stmt := chain [earlyExit,nAssign,hnAssign]
def prologue : Stmt := chain [sizeCode,mixedCode,guardPart]

theorem size_shape : KeygenLevelNtt.sizeCode=sizeCode := by decide
theorem mixed_shape : KeygenLevelNtt.mixedCode=mixedCode := by decide
theorem part0_shape : KeygenLevelNtt.part 0=guardPart := by decide

/- First pass: the divide-by-three section, executed only under full=1.
   Its inner statements keep the projection until a full instance is
   needed; every current call site passes full=0. -/
def tripleStmt : Stmt := match KeygenLevelNtt.part 1 with | .seq first _ => first | _ => .base .skip
def tripleTail : Stmt := match KeygenLevelNtt.part 1 with | .seq _ tail => tail | _ => .base .skip
def tripleBody : Stmt := match tripleStmt with | .branch _ yes _ => yes | _ => .base .skip
def tripleNo : Stmt := match tripleStmt with | .branch _ _ no => no | _ => .base .skip
def tripleGuard : Stmt := .branch (var "full") tripleBody tripleNo
def triplePass : Stmt := .seq tripleGuard (.base .skip)

theorem part1_split : KeygenLevelNtt.part 1=.seq tripleStmt tripleTail := by decide
theorem part1_tail : tripleTail=(.base .skip : Stmt) := by decide
theorem part1_branch : tripleStmt=tripleGuard := by decide

/- Intermediate passes: the reverse doubling rounds with their twiddle
   loop and radix-2 loop; t doubles each outer round. -/
def tInit : Stmt := assign "t" (.scalar (.bin .add (num 2) (.bin .shl (var "full") (num 2))))
def mInit : Stmt := assign "m" (.scalar (.bin .shl (.cast .u64 (num 1))
  (.bin .sub (.bin .sub (var "logn") (num 1)) (var "full"))))
def mGuard : CLogic.Expr := .cmp .lt (var "t") (var "n")
def mStep : Stmt := update "m" .shr (num 1)
def htAssign : Stmt := assign "ht" (.scalar (.bin .shr (var "t") (num 1)))
def u1Init : Stmt := .seq (assign "u1" (.scalar (num 0))) (assign "v1" (.scalar (num 0)))
def u1Step : Stmt := .seq (update "u1" .add (num 1)) (update "v1" .add (var "t"))
def sAssign : Stmt := assign "s" (read "igm" (.bin .add (var "m") (var "u1")))
def v1Bind : Stmt := bind "r1" "a" (.bin .mul (var "v1") (var "stride"))
def htBind : Stmt := bind "r2" "r1" (.bin .mul (var "ht") (var "stride"))
def vInit : Stmt := assign "v" (.scalar (num 0))
def pairStep : Stmt := .seq (bind "r1" "r1" (var "stride")) (bind "r2" "r2" (var "stride"))
def vStep : Stmt := .seq (update "v" .add (num 1)) pairStep
def vGuard : CLogic.Expr := .cmp .lt (var "v") (var "ht")
def xRead : Stmt := assign "x" (read "r1" zero)
def yRead : Stmt := assign "y" (read "r2" zero)
def addXY : Expr := call3 "modp_add" (scalar (var "x")) (scalar (var "y")) (scalar (var "p"))
def subXY : Expr := call3 "modp_sub" (scalar (var "x")) (scalar (var "y")) (scalar (var "p"))
def vWriteLow : Stmt := write "r1" zero addXY
def vWriteHigh : Stmt := write "r2" zero
  (call4 "modp_montymul" subXY (scalar (var "s")) (scalar (var "p")) (scalar (var "p0i")))
def vBody : Stmt := block (.seq (declareU32 ["x","y"])
  (.seq xRead (.seq yRead (.seq vWriteLow (.seq vWriteHigh (.base .skip))))))
def vLoop : Stmt := .seq vInit (.loop vGuard vBody vStep)
def u1Inner : Stmt := block (.seq (declareU64 ["v"]) (.seq (declareU32 ["s"])
  (.seq sAssign (.seq v1Bind (.seq htBind (.seq vLoop (.base .skip)))))))
def u1Guard : CLogic.Expr := .cmp .lt (var "u1") (var "m")
def u1Loop : Stmt := .seq u1Init (.loop u1Guard u1Inner u1Step)
def mInner : Stmt := block (.seq (declareU64 ["ht","u1","v1"])
  (.seq htAssign (.seq u1Loop (.seq (update "t" .shl (num 1)) (.base .skip)))))
def mLoop : Stmt := .seq mInit (.loop mGuard mInner mStep)
def intermediatePass : Stmt := .seq tInit (.seq mLoop (.base .skip))

theorem part2_shape : KeygenLevelNtt.part 2=intermediatePass := by decide

/- Final pass: the degree-1 inverse butterflies modulo X^2-X+1. -/
def wAssign : Stmt := assign "w" (read "igm" (num 0))
def uInit : Stmt := assign "u" (.scalar (num 0))
def r1Init : Stmt := bind "r1" "a" zero
def r2Init : Stmt := bind "r2" "a" (.bin .mul (var "hn") (var "stride"))
def uStep : Stmt := .seq (update "u" .add (num 1)) pairStep
def uGuard : CLogic.Expr := .cmp .lt (var "u") (var "hn")
def a0Read : Stmt := assign "a0" (read "r1" zero)
def a1Read : Stmt := assign "a1" (read "r2" zero)
def bAssign : Stmt := assign "b" (call3 "modp_add" (scalar (var "a0")) (scalar (var "a1"))
  (scalar (var "p")))
def subA : Expr := call3 "modp_sub" (scalar (var "a0")) (scalar (var "a1")) (scalar (var "p"))
def cAssign : Stmt := assign "c" (call4 "modp_montymul" (scalar (var "w")) subA
  (scalar (var "p")) (scalar (var "p0i")))
def fWriteLow : Stmt := write "r1" zero
  (call3 "modp_sub" (scalar (var "b")) (scalar (var "c")) (scalar (var "p")))
def fWriteHigh : Stmt := write "r2" zero
  (call3 "modp_add" (scalar (var "c")) (scalar (var "c")) (scalar (var "p")))
def fBody : Stmt := block (.seq (declareU32 ["a0","a1","b","c"])
  (.seq a0Read (.seq a1Read (.seq bAssign (.seq cAssign
    (.seq fWriteLow (.seq fWriteHigh (.base .skip))))))))
def fLoop : Stmt := .seq (.seq uInit (.seq r1Init r2Init)) (.loop uGuard fBody uStep)
def finalPass : Stmt := .seq wAssign (.seq fLoop (.base .skip))

theorem part3_shape : KeygenLevelNtt.part 3=finalPass := by decide

/- Correction: all values are divided by n through one Montgomery scaling
   loop, preceded by the exact modp_R/modp_div words. -/
def rAssign : Stmt := assign "R" (call1 "modp_R" (scalar (var "p")))
def niAssign : Stmt := assign "ni" (call5 "modp_div" (scalar (var "R"))
  (.scalar (.cast .u32 (var "n"))) (scalar (var "p")) (scalar (var "p0i")) (scalar (var "R")))
def cInit : Stmt := .seq uInit r1Init
def cStep : Stmt := .seq (update "u" .add (num 1)) (bind "r1" "r1" (var "stride"))
def cGuard : CLogic.Expr := .cmp .lt (var "u") (var "n")
def cScale : Stmt := write "r1" zero
  (call4 "modp_montymul" (read "r1" zero) (scalar (var "ni")) (scalar (var "p"))
    (scalar (var "p0i")))
def cBody : Stmt := block (.seq cScale (.base .skip))
def cLoop : Stmt := .seq cInit (.loop cGuard cBody cStep)
def correction : Stmt := .seq rAssign (.seq niAssign (.seq cLoop (.base .skip)))

theorem part4_shape : KeygenLevelNtt.part 4=correction := by decide

/- Sequence composition of all parts equals the accepted whole corpus. -/
def inverseBody : Stmt := chain [sizeCode,mixedCode,guardPart,triplePass,
  intermediatePass,finalPass,correction]

theorem body_source : KeygenLevelNtt.inverse=inverseBody := by decide

end FT1536.Source3.NttInversePrograms192
