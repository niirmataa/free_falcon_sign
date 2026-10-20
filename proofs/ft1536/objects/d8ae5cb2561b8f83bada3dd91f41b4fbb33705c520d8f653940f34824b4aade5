import Source3.C99ModularAnnotation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Parsed program of the pinned modp_mkgm3 body (B1.03). The statement tree
   mirrors the source region line by line; `source_bound` below is the source
   binding (parser output on the pinned bytes equals this tree). The while
   loop `while (k ++ < 11)` appears in its state-exact desugared form (see
   C99ModularParser.statement): seq (loop (k < 11) (seq (k ++) body) skip)
   (k ++). The REV10 stores use the dedicated storeRev form. -/
namespace FT1536.Source3.KeygenMkgm3Program
open C99ModularReference (Expr Stmt)
open C99ModularReference (chainOf)

def var (s : String) : CLogic.Expr := .var s.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def cell (s : String) : Expr := .scalar (var s)
def load (array : String) (index : CLogic.Expr) : Expr :=
  .load32 array.toList index
def inc (s : String) : Stmt := .base (.scalar (.update s.toList .add (num 1)))
def dec (s : String) : Stmt := .base (.scalar (.update s.toList .sub (num 1)))
def wordDecl (names : List String) : Stmt :=
  .base (.scalar (.declare .u32 (names.map String.toList)))
def indexDecl (names : List String) : Stmt :=
  .base (.scalar (.declare .u64 (names.map String.toList)))

def mont (a b : Expr) : Expr :=
  .call4 "modp_montymul".toList a b (cell "p") (cell "p0i")

def declarations : List Stmt := [
  indexDecl ["u"],
  .base (.scalar (.declare .u32 ["k".toList])),
  wordDecl ["R","R2","w","ig"]]

def rAssign : Stmt := .assign "R".toList (.call1 "modp_R".toList (cell "p"))
def r2Assign : Stmt := .assign "R2".toList (.call2 "modp_R2".toList (cell "p") (cell "p0i"))
def gConvert : Stmt := .assign "g".toList (mont (cell "g") (cell "R2"))
def kFromLogn0 : Stmt := .assign "k".toList (.scalar (var "logn"))

def montGG : Expr := mont (cell "g") (cell "g")
def tripleGG : Expr := mont (cell "g") montGG

def ifNotFull : Stmt := .branch (.lnot (var "full"))
  (.scope [] (chainOf [.assign "g".toList tripleGG,inc "k"])) (.base .skip)

/- `while (k ++ < 11) { g = modp_montymul(g, g, p, p0i); }` in the parser's
   state-exact desugared form. -/
def whileK : Stmt :=
  .seq (.loop (.cmp .lt (var "k") (num 11))
    (.seq (inc "k") (.scope [] (chainOf [.assign "g".toList montGG]))) (.base .skip)) (inc "k")

def igAssign : Stmt := .assign "ig".toList
  (.call5 "modp_div".toList (cell "R2") (cell "g") (cell "p") (cell "p0i")
    (.call1 "modp_R".toList (cell "p")))

def lognOne : CLogic.Expr := .cmp .eq (var "logn") (num 1)

def thenOne : Stmt := .scope [] (chainOf [
  .store32 "gm".toList (num 1) (cell "g"),
  .store32 "igm".toList (num 1) (cell "ig")])

/- `gm[b + REV10[u << k]] = x;` and relatives. -/
def storeRev (array : String) (index : CLogic.Expr) (value : Expr) : Stmt :=
  .storeRev array.toList "REV10".toList (var "b") index value

def revIndex : CLogic.Expr := .bin .shl (var "u") (var "k")
def revIndexNext : CLogic.Expr :=
  .bin .shl (.bin .add (var "u") (num 1)) (var "k")

def montXG4 : Expr := mont (cell "x") (cell "g4")
def montIXIG4 : Expr := mont (cell "ix") (cell "ig4")
def montXG2 : Expr := mont (cell "x") (cell "g2")
def montIXIG2 : Expr := mont (cell "ix") (cell "ig2")

def lastRowBody : Stmt := chainOf [
  storeRev "gm" revIndex (cell "x"),
  storeRev "igm" revIndex (cell "ix"),
  .assign "x".toList montXG4,
  .assign "ix".toList montIXIG4,
  storeRev "gm" revIndexNext (cell "x"),
  storeRev "igm" revIndexNext (cell "ix"),
  .assign "x".toList montXG2,
  .assign "ix".toList montIXIG2]

