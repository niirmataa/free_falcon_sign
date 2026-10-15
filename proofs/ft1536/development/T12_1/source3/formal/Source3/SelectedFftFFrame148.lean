import Source3.SelectedFftFComplete148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedFftFFrame148
open C99CompactState115 (reference)
open SelectedFftFComplete148 (after)

theorem sizes : after.heap.size=(reference SelectedFftBuffer141.before).heap.size :=
  SelectedTripling148.loop_frame.sizes.trans SelectedFftMiddleContext144.sizes

theorem permissions : after.heap.writable=(reference SelectedFftBuffer141.before).heap.writable :=
  SelectedTripling148.loop_frame.writable.trans SelectedFftMiddleContext144.permissions

theorem outside (block offset : Nat) (separate : FftLoopFrame141.Outside SelectedFftBuffer141.base 1536 block offset) :
    after.heap.bytes block offset=(reference SelectedFftBuffer141.before).heap.bytes block offset :=
  (SelectedTripling148.loop_frame.bytes block offset separate).trans (SelectedFftMiddleContext144.outside_byte block offset separate)

theorem pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment after.heap :=
  FftPinned139.procedure _ _ _ _ SelectedFftFComplete148.source FftPinned139.converted

end FT1536.Source3.SelectedFftFFrame148
