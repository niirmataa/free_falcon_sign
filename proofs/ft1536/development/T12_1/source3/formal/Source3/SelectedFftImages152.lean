import Source3.FftFirstClosed152
import Source3.FftPassValues152
import Source3.FftTriplingValues152
import Source3.SelectedRawNorm151

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftImages152

def fFirstGroup (i : Fin 1536) : BitVec 64 :=
  if 24≤FftGroupValues152.owner 768 384 0 i ∧ FftGroupValues152.owner 768 384 0 i<384 then
    FftLoopStep141.advance 1536 768 384 (FftGroupValues152.owner 768 384 0 i) (by decide)
      SelectedFftLoop141.real SelectedFftLoop141.imag SelectedFftBuffer141.values i else SelectedFftBuffer141.values i

theorem f_group_source : SelectedFftLoop141.finalValues=fFirstGroup := by
  funext i
  exact FftGroupValues152.pointwise 1536 768 384 0 (by decide) SelectedFftLoop141.real SelectedFftLoop141.imag
    (by decide) 360 24 (by decide) (by decide) SelectedFftBuffer141.values i

def fMiddle := FftPassValues152.middle 1536 768 (by decide) 7 384 4 fFirstGroup
def fImage := FftTriplingValues152.image SelectedTriplingConstants148.values fMiddle

theorem f_middle_source : SelectedFftMiddle144.finalValues=fMiddle := by
  unfold SelectedFftMiddle144.finalValues
  rw [FftPassValues152.source 1536 768 3 7 384 4 _ FftOuterSchedule144.remaining,f_group_source]
  rfl

theorem f_source : SelectedTripling148.finalValues=fImage := by
  unfold SelectedTripling148.finalValues
  rw [FftTriplingValues152.source,f_middle_source]
  rfl

def gFirst := FftFirstClosed152.image 1536 768 (by decide) SelectedFftGEntry150.wr SelectedFftGEntry150.wi SelectedFftGInput148.values
def gMiddle := FftPassValues152.middle 1536 768 (by decide) 8 768 2 gFirst
def gImage := FftTriplingValues152.image SelectedTriplingConstants148.values gMiddle

theorem g_first_source : SelectedFftGFirst150.finalValues=gFirst :=
  FftFirstClosed152.source 1536 768 (by decide) SelectedFftGEntry150.wr SelectedFftGEntry150.wi SelectedFftGInput148.values

theorem g_middle_source : SelectedFftGMiddle150.finalValues=gMiddle := by
  unfold SelectedFftGMiddle150.finalValues
  rw [FftPassValues152.source 1536 768 3 8 768 2 _ SelectedFftGMiddle150.plan,g_first_source]
  rfl

theorem g_source : SelectedFftGTripling150.finalValues=gImage := by
  unfold SelectedFftGTripling150.finalValues
  rw [FftTriplingValues152.source,g_middle_source]
  rfl

theorem source_images : C99WordBuffer140.Represents SelectedRawNorm151.after.heap SelectedFftBuffer141.base fImage ∧
    C99WordBuffer140.Represents SelectedRawNorm151.after.heap SelectedFftGInput148.base gImage := by
  rw [← f_source,← g_source]
  exact SelectedRawNorm151.images

def normWord := FprHeadersFast137.double (KeygenNormInduction151.sum fImage gImage 1536 0 0)

theorem norm_source : SelectedRawNorm151.finalWord=normWord := by
  unfold SelectedRawNorm151.finalWord SelectedRawNorm151.sumWord
  rw [f_source,g_source]
  rfl

/-- Exact reformulation of the still-open numerical gate, not a relaxed bound. -/
theorem obligation : SelectedRawNorm151.NumericalObligation ↔ FprCompare.spec normWord GeneratedBound135.finalWord=1 := by
  unfold SelectedRawNorm151.NumericalObligation
  rw [norm_source]

end FT1536.Source3.SelectedFftImages152
