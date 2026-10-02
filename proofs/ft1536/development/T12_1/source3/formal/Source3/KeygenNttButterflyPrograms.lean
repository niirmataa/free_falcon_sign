import Source3.C99ModularParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenNttButterflyPrograms
open C99ModularReference (Expr Stmt)

def scalar (name : String) : Expr := .scalar (.var name.toList)
def zero : CLogic.Expr := .literal .u64 0
def read (name : String) (index : CLogic.Expr := zero) : Expr := .load32 name.toList index
def mont (a b : Expr) : Expr := .call4 "modp_montymul".toList a b (scalar "p") (scalar "p0i")
def add (a b : Expr) : Expr := .call3 "modp_add".toList a b (scalar "p")
def sub (a b : Expr) : Expr := .call3 "modp_sub".toList a b (scalar "p")
def declaration (names : List String) : Stmt := .base (.scalar (.declare .u32 (names.map String.toList)))
def assign (name : String) (e : Expr) : Stmt := .assign name.toList e
def write (name : String) (index : CLogic.Expr) (e : Expr) : Stmt := .store32 name.toList index e
def chain : List Stmt → Stmt
  | [] => .base .skip
  | first::rest => .seq first (chain rest)

def firstAtoms : List Stmt := [
  declaration ["a0","a1","b"],
  assign "a0" (read "r1"),assign "a1" (read "r2"),
  assign "b" (mont (scalar "a1") (scalar "w")),
  write "r1" zero (add (scalar "a0") (scalar "b")),
  write "r2" zero (sub (add (scalar "a0") (scalar "a1")) (scalar "b"))]
def firstBody : Stmt := chain firstAtoms

def binaryAtoms : List Stmt := [
  declaration ["x","y"],assign "x" (read "r1"),assign "y" (read "r2"),
  assign "y" (mont (scalar "y") (scalar "s")),
  write "r1" zero (add (scalar "x") (scalar "y")),
  write "r2" zero (sub (scalar "x") (scalar "y"))]
def binaryBody : Stmt := chain binaryAtoms

def stride : CLogic.Expr := .var "stride".toList
def twiceStride : CLogic.Expr := .bin .mul (.literal .i32 2) stride
def tripleAtoms : List Stmt := [
  declaration ["fA","fB","fC","fB0","fB1","fB2","fC0","fC1","fC2"],declaration ["x","x2"],
  assign "x" (read "gm" (.var "r".toList)),assign "x2" (mont (scalar "x") (scalar "x")),
  assign "fA" (read "r1"),assign "fB" (read "r1" stride),assign "fC" (read "r1" twiceStride),
  assign "fB0" (mont (scalar "fB") (scalar "x")),
  assign "fB1" (mont (scalar "fB0") (scalar "w")),
  assign "fB2" (mont (scalar "fB1") (scalar "w")),
  assign "fC0" (mont (scalar "fC") (scalar "x2")),
  assign "fC1" (mont (scalar "fC0") (scalar "w")),
  assign "fC2" (mont (scalar "fC1") (scalar "w")),
  write "r1" zero (add (scalar "fA") (add (scalar "fB0") (scalar "fC0"))),
  write "r1" stride (add (scalar "fA") (add (scalar "fB1") (scalar "fC2"))),
  write "r1" twiceStride (add (scalar "fA") (add (scalar "fB2") (scalar "fC1")))]
def tripleBody : Stmt := chain tripleAtoms

theorem first_source : C99ModularParser.region 3070 7=some firstBody := by decide
theorem binary_source : C99ModularParser.region 3095 7=some binaryBody := by decide
theorem triple_source : C99ModularParser.region 3115 20=some tripleBody := by decide
theorem wrapper_source : (Pinned.keygenLines.drop 3250).take 2 =
    ["#define modp_NTT3(a, gm, logn, full, p, p0i) \\\n","\tmodp_NTT3_ext(a, 1, gm, logn, full, p, p0i)\n"] := by decide

end FT1536.Source3.KeygenNttButterflyPrograms
