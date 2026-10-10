import Source3.KeygenMakeCertCall
import Source3.KeygenMakeCertChronology
import Source3.KeygenMakeCertMaterial
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated051 internal full terms. Certificate types are consumed at their pinned
   interface; the workspace bridge is an explicit open field. Not a review. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeCertCall,
      ["tail_source","gate_position","break_position","gate_shape","profile_shape","args_shape","fprCast","fprCast_offset","CertBind","Profile","bind_profile","bind_callee_profile","profile_of_dimensions","Call","call_cells","call_bit","CertificateGate","gate_cells","gate_flow","accepted_break_requires_call","retry_requires_call","gate_no_normal"]),
    (`FT1536.Source3.KeygenMakeCertChronology,
      ["count_cells","dimensions_cells","AttemptExec","AttemptExecution","AttemptAccepted","AttemptRejected","attempt_exit_split","attempt_no_normal","attempt_remaining","Aborted","Numbered","LoopTrace","LoopExecution","LoopSucceeded","attemptCap","actual_attempt_cap","BoundFacts","source_bounds","loop_bounds","successful_loop_last_attempt","loop_bounds_success"]),
    (`FT1536.Source3.KeygenMakeCertChronology.AttemptExecution,
      ["exit"]),
    (`FT1536.Source3.KeygenMakeCertChronology.LoopExecution,
      ["exit"]),
    (`FT1536.Source3.KeygenMakeCertMaterial,
      ["LegalWorkspace","workspace_scratch_block","accepted_certificate","load16_same","represents_same","cell_same","public_represents_same","leave_shape","leave_bytes"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeCertCall.CertBind,
    ``FT1536.Source3.KeygenMakeCertCall.CertificateGate,
    ``FT1536.Source3.KeygenMakeCertCall.Profile,
    ``FT1536.Source3.KeygenMakeCertCall.CertBind.workspace,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Sampled,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
    ``FT1536.Source3.KeygenMakeSearchPrefix.sampled_remaining,
    ``FT1536.Source3.KeygenMakeSearchPrefix.exhaustion,
    ``FT1536.Source3.KeygenMakeSearchPrefix.gates_locals,
    ``FT1536.Source3.KeygenMakeSearchPrefix.gates_flow,
    ``FT1536.Source3.KeygenMakeSampling.CappedSetup,
    ``FT1536.Source3.KeygenMakeSearchTrace.Numbered,
    ``FT1536.Source3.KeygenMakeLocalFrame.fixed,
    ``FT1536.Source3.KeygenCapWords.Count,
    ``FT1536.Source3.KeygenCapExecution.abortFlow,
    ``FT1536.Source3.KeygenAttemptCap.limit,
    ``FT1536.Source3.CertificateFunctionReference.Arguments,
    ``FT1536.Source3.CertificateFunctionReference.Profile,
    ``FT1536.Source3.CertificateFunctionReference.Exec,
    ``FT1536.Source3.CertificateFunctionReference.initial,
    ``FT1536.Source3.CertificateFunctionReference.resolveLayout,
    ``FT1536.Source3.CertificateFunctionFrame.source_frame,
    ``FT1536.Source3.CertificateFunctionOutcome.accepted,
    ``FT1536.Source3.CertificateFunctionOutcome.CallerFrame,
    ``FT1536.Source3.CertificateFunctionOutcome.StoredBounds,
    ``FT1536.Source3.CertificateM0Environment.Exec,
    ``FT1536.Source3.CertificateM0Environment.Pinned,
    ``FT1536.Source3.CertificateM0Environment.stored_words,
    ``FT1536.Source3.CertificateFrameEntry.Legal,
    ``FT1536.Source3.CertificateFunctionSyntax.Bound,
    ``FT1536.Source3.CertificateRegionFrame.Outside,
    ``FT1536.Source3.CertificateAfterConversion.workspacePointer,
    ``FT1536.Source3.KeygenMaterial.Represents,
    ``FT1536.Source3.KeygenPublicNormalizePolynomial.Represents,
    ``FT1536.Source3.KeygenPublicInputCells.Cell,
    ``FT1536.Source3.KeygenSamplerFrame.represents,
    ``FT1536.Source3.ShakeExtractFrame.SameBlock,
    ``FT1536.Source3.KeygenMakeSearchMaterial.source_ntru,
    ``FT1536.Source3.KeygenMakePublicCall.Material]
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
