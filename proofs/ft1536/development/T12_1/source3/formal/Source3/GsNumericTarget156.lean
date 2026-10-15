import Source3.SelectedGsNorm155
import Source3.NormTrace153

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsNumericTarget156

def denominator (i : Fin 768) : BitVec 64 :=
  GsInvNormShape154.denominator (GsInvNormInvariant154.sample (by decide)
    GeneratedFftTree153FTriple.word GeneratedFftTree153GTriple.word i)

def inverse (input : Fin 768 → BitVec 64) (i : Fin 768) : BitVec 64 := FprInvFast154.word (input i)

/-- Separate exact denominator and inverse certificates without changing the source value. -/
theorem source : SelectedGsInvNorm154.values=inverse denominator := by rfl

end FT1536.Source3.GsNumericTarget156
