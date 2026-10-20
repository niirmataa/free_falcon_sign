import Source3.PublicTailShape159

/- DIAGNOSTIC: report which tail sub-shapes match the pinned parser.
   Nonempty stdout by design; not accepted proof evidence. -/
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

open FT1536.Source3

def check (label : String) (b : Bool) : IO Unit :=
  IO.println (label ++ ": " ++ (if b then "OK" else "FAIL"))

#eval do
  let t := KeygenPublicForwardProgram.tail
  let r := PublicTailShape159.rSet
  let fp := PublicTailShape159.firstPass
  let mp := PublicTailShape159.midPasses
  let tr := PublicTailShape159.tripling
  check "rSet" (decide (r = KeygenPublicExec.Stmt.assign "r".toList
    (KeygenWordExpr.Expr.load16 "gm_square".toList (CLogic.Expr.literal .i32 1))))
  -- decompose tail manually from the probe AST
  let (rSet', rest) := match t with
    | .seq a b => (a, b)
    | _ => (t, t)
  check "tail.rSet=" (rSet' = r)
  let (first, rest2) := match rest with
    | .seq a b => (a, b)
    | _ => (rest, rest)
  check "tail.firstPass=" (first = fp)
  let (tSet', rest3) := match rest2 with
    | .seq a b => (a, b)
    | _ => (rest2, rest2)
  check "tail.tSet=" (tSet' = PublicTailShape159.tSet)
  let (mid', rest4) := match rest3 with
    | .seq a b => (a, b)
    | _ => (rest3, rest3)
  check "tail.midPasses=" (mid' = mp)
  check "tail.tripling=" (rest4 = tr)
  IO.println "--- detailed mismatches ---"
  if first ≠ fp then
    IO.println ("PARSED firstPass =\n" ++ repr first ++ "\nOUR firstPass =\n" ++ repr fp)
  if mid' ≠ mp then
    IO.println ("PARSED midPasses =\n" ++ repr mid' ++ "\nOUR midPasses =\n" ++ repr mp)
  if rest4 ≠ tr then
    IO.println ("PARSED tripling =\n" ++ repr rest4 ++ "\nOUR tripling =\n" ++ repr tr)
