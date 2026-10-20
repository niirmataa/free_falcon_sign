import AllSource3
import Lean.Elab.Tactic.Omega

set_option maxRecDepth 32768
set_option maxHeartbeats 0
set_option Elab.async false
set_option pp.fullNames true
set_option pp.proofs true
set_option pp.maxSteps 200000

theorem FT1536.PremiseArithmeticAudit.impossible_control (n : Nat) (h : n < n) : 0 = 1 := by
  exact (Nat.lt_irrefl n h).elim

theorem FT1536.PremiseArithmeticAudit.feasible_control (n : Nat) (h : n < 10) : n ≤ 10 := by
  omega

open Lean Meta in
run_cmd Lean.Elab.Command.liftTermElabM do
  let raw ← IO.FS.readFile "OMEGA_WANTED.json"
  let .ok parsed := Json.parse raw | throwError "Invalid names"
  let .ok (wanted : Array String) := fromJson? parsed | throwError "Invalid names"
  let file ← IO.FS.Handle.mk "OMEGA_RESULTS.jsonl" .write
  for i in [:wanted.size] do
    let label := wanted[i]!
    let info ← getConstInfo label.toName
    let row ← withNewMCtxDepth <| withCurrHeartbeats <|
        withOptions (fun o => maxHeartbeats.set o 10000) <|
        forallTelescope info.type fun xs result => do
      let goal ← mkFreshExprMVar (mkConst ``False)
      let mut found := false
      let mut diagnostic := ""
      try
        Lean.Elab.Tactic.Omega.omega (← getLocalHyps).toList goal.mvarId!
        found := true
      catch e => diagnostic := (← e.toMessageData.toString)
      if !found then
        return Json.mkObj [("name",toJson label),("result",toJson "INCONCLUSIVE"),
          ("diagnostic",toJson diagnostic)]
      let name := Name.str `FT1536.PremiseArithmeticAudit ("refutation_"++toString i)
      let type ← mkForallFVars xs (mkConst ``False)
      let proof ← mkLambdaFVars xs (← instantiateMVars goal)
      addDecl (.thmDecl {name := name,levelParams := info.levelParams,type := type,value := proof})
      let axes ← collectAxioms name
      for ax in axes do
        unless #[``propext,``Classical.choice,``Quot.sound].contains ax do
          throwError "Unexpected axiom {ax}"
      return Json.mkObj [("name",toJson label),("result",toJson "INCONSISTENT_PREMISES"),
        ("original_result",toJson (← ppExpr result).pretty),
        ("countertheorem",toJson name.toString),
        ("type",toJson (← ppExpr type).pretty),
        ("proof",toJson (← ppExpr proof).pretty),
        ("axioms",toJson (axes.map Name.toString))]
    file.putStrLn row.compress
