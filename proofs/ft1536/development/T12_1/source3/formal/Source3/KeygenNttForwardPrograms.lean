import Source3.KeygenNttButterflyPrograms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The complete pinned modp_NTT3_ext forward body (region 3046 91) split
   into its four source parts: prologue with the logn0 guard, first pass,
   intermediate doubling passes and the final triple pass. Each part is
   source-bound to its own contiguous region and their glue (sequence
   composition modulo the parser's synthetic skip terminator) is the whole
   body. Every guard is retained, including the void logn0 return. -/
namespace FT1536.Source3.KeygenNttForwardPrograms
open C99ModularReference (Expr Stmt)
open KeygenNttButterflyPrograms (firstBody binaryBody tripleBody chain scalar read zero)

def var (s : String) : CLogic.Expr := .var s.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def update (name : String) (op : B20.C.BinOp) (e : CLogic.Expr) : Stmt :=
  .base (.scalar (.update name.toList op e))
def bind (target source : String) (index : CLogic.Expr) : Stmt :=
  .base (.bindPtr target.toList source.toList index)
def sizeDeclaration (names : List String) : Stmt :=
  .base (.scalar (.declare .u64 (names.map String.toList)))
def wordDeclaration (names : List String) : Stmt :=
  .base (.scalar (.declare .u32 (names.map String.toList)))
def block (code : Stmt) : Stmt := .scope (C99ModularParser.declarations code) code

/- Prologue: declarations, the logn0 void return, and the MKN macro
   expansion assigning n and hn. -/
def locals : Stmt := sizeDeclaration ["n","hn","u","r","m","t"]
def word : Stmt := wordDeclaration ["w"]
def pointers : Stmt := chain [.base (.declarePtr "r1".toList),.base (.declarePtr "r2".toList)]
def lognZero : CLogic.Expr := .cmp .eq (var "logn") (num 0)
def earlyExit : Stmt := .branch lognZero (.scope [] (.seq .retVoid (.base .skip))) (.base .skip)
def nAssign : Stmt := .assign "n".toList (.scalar (C99ArrayParser.mkn (var "logn") (var "full")))
def hnAssign : Stmt := .assign "hn".toList (.scalar (.bin .shr (var "n") (num 1)))
def prologue : Stmt := chain [locals,word,pointers,earlyExit,nAssign,hnAssign]

/- First pass: the degree-1 butterflies over low/high halves. -/
def wAssign : Stmt := .assign "w".toList (.load32 "gm".toList (num 1))
def firstInit : Stmt := .seq (.assign "u".toList (.scalar (num 0)))
  (.seq (bind "r1" "a" zero) (bind "r2" "a" (.bin .mul (var "hn") (var "stride"))))
def pointerAdvance : Stmt :=
  .seq (bind "r1" "r1" (var "stride")) (bind "r2" "r2" (var "stride"))
def step (counter : String) : Stmt :=
  .seq (update counter .add (num 1)) pointerAdvance
def firstLoop : Stmt := .seq firstInit
  (.loop (.cmp .lt (var "u") (var "hn")) (block firstBody) (step "u"))
def firstPass : Stmt := chain [wAssign,firstLoop]

/- Intermediate passes: the doubling loop with its inner twiddle loop and
   radix-2 loop; t halves each outer round. -/
def tFromHalf : Stmt := .assign "t".toList (.scalar (var "hn"))
def mInit : Stmt := .assign "m".toList (.scalar (num 2))
def mGuard : CLogic.Expr := .cmp .gt (var "t") (.bin .add (num 1) (.bin .shl (var "full") (num 1)))
def mStep : Stmt := update "m" .shl (num 1)
def htAssign : Stmt := .assign "ht".toList (.scalar (.bin .shr (var "t") (num 1)))
def u1Init : Stmt :=
  .seq (.assign "u1".toList (.scalar (num 0))) (.assign "v1".toList (.scalar (num 0)))
def u1Step : Stmt := .seq (update "u1" .add (num 1)) (update "v1" .add (var "t"))
def sAssign : Stmt := .assign "s".toList (.load32 "gm".toList (.bin .add (var "m") (var "u1")))
def v1Bind : Stmt := bind "r1" "a" (.bin .mul (var "v1") (var "stride"))
def htBind : Stmt := bind "r2" "r1" (.bin .mul (var "ht") (var "stride"))
def vInit : Stmt := .assign "v".toList (.scalar (num 0))
def vLoop : Stmt := .seq vInit
  (.loop (.cmp .lt (var "v") (var "ht")) (block binaryBody) (step "v"))
def u1Inner : Stmt :=
  chain [sizeDeclaration ["v"],wordDeclaration ["s"],sAssign,v1Bind,htBind,vLoop]
def u1Loop : Stmt := .seq u1Init
  (.loop (.cmp .lt (var "u1") (var "m")) (block u1Inner) u1Step)
def tFromHalf2 : Stmt := .assign "t".toList (.scalar (var "ht"))
def mInner : Stmt := chain [sizeDeclaration ["ht","u1","v1"],htAssign,u1Loop,tFromHalf2]
def intermediatePass : Stmt :=
  chain [tFromHalf,.seq mInit (.loop mGuard (block mInner) mStep)]

/- Final triple pass: only under full=1, one wide butterfly per triple. -/
def wSquared : Stmt := .assign "w".toList
  (.call4 "modp_montymul".toList (read "gm" (num 1)) (read "gm" (num 1)) (scalar "p") (scalar "p0i"))
def rInit : Stmt :=
  .assign "r".toList (.scalar (.bin .shl (.cast .u64 (num 1)) (.bin .sub (var "logn") (num 1))))
def tripleInit : Stmt := .seq (.assign "u".toList (.scalar (num 0)))
  (.seq rInit (bind "r1" "a" zero))
def tripleStep : Stmt := .seq (update "u" .add (num 3))
  (.seq (update "r" .add (num 1)) (bind "r1" "r1" (.bin .mul (num 3) (var "stride"))))
def tripleLoop : Stmt := .seq tripleInit
  (.loop (.cmp .lt (var "u") (var "n")) (block tripleBody) tripleStep)
def tripleInner : Stmt := chain [wSquared,tripleLoop]
def triplePass : Stmt :=
  chain [.branch (var "full") (block tripleInner) (.base .skip)]

/- Sequence composition modulo the parser's synthetic skip terminator. -/
def glue : Stmt → Stmt → Stmt
  | .seq a b,tail => .seq a (glue b tail)
  | .base .skip,tail => tail
  | code,tail => .seq code tail

def forwardBody : Stmt := glue prologue (glue firstPass (glue intermediatePass triplePass))

theorem prologue_source : C99ModularParser.region 3046 9=some prologue := by decide
theorem first_source :
    C99ModularParser.regionContext ["r1".toList,"r2".toList] 3066 12=some firstPass := by decide
theorem intermediate_source :
    C99ModularParser.regionContext ["r1".toList,"r2".toList] 3082 24=some intermediatePass := by decide
theorem triple_source :
    C99ModularParser.regionContext ["r1".toList,"r2".toList] 3110 27=some triplePass := by decide
theorem body_source : C99ModularParser.region 3046 91=some forwardBody := by decide

end FT1536.Source3.KeygenNttForwardPrograms
