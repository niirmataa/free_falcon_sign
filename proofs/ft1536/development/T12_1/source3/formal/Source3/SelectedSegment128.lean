import Source3.SelectedFullSampler128
import Source3.GeneratedProcessTransitions128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSegment128
open C99CompactState115 (reference)
open SelectedFullSampler128 (ctx initial)

/-- CANDIDATE CHECK ONLY until every logged event is source-proved.
    The source n stays1536;32 is a proof-cut length, not a new sampler bound. -/
def propose := ShakeProcessProposal128.propose GeneratedProcessTransitions128.candidates
def result := KeygenOuterSegment128.run ctx propose 256 7 64 32 initial
theorem defined : result.isSome=true := by decide +kernel
def output : ShakeProcessEvents128.Result := result.get defined
theorem computed : KeygenOuterSegment128.run ctx propose 256 7 64 32 initial=some output :=
  SelectedInput124.option_get result defined

theorem event_count : output.2.length=1 := by decide +kernel
theorem counter : C99NameMap115.lookup output.1.locals "u".toList=some (.u64 (some 32)) := by decide +kernel

/-- An explicit obligation, not an assumed property of native proposals. -/
def Obligations : Prop := ShakeProcessEvents128.All ctx output.2

theorem source (checked : Obligations) :
    KeygenSamplerPrefix128.Prefix ctx 32 (reference initial) (reference output.1) :=
  KeygenSamplerPrefix128.run_prefix ctx propose 256 7 64 32 initial output.1 output.2 computed checked

end FT1536.Source3.SelectedSegment128
