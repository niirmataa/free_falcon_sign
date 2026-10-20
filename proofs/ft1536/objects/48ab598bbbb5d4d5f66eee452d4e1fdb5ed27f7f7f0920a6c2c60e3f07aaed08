import Source3.KeygenModpR2
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal export audit, not an independent review. Record the actual
   types, terms and transitive axioms in the job directory. The command
   checks the standard axiom boundary and keeps both compiler logs empty;
   it neither constructs nor admits a proof. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.C99ModularReference.r2Code,
    ``FT1536.Source3.C99ModularReference.r2Body,
    ``FT1536.Source3.KeygenModpR2Exec.SourceExec,
    ``FT1536.Source3.KeygenModpR2.Contract,
    ``FT1536.Source3.KeygenMkgm3Callees.r2_header,
    ``FT1536.Source3.KeygenMkgm3Callees.r2_source_bound,
    ``FT1536.Source3.KeygenModpR2Word.halve_contract,
    ``FT1536.Source3.KeygenModpR2Word.squares_contract,
    ``FT1536.Source3.KeygenModpR2Word.word_contract,
    ``FT1536.Source3.KeygenModpR2Word.value_law,
    ``FT1536.Source3.KeygenModpR2Exec.body_exact,
    ``FT1536.Source3.KeygenModpR2Exec.body_exists,
    ``FT1536.Source3.KeygenModpR2Exec.source_exact,
    ``FT1536.Source3.KeygenModpR2Exec.source_exists,
    ``FT1536.Source3.KeygenModpR2.source_contract,
    ``FT1536.Source3.KeygenModpR2.parsed_contract,
    ``FT1536.Source3.KeygenModpR2.call_contract,
    ``FT1536.Source3.KeygenModpR2.initialized_value_law,
    ``FT1536.Source3.KeygenModpR2.initialized_to_montgomery,
    ``FT1536.Source3.KeygenModpR2.call_exists]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let mut rows : Array Lean.Json := #[]
  for name in names do
    let info ← Lean.getConstInfo name
    let axes ← Lean.collectAxioms name
    for ax in axes do
      unless allowed.contains ax do
        throwError "Unexpected axiom {ax} in {name}"
    let typeText := (← Lean.Meta.ppExpr info.type).pretty
    let some term := info.value? (allowOpaque := true) | throwError "Missing body for {name}"
    let termText := (← Lean.Meta.ppExpr term).pretty
    if typeText.contains '⋯' || termText.contains '⋯' then
      throwError "Truncated audit text for {name}"
    rows := rows.push (Lean.Json.mkObj [
      ("name",Lean.toJson name.toString),
      ("type",Lean.toJson typeText),
      ("term",Lean.toJson termText),
      ("axioms",Lean.toJson (axes.map Lean.Name.toString))])
  IO.FS.writeFile "../MODP_R2_AUDIT.json" (Lean.Json.arr rows |>.pretty)
