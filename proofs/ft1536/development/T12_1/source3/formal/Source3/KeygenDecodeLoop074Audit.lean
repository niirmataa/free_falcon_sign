import Source3.KeygenDecodeControl
import Source3.KeygenDecodeNoneReady
import Source3.KeygenDecodeNoneCoefficient
import Source3.KeygenDecodeNoneCoefficientExists
import Source3.KeygenDecodeNoneMemory
import Source3.KeygenDecodeNoneCounter
import Source3.KeygenDecodeNoneImages
import Source3.KeygenDecodeNoneIteration
import Source3.KeygenDecodeNoneLoop
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal audit of complete source coefficient/loop components; complete prologue and return remain open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenDecodeControl,["normalOnly","normal_flow","seq_split","seq_split_given"]),
    (`FT1536.Source3.KeygenDecodeNoneReady,["Ready","Checks","ready_frame","body_checked","declare_w","declare_y"]),
    (`FT1536.Source3.KeygenDecodeNoneCoefficient,["source_store"]),
    (`FT1536.Source3.KeygenDecodeNoneCoefficientExists,["freshW","freshY","setW","setY","w_cell","y_cell","narrow_word","coefficient_exists"]),
    (`FT1536.Source3.KeygenDecodeNoneMemory,["element","WritableArray","Images","Trace","advance","legal_preserved","images_preserved","trace_sizes","load_later_store","load_later_trace","trace_readback"]),
    (`FT1536.Source3.KeygenDecodeNoneCounter,["test","loopCode","self_uint64","less64","test_calculation","test_eval","next","other_cell","next_ready","update_source","update_exists"]),
    (`FT1536.Source3.KeygenDecodeNoneImages,["ImagesAt","head","tail","preserved","wire_high","wire_low","byte_advance","load_allocated","from_wire_reads"]),
    (`FT1536.Source3.KeygenDecodeNoneIteration,["code","source_iteration","iteration_exists"]),
    (`FT1536.Source3.KeygenDecodeNoneLoop,["source_loop","loop_exists"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecNoneOriginal.source_bytes,
    ``FT1536.Source3.KeygenCodecNoneWire.source_readable,
    ``FT1536.Source3.KeygenCodecNoneWire.source_original_preserved,
    ``FT1536.Source3.KeygenDecodeNoneBinding.source_bound,
    ``FT1536.Source3.KeygenDecodeNoneSubtract.store_source,
    ``FT1536.Source3.KeygenDecodeCalculation.computes_exists,
    ``FT1536.Source3.KeygenDecodeWrite16.exists_store]
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
