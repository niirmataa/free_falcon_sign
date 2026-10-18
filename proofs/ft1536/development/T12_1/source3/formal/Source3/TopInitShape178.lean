import Source3.SelectedTopStatics178
import Source3.KeygenModpR2Exec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopInitShape178
open KeygenLevelExec (Stmt)
open LevelSequence177 (append)

def pSet : Stmt := .prime "p".toList "PRIMES3".toList (.literal .i32 0) .p
def iSet : Stmt := .modular (.assign "p0i".toList (.call1 "modp_ninv31".toList (.scalar (.var "p".toList))))
def rSet : Stmt := .modular (.assign "R2".toList (.call2 "modp_R2".toList
  (.scalar (.var "p".toList)) (.scalar (.var "p0i".toList))))
def steps := [pSet,iSet,rSet]
def args : List KeygenLevelCalls.Arg := [
  .pointer "gm".toList C99ProcedureParser.zero,
  .pointer "igm".toList C99ProcedureParser.zero,
  .scalar (.modular (.scalar (.var "logn".toList))),
  .scalar (.modular (.scalar (.literal .i32 1))),
  .scalar (.prime "PRIMES3".toList (.literal .i32 0) .g),
  .scalar (.modular (.scalar (.var "p".toList))),
  .scalar (.modular (.scalar (.var "p0i".toList)))]
def generate : Stmt := .call .generate args
def remaining := LevelSequence177.drop 4 MakeFgTopShape177.remaining

theorem front : LevelPrefix177.take 4 MakeFgTopShape177.remaining=steps++[generate] := by decide

theorem shape : MakeFgTopShape177.remaining=append steps (.seq generate remaining) :=
  (LevelPrefix177.partition 4 MakeFgTopShape177.remaining).trans
    (congrArg (fun xs => append xs remaining) front)

end FT1536.Source3.TopInitShape178
