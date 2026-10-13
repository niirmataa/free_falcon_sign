import Source3.KeygenDecodeWrite16
import Source3.KeygenCodecStaticBitBuffer
import Source3.KeygenCodecStaticBitUnary
import Source3.KeygenCodecStaticBitStream
import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenDecodeStaticSigned
import Source3.KeygenDecodeStaticWordOps
import Source3.KeygenDecodeStaticCertified
import Source3.KeygenDecodeStaticCertifiedLoop
import Source3.KeygenDecodeStaticCertifiedStore
import Source3.KeygenDecodeStaticRead
import Source3.KeygenDecodeStaticBitRead
import Source3.KeygenDecodeStaticStateFrame
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
    (`FT1536.Source3.KeygenCodecStaticBitBuffer,["buffer","bytesBits","buffer_length","buffer_value","append_word","drain_byte","drain"]),
    (`FT1536.Source3.KeygenCodecStaticBitUnary,["unary","unary_length","unary_positive","append_bit","unary_history"]),
    (`FT1536.Source3.KeygenCodecStaticBitStream,["coefficient","stream","bytes_append","coefficient_length","coefficient_history","stream_history","padding_bits","encoded_bits"]),
    (`FT1536.Source3.KeygenCodecStaticBitInverse,["magnitude","sign","magnitude_bound","magnitude_integer","packed_shape","unary_count","coefficient_shape","fixed","zeros","decode","fixed_append","zeros_append","signed_magnitude","decode_coefficient","many","many_stream","encoded_inverse"]),
    (`FT1536.Source3.KeygenDecodeStaticSigned,["IV","narrow","negated","narrow_integer","negated_integer","negate_defined","cast_magnitude","positive_store","negative_store","positive_calculation","negative_calculation"]),
    (`FT1536.Source3.KeygenDecodeStaticWordOps,["unsigned_nat32","convert_int32","plus_int32","minus_int32","and_int32","right_uint32","left_uint32"]),
    (`FT1536.Source3.KeygenDecodeStaticCertified,["Checked","skip","breakLoop","declare","bind","assign","compound","evaluate","ret","seq","seq_break","seq_return","scope","branch_true","branch_false"]),
    (`FT1536.Source3.KeygenDecodeStaticCertifiedLoop,["done","next","break_exit","return_exit","forLoop"]),
    (`FT1536.Source3.KeygenDecodeStaticCertifiedStore,["store_unique","store"]),
    (`FT1536.Source3.KeygenDecodeStaticRead,["cursor","next","readRhs","appendRhs","increment","calculation","append_calculation","source_append","source_single"]),
    (`FT1536.Source3.KeygenDecodeStaticBitRead,["low_refill","refill_bits","high_bit","consume_bit"]),
    (`FT1536.Source3.KeygenDecodeStaticStateFrame,["preserves","Same","exec_same","heap_frame","buf_frame"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecStaticComplete.source_outcome,
    ``FT1536.Source3.KeygenCodecStaticLength.encoded_length,
    ``FT1536.Source3.KeygenDecodeStaticBinding.source_bound,
    ``FT1536.Source3.KeygenDecodeStaticFrame.source_frame,
    ``FT1536.Source3.KeygenDecodeDynamicCalculation.computes_eval,
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
