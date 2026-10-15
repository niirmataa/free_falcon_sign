import Source3.SelectedResultantFComplete130
import Source3.SelectedResultantGComplete130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedResultantGate130
open C99CompactState115 (reference)

def before := NormalizedSamples129.after

/-- Both actual source calls, in order, with their original nonzero tests.
    Disposal makes the entire source state identical between these calls. -/
theorem source : KeygenResultantGate.Exec (reference before) ⟨reference before,.normal⟩ :=
  .accepted (reference before) (reference before) (.uint32 1) (.uint32 1)
    SelectedResultantFComplete130.source (by decide +kernel)
    SelectedResultantGComplete130.source (by decide +kernel)

end FT1536.Source3.SelectedResultantGate130
