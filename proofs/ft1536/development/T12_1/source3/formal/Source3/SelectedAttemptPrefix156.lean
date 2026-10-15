import Source3.SelectedGsGate156
import Source3.KeygenMakeSearchPrefix134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedAttemptPrefix156
open C99ArrayReference (State)
open C99CompactState115 (reference)

def saved := reference SelectedFullStart127.ready
def prepared := reference SelectedFullSampler128.prepared
noncomputable def publicInput := KeygenCallerPrefix.close saved SelectedGsNorm155.after

/-- Both actual samplers, both resultant checks, and both norm gates accept in the same source execution. -/
theorem ternary : KeygenCallerPrefix134.Ternary KeygenFullData127.env.ctx prepared ⟨SelectedGsNorm155.after,.normal⟩ :=
  .norm (reference NormalizedSamples129.middle) (reference NormalizedSamples129.after)
    (reference NormalizedSamples129.after) ⟨SelectedGsNorm155.after,.normal⟩
    NormalizedSamples129.first NormalizedSamples129.second SelectedResultantGate130.source SelectedGsGate156.norm_prefix

/-- The next obligations are the original public-key gate and root solver, before certificate/encoding. -/
theorem continue_search (publicState : State) (out : C99ProcedureReference.Result)
    (publicGate : KeygenAttemptMaterial.PublicGate publicInput ⟨publicState,.normal⟩)
    (rootGate : KeygenCallerSuccess.RootGate KeygenFullData127.env.ctx publicState out) :
    KeygenMakeSearchPrefix134.Sampled KeygenFullData127.env.ctx saved out :=
  .run prepared out SelectedFullSampler128.capped (.solver SelectedGsNorm155.after publicState out ternary publicGate rootGate)

end FT1536.Source3.SelectedAttemptPrefix156
