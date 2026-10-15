import Source3.GeneratedSamplerWords129
import Source3.NormalizedSamples129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SamplerImages129
open C99CompactState115 (reference)
open GeneratedSamplerWords129 (fVector gVector)

def finalState := NormalizedSamples129.after

theorem f_image : KeygenMaterial.Represents (reference finalState).heap
    (KeygenMakeEntry.input KeygenFullData127.env.blocks 0) fVector := by
  unfold KeygenMaterial.Represents KeygenSmallOutput.Stored
  decide +kernel

theorem g_image : KeygenMaterial.Represents (reference finalState).heap
    (KeygenMakeEntry.input KeygenFullData127.env.blocks 1) gVector := by
  unfold KeygenMaterial.Represents KeygenSmallOutput.Stored
  decide +kernel

theorem f_bound : KeygenIntegerLift.Bound fVector 1 := by
  unfold KeygenIntegerLift.Bound
  decide +kernel

theorem g_bound : KeygenIntegerLift.Bound gVector 1 := by
  unfold KeygenIntegerLift.Bound
  decide +kernel

/-- Both original source calls and every sampled coefficient on the SAME
    final heap. Neither a native-success claim nor a distribution is assumed. -/
theorem source_and_images :
    KeygenSamplerContext.Call KeygenFullData127.env.ctx
      (reference SelectedFullSampler128.prepared) "f" (reference NormalizedSamples129.middle) ∧
    KeygenSamplerContext.Call KeygenFullData127.env.ctx
      (reference NormalizedSamples129.middle) "g" (reference finalState) ∧
    KeygenMaterial.Represents (reference finalState).heap
      (KeygenMakeEntry.input KeygenFullData127.env.blocks 0) fVector ∧
    KeygenMaterial.Represents (reference finalState).heap
      (KeygenMakeEntry.input KeygenFullData127.env.blocks 1) gVector :=
  ⟨NormalizedSamples129.first,NormalizedSamples129.second,f_image,g_image⟩

end FT1536.Source3.SamplerImages129
