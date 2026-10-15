import Source3.KeygenSearchFft

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted serialization of actual source syntax; generated equalities
   must pass the kernel before any fragment is used as source. -/
namespace FT1536.Source3.Fft138SyntaxGenerator

def parts : C99ProcedureReference.Stmt → List C99ProcedureReference.Stmt
  | .seq first second => first::parts second
  | .base .skip => []
  | other => [other]

def generate : IO Unit := do
  let some function := KeygenSearchFft.program "falcon_FFT3".toList |
    throw (IO.userError "Pinned FFT3 parse failed")
  let text := "import Source3.KeygenSearchFft\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.GeneratedFft138Syntax\n\n" ++
    "def function : C99ProcedureReference.Function :=\n  " ++ (reprStr function).replace "\n" "\n  " ++ "\n\n" ++
    "def parts : List C99ProcedureReference.Stmt :=\n  " ++ (reprStr (parts function.body)).replace "\n" "\n  " ++ "\n\n" ++
    "theorem source : KeygenSearchFft.program \"falcon_FFT3\".toList=some function := by decide +kernel\n\n" ++
    "theorem body_shape : function.body=C99ProcedureParser.chain parts := by decide +kernel\n\n" ++
    "end FT1536.Source3.GeneratedFft138Syntax\n"
  IO.FS.writeFile "../GeneratedFft138Syntax.lean" text
  IO.FS.writeFile "../FFT138_PARTS.json" (Lean.Json.pretty (Lean.toJson ((parts function.body).map reprStr)))

end FT1536.Source3.Fft138SyntaxGenerator
#eval FT1536.Source3.Fft138SyntaxGenerator.generate
