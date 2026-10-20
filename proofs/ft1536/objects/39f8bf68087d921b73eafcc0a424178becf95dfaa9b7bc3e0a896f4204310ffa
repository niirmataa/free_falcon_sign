import Source3.KeygenMakeCertRelocation
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated054 internal full terms. The certificate execution is
   transported across the block relocation (the sigma conjugate of the
   pinned block0 machine), and every accepted-package conclusion is read
   in actual-world scratch-block bytes. Not a review. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeCertRelocation,
      ["map_swapPtr","map_swapPtr_zero","map_swapPtr_cancel","swapBlock_zero_id","state_ext","context_ext","args_ext","swapState_swapState","swapState_zero","relocateCtx_relocateCtx","swapArgs_swapArgs","swapArgs_zero","swapState_heap","swapResult","swapResult_flow","swapResult_zero","swapPtr_table","swapPtr_withIndex","pinned_swap_forward","pinned_swap","workspaceAt","workspaceAt_swap","workspaceAt_block","workspaceAt_offset","CertBindAt","cells_swap","workspaceAt_iff","certBindAt_iff","ExecAt","execAt_zero","execAt_swap","CallAt","callAt_run","callAt_bit","callAt_cells","profile_swapState","CertificateGateAt","gateAt_rejected","gateAt_accepted","gateAt_unprofiled","gateAt_flow","gateAt_no_normal","accepted_break_requires_callAt","retry_requires_callAt","pointerAt","align4_swap","pointerAt_swap","SpaceAt","spaceAt_iff","LegalAt","legalAt_iff","layoutAt","layoutAt_swap","StoredBoundsAt","storedBoundsAt_iff","wordRead_at_load64","CallerFrameAt","callerFrameAt_iff","swapBlock_table_free","foreign_block_retained_at","workspace_block_retained_at","DeadAt","deadAt_iff","AcceptedPackageAt","dimensions_swapState","accepted_package_at"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.swapState,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.relocateCtx,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.swapArgs,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.Cells,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.cells_relocated,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.cert_bind_relocated,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.Binding,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.AcceptedPackage,
    ``FT1536.Source3.KeygenMakeWorkspaceAllocation.accepted_certificate_relocated_of_allocation,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapBlock,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap_swap,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_swapPtr,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_zero,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap_zero,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapBlock_self,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapBlock_self_zero,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapBlock_zero,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapBlock_fixed,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap_size,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap_writable,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap_bytes,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.load64_swap,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.load32_swap,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.fprCast_swap,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.workspacePointer_swap,
    ``FT1536.Source3.KeygenMakeCertCall.CertBind,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeCertCall.CertificateGate,
    ``FT1536.Source3.KeygenMakeCertCall.Profile,
    ``FT1536.Source3.KeygenMakeCertCall.fprCast,
    ``FT1536.Source3.KeygenMakeCertCall.call_cells,
    ``FT1536.Source3.KeygenMakeCertCall.call_bit,
    ``FT1536.Source3.KeygenMakeCertCall.gate_flow,
    ``FT1536.Source3.KeygenMakeCertCall.gate_no_normal,
    ``FT1536.Source3.KeygenMakeCertCall.accepted_break_requires_call,
    ``FT1536.Source3.KeygenMakeCertCall.retry_requires_call,
    ``FT1536.Source3.CertificateM0Environment.Exec,
    ``FT1536.Source3.CertificateM0Environment.Pinned,
    ``FT1536.Source3.CertificateFunctionReference.Arguments,
    ``FT1536.Source3.CertificateFunctionReference.initial,
    ``FT1536.Source3.CertificateFunctionOutcome.StoredBounds,
    ``FT1536.Source3.CertificateFunctionOutcome.CallerFrame,
    ``FT1536.Source3.CertificateFunctionWitness.layout,
    ``FT1536.Source3.CertificateWorkspace.layout,
    ``FT1536.Source3.CertificateWorkspace.slot,
    ``FT1536.Source3.CertificateWorkspace.bytes,
    ``FT1536.Source3.CertificateFrameEntry.Legal,
    ``FT1536.Source3.CertificateRegionFrame.Outside,
    ``FT1536.Source3.CertificateFunctionSyntax.Bound,
    ``FT1536.Source3.CertificateEffects.Event,
    ``FT1536.Source3.CertificateEffects.Good,
    ``FT1536.Source3.CertificateMemory.Layout,
    ``FT1536.Source3.CertificateMemory.leaves,
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer.offset,
    ``FT1536.Source3.C99MemoryReference.Allocated,
    ``FT1536.Source3.C99MemoryReference.Load64,
    ``FT1536.Source3.C99MemoryReference.Load32,
    ``FT1536.Source3.C99MemoryReference.Store64,
    ``FT1536.Source3.C99MemoryBridge.encode,
    ``FT1536.Source3.C99MemoryBridge.load64_source_to_interpreter,
    ``FT1536.Source3.C99Automatic32.align4,
    ``FT1536.Source3.C99Automatic32.address,
    ``FT1536.Source3.C99Automatic32.pointer,
    ``FT1536.Source3.C99Automatic32.Space,
    ``FT1536.Source3.C99PointerFootprint.TablesOutside,
    ``FT1536.Source3.C99ArrayReference.State,
    ``FT1536.Source3.StableBinaryByteView.wordRead,
    ``FT1536.Source3.StableBinary.addr,
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenSearchContext.ReadTmp,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
    ``FT1536.Source3.KeygenMakeCertChronology.dimensions_cells,
    ``FT1536.Source3.KeygenMakeWorkspaceTables.tablesOutside_nonTable,
    ``FT1536.Source3.KeygenMakeWorkspaceTables.tablesOutside_zero,
    ``FT1536.Source3.FftGlobalMemory.environment,
    ``FT1536.Source3.FftGlobalMemory.pointer,
    ``FT1536.Source3.FftGlobalMemory.block,
    ``FT1536.Source3.FftGlobalMemory.tables,
    ``FT1536.Source3.FftTableSources.words,
    ``FT1536.Source3.FftTableParser.Table]
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
