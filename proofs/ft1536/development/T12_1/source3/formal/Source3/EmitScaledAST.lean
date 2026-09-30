import Source3.C99PrimitiveExists

namespace FT1536.Source3.EmitScaledAST
open FprPrimitives

def emitInstr : Instr → String
  | .scalar s => "(.scalar (" ++ reprStr s ++ "))"
  | .norm m e => "(.norm " ++ reprStr m ++ " " ++ reprStr e ++ ")"
  | .forInc _ _ _ => "UNSUPPORTED_FOR"

def main : IO Unit := do
  let some scaled := parseFunction (cslice 150 55) | throw (IO.userError "scaled parse failure")
  let some ofCode := CLogicParser.parseFunction (hslice 86 5) | throw (IO.userError "of parse failure")
  let some norm := normStatements ['m'] ['e'] | throw (IO.userError "norm parse failure")
  IO.println "import Source3.FprPrimitives\nnamespace FT1536.Source3.FprScaledAST\n"
  IO.println ("def scaledCode : FprPrimitives.Function := {\nname := " ++ reprStr scaled.name ++
    "\nresult := " ++ reprStr scaled.result ++ "\nparams := " ++ reprStr scaled.params ++
    "\nbody := [\n" ++ String.intercalate ",\n" (scaled.body.map emitInstr) ++ "\n]}\n")
  IO.println ("def ofCode : CLogic.Function :=\n  " ++ (reprStr ofCode).replace "\n" "\n  ")
  IO.println ("def normCode : List CLogic.Stmt := " ++ reprStr norm)
  IO.println "end FT1536.Source3.FprScaledAST"

end FT1536.Source3.EmitScaledAST

#eval FT1536.Source3.EmitScaledAST.main
