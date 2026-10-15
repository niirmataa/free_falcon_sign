import Source3.FftPairStates140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFourWrites140
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)

def pair (before : State) (p q : ArrayPointer) (a b : BitVec 64) : State :=
  {before with heap := C99WordStore140.write (C99WordStore140.write before.heap p a) q b}

theorem pair_output (kind : FftPairShape140.Kind) (before : State) (x : FftMulStates140.Words) (p q : ArrayPointer) :
    FftPairStates140.output kind before x p q=
      pair before p q (FftPairStates140.real kind x) (FftPairStates140.imag kind x) := by rfl

theorem compose (before : State) (p0 p1 p2 p3 : ArrayPointer) (w0 w1 w2 w3 : BitVec 64) :
    pair (pair before p0 p1 w0 w1) p2 p3 w2 w3=
      {before with heap := C99WordStore140.write (C99WordStore140.write (C99WordStore140.write (C99WordStore140.write before.heap p0 w0) p1 w1) p2 w2) p3 w3} := by rfl

end FT1536.Source3.FftFourWrites140