def lastRowLoop : Stmt :=
  .seq (.assign "u".toList (.scalar (num 0)))
    (.loop (.cmp .lt (var "u") (var "b")) (.scope [] lastRowBody)
      (.base (.scalar (.update "u".toList .add (num 2)))))

def elseRow : Stmt := .scope (["x","ix","g2","g4","ig2","ig4","b"].map String.toList)
  (chainOf [
    wordDecl ["x","ix","g2","g4","ig2","ig4"],
    indexDecl ["b"],
    .assign "x".toList (cell "g"),
    .assign "ix".toList (cell "ig"),
    .assign "g2".toList montGG,
    .assign "g4".toList (mont (cell "g2") (cell "g2")),
    .assign "ig2".toList (mont (cell "ig") (cell "ig")),
    .assign "ig4".toList (mont (cell "ig2") (cell "ig2")),
    .assign "k".toList (.scalar (.bin .sub (num 11) (var "logn"))),
    .assign "b".toList (.scalar (.bin .shl (.cast .u64 (num 1))
      (.bin .sub (var "logn") (num 1)))),
    lastRowLoop])

def rowSelect : Stmt := .branch lognOne thenOne elseRow

def kFromLogn : Stmt := .assign "k".toList
  (.scalar (.bin .sub (var "logn") (num 1)))

def montYY : Expr := mont (cell "y") (cell "y")
def montZZ : Expr := mont (cell "z") (cell "z")

def cubeBody : Stmt := .scope (["y","z"].map String.toList) (chainOf [
  wordDecl ["y","z"],
  .assign "y".toList (load "gm" (.bin .shl (var "u") (num 1))),
  .assign "z".toList (load "igm" (.bin .shl (var "u") (num 1))),
  .assign "y".toList (mont (cell "y") montYY),
  .assign "z".toList (mont (cell "z") montZZ),
  .store32 "gm".toList (var "u") (cell "y"),
  .store32 "igm".toList (var "u") (cell "z")])

def cubeLoop : Stmt :=
  .seq (.assign "u".toList (.scalar (.bin .shl (.cast .u64 (num 1)) (var "k"))))
    (.loop (.cmp .lt (var "u") (.bin .shl (.cast .u64 (num 1))
      (.bin .add (var "k") (num 1)))) cubeBody
      (inc "u"))

def ifFull : Stmt := .branch (var "full")
  (.scope [] (chainOf [dec "k",cubeLoop])) (.base .skip)

def squareBody : Stmt := .scope (["v"].map String.toList) (chainOf [
  indexDecl ["v"],
  .assign "v".toList (.scalar (.bin .shl (var "u") (num 1))),
  .store32 "gm".toList (var "u")
    (mont (load "gm" (var "v")) (load "gm" (var "v"))),
  .store32 "igm".toList (var "u")
    (mont (load "igm" (var "v")) (load "igm" (var "v")))])

def squareLoop : Stmt :=
  .seq (.assign "u".toList (.scalar (.bin .sub
      (.bin .shl (.cast .u64 (num 1)) (var "k")) (num 1))))
    (.loop (.cmp .gt (var "u") (num 0)) squareBody (dec "u"))

def topElements : List Stmt := [
  .store32 "gm".toList (num 0) (load "gm" (num 1)),
  .assign "w".toList (load "gm" (num 1)),
  .store32 "igm".toList (num 0)
    (.call5 "modp_div".toList (cell "R2")
      (.call3 "modp_sub".toList
        (.call3 "modp_add".toList (cell "w") (cell "w") (cell "p"))
        (cell "R") (cell "p"))
      (cell "p") (cell "p0i") (cell "R"))]

/- The body tree mirrors the parser's flat seq spine statement by
   statement: the parser's body recursion yields one right-nested seq
   chain, so nested chainOf groups (declarations, top elements) are
   spliced into the same flat list rather than wrapped as single
   statements. -/
def code : Stmt := chainOf (declarations ++
  [rAssign,
   r2Assign,
   gConvert,
   kFromLogn0,
   ifNotFull,
   whileK,
   igAssign,
   rowSelect,
   kFromLogn,
   ifFull,
   squareLoop] ++ topElements)

theorem source_header :
    Pinned.keygenLines[2940]?=
      some "modp_mkgm3(uint32_t *restrict gm, uint32_t *restrict igm,\n" := by decide

theorem source_bound : C99ModularParser.region 2945 91=some code := by decide

end FT1536.Source3.KeygenMkgm3Program
