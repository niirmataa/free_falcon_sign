import Source3.KeygenSourceToFiber001

set_option pp.universes true
set_option pp.maxSteps 200000

run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.KeygenSourceToFiber001.PinnedExec,
    ``FT1536.Source3.KeygenSourceToFiber001.Success,
    ``FT1536.Source3.KeygenSourceToFiber001.Emitted,
    ``FT1536.Source3.KeygenSourceToFiber001.Output,
    ``FT1536.Source3.KeygenSourceToFiber001.secretBytes,
    ``FT1536.Source3.KeygenSourceToFiber001.publicBytes,
    ``FT1536.Source3.KeygenSourceToFiber001.FiberFacts,
    ``FT1536.Source3.KeygenSourceToFiber001.Contract,
    ``FT1536.Source3.KeygenSourceToFiber001.contract_of_output,
    ``FT1536.Source3.KeygenSourceToFiber001.emitted_to_actual_fiber,
    ``FT1536.Source3.KeygenSourceToFiber001.actual_observed_fiber]
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
