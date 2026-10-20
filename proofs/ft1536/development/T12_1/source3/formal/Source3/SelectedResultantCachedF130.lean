import Source3.NormalizedSamples129
import Source3.KeygenResultantCached130
import Source3.KeygenResultantCall093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedResultantCachedF130
open C99CompactState115 (reference)

def before := NormalizedSamples129.after
def args := KeygenResultantGate.arguments "f"
def result := KeygenResultantCached130.run 2048 7 before args

/-- A finite computation of the original body, not a native-result premise.
    It simultaneously checks defined execution and the converted C return. -/
theorem returned_one : result.map Prod.snd=some (.u32 1) := by decide +kernel

theorem defined : result.isSome=true := by
  have checked := returned_one
  cases found : result with
  | none => simp [found] at checked
  | some out => rfl

def output : C99CompactState115.State×B20.C.Val := result.get defined

theorem computed : KeygenResultantCached130.run 2048 7 before args=some output :=
  SelectedInput124.option_get result defined

theorem value_one : output.2=.u32 1 := by
  have checked := returned_one
  change (KeygenResultantCached130.run 2048 7 before args).map Prod.snd=some (.u32 1) at checked
  rw [computed] at checked
  exact Option.some.inj checked

theorem source_raw : KeygenResultantSource.Call (reference before) args (reference output.1)
    (C99ValueBridge.value output.2) :=
  KeygenResultantCached130.sound 2048 7 before output.1 args output.2 computed

theorem unchanged : reference output.1=reference before :=
  KeygenResultantCall093.call_state _ _ args _ source_raw

/-- The actual first resultant call returns1 and leaves the whole caller
    state unchanged after disposing b[96]. -/
theorem source : KeygenResultantSource.Call (reference before) args (reference before) (.uint32 1) := by
  have checked := source_raw
  rw [unchanged,value_one] at checked
  exact checked

end FT1536.Source3.SelectedResultantCachedF130
