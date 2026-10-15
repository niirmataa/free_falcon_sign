import Source3.FftMulClosed140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcMulShape145
open C99ArrayReference (Name Expr Stmt State)
open FftMulShape140 (aNames bNames dNames temporaries varExpr)
open FftMulStates140 (Words)

structure Parameters where
  dr : Name
  di : Name
  ar : Name
  ai : Name
  br : Name
  bi : Name

def varName (name : Name) : Expr := .scalar (.var name)
def arguments (p : Parameters) : List Expr := [varName p.dr,varName p.di,varName p.ar,varName p.ai,varName p.br,varName p.bi]
def operations (p : Parameters) : List Stmt := [
  .scalar (.declare .u64 aNames),.scalar (.declare .u64 bNames),.scalar (.declare .u64 dNames),
  .assign "fpct_a_re".toList (varName p.ar),.assign "fpct_a_im".toList (varName p.ai),
  .assign "fpct_b_re".toList (varName p.br),.assign "fpct_b_im".toList (varName p.bi),
  .assign "fpct_d_re".toList (FftWordExpressions140.sub
    (FftWordExpressions140.mul (varExpr "fpct_a_re") (varExpr "fpct_b_re"))
    (FftWordExpressions140.mul (varExpr "fpct_a_im") (varExpr "fpct_b_im"))),
  .assign "fpct_d_im".toList (FftWordExpressions140.add
    (FftWordExpressions140.mul (varExpr "fpct_a_re") (varExpr "fpct_b_im"))
    (FftWordExpressions140.mul (varExpr "fpct_a_im") (varExpr "fpct_b_re"))),
  .assign p.dr (varExpr "fpct_d_re"),.assign p.di (varExpr "fpct_d_im")]

def code (p : Parameters) : Stmt := .scope temporaries [] (FpcSourceExpansion.sequence (operations p))


structure Entry (s : State) (p : Parameters) (x : Words) : Prop where
  arCell : s.locals p.ar=some (.uint64,some (.uint64 x.ar))
  aiCell : s.locals p.ai=some (.uint64,some (.uint64 x.ai))
  brCell : s.locals p.br=some (.uint64,some (.uint64 x.br))
  biCell : s.locals p.bi=some (.uint64,some (.uint64 x.bi))
  drCell : ∃ old, s.locals p.dr=some (.uint64,old)
  diCell : ∃ old, s.locals p.di=some (.uint64,old)
  arSafe : p.ar∉temporaries
  aiSafe : p.ai∉temporaries
  brSafe : p.br∉temporaries
  biSafe : p.bi∉temporaries
  drSafe : p.dr∉temporaries
  diSafe : p.di∉temporaries
  distinct : p.dr≠p.di

def lastReal (s : State) (p : Parameters) (x : Words) := FftLocalCells140.put (FftMulStates140.s9 s x) p.dr (FftMulStates140.real x)
def lastImag (s : State) (p : Parameters) (x : Words) := FftLocalCells140.put (lastReal s p x) p.di (FftMulStates140.imag x)
def output (s : State) (p : Parameters) (x : Words) :=
  FftLocalCells140.put (FftLocalCells140.put s p.dr (FftMulStates140.real x)) p.di (FftMulStates140.imag x)

end FT1536.Source3.FpcMulShape145
