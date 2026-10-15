import Source3.SelectedNumericFft153
import Source3.GeneratedNormCheck153
import Source3.KeygenAttemptNorm133

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedNormGate153

theorem sum_word : KeygenNormInduction151.sum GeneratedFftTree153FTriple.word GeneratedFftTree153GTriple.word 1536 0 0=
    GeneratedNormData153.sumWord := by
  have source := NormTrace153.source GeneratedFftTree153FTriple.word GeneratedFftTree153GTriple.word GeneratedNormData153.point
    GeneratedNormCheck153.source 1536 0 (by decide)
  change KeygenNormInduction151.sum GeneratedFftTree153FTriple.word GeneratedFftTree153GTriple.word 1536 0
    (GeneratedNormData153.point 0)=GeneratedNormData153.point 1536 at source
  rw [GeneratedNormData153.first,GeneratedNormData153.last] at source
  exact source

theorem norm_word : SelectedRawNorm151.finalWord=GeneratedNormData153.finalWord := by
  rw [SelectedNumericFft153.norm_source,sum_word,GeneratedNormData153.doubled]

theorem accepted : SelectedRawNorm151.NumericalObligation := by
  unfold SelectedRawNorm151.NumericalObligation
  rw [norm_word]
  decide +kernel

/-- The actual first raw-norm gate accepts, with no numerical-comparison premise. -/
theorem source : KeygenNormFrame.Exec KeygenFullData127.env.ctx
    (C99CompactState115.reference SelectedBound135.after) ⟨SelectedRawNorm151.after,.normal⟩ :=
  SelectedRawNorm151.accepted_of_comparison accepted

/-- The remaining source obligation begins at the original Gram-Schmidt stage. -/
theorem continue_gs (out : C99ProcedureReference.Result)
    (gram : KeygenAttemptNorm133.GS KeygenFullData127.env.ctx SelectedRawNorm151.after out) :
    KeygenAttemptNorm133.Exec KeygenFullData127.env.ctx (C99CompactState115.reference SelectedBound135.before) out :=
  .gs (C99CompactState115.reference SelectedBound135.after) SelectedRawNorm151.after out SelectedBound135.source source gram

end FT1536.Source3.SelectedNormGate153
