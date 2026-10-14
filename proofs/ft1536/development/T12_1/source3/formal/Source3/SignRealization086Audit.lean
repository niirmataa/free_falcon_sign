import Source3.SignRealizationObligations086
import Assembly
import AssemblyComp

set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.explicit true
set_option pp.universes true
set_option pp.maxSteps 200000

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.SignRealizationObligations086.WeightFamily,
    ``FT1536.Source3.SignRealizationObligations086.WeightData,
    ``FT1536.Source3.SignRealizationObligations086.PointwiseStageGoal,
    ``FT1536.Source3.SignRealizationObligations086.attempt_bound,
    ``FT1536.Source3.SignRealizationObligations086.local_certificate,
    ``FT1536.Source3.SignRealizationObligations086.rom_from_construction,
    ``FT1536.Source3.SignRealizationObligations086.unconditioned_error,
    ``FT1536.Source3.SignRealizationObligations086.model_bound_of_pointwise_goal,
    ``FT1536.Assembly.end_to_end_assembled_theorem_statement,
    ``FT1536.AssemblyComp.advMT_ge_of_public_sim_stream_win,
    ``FT1536.Run2.concrete_euf_cma_to_mt_isis]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names do
    IO.FS.writeFile "../SEARCH_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
    let info ← Lean.getConstInfo name
    let axes ← Lean.collectAxioms name
    for ax in axes do
      unless allowed.contains ax do throwError "Unexpected axiom {ax} in {name}"
    let body ← match info.value? (allowOpaque := true) with
      | some term => pure (Lean.Json.mkObj [("kind",Lean.toJson "definition_or_theorem"),
          ("term",Lean.toJson (← render term))])
      | none =>
          match info with
          | .inductInfo ind =>
              let mut constructors : Array Lean.Json := #[]
              for ctor in ind.ctors do
                let ci ← Lean.getConstInfo ctor
                constructors := constructors.push (Lean.Json.mkObj [
                  ("name",Lean.toJson ctor.toString),("type",Lean.toJson (← render ci.type))])
              pure (Lean.Json.mkObj [("kind",Lean.toJson "kernel_inductive"),
                ("constructors",Lean.Json.arr constructors)])
          | _ => throwError "Unexpected bodyless declaration {name}"
    rows := rows.push (Lean.Json.mkObj [
      ("name",Lean.toJson name.toString),("type",Lean.toJson (← render info.type)),
      ("body",body),("axioms",Lean.toJson (axes.map Lean.Name.toString))])
    IO.FS.withFile "../SEARCH_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../SEARCH_AUDIT.json" (Lean.Json.arr rows |>.pretty)
