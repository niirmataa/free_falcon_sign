import Source3.KeygenExternalSampling082
import Source3.KeygenExternalGates082
import Source3.KeygenExternalLoop082
import Source3.KeygenPublicEntry082
import Source3.KeygenPublicPrivateBridge082
import Source3.KeygenPublicComplete082
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Author inventory of root public input transport and joint observed key output. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenExternalSampling082,["Outside","moved","prepared","norm_prepared","sampler","two_samplers","resultants","ternary"]),
    (`FT1536.Source3.KeygenExternalGates082,["public_call","after_ternary","gates","sampled"]),
    (`FT1536.Source3.KeygenExternalLoop082,["attempt","loop"]),
    (`FT1536.Source3.KeygenPublicEntry082,["Legal","ready_parts","ready_block","ready_metadata","ready_tables","writable_block","at_loop_output"]),
    (`FT1536.Source3.KeygenPublicPrivateBridge082,["site_frame","segments_frame","private_frame","public_entry"]),
    (`FT1536.Source3.KeygenPublicComplete082,["Output","public_after_return","observed_pair","actual_observed_pair"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenPublicEncodeBinding077.source_bound,
    ``FT1536.Source3.KeygenPublicDecodeBinding077.source_bound,
    ``FT1536.Source3.KeygenPublicCallerComplete077.observed_output,
    ``FT1536.Source3.KeygenSecretComplete081.observed_secret,
    ``FT1536.Source3.KeygenSecretInvocation081.PinnedExec,
    ``FT1536.Source3.KeygenMakeAssembly080.LegalEntry,
    ``FT1536.Source3.KeygenOutputMemory081.Legal,
    ``FT1536.Source3.KeygenPublicPacket077.DecodePublic,
    ``FT1536.Source3.KeygenPublicObserved077.ObservedPublic]
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
