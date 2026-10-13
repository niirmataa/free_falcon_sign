import Source3.KeygenSecretBits081
import Source3.KeygenSecretSegment081
import Source3.KeygenSecretPacket081
import Source3.KeygenSecretChain081
import Source3.KeygenSecretPrelude081
import Source3.KeygenSecretObserved081
import Source3.KeygenSecretCallerTrace081
import Source3.KeygenPublicForeign081
import Source3.KeygenPublicSuffixFrame081
import Source3.KeygenSecretTailSource081
import Source3.KeygenSecretLocal081
import Source3.KeygenSecretTailBinding081
import Source3.KeygenSecretInvocation081
import Source3.KeygenOutputMemory081
import Source3.KeygenSecretComplete081
import Source3.KeygenSecretDecodeSource081
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Author inventory of complete observed secret packet, source decoders and caller lifetime. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenSecretBits081,["word","many","word_honest","many_honest","stream_length"]),
    (`FT1536.Source3.KeygenSecretSegment081,["usedBits","usedBytes","paddingBits","segment","remaining","parsed","used_bits","used_bytes","bit_count","padding","segment_honest"]),
    (`FT1536.Source3.KeygenSecretPacket081,["Material","decodeVector","DecodeSecret","payload","packet","decode_vector","segment_wordlist","segment_last","decode_honest","packet_length"]),
    (`FT1536.Source3.KeygenSecretChain081,["bytes","bytes_step","bytes_done","bytes_zero","Cursor","CallBytes","next_cursor","source_trace","length_bound"]),
    (`FT1536.Source3.KeygenSecretPrelude081,["skeStores","header_value","header","ske_head","ske_frame","prelude"]),
    (`FT1536.Source3.KeygenSecretObserved081,["ObservedSecret","packet_observed","byte_block","length_block","preserved","unique"]),
    (`FT1536.Source3.KeygenSecretCallerTrace081,["privateCode","source_parts","split_success","split_normal","next_normal","no_public_calls","legacy","length_store","trace"]),
    (`FT1536.Source3.KeygenPublicForeign081,["BufferOutside","same_trans","execution","call","site"]),
    (`FT1536.Source3.KeygenPublicSuffixFrame081,["head_frame","encoding_frame"]),
    (`FT1536.Source3.KeygenSecretTailSource081,["Source","Addresses","from_encoding"]),
    (`FT1536.Source3.KeygenSecretLocal081,["Separation","packet","Laws","trace_foreign","private_output","through_public"]),
    (`FT1536.Source3.KeygenSecretTailBinding081,["prelude_head","prelude_encoding","append","to_encoding"]),
    (`FT1536.Source3.KeygenSecretInvocation081,["PinnedExec","projection","Frontier","successful_frontier"]),
    (`FT1536.Source3.KeygenOutputMemory081,["Legal","bound_heap","external","internal","separation","material_legal","after_return"]),
    (`FT1536.Source3.KeygenSecretComplete081,["SameCertificate","same_symm","certificate_material","Output","observed_secret","actual_observed_decode","length_bounds"]),
    (`FT1536.Source3.KeygenSecretDecodeSource081,["observed_slice","packet_split","args","source_decoder_at_return"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMakeProgram.source_bound,
    ``FT1536.Source3.KeygenCodecStaticBinding.source_bound,
    ``FT1536.Source3.KeygenDecodeStaticBinding.source_bound,
    ``FT1536.Source3.KeygenMakeAssembly080.LegalEntry,
    ``FT1536.Source3.KeygenMakeInvocation.VirtualLegal,
    ``FT1536.Source3.KeygenCodecStaticComplete.encoded,
    ``FT1536.Source3.KeygenInt16Caller076.chain_transport,
    ``FT1536.Source3.KeygenDecodeStaticComplete.source_outcome,
    ``FT1536.Source3.KeygenPinnedInvocation080.successful_frontier]
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
