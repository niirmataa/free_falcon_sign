import Source3.GeneratedFftTreeInput153F
import Source3.GeneratedFftTreeInput153G
import Source3.GeneratedFftTreeStage153F0
import Source3.GeneratedFftTreeStage153G0
import Source3.GeneratedFftTreeStage153FMiddle1
import Source3.GeneratedFftTreeStage153FMiddle2
import Source3.GeneratedFftTreeStage153FMiddle3
import Source3.GeneratedFftTreeStage153FMiddle4
import Source3.GeneratedFftTreeStage153FMiddle5
import Source3.GeneratedFftTreeStage153FMiddle6
import Source3.GeneratedFftTreeStage153FMiddle7
import Source3.GeneratedFftTreeStage153GMiddle0
import Source3.GeneratedFftTreeStage153GMiddle1
import Source3.GeneratedFftTreeStage153GMiddle2
import Source3.GeneratedFftTreeStage153GMiddle3
import Source3.GeneratedFftTreeStage153GMiddle4
import Source3.GeneratedFftTreeStage153GMiddle5
import Source3.GeneratedFftTreeStage153GMiddle6
import Source3.GeneratedFftTreeStage153GMiddle7
import Source3.GeneratedFftTreeStage153FTriple
import Source3.GeneratedFftTreeStage153GTriple

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedNumericFft153

theorem f_first : SelectedFftImages152.fFirstGroup=GeneratedFftTree153FMiddle0.word :=
  FftCertificateLink153.f_first _ _ GeneratedFftTreeInput153F.source GeneratedFftTreeStage153F0.source

theorem g_first : SelectedFftImages152.gFirst=GeneratedFftTree153GFirst.word :=
  FftCertificateLink153.g_first _ _ GeneratedFftTreeInput153G.source GeneratedFftTreeStage153G0.source

theorem f_middle : SelectedFftImages152.fMiddle=GeneratedFftTree153FMiddle7.word := by
  unfold SelectedFftImages152.fMiddle
  rw [f_first]
  calc
    FftPassValues152.middle 1536 768 (by decide) 7 384 4 GeneratedFftTree153FMiddle0.word = FftPassValues152.middle 1536 768 (by decide) 6 192 8 GeneratedFftTree153FMiddle1.word := FftLiteralCertificate153.next_pass 6 384 4 _ _ GeneratedFftTreeStage153FMiddle1.source
    _ = FftPassValues152.middle 1536 768 (by decide) 5 96 16 GeneratedFftTree153FMiddle2.word := FftLiteralCertificate153.next_pass 5 192 8 _ _ GeneratedFftTreeStage153FMiddle2.source
    _ = FftPassValues152.middle 1536 768 (by decide) 4 48 32 GeneratedFftTree153FMiddle3.word := FftLiteralCertificate153.next_pass 4 96 16 _ _ GeneratedFftTreeStage153FMiddle3.source
    _ = FftPassValues152.middle 1536 768 (by decide) 3 24 64 GeneratedFftTree153FMiddle4.word := FftLiteralCertificate153.next_pass 3 48 32 _ _ GeneratedFftTreeStage153FMiddle4.source
    _ = FftPassValues152.middle 1536 768 (by decide) 2 12 128 GeneratedFftTree153FMiddle5.word := FftLiteralCertificate153.next_pass 2 24 64 _ _ GeneratedFftTreeStage153FMiddle5.source
    _ = FftPassValues152.middle 1536 768 (by decide) 1 6 256 GeneratedFftTree153FMiddle6.word := FftLiteralCertificate153.next_pass 1 12 128 _ _ GeneratedFftTreeStage153FMiddle6.source
    _ = FftPassValues152.middle 1536 768 (by decide) 0 3 512 GeneratedFftTree153FMiddle7.word := FftLiteralCertificate153.next_pass 0 6 256 _ _ GeneratedFftTreeStage153FMiddle7.source
    _ = GeneratedFftTree153FMiddle7.word := rfl

