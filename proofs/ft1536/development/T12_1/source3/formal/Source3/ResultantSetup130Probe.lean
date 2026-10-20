import Source3.KeygenResultantCached130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ResultantSetup130Probe

def before : C99CompactState115.State :=
  ⟨⟨.empty⟩,[("logn".toList,.u32 (some 10))],[],[],[]⟩

def result := KeygenScalarCompute121.run 16 GeneratedResultantSyntax130.setup before

/-- Small diagnostic only; not an execution on the actual KeyGen input. -/
theorem defined : result.isSome=true := by decide +kernel

end FT1536.Source3.ResultantSetup130Probe

#eval IO.FS.writeFile "../SETUP130_PROBE.txt"
  (reprStr FT1536.Source3.ResultantSetup130Probe.result ++ "\n")
