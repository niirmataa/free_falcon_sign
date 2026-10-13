import Source3.KeygenDecodeNoneEntryCalculations
import Source3.KeygenDecodeNoneEntryControl
import Source3.KeygenDecodeNonePrologue
import Source3.KeygenDecodeNonePrologueExists
import Source3.KeygenDecodeNoneFor
import Source3.KeygenDecodeSequence
import Source3.KeygenDecodeNoneComplete
import Source3.KeygenDecodeNoneExactFrame
import Source3.KeygenCodecNoneRoundtrip
import Source3.KeygenDecodeDispatchBindingPart00
import Source3.KeygenDecodeDispatchSource
import Source3.KeygenDecodeDispatchBinding
import Source3.KeygenDecodeNoneDispatchExecution
import Source3.KeygenDecodeNoneDispatchFacts
import Source3.KeygenCodecNoneCallMaterial
import Source3.KeygenCodecNoneCallRoundtrip
import Source3.KeygenCodecNoneMemoryIdentity
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal audit of full source NONE bodies/dispatchers and physical memory identity; STATIC and mathematical transport remain separate. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenDecodeNoneEntryCalculations,["nRhs","lengthRhs","hqRhs","tqRhs","q_comparison","q_calculation","logn_subtraction","n_shift","n_calculation","length_shift","length_calculation","length_comparison","length_test_calculation","hq_shift","hq_calculation","tq_add","tq_increment","tq_calculation"]),
    (`FT1536.Source3.KeygenDecodeNoneEntryControl,["empty_scope","false_split","false_exists","nAfter","q_branch_source","q_branch_exists","length_gate_source","length_gate_exists"]),
    (`FT1536.Source3.KeygenDecodeNonePrologue,["afterNU","plug","prefixCode","source_partition","Prepared","declaration_nu","declaration_hqtq","prefix_split","prefix_source"]),
    (`FT1536.Source3.KeygenDecodeNonePrologueExists,["freshNU","freshBuf","freshHQ","setHQ","setTQ","prefix_exists"]),
    (`FT1536.Source3.KeygenDecodeNoneFor,["initialized","init_source","init_exists","init_ready","for_source","for_exists","return_source","return_exists","return_tail_source","return_tail_exists"]),
    (`FT1536.Source3.KeygenDecodeSequence,["chain","normal_split","append_normal"]),
    (`FT1536.Source3.KeygenDecodeNoneComplete,["statements","plug_chain","suffix_source","source_outcome","decoder_exists"]),
    (`FT1536.Source3.KeygenDecodeNoneExactFrame,["Window","element_offset","trace_frame"]),
    (`FT1536.Source3.KeygenCodecNoneRoundtrip,["EncoderArgs","EncoderState","DecoderArgs","DecoderState","DecoderFlow","decoderArgs","Decoded","Outcome","byte_trace_writable","encoder_images","source_roundtrip","roundtrip_exists"]),
    (`FT1536.Source3.KeygenDecodeDispatchBinding,["switch000Test","switch000TestTokens","switch000Value0","switch000Tokens0","switch000Value1","switch000Tokens1","switch000Value2","switch000Tokens2","switch000_test","switch000_arm0","switch000_arm1","switch000_arm2","node000","node000Tokens","node000_source","node001","node001Tokens","node001_source","node002","node002Tokens","node002_source","expectedHeader","signatureTokens","signature_source","code","allTokens","lexical_source","complete_tokens_source","source_bound"]),
    (`FT1536.Source3.KeygenDecodeDispatchSource,["sourceSha","lines"]),
    (`FT1536.Source3.KeygenDecodeNoneDispatchExecution,["CallArgs","Exec","Call"]),
    (`FT1536.Source3.KeygenDecodeNoneDispatchFacts,["comp_eval","arguments_initial","switch_call","call_split","call_exists"]),
    (`FT1536.Source3.KeygenCodecNoneCallMaterial,["call_split"]),
    (`FT1536.Source3.KeygenCodecNoneCallRoundtrip,["CallOutcome","decoder_args_same","source_call_roundtrip","call_roundtrip_exists"]),
    (`FT1536.Source3.KeygenCodecNoneMemoryIdentity,["original_read","element_zero","words_readback","trace_identity","source_in_place_identity","in_place_exists"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenDecodeNoneLoop.source_loop,
    ``FT1536.Source3.KeygenDecodeNoneLoop.loop_exists,
    ``FT1536.Source3.KeygenDecodeNoneCoefficient.source_store,
    ``FT1536.Source3.KeygenDecodeNoneCoefficientExists.coefficient_exists,
    ``FT1536.Source3.KeygenCodecNoneOriginal.source_bytes,
    ``FT1536.Source3.KeygenCodecNoneWire.source_readable,
    ``FT1536.Source3.KeygenCodecNoneWire.source_original_preserved]
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
