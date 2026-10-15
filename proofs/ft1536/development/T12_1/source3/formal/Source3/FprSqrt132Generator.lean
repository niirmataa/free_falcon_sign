import Source3.FprSqrtSyntax132

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted serialization of source parse; generated equality is checked
   separately in the kernel before the literal body is used. -/
namespace FT1536.Source3.FprSqrt132Generator

def generate : IO Unit := do
  let some code := FprSqrtSyntax132.parse | throw (IO.userError "sqrt parse failed")
  let text := "import Source3.FprSqrtSyntax132\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.GeneratedSqrt132\n\n" ++
    "def code : FprSqrtSyntax132.Code :=\n  " ++ (reprStr code).replace "\n" "\n  " ++ "\n\n" ++
    "theorem source : FprSqrtSyntax132.parse=some code := by decide +kernel\n\n" ++
    "theorem function_source : FprSqrtSyntax132.function=some (FprSqrtSyntax132.lower code) := by\n  simp only [FprSqrtSyntax132.function,FprSqrtSyntax132.active_source,ite_true,source,Option.map_some]\n\n" ++
    "end FT1536.Source3.GeneratedSqrt132\n"
  IO.FS.writeFile "../GeneratedSqrt132.lean" text

end FT1536.Source3.FprSqrt132Generator
#eval FT1536.Source3.FprSqrt132Generator.generate
