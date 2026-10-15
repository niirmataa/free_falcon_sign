import Source3.FftNumericPass153

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftCertificateLink153

def remainingF (input : Fin 1536 → BitVec 64) (i : Fin 1536) : BitVec 64 :=
  if 24≤FftGroupValues152.owner 768 384 0 i ∧ FftGroupValues152.owner 768 384 0 i<384 then
    FftLoopStep141.advance 1536 768 384 (FftGroupValues152.owner 768 384 0 i) (by decide)
      SelectedFftLoop141.real SelectedFftLoop141.imag input i else input i

def firstG := FftFirstClosed152.image 1536 768 (by decide) SelectedFftGEntry150.wr SelectedFftGEntry150.wi
def middle (t m : Nat) := FftNumericPass153.middle 1536 768 t m (by decide)
def tripling := FftNumericPass153.tripling SelectedTriplingConstants148.values

theorem f_first (input output : Fin 1536 → BitVec 64) (entry : SelectedFftBuffer141.values=input)
    (checked : remainingF input=output) : SelectedFftImages152.fFirstGroup=output := by
  change remainingF SelectedFftBuffer141.values=output
  rw [entry,checked]

theorem g_first (input output : Fin 1536 → BitVec 64) (entry : SelectedFftGInput148.values=input)
    (checked : firstG input=output) : SelectedFftImages152.gFirst=output := by
  change firstG SelectedFftGInput148.values=output
  rw [entry,checked]

theorem next_pass (count t m : Nat) (input output : Fin 1536 → BitVec 64) (checked : middle t m input=output) :
    FftPassValues152.middle 1536 768 (by decide) (count+1) t m input=
      FftPassValues152.middle 1536 768 (by decide) count (t/2) (m*2) output := by
  rw [FftPassValues152.middle,← FftNumericPass153.middle_source]
  change FftPassValues152.middle 1536 768 (by decide) count (t/2) (m*2) (middle t m input)=_
  rw [checked]

theorem final_pass (input output : Fin 1536 → BitVec 64) (checked : tripling input=output) :
    FftTriplingValues152.image SelectedTriplingConstants148.values input=output := by
  rw [← FftNumericPass153.tripling_source]
  exact checked

end FT1536.Source3.FftCertificateLink153
