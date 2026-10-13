import Source3.KeygenDecodeWrite16
import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenDecodeNoneExactFrame
import Source3.KeygenDecodeStaticPrologueCalculations
import Source3.KeygenDecodeStaticPrologueProfile
import Source3.KeygenDecodeStaticPrologue
import Source3.KeygenDecodeStaticComplete
import Source3.KeygenCodecStaticWire
import Source3.KeygenCodecStaticRoundtrip
import Source3.KeygenDecodeStaticDispatchExecution
import Source3.KeygenDecodeStaticDispatchFacts
import Source3.KeygenCodecStaticCallMaterial
import Source3.KeygenCodecStaticCallRoundtrip
import Source3.KeygenCodecStaticMemoryIdentity
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal audit of constructive scalar/read/store components; full operational STATIC round-trip remains open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenDecodeStaticPrologueCalculations,["nRhs","maskRhs","q_calculation","n_calculation","shift_j","subtract_one","mask_calculation","source_n","source_mask"]),
    (`FT1536.Source3.KeygenDecodeStaticPrologueProfile,["set32","set64","profiled","q_branch"]),
    (`FT1536.Source3.KeygenDecodeStaticPrologue,["pieces","code","source_partition","freshBuf","freshNUV","freshDBMask","freshLenJ","boundBuf","zero32","zero64","complete"]),
    (`FT1536.Source3.KeygenDecodeStaticComplete,["paddingCount","decoder_checked","source_outcome","decoder_exists"]),
    (`FT1536.Source3.KeygenCodecStaticWire,["Capacity","uniform_capacity","source_bytes","trace_writable","physical_reads","original_preserved"]),
    (`FT1536.Source3.KeygenCodecStaticRoundtrip,["EncoderArgs","EncoderState","DecoderArgs","DecoderState","DecoderFlow","decoderArgs","Decoded","Outcome","encoder_images","observed_extent","source_roundtrip","roundtrip_exists"]),
    (`FT1536.Source3.KeygenDecodeStaticDispatchExecution,["CallArgs","Exec","Call"]),
    (`FT1536.Source3.KeygenDecodeStaticDispatchFacts,["comp_eval","arguments_initial","switch_call","call_split","call_exists"]),
    (`FT1536.Source3.KeygenCodecStaticCallMaterial,["call_split"]),
    (`FT1536.Source3.KeygenCodecStaticCallRoundtrip,["CallOutcome","decoder_args_same","source_call_roundtrip","call_roundtrip_exists"]),
    (`FT1536.Source3.KeygenCodecStaticMemoryIdentity,["source_in_place_identity","in_place_exists"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenDecodeStaticLoop.for_loop,
    ``FT1536.Source3.KeygenCodecStaticComplete.source_outcome,
    ``FT1536.Source3.KeygenCodecStaticLength.encoded_length,
    ``FT1536.Source3.KeygenDecodeStaticBinding.source_bound,
    ``FT1536.Source3.KeygenCodecNoneMemoryIdentity.trace_identity]
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
