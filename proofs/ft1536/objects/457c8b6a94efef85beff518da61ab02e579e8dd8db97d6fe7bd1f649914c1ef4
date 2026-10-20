import Source3.KeygenMakeStatementMachine
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated059 internal full terms. The statement-machine extraction ties
   the C call site `(fpr *)fk->tmp` to `ExecAt` through the `temp_size` body
   and the `falcon_keygen_new` prologue binding, discharges the b-not-1/2
   side condition from allocation freshness and closes `call_same_block` with
   the EntryFacts/CertEntryFrame residual discharges. Not a review and not a
   codec or law claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeStatementMachine,
      ["allocated_of_load64","pinned_block_live","pinned_one_live","pinned_two_live","binding_scratch_free","objects_table_free","allocated_same","scratch_extent_exact","scratch_extent_workspace","fprCast_scratch_span","call_site_bridge","certBindAt_of_allocation","callAt_of_allocation","call_same_block","cert_entry_frame","scratch_block_of_call","legal_of_pointer","input_of_pointer","entry_facts_of_allocation","cert_package_of_call"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenSearchContext.field,
    ``FT1536.Source3.KeygenSearchContext.pointerWord,
    ``FT1536.Source3.KeygenSearchContext.M0,
    ``FT1536.Source3.KeygenSearchContext.ReadTmp,
    ``FT1536.Source3.KeygenSearchContext.ObjectLegal,
    ``FT1536.Source3.KeygenCallerEntry.Initial,
    ``FT1536.Source3.KeygenMakeEntry.Original,
    ``FT1536.Source3.KeygenMakeEntry.input,
    ``FT1536.Source3.KeygenMakeEntry.publicPointer,
    ``FT1536.Source3.KeygenMakeEntry.input_width,
    ``FT1536.Source3.KeygenMakeEntry.object_live,
    ``FT1536.Source3.KeygenMakeEntry.scratch_live,
    ``FT1536.Source3.KeygenMakeObjects.pointer,
    ``FT1536.Source3.KeygenMakeObjects.count,
    ``FT1536.Source3.KeygenMakeObjects.width,
    ``FT1536.Source3.KeygenMakeObjects.extent,
    ``FT1536.Source3.KeygenMakeObjects.Block,
    ``FT1536.Source3.KeygenMakeObjects.Exec,
    ``FT1536.Source3.KeygenMakeObjects.object,
    ``FT1536.Source3.KeygenMakeObjects.allocated_object,
    ``FT1536.Source3.KeygenMakeObjects.fresh_separate,
    ``FT1536.Source3.KeygenMakeObjects.slots,
    ``FT1536.Source3.KeygenMakeObjects.live_frame,
    ``FT1536.Source3.KeygenRngSource.Fresh,
    ``FT1536.Source3.KeygenRngReference.call_slots,
    ``FT1536.Source3.KeygenMakePrologue.Declarations,
    ``FT1536.Source3.KeygenMakePrologue.declared,
    ``FT1536.Source3.KeygenMakePrologue.counted,
    ``FT1536.Source3.KeygenMakePrologue.sized,
    ``FT1536.Source3.KeygenMakePrologue.ready,
    ``FT1536.Source3.KeygenMakePrologue.projectionStart,
    ``FT1536.Source3.KeygenMakePrologue.allocation_projection,
    ``FT1536.Source3.KeygenMakePrologue.projection_original,
    ``FT1536.Source3.KeygenMakePrologue.initial,
    ``FT1536.Source3.KeygenMakePrologue.count_result,
    ``FT1536.Source3.KeygenMakePrologue.dimensions_result,
    ``FT1536.Source3.KeygenMakeReady.Prefix,
    ``FT1536.Source3.KeygenMakeReady.Gate,
    ``FT1536.Source3.KeygenMakeReady.gate_normal,
    ``FT1536.Source3.KeygenMakeReady.block_frame,
    ``FT1536.Source3.KeygenMakeReady.normal_prefix,
    ``FT1536.Source3.KeygenPublicInputMaterial.Legal,
    ``FT1536.Source3.KeygenPublicFrame.Tables,
    ``FT1536.Source3.KeygenPublicFrame.Outside,
    ``FT1536.Source3.KeygenRootSearch.Protected,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Remaining,
    ``FT1536.Source3.KeygenMakeAttemptSpine.EntryFacts,
    ``FT1536.Source3.KeygenMakeAttemptSpine.entry_of_allocation,
    ``FT1536.Source3.KeygenMakeRetryTransport.EntryFrame,
    ``FT1536.Source3.KeygenMakeRetryTransport.CertEntryFrame,
    ``FT1536.Source3.KeygenMakeRetryTransport.cert_gate_entry,
    ``FT1536.Source3.KeygenMakeRetryTransport.cert_shape,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.Binding,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.scratchOf,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.scratch_count,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.scratch_offset,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.scratch_extent,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.tempSize_exact,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.tempSize_workspace,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.binding_tmp_load,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.readTmp_of_binding,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.cert_bind_relocated_of_allocation,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.extent,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.extent_swapPtr,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.bridge_iff,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.bridge_relocated,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.bridge_of_extent,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapBlock,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_block,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_offset,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap_zero,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap_swap,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.fprCast_swap,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.Cells,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.swapState,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.relocateCtx,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.swapArgs,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.cert_bind_relocated,
    ``FT1536.Source3.KeygenMakeWorkspaceTables.tables_block,
    ``FT1536.Source3.KeygenMakeWorkspaceTables.tablesOutside_nonTable,
    ``FT1536.Source3.KeygenMakeWorkspaceTables.tablesOutside_zero,
    ``FT1536.Source3.KeygenMakeWorkspaceTables.foreign_block_retained,
    ``FT1536.Source3.KeygenMakeWorkspaceExtent.candidates_fold_max,
    ``FT1536.Source3.KeygenMakeWorkspaceExtent.workspace_extent_value,
    ``FT1536.Source3.KeygenMakeWorkspaceExtent.reservation_matches_workspace,
    ``FT1536.Source3.KeygenMakeCertCall.CertBind,
    ``FT1536.Source3.KeygenMakeCertCall.Profile,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeCertCall.CertificateGate,
    ``FT1536.Source3.KeygenMakeCertCall.fprCast,
    ``FT1536.Source3.KeygenMakeCertCall.bind_callee_profile,
    ``FT1536.Source3.KeygenMakeCertCall.call_cells,
    ``FT1536.Source3.KeygenMakeCertCall.accepted_break_requires_call,
    ``FT1536.Source3.KeygenMakeCertCall.retry_requires_call,
    ``FT1536.Source3.KeygenMakeCertCall.args_shape,
    ``FT1536.Source3.KeygenMakeCertMaterial.LegalWorkspace,
    ``FT1536.Source3.KeygenMakeCertMaterial.workspace_scratch_block,
    ``FT1536.Source3.KeygenMakeCertMaterial.leave_shape,
    ``FT1536.Source3.KeygenMakeCertMaterial.leave_bytes,
    ``FT1536.Source3.KeygenMakeCertRelocation.ExecAt,
    ``FT1536.Source3.KeygenMakeCertRelocation.CallAt,
    ``FT1536.Source3.KeygenMakeCertRelocation.CertBindAt,
    ``FT1536.Source3.KeygenMakeCertRelocation.callAt_run,
    ``FT1536.Source3.KeygenMakeCertRelocation.certBindAt_iff,
    ``FT1536.Source3.KeygenMakeCertRelocation.pinned_swap,
    ``FT1536.Source3.KeygenMakeCertRelocation.AcceptedPackageAt,
    ``FT1536.Source3.KeygenMakeCertRelocation.accepted_package_at,
    ``FT1536.Source3.CertificateM0Environment.Pinned,
    ``FT1536.Source3.CertificateM0Environment.Exec,
    ``FT1536.Source3.FftGlobalMemory.block,
    ``FT1536.Source3.FftGlobalMemory.pointer,
    ``FT1536.Source3.FftGlobalMemory.tables,
    ``FT1536.Source3.FftGlobalMemory.environment,
    ``FT1536.Source3.FftTableParser.Table,
    ``FT1536.Source3.FftTableParser.rowCount,
    ``FT1536.Source3.FftTableSources.words,
    ``FT1536.Source3.FftTableSources.words_length,
    ``FT1536.Source3.CertificateFunctionReference.Arguments,
    ``FT1536.Source3.CertificateFunctionReference.Profile,
    ``FT1536.Source3.CertificateFunctionReference.initial,
    ``FT1536.Source3.CertificateFunctionWitness.Witness,
    ``FT1536.Source3.CertificateFunctionWitness.layout,
    ``FT1536.Source3.CertificateFunctionSyntax.Bound,
    ``FT1536.Source3.CertificateFunctionFrame.source_frame,
    ``FT1536.Source3.CertificateFunctionOutcome.StoredBounds,
    ``FT1536.Source3.CertificateFunctionOutcome.CallerFrame,
    ``FT1536.Source3.CertificateFunctionOutcome.accepted,
    ``FT1536.Source3.CertificateFunctionOutcome.reverse_source,
    ``FT1536.Source3.CertificateReverse.Snapshot,
    ``FT1536.Source3.CertificateEffects.Event,
    ``FT1536.Source3.CertificateEffects.Good,
    ``FT1536.Source3.CertificateEffects.State,
    ``FT1536.Source3.CertificateWorkspace.bytes,
    ``FT1536.Source3.CertificateAfterConversion.workspacePointer,
    ``FT1536.Source3.CertificateFrameEntry.Legal,
    ``FT1536.Source3.CertificateRegionFrame.Outside,
    ``FT1536.Source3.C99PointerFootprint.TablesOutside,
    ``FT1536.Source3.C99Automatic32.pointer,
    ``FT1536.Source3.C99MemoryBridge.encode,
    ``FT1536.Source3.StableBinaryByteView.flagRead,
    ``FT1536.Source3.ShakeExtractFrame.SameBlock,
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
    ``FT1536.Source3.C99ProcedureReference.Result,
    ``FT1536.Source3.C99ProcedureReference.Flow,
    ``FT1536.Source3.C99ProcedureReference.Stmt,
    ``FT1536.Source3.KeygenEntropySource.Event,
    ``FT1536.Source3.KeygenResidueTrace.names,
    ``FT1536.Source3.KeygenMaterial.Represents,
    ``FT1536.Source3.KeygenPublicNormalizePolynomial.Represents]
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
