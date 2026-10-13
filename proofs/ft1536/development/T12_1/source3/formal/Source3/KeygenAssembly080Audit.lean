import Source3.KeygenCertificateReadonly080
import Source3.KeygenCertificateReachable080
import Source3.KeygenCertificateAt080
import Source3.KeygenAcceptedLoop080
import Source3.KeygenAttemptSerialization080
import Source3.KeygenPrecertificate080
import Source3.KeygenAttemptAt080
import Source3.KeygenRetryAt080
import Source3.KeygenLoopAt080
import Source3.KeygenCertificateOccurrence080
import Source3.KeygenLoopMaterial080
import Source3.KeygenEntryAt080
import Source3.KeygenTailCellsAt080
import Source3.KeygenSameCertificate080
import Source3.KeygenMakeAssembly080
import Source3.KeygenCertificateSource080
import Source3.KeygenPinnedInvocation080
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Author inventory of B1.07 source assembly, relocation, common call and lifetime. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCertificateReadonly080,["prefix_stable","source_readonly","call_same_block"]),
    (`FT1536.Source3.KeygenCertificateReachable080,["call_frame","gate_entry","attempt_entry"]),
    (`FT1536.Source3.KeygenCertificateAt080,["workspace","call_frame","entry_frame","space_preserved"]),
    (`FT1536.Source3.KeygenAcceptedLoop080,["facts_after","loop_material"]),
    (`FT1536.Source3.KeygenAttemptSerialization080,["accepted_loop_to_calls"]),
    (`FT1536.Source3.KeygenPrecertificate080,["Entry","source_material"]),
    (`FT1536.Source3.KeygenAttemptAt080,["sampled_material","Exec","accepted_material"]),
    (`FT1536.Source3.KeygenRetryAt080,["gate_call","gate_entry","attempt_remaining","attempt_entry","facts_after"]),
    (`FT1536.Source3.KeygenLoopAt080,["AttemptExecution","AttemptAccepted","AttemptRejected","Aborted","Numbered","LoopTrace","LoopExecution","LoopSucceeded","attemptCap","actual_attempt_cap","BoundFacts","source_bounds","loop_bounds","successful_loop_last_attempt","loop_bounds_success"]),
    (`FT1536.Source3.KeygenLoopAt080.AttemptExecution,["exit"]),
    (`FT1536.Source3.KeygenLoopAt080.LoopExecution,["exit"]),
    (`FT1536.Source3.KeygenCertificateOccurrence080,["CanonicalOccurrence","canonical","Package","from_call"]),
    (`FT1536.Source3.KeygenLoopMaterial080,["material","AttemptCertificate","attempt_certificate","final_certificate"]),
    (`FT1536.Source3.KeygenEntryAt080,["entry_facts","scratch_size"]),
    (`FT1536.Source3.KeygenTailCellsAt080,["attempt_arrays","attempt_comp","attempt_cells","loop_cells"]),
    (`FT1536.Source3.KeygenSameCertificate080,["Joined","material","attempt_joined","loop_joined"]),
    (`FT1536.Source3.KeygenMakeAssembly080,["LegalEntry","Invocation","Frontier","successful_frontier","callId","call_id_bound","automatic_objects_dead","no_dead_material_read"]),
    (`FT1536.Source3.KeygenCertificateSource080,["Call","call_projection","Gate","gate_projection","Attempt","attempt_projection","AttemptExecution","projected","Loop","loop_projection"]),
    (`FT1536.Source3.KeygenPinnedInvocation080,["PinnedExec","projection","successful_frontier"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeProgram.source_bound,
    ``FT1536.Source3.KeygenMakeCertCall.args_shape,
    ``FT1536.Source3.KeygenMakeCertCall.gate_shape,
    ``FT1536.Source3.KeygenMakeMaterialWitness.Witness,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.Cells,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapBlock,
    ``FT1536.Source3.KeygenMakeCertRelocation.ExecAt,
    ``FT1536.Source3.KeygenMakeEntry.Original,
    ``FT1536.Source3.KeygenPublicCallerExecution077.Encoding]
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
