import Source3.KeygenMakeInvocation
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated060 internal full terms. The whole-invocation statement-machine
   execution runs the 18 encoding-tail statements to the actual encoder call
   sites with their evaluated argument cells, exposes the four output-capacity
   return-0 edges and closes every return edge with the complete teardown;
   the certificate package is tied to the same invocation through the accepted
   gate call. Not a review and not a codec or law claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeInvocation,
      ["Env","inputOf","publicOf","skePtr","skeElem","skeName","assign","byteOff","StoreByte","wordOf","VirtualLegal","Canonical","WritePointer","ReadPointer","load64_after_store","load64_of_store","canonical_word_eq","read_unique","input_canonical","skeElem_offset","SmallSite","PublicSite","small_site_material","Segments","initCounter","segments_flow","privkeyLenRead","skbufAssign","skHeader","skoffOne","skeBind","privkeyLenWrite","pubkeyLenRead","pkHeader","zeroCapacity","pubkeyLenWrite","retOne","lastStmt","last_cons","tail_source","tail_last","Head","Encoding","segments_tables","segments_arrays","head_flow","head_tables","head_cells","encoding_exit","tail_exit","TailCells","Invocation","invocation_flow","invocation_teardown","invocation_gate","CertPackage","cert_package","invocation_certificate"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenMakeEntry.input,
    ``FT1536.Source3.KeygenMakeEntry.publicPointer,
    ``FT1536.Source3.KeygenMakeObjects.pointer,
    ``FT1536.Source3.KeygenMakeObjects.name,
    ``FT1536.Source3.KeygenMakeObjects.count,
    ``FT1536.Source3.KeygenMakeObjects.width,
    ``FT1536.Source3.KeygenMakeArguments.Arguments,
    ``FT1536.Source3.KeygenMakeArguments.params,
    ``FT1536.Source3.KeygenMakeArguments.values,
    ``FT1536.Source3.KeygenMakeArguments.Bind,
    ``FT1536.Source3.KeygenMakeLifetime.close,
    ``FT1536.Source3.KeygenMakeLifetime.close_flow,
    ``FT1536.Source3.KeygenMakeLifetime.close_object,
    ``FT1536.Source3.KeygenMakeLifetime.prefix_empty,
    ``FT1536.Source3.KeygenMakeReady.Prefix,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
    ``FT1536.Source3.KeygenMakeCertMaterial.LegalWorkspace,
    ``FT1536.Source3.KeygenMakeCertCall.CertBind,
    ``FT1536.Source3.KeygenMakeCertCall.Profile,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeCertCall.CertificateGate,
    ``FT1536.Source3.KeygenMakeCertCall.profile_of_dimensions,
    ``FT1536.Source3.KeygenMakeCertCall.accepted_break_requires_call,
    ``FT1536.Source3.KeygenMakeCertChronology.AttemptExec,
    ``FT1536.Source3.KeygenMakeCertChronology.AttemptExecution,
    ``FT1536.Source3.KeygenMakeCertChronology.LoopTrace,
    ``FT1536.Source3.KeygenMakeCertChronology.AttemptAccepted,
    ``FT1536.Source3.KeygenMakeCertChronology.successful_loop_last_attempt,
    ``FT1536.Source3.KeygenMakeStatementMachine.cert_package_of_call,
    ``FT1536.Source3.KeygenMakeProgram.encoding,
    ``FT1536.Source3.KeygenMakeProgram.varExpr,
    ``FT1536.Source3.KeygenMakeProgram.number,
    ``FT1536.Source3.KeygenMakeProgram.capacityReturn,
    ``FT1536.Source3.KeygenMakeProgram.secretLoop,
    ``FT1536.Source3.KeygenMakeProgram.publicDispatch,
    ``FT1536.Source3.KeygenCapExecution.abortFlow,
    ``FT1536.Source3.KeygenEntropySource.Event,
    ``FT1536.Source3.CertificateFunctionReference.Arguments,
    ``FT1536.Source3.CertificateFunctionSyntax.Bound,
    ``FT1536.Source3.CertificateFunctionOutcome.StoredBounds,
    ``FT1536.Source3.CertificateFunctionWitness.Witness,
    ``FT1536.Source3.CertificateFunctionWitness.layout,
    ``FT1536.Source3.CertificateReverse.Snapshot,
    ``FT1536.Source3.CertificateEffects.Event,
    ``FT1536.Source3.CertificateEffects.Good,
    ``FT1536.Source3.CertificateEffects.State,
    ``FT1536.Source3.C99Automatic32.pointer,
    ``FT1536.Source3.C99MemoryBridge.encode,
    ``FT1536.Source3.StableBinaryByteView.flagRead,
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.C99MemoryReference.Allocated,
    ``FT1536.Source3.C99MemoryReference.Load64,
    ``FT1536.Source3.C99MemoryReference.Load32,
    ``FT1536.Source3.C99MemoryReference.Store64,
    ``FT1536.Source3.C99ArrayReference.State,
    ``FT1536.Source3.C99ArrayReference.Name,
    ``FT1536.Source3.C99ArrayReference.bindPointer,
    ``FT1536.Source3.C99IntegerReference.Value,
    ``FT1536.Source3.C99IntegerReference.Ty,
    ``FT1536.Source3.C99ScalarReference.set,
    ``FT1536.Source3.C99ProcedureReference.Result,
    ``FT1536.Source3.C99ProcedureReference.Flow]
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
