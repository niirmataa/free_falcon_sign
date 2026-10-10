import Source3.KeygenMakeMaterialWitness
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated055 internal full terms. The solver call keeps the h frame
   and ONE material carries both equations on the same physical f/g/F/G/h,
   preserved by the accepted certificate call to the encoding-tail input
   boundary. Not a review and not a codec or law claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeMaterialWitness,
      ["Witness","EncodingInputs","element_block","output_block","small_writes_bytes","residue_writes_bytes","trace_bytes","validation_record_same","validation_h_same","solver_h_same","h_represented_solver","witness_at_solver","public_material_equations","certificate_material_block","witness_represented","attempt_witness","encoding_position","encoding_tail_length"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeCertMaterial.LegalWorkspace,
    ``FT1536.Source3.KeygenMakeCertMaterial.represents_same,
    ``FT1536.Source3.KeygenMakeCertMaterial.public_represents_same,
    ``FT1536.Source3.KeygenMakeCertMaterial.leave_shape,
    ``FT1536.Source3.KeygenMakeCertMaterial.leave_bytes,
    ``FT1536.Source3.KeygenMakePublicCall.Material,
    ``FT1536.Source3.KeygenMakePublicCall.source_same_material,
    ``FT1536.Source3.KeygenMakeWorkspaceTables.foreign_block_retained,
    ``FT1536.Source3.KeygenMakeWorkspaceTables.tablesOutside_nonTable,
    ``FT1536.Source3.KeygenRootCaller.Legal,
    ``FT1536.Source3.KeygenRootCaller.bound,
    ``FT1536.Source3.KeygenRootCaller.bind_exact,
    ``FT1536.Source3.KeygenRootCaller.bound_entry,
    ``FT1536.Source3.KeygenRootCaller.success,
    ``FT1536.Source3.KeygenRootSource.Call,
    ``FT1536.Source3.KeygenRootSource.Exec,
    ``FT1536.Source3.KeygenRootSource.Entry,
    ``FT1536.Source3.KeygenRootSource.suffix_entry,
    ``FT1536.Source3.KeygenRootValidation.Entry,
    ``FT1536.Source3.KeygenRootValidation.arrays,
    ``FT1536.Source3.KeygenRootValidation.validation,
    ``FT1536.Source3.KeygenRootValidationSource.Exec,
    ``FT1536.Source3.KeygenRootSearch.Protected,
    ``FT1536.Source3.KeygenRootSearch.frame,
    ``FT1536.Source3.KeygenRootSearch.output_caller,
    ``FT1536.Source3.KeygenSearchStability.root,
    ``FT1536.Source3.KeygenRootObjects.gate,
    ``FT1536.Source3.KeygenRootObjects.search_profile,
    ``FT1536.Source3.KeygenOutputGateBounds.Caller,
    ``FT1536.Source3.KeygenOutputGateBounds.gate_writes,
    ``FT1536.Source3.KeygenSmallBounds.Writes,
    ``FT1536.Source3.KeygenSmallOutput.element,
    ``FT1536.Source3.KeygenSmallOutput.Stored,
    ``FT1536.Source3.KeygenSmallOutput.Store16,
    ``FT1536.Source3.KeygenResidueTrace.Arrays,
    ``FT1536.Source3.KeygenResidueTrace.Writes,
    ``FT1536.Source3.KeygenResidueTrace.Inputs,
    ``FT1536.Source3.KeygenResidueTrace.slots,
    ``FT1536.Source3.KeygenResidueLoop.Trace,
    ``FT1536.Source3.KeygenResidueLoop.source_trace,
    ``FT1536.Source3.KeygenMkgm3Frame.Outside,
    ``FT1536.Source3.KeygenMkgm3Frame.Bindings,
    ``FT1536.Source3.KeygenMkgm3Frame.outside_bytes,
    ``FT1536.Source3.KeygenMkgm3Frame.source_footprint,
    ``FT1536.Source3.KeygenMkgm3.Entry,
    ``FT1536.Source3.KeygenMkgm3Layout.output,
    ``FT1536.Source3.KeygenMkgm3Layout.gm,
    ``FT1536.Source3.KeygenMkgm3Layout.Legal,
    ``FT1536.Source3.KeygenMemoryStability.Stable,
    ``FT1536.Source3.KeygenMemoryStability.modular,
    ``FT1536.Source3.KeygenNttControl.frame,
    ``FT1536.Source3.KeygenSolverNttCalls.Caller,
    ``FT1536.Source3.KeygenSolverTransforms.Bindings,
    ``FT1536.Source3.KeygenSolverTransforms.four_code,
    ``FT1536.Source3.KeygenNttMemoryFrame.Frame,
    ``FT1536.Source3.KeygenSolverValidation.sequence_frame,
    ``FT1536.Source3.KeygenSolverValidation.read_only_heap,
    ``FT1536.Source3.KeygenOutputGateValidation.Validation,
    ``FT1536.Source3.KeygenOutputGateValidation.material,
    ``FT1536.Source3.KeygenSolverEquation.Bounds,
    ``FT1536.Source3.KeygenSolverEquation.Equation,
    ``FT1536.Source3.KeygenMaterial.Represents,
    ``FT1536.Source3.KeygenPublicNormalizePolynomial.Represents,
    ``FT1536.Source3.KeygenPublicInputCells.Cell,
    ``FT1536.Source3.KeygenIntegerLift.Bound,
    ``FT1536.Source3.KeygenAttemptMaterial.Material,
    ``FT1536.Source3.KeygenMakeSearchPrefix.Dimensions,
    ``FT1536.Source3.KeygenMakeCertCall.Call,
    ``FT1536.Source3.KeygenMakeCertCall.CertificateGate,
    ``FT1536.Source3.KeygenMakeCertCall.bind_callee_profile,
    ``FT1536.Source3.CertificateFunctionOutcome.CallerFrame,
    ``FT1536.Source3.CertificateFunctionOutcome.accepted,
    ``FT1536.Source3.CertificateFunctionReference.Exec,
    ``FT1536.Source3.CertificateFunctionReference.Arguments,
    ``FT1536.Source3.CertificateM0Environment.Exec,
    ``FT1536.Source3.CertificateRegionFrame.Outside,
    ``FT1536.Source3.C99PointerFootprint.TablesOutside,
    ``FT1536.Source3.ShakeExtractFrame.SameBlock,
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.KeygenPublicInputMaterial.Legal,
    ``FT1536.Source3.KeygenPublicInputLifetime.LiveTables,
    ``FT1536.Source3.KeygenPublicFrame.Tables,
    ``FT1536.Source3.KeygenMakeProgram.encoding,
    ``FT1536.Source3.KeygenMakeProgram.outer,
    ``FT1536.Source3.KeygenMakeProgram.attemptedLoop,
    ``FT1536.Source3.KeygenMakeProgram.get,
    ``FT1536.Source3.KeygenMakeProgram.outer_shape,
    ``FT1536.Source3.KeygenMakeProgram.actual_encoder_tail_length,
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenCapWords.Count]
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
