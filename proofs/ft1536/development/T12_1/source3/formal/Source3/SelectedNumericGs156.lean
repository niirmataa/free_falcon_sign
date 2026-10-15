import Source3.GeneratedGsCheck156Denominator
import Source3.GeneratedGsCheck156Inverse
import Source3.GeneratedGsCheck156ScaledF
import Source3.GeneratedGsCheck156ScaledG
import Source3.GeneratedGsCheck156FinalF
import Source3.GeneratedGsCheck156FinalG

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedNumericGs156

theorem inverse : SelectedGsInvNorm154.values=GeneratedGsData156Inverse.word := by
  rw [GsNumericTarget156.source,GeneratedGsCheck156Denominator.source]
  exact GeneratedGsCheck156Inverse.source

theorem scaled_f : SelectedGsScale155.fValues=GeneratedGsData156ScaledF.word := GeneratedGsCheck156ScaledF.source
theorem scaled_g : SelectedGsScale155.gValues=GeneratedGsData156ScaledG.word := GeneratedGsCheck156ScaledG.source

theorem f_source : SelectedGsAuto155.fValues=GeneratedGsData156FinalF.word := by
  unfold SelectedGsAuto155.fValues
  rw [inverse,scaled_f]
  exact GeneratedGsCheck156FinalF.source
theorem g_source : SelectedGsAuto155.gValues=GeneratedGsData156FinalG.word := by
  unfold SelectedGsAuto155.gValues
  rw [inverse,scaled_g]
  exact GeneratedGsCheck156FinalG.source

theorem images : C99WordBuffer140.Represents SelectedGsNorm155.after.heap SelectedGsStart155.p GeneratedGsData156FinalF.word ∧
    C99WordBuffer140.Represents SelectedGsNorm155.after.heap SelectedGsStart155.q GeneratedGsData156FinalG.word := by
  rw [← f_source,← g_source]
  exact SelectedGsNorm155.images

theorem norm_source : SelectedGsNorm155.finalWord=FprHeadersFast137.double
    (KeygenNormInduction151.sum GeneratedGsData156FinalF.word GeneratedGsData156FinalG.word 1536 0 0) := by
  unfold SelectedGsNorm155.finalWord SelectedGsNorm155.sumWord
  rw [f_source,g_source]

end FT1536.Source3.SelectedNumericGs156