theorem g_middle : SelectedFftImages152.gMiddle=GeneratedFftTree153GMiddle7.word := by
  unfold SelectedFftImages152.gMiddle
  rw [g_first]
  calc
    FftPassValues152.middle 1536 768 (by decide) 8 768 2 GeneratedFftTree153GFirst.word = FftPassValues152.middle 1536 768 (by decide) 7 384 4 GeneratedFftTree153GMiddle0.word := FftLiteralCertificate153.next_pass 7 768 2 _ _ GeneratedFftTreeStage153GMiddle0.source
    _ = FftPassValues152.middle 1536 768 (by decide) 6 192 8 GeneratedFftTree153GMiddle1.word := FftLiteralCertificate153.next_pass 6 384 4 _ _ GeneratedFftTreeStage153GMiddle1.source
    _ = FftPassValues152.middle 1536 768 (by decide) 5 96 16 GeneratedFftTree153GMiddle2.word := FftLiteralCertificate153.next_pass 5 192 8 _ _ GeneratedFftTreeStage153GMiddle2.source
    _ = FftPassValues152.middle 1536 768 (by decide) 4 48 32 GeneratedFftTree153GMiddle3.word := FftLiteralCertificate153.next_pass 4 96 16 _ _ GeneratedFftTreeStage153GMiddle3.source
    _ = FftPassValues152.middle 1536 768 (by decide) 3 24 64 GeneratedFftTree153GMiddle4.word := FftLiteralCertificate153.next_pass 3 48 32 _ _ GeneratedFftTreeStage153GMiddle4.source
    _ = FftPassValues152.middle 1536 768 (by decide) 2 12 128 GeneratedFftTree153GMiddle5.word := FftLiteralCertificate153.next_pass 2 24 64 _ _ GeneratedFftTreeStage153GMiddle5.source
    _ = FftPassValues152.middle 1536 768 (by decide) 1 6 256 GeneratedFftTree153GMiddle6.word := FftLiteralCertificate153.next_pass 1 12 128 _ _ GeneratedFftTreeStage153GMiddle6.source
    _ = FftPassValues152.middle 1536 768 (by decide) 0 3 512 GeneratedFftTree153GMiddle7.word := FftLiteralCertificate153.next_pass 0 6 256 _ _ GeneratedFftTreeStage153GMiddle7.source
    _ = GeneratedFftTree153GMiddle7.word := rfl

theorem f_source : SelectedTripling148.finalValues=GeneratedFftTree153FTriple.word := by
  rw [SelectedFftImages152.f_source]
  unfold SelectedFftImages152.fImage
  rw [f_middle]
  exact FftLiteralCertificate153.final_pass _ _ GeneratedFftTreeStage153FTriple.source

theorem g_source : SelectedFftGTripling150.finalValues=GeneratedFftTree153GTriple.word := by
  rw [SelectedFftImages152.g_source]
  unfold SelectedFftImages152.gImage
  rw [g_middle]
  exact FftLiteralCertificate153.final_pass _ _ GeneratedFftTreeStage153GTriple.source

theorem images : C99WordBuffer140.Represents SelectedRawNorm151.after.heap SelectedFftBuffer141.base GeneratedFftTree153FTriple.word ∧
    C99WordBuffer140.Represents SelectedRawNorm151.after.heap SelectedFftGInput148.base GeneratedFftTree153GTriple.word := by
  rw [← f_source,← g_source]
  exact SelectedRawNorm151.images

theorem norm_source : SelectedRawNorm151.finalWord=FprHeadersFast137.double
    (KeygenNormInduction151.sum GeneratedFftTree153FTriple.word GeneratedFftTree153GTriple.word 1536 0 0) := by
  unfold SelectedRawNorm151.finalWord SelectedRawNorm151.sumWord
  rw [f_source,g_source]

end FT1536.Source3.SelectedNumericFft153
