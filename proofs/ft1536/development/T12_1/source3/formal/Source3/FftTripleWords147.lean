import Source3.FftTripleCalls145
import Source3.FftTripleAddCalls146

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleWords147

structure Inputs where
  aR : BitVec 64
  aI : BitVec 64
  bR : BitVec 64
  bI : BitVec 64
  cR : BitVec 64
  cI : BitVec 64
  qR : BitVec 64
  qI : BitVec 64
  w2R : BitVec 64
  w2I : BitVec 64
  w4R : BitVec 64
  w4I : BitVec 64

def operands0 (x : Inputs) : FftMulStates140.Words := ⟨x.bR,x.bI,x.qR,x.qI⟩
def real0 (x : Inputs) := FftMulStates140.real (operands0 x)
def imag0 (x : Inputs) := FftMulStates140.imag (operands0 x)

def operands1 (x : Inputs) : FftMulStates140.Words := ⟨(real0 x),(imag0 x),x.w2R,x.w2I⟩
def real1 (x : Inputs) := FftMulStates140.real (operands1 x)
def imag1 (x : Inputs) := FftMulStates140.imag (operands1 x)

def operands2 (x : Inputs) : FftMulStates140.Words := ⟨(real0 x),(imag0 x),x.w4R,x.w4I⟩
def real2 (x : Inputs) := FftMulStates140.real (operands2 x)
def imag2 (x : Inputs) := FftMulStates140.imag (operands2 x)

def real3 (x : Inputs) := FpcSqrShape145.real (x.qR) (x.qI)
def imag3 (x : Inputs) := FpcSqrShape145.imag (x.qR) (x.qI)

def operands4 (x : Inputs) : FftMulStates140.Words := ⟨x.cR,x.cI,(real3 x),(imag3 x)⟩
def real4 (x : Inputs) := FftMulStates140.real (operands4 x)
def imag4 (x : Inputs) := FftMulStates140.imag (operands4 x)

def operands5 (x : Inputs) : FftMulStates140.Words := ⟨(real4 x),(imag4 x),x.w2R,x.w2I⟩
def real5 (x : Inputs) := FftMulStates140.real (operands5 x)
def imag5 (x : Inputs) := FftMulStates140.imag (operands5 x)

def operands6 (x : Inputs) : FftMulStates140.Words := ⟨(real4 x),(imag4 x),x.w4R,x.w4I⟩
def real6 (x : Inputs) := FftMulStates140.real (operands6 x)
def imag6 (x : Inputs) := FftMulStates140.imag (operands6 x)

def operands7 (x : Inputs) : FftMulStates140.Words := ⟨(real0 x),(imag0 x),(real4 x),(imag4 x)⟩
def real7 (x : Inputs) := FftPairStates140.real .add (operands7 x)
def imag7 (x : Inputs) := FftPairStates140.imag .add (operands7 x)

def operands8 (x : Inputs) : FftMulStates140.Words := ⟨(real1 x),(imag1 x),(real6 x),(imag6 x)⟩
def real8 (x : Inputs) := FftPairStates140.real .add (operands8 x)
def imag8 (x : Inputs) := FftPairStates140.imag .add (operands8 x)

def operands9 (x : Inputs) : FftMulStates140.Words := ⟨(real2 x),(imag2 x),(real5 x),(imag5 x)⟩
def real9 (x : Inputs) := FftPairStates140.real .add (operands9 x)
def imag9 (x : Inputs) := FftPairStates140.imag .add (operands9 x)

def storeWords (x : Inputs) : Fin 3 → FftMulStates140.Words
  | ⟨0,_⟩ => ⟨x.aR,x.aI,(real7 x),(imag7 x)⟩
  | ⟨1,_⟩ => ⟨x.aR,x.aI,(real8 x),(imag8 x)⟩
  | ⟨2,_⟩ => ⟨x.aR,x.aI,(real9 x),(imag9 x)⟩

end FT1536.Source3.FftTripleWords147
