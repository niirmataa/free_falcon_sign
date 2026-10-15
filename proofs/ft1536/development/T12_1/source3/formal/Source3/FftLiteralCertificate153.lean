import Source3.FftLiteralPass153
import Source3.FftCertificateLink153

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLiteralCertificate153

def middle (t m : Nat) := FftLiteralPass153.middle 1536 768 t m (by decide)
def tripling := FftLiteralPass153.tripling SelectedTriplingConstants148.values

theorem middle_source (t m : Nat) (input : Fin 1536 → BitVec 64) :
    middle t m input=FftCertificateLink153.middle t m input :=
  (FftLiteralPass153.middle_source 1536 768 t m (by decide) input).trans
    (FftNumericPass153.middle_source 1536 768 t m (by decide) input).symm

theorem tripling_source (input : Fin 1536 → BitVec 64) : tripling input=FftCertificateLink153.tripling input :=
  (FftLiteralPass153.tripling_source SelectedTriplingConstants148.values input).trans
    (FftNumericPass153.tripling_source SelectedTriplingConstants148.values input).symm

theorem next_pass (count t m : Nat) (input output : Fin 1536 → BitVec 64) (checked : middle t m input=output) :
    FftPassValues152.middle 1536 768 (by decide) (count+1) t m input=
      FftPassValues152.middle 1536 768 (by decide) count (t/2) (m*2) output :=
  FftCertificateLink153.next_pass count t m input output ((middle_source t m input).symm.trans checked)

theorem final_pass (input output : Fin 1536 → BitVec 64) (checked : tripling input=output) :
    FftTriplingValues152.image SelectedTriplingConstants148.values input=output :=
  FftCertificateLink153.final_pass input output ((tripling_source input).symm.trans checked)

end FT1536.Source3.FftLiteralCertificate153
