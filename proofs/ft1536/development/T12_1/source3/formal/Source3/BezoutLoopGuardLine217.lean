import Source3.SelectedBezoutLoopGuard217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Parse the pinned source guard line independently; full part7 linkage remains open. -/
namespace FT1536.Source3.BezoutLoopGuardLine217
open KeygenWordExpr (Expr)

def parsed : Option Expr := do
  let line ← Pinned.keygenLines[4021]?
  let tokens ← KeygenZintCall.tokens line.toList
  match tokens with
  | ['i','f']::['(']::rest => do
      let (test,tail) ← KeygenWordExpr.expression (KeygenZintCall.widths .bezout) rest
      if tail=[[')'],['{']] then pure test else none
  | _ => none

theorem source_line : parsed=some BezoutLoopGuard217.condition := by decide

end FT1536.Source3.BezoutLoopGuardLine217
