import Source3.KeygenMakeSkeChain
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated063 full terms for the concrete nine-statement ske chain.
   Internal audit only; no codec frame or law claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeSkeChain,
      ["chain","chain_source","skeName_ne_skbuf","mat_at_head","bindSke_step","encoding_cons_normal","prefix_ske_chain","initCounter_words","chain_words_at_loop","segments_first_site","first_site_history","first_site_liveness"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeSkeCells.SkeCellWord,
    ``FT1536.Source3.KeygenMakeSkeCells.ske_word_of_bind,
    ``FT1536.Source3.KeygenMakeSkeCells.ske_word_of_store_frame,
    ``FT1536.Source3.KeygenMakeSkeCells.small_site_src_live,
    ``FT1536.Source3.KeygenMakeSkeCells.small_site_material_extended,
    ``FT1536.Source3.KeygenMakeInvocation.Head,
    ``FT1536.Source3.KeygenMakeInvocation.Encoding,
    ``FT1536.Source3.KeygenMakeInvocation.Segments,
    ``FT1536.Source3.KeygenMakeInvocation.head_cells,
    ``FT1536.Source3.KeygenMakeProgram.encoding,
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Remaining,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Sampled,
    ``FT1536.Source3.KeygenMakeSearchPrefix.sampled_remaining,
    ``FT1536.Source3.KeygenMakeCertChronology.AttemptExec,
    ``FT1536.Source3.KeygenMakeCertChronology.AttemptExecution,
    ``FT1536.Source3.KeygenMakeCertChronology.LoopTrace,
    ``FT1536.Source3.KeygenMakeCertChronology.attempt_remaining,
    ``FT1536.Source3.KeygenMakeCertCall.CertBind,
    ``FT1536.Source3.KeygenMakeCertCall.Profile,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeCertCall.CertificateGate,
    ``FT1536.Source3.KeygenMakeCertCall.profile_of_dimensions,
    ``FT1536.Source3.KeygenMakeCertCall.accepted_break_requires_call,
    ``FT1536.Source3.KeygenMakeRetryTransport.EntryFrame,
    ``FT1536.Source3.KeygenMakeRetryTransport.CertEntryFrame,
    ``FT1536.Source3.KeygenMakeRetryTransport.sampled_entry,
    ``FT1536.Source3.KeygenMakeRetryTransport.initial_of_attempt,
    ``FT1536.Source3.KeygenMakeRetryTransport.frame_of_attempt,
    ``FT1536.Source3.KeygenCallerEntry.Initial,
    ``FT1536.Source3.KeygenMakeAttemptSpine.entry_of_allocation,
    ``FT1536.Source3.KeygenMakeEntry.Original,
    ``FT1536.Source3.KeygenMakeEntry.input,
    ``FT1536.Source3.KeygenMakeEntry.publicPointer,
    ``FT1536.Source3.KeygenMakeReady.Prefix,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.Shape,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.legalWorkspace_of_shape,
    ``FT1536.Source3.KeygenMkgm3Layout.Legal,
    ``FT1536.Source3.KeygenMakeCertMaterial.LegalWorkspace,
    ``FT1536.Source3.KeygenMakeCertMaterial.workspace_scratch_block,
    ``FT1536.Source3.C99Automatic32.Space,
    ``FT1536.Source3.C99Automatic32.align4,
    ``FT1536.Source3.KeygenMakeInvocation.Env,
    ``FT1536.Source3.KeygenMakeInvocation.CertPackage,
    ``FT1536.Source3.KeygenMakeInvocation.cert_package,
    ``FT1536.Source3.KeygenMakeInvocation.Invocation,
    ``FT1536.Source3.KeygenMakeInvocation.SmallSite,
    ``FT1536.Source3.KeygenMakeInvocation.VirtualLegal,
    ``FT1536.Source3.KeygenMakeInvocation.Canonical,
    ``FT1536.Source3.KeygenMakeInvocation.skeElem,
    ``FT1536.Source3.KeygenMakeInvocation.skeName,
    ``FT1536.Source3.KeygenMakeInvocation.inputOf,
    ``FT1536.Source3.KeygenMakeInvocation.wordOf,
    ``FT1536.Source3.KeygenMakeInvocation.WritePointer,
    ``FT1536.Source3.KeygenMakeInvocation.ReadPointer,
    ``FT1536.Source3.KeygenMakeInvocation.load64_of_store,
    ``FT1536.Source3.KeygenMakeInvocation.canonical_word_eq,
    ``FT1536.Source3.KeygenMakeInvocation.input_canonical,
    ``FT1536.Source3.KeygenMakeInvocation.inputOf_mem_live,
    ``FT1536.Source3.KeygenMakeInvocation.virtualLegal_exists,
    ``FT1536.Source3.KeygenMakeLifetime.close_flow,
    ``FT1536.Source3.KeygenCapExecution.abortFlow,
    ``FT1536.Source3.KeygenEntropySource.Event,
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.C99MemoryReference.Allocated,
    ``FT1536.Source3.C99MemoryReference.Load64,
    ``FT1536.Source3.C99MemoryReference.Store64,
    ``FT1536.Source3.C99MemoryReference.load64_deterministic,
    ``FT1536.Source3.C99ArrayReference.State,
    ``FT1536.Source3.C99ArrayReference.Name,
    ``FT1536.Source3.C99IntegerReference.Value,
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
