import Source3.NttPrologue182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopForwardShape182
open KeygenLevelExec (Stmt)

def args (name : String) : List KeygenLevelCalls.Arg := [
  .pointer name.toList C99ProcedureParser.zero,
  .scalar (.modular (.scalar (.literal .i32 1))),
  .pointer "gm".toList C99ProcedureParser.zero,
  .scalar (.modular (.scalar (.var "logn".toList))),
  .scalar (.modular (.scalar (.literal .i32 1))),
  .scalar (.modular (.scalar (.var "p".toList))),
  .scalar (.modular (.scalar (.var "p0i".toList)))]
def first : Stmt := .call .forward (args "fs")
def second : Stmt := .call .forward (args "gs")
def remaining := LevelSequence177.drop 2 TopInitShape178.remaining

theorem front : LevelPrefix177.take 2 TopInitShape178.remaining=[first,second] := by decide

theorem shape : TopInitShape178.remaining=.seq first (.seq second remaining) :=
  (LevelPrefix177.partition 2 TopInitShape178.remaining).trans
    (congrArg (fun steps => LevelSequence177.append steps remaining) front)

end FT1536.Source3.TopForwardShape182
