import Source3.SelectedNumericGs156
import Source3.GeneratedGsCheck156Norm

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsGate156

theorem sum_word : KeygenNormInduction151.sum GeneratedGsData156FinalF.word GeneratedGsData156FinalG.word 1536 0 0=
    GeneratedGsData156Norm.sumWord := by
  have source := NormTrace153.source GeneratedGsData156FinalF.word GeneratedGsData156FinalG.word GeneratedGsData156Norm.point
    GeneratedGsCheck156Norm.source 1536 0 (by decide)
  change KeygenNormInduction151.sum GeneratedGsData156FinalF.word GeneratedGsData156FinalG.word 1536 0
    (GeneratedGsData156Norm.point 0)=GeneratedGsData156Norm.point 1536 at source
  rw [GeneratedGsData156Norm.first,GeneratedGsData156Norm.last] at source
  exact source

theorem norm_word : SelectedGsNorm155.finalWord=GeneratedGsData156Norm.finalWord := by
  rw [SelectedNumericGs156.norm_source,sum_word,GeneratedGsData156Norm.doubled]

theorem accepted : SelectedGsNorm155.NumericalObligation := by
  unfold SelectedGsNorm155.NumericalObligation
  rw [norm_word]
  decide +kernel

/-- The actual selected GS computation and its original gate accept without a comparison premise. -/
theorem source : KeygenAttemptNorm133.GS KeygenFullData127.env.ctx SelectedRawNorm151.after ⟨SelectedGsNorm155.after,.normal⟩ :=
  SelectedGsNorm155.accepted_of_comparison accepted

/-- Both original raw and GS norm gates are discharged in the corrected source spine. -/
theorem norm_prefix : KeygenAttemptNorm133.Exec KeygenFullData127.env.ctx
    (C99CompactState115.reference SelectedBound135.before) ⟨SelectedGsNorm155.after,.normal⟩ :=
  SelectedGsNorm155.norm_prefix accepted

end FT1536.Source3.SelectedGsGate156
