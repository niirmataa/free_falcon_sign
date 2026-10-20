import Source3.ExpressionFuel

namespace FT1536.Source3.EmitFprAST
open FprPrimitives

def emitInstr : Nat → Instr → String
  | 0,_ => "ERROR_FUEL"
  | _+1,.scalar s => "(.scalar (" ++ reprStr s ++ "))"
  | _+1,.norm m e => "(.norm " ++ reprStr m ++ " " ++ reprStr e ++ ")"
  | fuel+1,.forInc i n body =>
      "(.forInc " ++ reprStr i ++ " " ++ toString n ++ " [\n" ++
      String.intercalate ",\n" (body.map (emitInstr fuel)) ++ "\n])"

def emitFunction (name : String) (f : FprPrimitives.Function) : String :=
  "def " ++ name ++ " : FprPrimitives.Function := {\nname := " ++ reprStr f.name ++
  "\nresult := " ++ reprStr f.result ++ "\nparams := " ++ reprStr f.params ++
  "\nbody := [\n" ++ String.intercalate ",\n" (f.body.map (emitInstr 16)) ++ "\n]}\n"

def main : IO Unit := do
  let some add := addProgram | throw (IO.userError "add parse failure")
  let some mul := mulProgram | throw (IO.userError "mul parse failure")
  let some div := divProgram | throw (IO.userError "div parse failure")
  let some ur := ursh | throw (IO.userError "ursh parse failure")
  let some ul := ulsh | throw (IO.userError "ulsh parse failure")
  let some pk := pack | throw (IO.userError "pack parse failure")
  let some norm := normStatements ['x','u'] ['e','x'] | throw (IO.userError "norm parse failure")
  IO.println "import Source3.FprPrimitives\nnamespace FT1536.Source3.FprAST\n"
  IO.println (emitFunction "addCode" add)
  IO.println (emitFunction "mulCode" mul)
  IO.println (emitFunction "divCode" div)
  IO.println ("def urshCode : CLogic.Function :=\n  " ++ (reprStr ur).replace "\n" "\n  ")
  IO.println ("def ulshCode : CLogic.Function :=\n  " ++ (reprStr ul).replace "\n" "\n  ")
  IO.println ("def packCode : CLogic.Function :=\n  " ++ (reprStr pk).replace "\n" "\n  ")
  IO.println ("def normCode : List CLogic.Stmt := " ++ reprStr norm)
  IO.println "end FT1536.Source3.FprAST"

end FT1536.Source3.EmitFprAST

#eval FT1536.Source3.EmitFprAST.main
