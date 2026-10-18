import Source3.SelectedSecondMetadata185

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopProductShape185
open KeygenLevelExec (Stmt)

def r3Set : Stmt := .modular (.assign "R3".toList
  (KeygenMkgm3Program.mont (KeygenMkgm3Program.cell "R2") (KeygenMkgm3Program.cell "R2")))
def loop : Stmt := match LevelSequence177.drop 1 TopForwardShape182.remaining with
  | .seq code _ => code
  | code => code
def tail : Stmt := LevelSequence177.drop 2 TopForwardShape182.remaining

theorem front : LevelPrefix177.take 2 TopForwardShape182.remaining=[r3Set,loop] := by decide

theorem shape : TopForwardShape182.remaining=.seq r3Set (.seq loop tail) :=
  (LevelPrefix177.partition 2 TopForwardShape182.remaining).trans
    (congrArg (fun steps => LevelSequence177.append steps tail) front)

end FT1536.Source3.TopProductShape185
