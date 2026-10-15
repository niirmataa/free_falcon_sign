import Source3.FftMulShape140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftMulStates140
open C99ArrayReference (State)
open FftLocalCells140 (put)

structure Words where
  ar : BitVec 64
  ai : BitVec 64
  br : BitVec 64
  bi : BitVec 64

def real (x : Words) := FftWordExpressions140.real x.ar x.ai x.br x.bi
def imag (x : Words) := FftWordExpressions140.imag x.ar x.ai x.br x.bi

structure Entry (before : State) (x : Words) : Prop where
  ar : before.locals "a1r".toList=some (.uint64,some (.uint64 x.ar))
  ai : before.locals "a1i".toList=some (.uint64,some (.uint64 x.ai))
  br : before.locals "sr".toList=some (.uint64,some (.uint64 x.br))
  bi : before.locals "si".toList=some (.uint64,some (.uint64 x.bi))

def s1 (before : State) : State := C99DeclarationStatements.effect .u64 FftMulShape140.aNames before
def s2 (before : State) : State := C99DeclarationStatements.effect .u64 FftMulShape140.bNames (s1 before)
def s3 (before : State) : State := C99DeclarationStatements.effect .u64 FftMulShape140.dNames (s2 before)

def s4 (before : State) (x : Words) : State := put (s3 before) "fpct_a_re".toList (x.ar)

def s5 (before : State) (x : Words) : State := put (s4 before x) "fpct_a_im".toList (x.ai)

def s6 (before : State) (x : Words) : State := put (s5 before x) "fpct_b_re".toList (x.br)

def s7 (before : State) (x : Words) : State := put (s6 before x) "fpct_b_im".toList (x.bi)

def s8 (before : State) (x : Words) : State := put (s7 before x) "fpct_d_re".toList (real x)

def s9 (before : State) (x : Words) : State := put (s8 before x) "fpct_d_im".toList (imag x)

def s10 (before : State) (x : Words) : State := put (s9 before x) "a1r".toList (real x)

def s11 (before : State) (x : Words) : State := put (s10 before x) "a1i".toList (imag x)

def output (before : State) (x : Words) : State :=
  put (put before "a1r".toList (real x)) "a1i".toList (imag x)

end FT1536.Source3.FftMulStates140
