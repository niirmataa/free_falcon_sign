import Source3.KeygenMakeInvocation
import Source3.KeygenMakeLoopChronology
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated061 internal full terms. The virtual-map legality class is
   restricted to the finite live-block set (the 060 all-Nat shape is
   unsatisfiable and made the encoded branch vacuous); the pointer
   uniqueness proofs and their consumers are re-checked here. The
   loop-trace chronology composition of the per-retry transport and the
   TailCells derivation across rejected attempts complete the exports.
   Not a review and not a codec or law claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeInvocation,
      ["Env","blocks_mem_live","inputOf","publicOf","skePtr","skeElem","skeName","assign","byteOff","StoreByte","wordOf","VirtualLegal","no_global_virtual_legal","virtualLegal_identity","virtualLegal_exists","Canonical","WritePointer","ReadPointer","load64_after_store","load64_of_store","canonical_word_eq","read_unique","input_canonical","skeElem_offset","inputOf_mem_live","publicOf_mem_live","skePtr_mem_live","SmallSite","PublicSite","small_site_material","Segments","initCounter","segments_flow","privkeyLenRead","skbufAssign","skHeader","skoffOne","skeBind","privkeyLenWrite","pubkeyLenRead","pkHeader","zeroCapacity","pubkeyLenWrite","retOne","lastStmt","last_cons","tail_source","tail_last","Head","Encoding","segments_tables","segments_arrays","head_flow","head_tables","head_cells","encoding_exit","tail_exit","TailCells","Invocation","invocation_flow","invocation_teardown","invocation_gate","CertPackage","cert_package","invocation_certificate"]),
    (`FT1536.Source3.KeygenMakeInvocation.Env,
      ["live"]),
    (`FT1536.Source3.KeygenMakeLoopChronology,
      ["ready_arrays_object","ready_arrays_other","ready_comp","ready_logn","ready_ter","ready_limit","ready_dimensions","advanced_arrays","advanced_comp","state_close_arrays","result_close_arrays","public_gate_arrays","root_gate_arrays","gates_arrays","sampled_arrays","attempt_arrays","sampled_comp","attempt_comp","skeName_not_rt","attempt_tail_cells","loop_tail_cells","loop_retry_entry","entry_tail_cells","entry_dimensions","entry_remaining","tail_cells_of_loop","loop_tail_entry"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenMakeEntry.input,
    ``FT1536.Source3.KeygenMakeEntry.publicPointer,
    ``FT1536.Source3.KeygenMakeEntry.Original,
    ``FT1536.Source3.KeygenMakeObjects.pointer,
    ``FT1536.Source3.KeygenMakeObjects.name,
    ``FT1536.Source3.KeygenMakeObjects.count,
    ``FT1536.Source3.KeygenMakeObjects.width,
    ``FT1536.Source3.KeygenMakeObjects.enter,
    ``FT1536.Source3.KeygenMakeArguments.Arguments,
    ``FT1536.Source3.KeygenMakeArguments.params,
    ``FT1536.Source3.KeygenMakeArguments.values,
    ``FT1536.Source3.KeygenMakeArguments.Bind,
    ``FT1536.Source3.KeygenMakeArguments.actual_cells,
    ``FT1536.Source3.KeygenMakeArguments.bind_exact,
    ``FT1536.Source3.KeygenMakeLifetime.close,
    ``FT1536.Source3.KeygenMakeLifetime.close_flow,
    ``FT1536.Source3.KeygenMakeLifetime.close_object,
    ``FT1536.Source3.KeygenMakeLifetime.prefix_empty,
    ``FT1536.Source3.KeygenMakeReady.Prefix,
    ``FT1536.Source3.KeygenMakeReady.normal_prefix,
    ``FT1536.Source3.KeygenMakeReady.gate_normal,
    ``FT1536.Source3.KeygenMakePrologue.declared,
    ``FT1536.Source3.KeygenMakePrologue.counted,
    ``FT1536.Source3.KeygenMakePrologue.sized,
    ``FT1536.Source3.KeygenMakePrologue.logged,
    ``FT1536.Source3.KeygenMakePrologue.ternary,
    ``FT1536.Source3.KeygenMakePrologue.ready,
    ``FT1536.Source3.KeygenMakePrologue.middle,
    ``FT1536.Source3.KeygenMakePrologue.tailDeclared,
    ``FT1536.Source3.KeygenMakePrologue.a0,
    ``FT1536.Source3.KeygenMakePrologue.a1,
    ``FT1536.Source3.KeygenMakePrologue.a2,
    ``FT1536.Source3.KeygenMakePrologue.a3,
    ``FT1536.Source3.KeygenMakePrologue.a4,
    ``FT1536.Source3.KeygenMakePrologue.a5,
    ``FT1536.Source3.KeygenMakePrologue.a6,
    ``FT1536.Source3.KeygenMakePrologue.count_result,
    ``FT1536.Source3.KeygenMakePrologue.dimensions_result,
    ``FT1536.Source3.KeygenMakePrologue.initial,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Remaining,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Gates,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Sampled,
    ``FT1536.Source3.KeygenMakeSearchPrefix.close,
    ``FT1536.Source3.KeygenMakeSearchPrefix.updated,
    ``FT1536.Source3.KeygenMakeSearchPrefix.gates_locals,
    ``FT1536.Source3.KeygenMakeSampling.cap_before_setup,
    ``FT1536.Source3.KeygenMakeSampling.prepared_slot,
    ``FT1536.Source3.KeygenMakeSearchPrefix.prepared_local,
    ``FT1536.Source3.KeygenCapWords.advanced,
    ``FT1536.Source3.KeygenCapExecution.abortFlow,
    ``FT1536.Source3.KeygenCallerInit.rtNames,
    ``FT1536.Source3.KeygenCallerPrefix.close,
    ``FT1536.Source3.KeygenCallerPrefix.ternary_slots,
    ``FT1536.Source3.KeygenAttemptMaterial.PublicGate,
    ``FT1536.Source3.KeygenCallerSuccess.RootGate,
    ``FT1536.Source3.KeygenRootSource.Call,
    ``FT1536.Source3.KeygenRootSource.slots,
    ``FT1536.Source3.KeygenRngReference.call_slots,
    ``FT1536.Source3.KeygenMakeCertMaterial.LegalWorkspace,
    ``FT1536.Source3.KeygenMakeCertCall.CertBind,
    ``FT1536.Source3.KeygenMakeCertCall.Profile,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeCertCall.CertificateGate,
    ``FT1536.Source3.KeygenMakeCertCall.gate_cells,
    ``FT1536.Source3.KeygenMakeCertCall.profile_of_dimensions,
    ``FT1536.Source3.KeygenMakeCertCall.accepted_break_requires_call,
    ``FT1536.Source3.KeygenMakeCertChronology.AttemptExec,
    ``FT1536.Source3.KeygenMakeCertChronology.AttemptExecution,
    ``FT1536.Source3.KeygenMakeCertChronology.LoopTrace,
    ``FT1536.Source3.KeygenMakeCertChronology.AttemptAccepted,
    ``FT1536.Source3.KeygenMakeCertChronology.attempt_remaining,
    ``FT1536.Source3.KeygenMakeCertChronology.successful_loop_last_attempt,
    ``FT1536.Source3.KeygenMakeRetryTransport.EntryFrame,
    ``FT1536.Source3.KeygenMakeRetryTransport.CertEntryFrame,
    ``FT1536.Source3.KeygenMakeRetryTransport.entry_frame_trans,
    ``FT1536.Source3.KeygenMakeRetryTransport.attempt_entry,
    ``FT1536.Source3.KeygenMakeRetryTransport.initial_of_attempt,
    ``FT1536.Source3.KeygenMakeRetryTransport.frame_of_attempt,
    ``FT1536.Source3.KeygenMakeStatementMachine.cert_package_of_call,
    ``FT1536.Source3.KeygenMakeProgram.encoding,
    ``FT1536.Source3.KeygenMakeProgram.varExpr,
    ``FT1536.Source3.KeygenMakeProgram.number,
    ``FT1536.Source3.KeygenMakeProgram.capacityReturn,
    ``FT1536.Source3.KeygenMakeProgram.secretLoop,
    ``FT1536.Source3.KeygenMakeProgram.publicDispatch,
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
    ``FT1536.Source3.C99ArrayReference.bindValue,
    ``FT1536.Source3.C99ArrayReference.restoreScope,
    ``FT1536.Source3.C99IntegerReference.Value,
    ``FT1536.Source3.C99IntegerReference.Ty,
    ``FT1536.Source3.C99ScalarReference.set,
    ``FT1536.Source3.C99ProcedureReference.Result,
    ``FT1536.Source3.C99ProcedureReference.Flow,
    ``FT1536.Source3.C99CountedWords.Limit,
    ``FT1536.Source3.C99CountedWords.convert_self,
    ``FT1536.Source3.C99DeclarationStatements.effect,
    ``FT1536.Source3.C99DeclarationCells.declareCells]
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
