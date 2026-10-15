import Source3.KeygenResultantCached130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ResultantSetup130FixedProbe

def before : C99CompactState115.State :=
  ⟨⟨.empty⟩,[("logn".toList,.u32 (some 10))],[],[],[]⟩

def result := C99ScalarSteps130.run 16 GeneratedResultantSyntax130.setup before

theorem defined : result.isSome=true := by decide +kernel

theorem dimension : result.map (fun state => C99NameMap115.lookup state.locals "n".toList)=
    some (some (.u64 (some 1536))) := by decide +kernel

end FT1536.Source3.ResultantSetup130FixedProbe
