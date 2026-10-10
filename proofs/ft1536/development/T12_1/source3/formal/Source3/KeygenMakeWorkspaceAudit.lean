import Source3.KeygenMakeWorkspaceRelocation
import Source3.KeygenMakeWorkspaceBridge
import Source3.KeygenMakeWorkspaceTables
import Source3.KeygenMakeWorkspaceExtent
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated052 internal full terms. The workspace bridge is DERIVED from source
   facts (relocation + workspace extent); certificate interfaces are consumed at
   their pinned types. Not a review. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeWorkspaceRelocation,
      ["swapBlock","swapBlock_zero","swapBlock_self_zero","swapBlock_fixed","swapBlock_self","swap","swapPtr","arrayPointer_ext","memory_ext","swap_bytes","swap_size","swap_writable","swap_zero","swap_swap","swapPtr_block","swapPtr_offset","swapPtr_base","swapPtr_count","swapPtr_elementBytes","swapPtr_index","swapPtr_fields","swapPtr_zero","swapPtr_swapPtr","allocated_forward","allocated_swap","load64_forward","load64_swap","load32_forward","load32_swap","size_function_swap","writable_function_swap","size_function_swap_back","writable_function_swap_back","store64_forward","store64_swap","store32_forward","store32_swap","memcpy_forward","memcpy_swap","initialized_forward","initialized_block_swap","preserves_forward","preserves_swap","steps_swap_forward","steps_swap","fprCast_swap","workspacePointer_swap","extent","extent_swapPtr","bridge_iff","relocated_scratch_block","bridge_relocated","bridge_of_extent"]),
    (`FT1536.Source3.KeygenMakeWorkspaceBridge,
      ["Shape","Cells","workspace_of_source","cert_bind_of_source","swapState","relocateCtx","swapArgs","field_relocated","pointerWord_relocated","bound_relocated","objectLegal_relocated","pointerLegal_relocated","readTmp_relocated","cells_relocated","cert_bind_relocated","legal_of_shape","legalWorkspace_of_shape","accepted_certificate_source"]),
    (`FT1536.Source3.KeygenMakeWorkspaceTables,
      ["tables_block","initial_tables","tablesOutside_nonTable","tablesOutside_zero","foreign_block_retained","workspace_block_retained"]),
    (`FT1536.Source3.KeygenMakeWorkspaceExtent,
      ["cert_reservation_source","gmax_init","fg_loop_source","fg_depth0_source","fg_depth0_candidate","fg_else_candidate_a","fg_else_candidate_b","depth_loop_source","depth_top_source","depth_top_candidate","depth_zero_source","depth_zero_candidates","binary_branch_source","final_else_dimension","final_else_tables","final_else_candidate1","final_else_candidate2","final_else_candidate3","final_else_candidate4","gmax_fold","gmax_return","tmp_len_source","tmp_malloc_source","small3","large3","alignFP","alignUW","degree","half","certCandidate","fgDepth0Candidate","fgCandidateA","fgCandidateB","depthTopCandidate","depth0Candidate1","depth0Candidate2","depth0Candidate3","depthCandidate1","depthCandidate2","depthCandidate3","depthCandidate4","candidates","candidates_length","certificate_candidate_member","candidates_bound","candidates_fold_max","cert_candidate_value","cert_candidate_workspace","workspace_extent_value","reservation_matches_workspace"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeCertCall.CertBind,
    ``FT1536.Source3.KeygenMakeCertCall.fprCast,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.CertificateAfterConversion.workspacePointer,
    ``FT1536.Source3.CertificateFrameEntry.Legal,
    ``FT1536.Source3.CertificateFrameEntry.allocated_workspace,
    ``FT1536.Source3.CertificateWorkspace.bytes,
    ``FT1536.Source3.CertificateWorkspace.workspace_size,
    ``FT1536.Source3.CertificateWorkspace.Legal,
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer.offset,
    ``FT1536.Source3.C99MemoryReference.Allocated,
    ``FT1536.Source3.C99MemoryReference.Load64,
    ``FT1536.Source3.C99MemoryReference.Load32,
    ``FT1536.Source3.C99MemoryReference.Store64,
    ``FT1536.Source3.C99MemoryReference.Store32,
    ``FT1536.Source3.C99MemoryReference.Memcpy,
    ``FT1536.Source3.C99InitializationTrace.Initialized,
    ``FT1536.Source3.C99InitializationTrace.Preserves,
    ``FT1536.Source3.C99InitializationTrace.Steps,
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenSearchContext.field,
    ``FT1536.Source3.KeygenSearchContext.pointerWord,
    ``FT1536.Source3.KeygenSearchContext.Bound,
    ``FT1536.Source3.KeygenSearchContext.ObjectLegal,
    ``FT1536.Source3.KeygenSearchContext.PointerLegal,
    ``FT1536.Source3.KeygenSearchContext.ReadTmp,
    ``FT1536.Source3.KeygenSearchContext.M0,
    ``FT1536.Source3.CertificateFunctionReference.Arguments,
    ``FT1536.Source3.CertificateFunctionReference.Profile,
    ``FT1536.Source3.CertificateFunctionReference.Exec,
    ``FT1536.Source3.CertificateFunctionReference.initial,
    ``FT1536.Source3.CertificateFunctionReference.resolveLayout,
    ``FT1536.Source3.CertificateM0Environment.Exec,
    ``FT1536.Source3.CertificateM0Environment.Pinned,
    ``FT1536.Source3.CertificateFunctionOutcome.accepted,
    ``FT1536.Source3.CertificateFunctionOutcome.StoredBounds,
    ``FT1536.Source3.CertificateFunctionOutcome.CallerFrame,
    ``FT1536.Source3.CertificateFunctionSyntax.Bound,
    ``FT1536.Source3.CertificateRegionFrame.Outside,
    ``FT1536.Source3.CertificateEffects.Good,
    ``FT1536.Source3.C99PointerFootprint.TablesOutside,
    ``FT1536.Source3.C99PointerFootprint.PointOutside,
    ``FT1536.Source3.FftGlobalMemory.tables,
    ``FT1536.Source3.FftGlobalMemory.environment,
    ``FT1536.Source3.FftGlobalMemory.pointer,
    ``FT1536.Source3.FftGlobalMemory.block,
    ``FT1536.Source3.KeygenMkgm3Layout.Legal,
    ``FT1536.Source3.C99Automatic32.Space,
    ``FT1536.Source3.KeygenMakeCertMaterial.accepted_certificate,
    ``FT1536.Source3.KeygenMakeCertMaterial.LegalWorkspace,
    ``FT1536.Source3.KeygenMakeCertMaterial.workspace_scratch_block,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
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
