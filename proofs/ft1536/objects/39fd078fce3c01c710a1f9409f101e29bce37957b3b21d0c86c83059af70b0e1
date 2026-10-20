import Source3.KeygenMakeArguments
import Source3.KeygenMakeLocalFrame
import Source3.KeygenMakeSearchPrefix
import Source3.KeygenMakeSearchTrace
import Source3.KeygenMakeSearchMaterial
import Source3.KeygenMakePublicCall
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated050 internal full terms. Certificate types are inspected, NOT consumed; this is not review. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeArguments,
      ["Arguments","Argument","params","values","fromHeader","parsedParams","header_params","header_source","base","Bind","entry","bind_exact","bind_exists","actual_cells","PrefixInvocation","normal_entry"]),
    (`FT1536.Source3.KeygenMakeLocalFrame,
      ["scalarKeep","arrayKeep","receiveKeep","procedureKeep","searchKeep","declared","scalar","restored","array","receive","procedure","search","fixed","checked_bodies","raw","gs","norm","resultants","ternary"]),
    (`FT1536.Source3.KeygenMakeSearchPrefix,
      ["close","close_fixed","close_local","public_locals","public_gate_locals","root_gate_locals","Gates","gates_locals","gates_flow","Sampled","Step","Dimensions","Remaining","updated","prepared_local","dimensions_advanced","sampled_remaining","exhaustion","cap_source","gates_source","no_false_acceptance"]),
    (`FT1536.Source3.KeygenMakeSearchTrace,
      ["Attempt","Rejected","AtCertificate","Trace","Numbered","Aborted","BoundFacts","source_bounds","chronological","no_cap_sample","Invocation","prefix_remaining","actual_initial_chronology","actual_final_prefix","CapFailure","cap_failure_lifetime"]),
    (`FT1536.Source3.KeygenMakeSearchMaterial,
      ["root_initial","context_norm","context_public","ternary_root","public_material","source_ntru","first_source_ntru"]),
    (`FT1536.Source3.KeygenMakePublicCall,
      ["boolReturns","BooleanFlow","body_flow","bool_returns_source","nonzero_success","bound","address_zero","scalar_variable","bind_exact","Material","source_same_material"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeProgram.source_bound,
    ``FT1536.Source3.KeygenMakeProgram.cap_source,
    ``FT1536.Source3.KeygenMakeProgram.actual_attempt_tail,
    ``FT1536.Source3.KeygenMakeReady.Prefix,
    ``FT1536.Source3.KeygenMakeReady.normal_prefix,
    ``FT1536.Source3.KeygenMakeReady.normal_prefix_locals,
    ``FT1536.Source3.KeygenMakeLifetime.close,
    ``FT1536.Source3.KeygenMakeLifetime.close_object,
    ``FT1536.Source3.KeygenMakeLifetime.prefix_empty,
    ``FT1536.Source3.KeygenMakeSampling.CappedSetup,
    ``FT1536.Source3.KeygenMakeSampling.cap_before_setup,
    ``FT1536.Source3.KeygenMakeSampling.prepared_initial,
    ``FT1536.Source3.KeygenMakeSampling.entry_from_prepared,
    ``FT1536.Source3.KeygenMakeSampling.no_counter_wrap,
    ``FT1536.Source3.KeygenCallerPrefix.Ternary,
    ``FT1536.Source3.KeygenCallerPrefix.ternary_root,
    ``FT1536.Source3.KeygenCallerPrefix.ternary_material,
    ``FT1536.Source3.KeygenRootCaller.success,
    ``FT1536.Source3.KeygenRootSource.Call,
    ``FT1536.Source3.KeygenPublicSource.Call,
    ``FT1536.Source3.KeygenPublicAccepted.source_same_material,
    ``FT1536.Source3.CertificateFunctionReference.Exec,
    ``FT1536.Source3.CertificateFunctionReference.initial,
    ``FT1536.Source3.CertificateFunctionReference.resolveLayout,
    ``FT1536.Source3.CertificateM0Environment.Pinned,
    ``FT1536.Source3.CertificateM0Environment.Exec,
    ``FT1536.Source3.CertificateFunctionOutcome.accepted]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
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
