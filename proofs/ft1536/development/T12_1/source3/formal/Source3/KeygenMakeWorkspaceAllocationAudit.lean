import Source3.KeygenMakeWorkspaceAllocation
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated053 internal full terms. The workspace Shape and the scratch
   legality frame are DERIVED from the allocation execution (temp_size store
   + fk->tmp malloc binding); certificate interfaces are consumed at their
   pinned types. Not a review. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeWorkspaceAllocation,
      ["creation_source","fk_object_allocation","profile_stores","scratch_binding","alignment_source","tempSizeBytes","tempSize_exact","tempSize_workspace","tempSize_bound","scratchCount","scratchOf","scratchCount_value","scratchCount_temp","scratch_fit","scratch_count","scratch_offset","scratch_aligned","scratch_extent","Binding","binding_shape","binding_legal","binding_tmp_load","readTmp_of_binding","shape_relocated","legal_relocated","AcceptedPackage","cert_bind_of_allocation","cert_bind_relocated_of_allocation","legalWorkspace_of_allocation","accepted_certificate_of_allocation","accepted_certificate_relocated_of_allocation"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.Shape,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.Cells,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.cert_bind_of_source,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.cert_bind_relocated,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.relocateCtx,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.swapState,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.swapArgs,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.legalWorkspace_of_shape,
    ``FT1536.Source3.KeygenMakeWorkspaceBridge.accepted_certificate_source,
    ``FT1536.Source3.KeygenMakeWorkspaceExtent.candidates,
    ``FT1536.Source3.KeygenMakeWorkspaceExtent.candidates_fold_max,
    ``FT1536.Source3.KeygenMakeWorkspaceExtent.cert_candidate_value,
    ``FT1536.Source3.KeygenMakeWorkspaceExtent.reservation_matches_workspace,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.extent,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.extent_swapPtr,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap_size,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swap_writable,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_block,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_base,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_count,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_elementBytes,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_index,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapPtr_offset,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.swapBlock_self,
    ``FT1536.Source3.KeygenMakeWorkspaceRelocation.relocated_scratch_block,
    ``FT1536.Source3.KeygenMakeCertCall.CertBind,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeCertCall.fprCast,
    ``FT1536.Source3.KeygenMkgm3Layout.Legal,
    ``FT1536.Source3.KeygenMkgm3Layout.scratchWords,
    ``FT1536.Source3.CertificateWorkspace.bytes,
    ``FT1536.Source3.CertificateWorkspace.workspace_size,
    ``FT1536.Source3.KeygenRngSource.Fresh,
    ``FT1536.Source3.KeygenMakeObjects.allocated,
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer.offset,
    ``FT1536.Source3.C99MemoryReference.Allocated,
    ``FT1536.Source3.C99MemoryReference.Load64,
    ``FT1536.Source3.C99MemoryReference.Store64,
    ``FT1536.Source3.C99MemoryReference.le64,
    ``FT1536.Source3.C99MemoryReference.byte64,
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenSearchContext.field,
    ``FT1536.Source3.KeygenSearchContext.pointerWord,
    ``FT1536.Source3.KeygenSearchContext.Bound,
    ``FT1536.Source3.KeygenSearchContext.ObjectLegal,
    ``FT1536.Source3.KeygenSearchContext.PointerLegal,
    ``FT1536.Source3.KeygenSearchContext.ReadTmp,
    ``FT1536.Source3.CertificateFunctionReference.Arguments,
    ``FT1536.Source3.CertificateM0Environment.Exec,
    ``FT1536.Source3.CertificateFunctionOutcome.StoredBounds,
    ``FT1536.Source3.CertificateFunctionOutcome.CallerFrame,
    ``FT1536.Source3.CertificateFunctionSyntax.Bound,
    ``FT1536.Source3.CertificateEffects.Event,
    ``FT1536.Source3.CertificateEffects.Good,
    ``FT1536.Source3.FftGlobalMemory.environment,
    ``FT1536.Source3.KeygenMakeCertMaterial.LegalWorkspace,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
    ``FT1536.Source3.C99Automatic32.Space,
    ``FT1536.Source3.C99Automatic32.pointer,
    ``FT1536.Source3.Pinned.keygenLines]
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
