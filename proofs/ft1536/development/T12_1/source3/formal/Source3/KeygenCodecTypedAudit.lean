import Source3.KeygenCodecValues
import Source3.KeygenCodecExecution
import Source3.KeygenCodecCoverage
import Source3.KeygenCodecRefinement
import Source3.KeygenCodecTypedSegments
import Source3.KeygenCodecProfile
import Source3.KeygenCodecNoneLength
import Source3.KeygenCodecGuardedWrite
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated065 full terms for typed codec execution, value coverage, same-heap projection and caller histories.
   Internal audit only; exact capacity windows, lengths and round-trips remain open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCodecValues,
      ["Name","calleeArgs","Args","Value","Locals","State","initialLocals","initial","withLocals","localSet","scalarTy","castInteger","truth","boolean","Load16","UnaryOp","BinaryOp","Update","Eval","assignOp","Assigned","declareLocals","hasBuf","declared"]),
    (`FT1536.Source3.KeygenCodecExecution,
      ["byteOff","StoreByte","Flow","body","testExpr","desugar","scopeObjects","scopeExit","CallArgs","Exec","Call"]),
    (`FT1536.Source3.KeygenCodecCoverage,
      ["scalarType","castType","expression","effect","constant","sequencing","testsSequenced","object","statement","innerScopes","functionScope","none_covered","static_covered","dispatch_covered","none_scopes","static_scopes","dispatch_scopes","none_sequencing","static_sequencing","dispatch_sequencing","default_call"]),
    (`FT1536.Source3.KeygenCodecRefinement,
      ["flow","Match","Out","match_locals","match_initial","body_project","desugar_project","branch_project","while_project","switch_project","exec_projection","call_projection","call_frame"]),
    (`FT1536.Source3.KeygenCodecTypedSegments,
      ["arguments","Site","projectedSite","nextState","Segments","projection","erase","chain_call_histories","chain_call_material"]),
    (`FT1536.Source3.KeygenCodecProfile,
      ["Profile","assign_cell","segment_cell","head_cell","encoding_cell","encoding_profile","init_profile","next_profile","segment_profiles","chain_profiles","arguments_profile"]),
    (`FT1536.Source3.KeygenCodecNoneLength,
      ["number_eval","size_three_eval","logn_eval","rhs","assignment_source","rhs_eval"]),
    (`FT1536.Source3.KeygenCodecGuardedWrite,
      ["Window","byteOff_offset","store_window","u_eval","capacity_eval","test","reject","guarded","first_site_source","unary_site_source","padding_site_source","guard_false_bound","write_after_guard","guard_locals","reject_state","guard_step","guarded_window"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecNoneBinding.source_bound,
    ``FT1536.Source3.KeygenCodecStaticBinding.source_bound,
    ``FT1536.Source3.KeygenCodecDispatchBinding.source_bound,
    ``FT1536.Source3.KeygenCodecFootprint.none_complete,
    ``FT1536.Source3.KeygenCodecFootprint.static_complete,
    ``FT1536.Source3.KeygenCodecFootprint.dispatch_complete,
    ``FT1536.Source3.KeygenCodecFootprint.run_frame,
    ``FT1536.Source3.KeygenCodecSkeSurvival.chain_call_histories,
    ``FT1536.Source3.KeygenCodecSkeSurvival.erase,
    ``FT1536.Source3.KeygenMakeInvocation.SmallSite,
    ``FT1536.Source3.KeygenMakeInvocation.Segments,
    ``FT1536.Source3.KeygenMakeInvocation.TailCells,
    ``FT1536.Source3.C99IntegerReference.CompareExec,
    ``FT1536.Source3.C99IntegerReference.ArithmeticExec,
    ``FT1536.Source3.C99IntegerReference.ShiftExec,
    ``FT1536.Source3.C99MemoryReference.PointerAdd]
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
