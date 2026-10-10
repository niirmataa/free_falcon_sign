import Source3.KeygenMakeRetryFrames
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated057 internal full terms. The solver-call frame covers every
   edge of the solver gate, the rejected edges (early search rejection,
   partial output-gate writes, zero-return validation) included, keeping
   the public h bytes. Not a review and not a codec or law claim. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenMakeRetryFrames,
      ["writesOnly","small_frame","writes_gate_code","call_bytes","negate_call","failed_guard_bytes","passed_guard_bytes","gate_frame","validation_frame","solver_frame","solver_h_frame"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenSmallSource.Stmt,
    ``FT1536.Source3.KeygenSmallSource.Exec,
    ``FT1536.Source3.KeygenSmallSource.code,
    ``FT1536.Source3.C99ModularFrame.readOnly,
    ``FT1536.Source3.C99ModularFrame.source_frame,
    ``FT1536.Source3.KeygenSmallOutput.Store16,
    ``FT1536.Source3.KeygenSmallStep.reject_result,
    ``FT1536.Source3.KeygenOutputGateSource.Context,
    ``FT1536.Source3.KeygenOutputGateSource.Condition,
    ``FT1536.Source3.KeygenOutputGateSource.condition,
    ``FT1536.Source3.KeygenOutputGateSource.Argument,
    ``FT1536.Source3.KeygenOutputGateSource.lower,
    ``FT1536.Source3.KeygenOutputGateSource.arguments,
    ``FT1536.Source3.KeygenOutputGateSource.view,
    ``FT1536.Source3.KeygenOutputGateSource.Call,
    ``FT1536.Source3.KeygenOutputGateSource.Evaluate,
    ``FT1536.Source3.KeygenOutputGateSource.Exec,
    ``FT1536.Source3.KeygenOutputGateBounds.Caller,
    ``FT1536.Source3.KeygenOutputGateBounds.destinationName,
    ``FT1536.Source3.KeygenOutputGateBounds.sourceIndex,
    ``FT1536.Source3.KeygenOutputGateBounds.binding_entry,
    ``FT1536.Source3.KeygenOutputGateBounds.caller_preserved,
    ``FT1536.Source3.KeygenSmallCalls.params,
    ``FT1536.Source3.KeygenRootValidation.Entry,
    ``FT1536.Source3.KeygenRootValidation.ready_inputs,
    ``FT1536.Source3.KeygenRootValidation.ready_caller,
    ``FT1536.Source3.KeygenRootValidation.arrays,
    ``FT1536.Source3.KeygenRootValidationSource.Exec,
    ``FT1536.Source3.KeygenRootValidationSource.Prepare,
    ``FT1536.Source3.KeygenRootValidationSource.prepared,
    ``FT1536.Source3.KeygenRootValidationSource.generator_entry,
    ``FT1536.Source3.KeygenRootValidationSource.ready,
    ``FT1536.Source3.KeygenRootValidationSource.returned,
    ``FT1536.Source3.KeygenRootValidationSource.genArgs,
    ``FT1536.Source3.KeygenLevelCalls.Bind,
    ``FT1536.Source3.KeygenLevelCalls.params,
    ``FT1536.Source3.KeygenLevelCalls.Kind,
    ``FT1536.Source3.KeygenLevelCalls.bind_heap,
    ``FT1536.Source3.KeygenResidueTrace.Inputs,
    ``FT1536.Source3.KeygenResidueTrace.Arrays,
    ``FT1536.Source3.KeygenResidueLoop.source_trace,
    ``FT1536.Source3.KeygenResidueLoop.Trace,
    ``FT1536.Source3.KeygenMakeMaterialWitness.trace_bytes,
    ``FT1536.Source3.KeygenMakeMaterialWitness.output_block,
    ``FT1536.Source3.KeygenNttControl.frame,
    ``FT1536.Source3.KeygenSolverNttCalls.Caller,
    ``FT1536.Source3.KeygenSolverTransforms.Bindings,
    ``FT1536.Source3.KeygenSolverTransforms.four_code,
    ``FT1536.Source3.KeygenSolverValidation.sequence_frame,
    ``FT1536.Source3.KeygenSolverValidation.read_only_heap,
    ``FT1536.Source3.KeygenNttMemoryFrame.Frame,
    ``FT1536.Source3.KeygenMkgm3Frame.outside_bytes,
    ``FT1536.Source3.KeygenMkgm3Frame.source_footprint,
    ``FT1536.Source3.KeygenMkgm3Program.code,
    ``FT1536.Source3.KeygenSolverTarget.code,
    ``FT1536.Source3.KeygenResidueProgram.code,
    ``FT1536.Source3.KeygenMemoryStability.Stable,
    ``FT1536.Source3.KeygenMemoryStability.modular,
    ``FT1536.Source3.KeygenSearchContext.Context,
    ``FT1536.Source3.KeygenSearchContext.M0,
    ``FT1536.Source3.KeygenSearchContext.ternary_m0,
    ``FT1536.Source3.KeygenSearchContext.tmp_value,
    ``FT1536.Source3.KeygenRootCaller.Legal,
    ``FT1536.Source3.KeygenRootCaller.bound,
    ``FT1536.Source3.KeygenRootCaller.bound_entry,
    ``FT1536.Source3.KeygenRootCaller.bind_exact,
    ``FT1536.Source3.KeygenRootSource.Call,
    ``FT1536.Source3.KeygenRootSource.Exec,
    ``FT1536.Source3.KeygenRootSource.suffix_entry,
    ``FT1536.Source3.KeygenRootSearch.Protected,
    ``FT1536.Source3.KeygenRootSearch.Exec,
    ``FT1536.Source3.KeygenRootSearch.frame,
    ``FT1536.Source3.KeygenRootSearch.output_caller,
    ``FT1536.Source3.KeygenRootObjects.search_profile,
    ``FT1536.Source3.KeygenRootObjects.gate,
    ``FT1536.Source3.KeygenSearchStability.root,
    ``FT1536.Source3.KeygenMkgm3Layout.output,
    ``FT1536.Source3.KeygenStaticTables.PrimeTable,
    ``FT1536.Source3.KeygenNttForwardExec.lognAt,
    ``FT1536.Source3.C99ArrayReference.State,
    ``FT1536.Source3.C99ArrayReference.Name,
    ``FT1536.Source3.C99ArrayReference.bind_heap,
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.C99MemoryReference.PointerAdd,
    ``FT1536.Source3.C99IntegerReference.Value,
    ``FT1536.Source3.C99ProcedureReference.Result,
    ``FT1536.Source3.ShakeExtractFrame.SameBlock,
    ``FT1536.Source3.KeygenResidueTrace.names]
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
