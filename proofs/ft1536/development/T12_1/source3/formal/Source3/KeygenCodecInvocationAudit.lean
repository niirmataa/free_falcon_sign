import Source3.KeygenCodecInvocation
import Source3.KeygenCodecLocalFacts
import Source3.KeygenCodecStaticWindow
import Source3.KeygenCodecStaticDispatch
import Source3.KeygenCodecInvocationWindows
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated066 full terms for whole-invocation typed codec composition and full STATIC capacity windows.
   Internal audit only; lengths, decoder round-trips and public codec source proofs remain open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCodecInvocation,
      ["segment_flow","Consecutive","segment_order","segment_count","Head","head_erase","Encoding","encoding_erase","secret_extract","head_success","split_success","no_secret_calls","afterSecret","tail_source","tail_trace","Invocation","invocation_erase","invocation_trace","invocation_calls","invocation_four_calls"]),
    (`FT1536.Source3.KeygenCodecLocalFacts,
      ["IntegerValue","IntegerTy","Valid","convert_type","set_valid","expression","update_valid","and_parts","eval_valid","objectsSafe","declare_valid","initial_valid"]),
    (`FT1536.Source3.KeygenCodecStaticWindow,
      ["Invariant","window_refl","window_trans","scope_valid","with_valid","evaluated_valid","safe","guard_live","guarded_fold","seq_safe","exec_fold","static_checked","static_window"]),
    (`FT1536.Source3.KeygenCodecStaticDispatch,
      ["comp_eval","switch_call","dispatch_window"]),
    (`FT1536.Source3.KeygenCodecInvocationWindows,
      ["site_window","invocation_windows"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecExecution.Exec,
    ``FT1536.Source3.KeygenCodecExecution.Call,
    ``FT1536.Source3.KeygenCodecTypedSegments.arguments,
    ``FT1536.Source3.KeygenCodecTypedSegments.Segments,
    ``FT1536.Source3.KeygenCodecTypedSegments.projection,
    ``FT1536.Source3.KeygenCodecTypedSegments.chain_call_material,
    ``FT1536.Source3.KeygenMakeInvocation.Head,
    ``FT1536.Source3.KeygenMakeInvocation.Invocation,
    ``FT1536.Source3.KeygenMakeInvocation.TailCells,
    ``FT1536.Source3.KeygenMakeInvocation.VirtualLegal,
    ``FT1536.Source3.KeygenCodecGuardedWrite.guarded_window,
    ``FT1536.Source3.KeygenCodecNoneLength.rhs_eval,
    ``FT1536.Source3.KeygenCodecNoneBinding.source_bound,
    ``FT1536.Source3.KeygenCodecStaticBinding.source_bound,
    ``FT1536.Source3.KeygenCodecDispatchBinding.source_bound]
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
