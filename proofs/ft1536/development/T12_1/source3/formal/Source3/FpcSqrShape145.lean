import Source3.FpcMulClosed145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcSqrShape145
open C99ArrayReference (State Name Expr Stmt)
open FftMulShape140 (aNames dNames varExpr)

def temporaries : List Name := aNames++dNames
def real (x y : BitVec 64) := FprHeadersFast137.sub (FprHeadersFast137.sqr x) (FprHeadersFast137.sqr y)
def imag (x y : BitVec 64) := FprHeadersFast137.double (FprMulFast137.word x y)

def operations (re im : Name) : List Stmt := [
  .scalar (.declare .u64 aNames),.scalar (.declare .u64 dNames),
  .assign "fpct_a_re".toList (.scalar (.var re)),.assign "fpct_a_im".toList (.scalar (.var im)),
  .assign "fpct_d_re".toList (FftWordExpressions140.sub
    (.call1 "fpr_sqr".toList (varExpr "fpct_a_re")) (.call1 "fpr_sqr".toList (varExpr "fpct_a_im"))),
  .assign "fpct_d_im".toList (.call1 "fpr_double".toList
    (FftWordExpressions140.mul (varExpr "fpct_a_re") (varExpr "fpct_a_im"))),
  .assign re (varExpr "fpct_d_re"),.assign im (varExpr "fpct_d_im")]

def code (re im : Name) : Stmt := .scope temporaries [] (FpcSourceExpansion.sequence (operations re im))

structure Entry (s : State) (re im : Name) (x y : BitVec 64) : Prop where
  reCell : s.locals re=some (.uint64,some (.uint64 x))
  imCell : s.locals im=some (.uint64,some (.uint64 y))
  reSafe : re∉temporaries
  imSafe : im∉temporaries
  distinct : re≠im

def s1 (s : State) := C99DeclarationStatements.effect .u64 aNames s
def s2 (s : State) := C99DeclarationStatements.effect .u64 dNames (s1 s)
def s3 (s : State) (x : BitVec 64) := FftLocalCells140.put (s2 s) "fpct_a_re".toList x
def s4 (s : State) (x y : BitVec 64) := FftLocalCells140.put (s3 s x) "fpct_a_im".toList y
def s5 (s : State) (x y : BitVec 64) := FftLocalCells140.put (s4 s x y) "fpct_d_re".toList (real x y)
def s6 (s : State) (x y : BitVec 64) := FftLocalCells140.put (s5 s x y) "fpct_d_im".toList (imag x y)
def s7 (s : State) (re : Name) (x y : BitVec 64) := FftLocalCells140.put (s6 s x y) re (real x y)
def s8 (s : State) (re im : Name) (x y : BitVec 64) := FftLocalCells140.put (s7 s re x y) im (imag x y)
def output (s : State) (re im : Name) (x y : BitVec 64) :=
  FftLocalCells140.put (FftLocalCells140.put s re (real x y)) im (imag x y)

end FT1536.Source3.FpcSqrShape145
