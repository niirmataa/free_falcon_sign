import Source3.KeygenDecodeWrite16
import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenDecodeNoneExactFrame
import Source3.KeygenInt16Vector076
import Source3.KeygenInt16Reads076
import Source3.KeygenInt16Words076
import Source3.KeygenInt16Representation076
import Source3.KeygenInt16Construct076
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
    (`FT1536.Source3.KeygenInt16Vector076,["Words","lowIndex","highIndex","coefficient","words","vector","Signed16","coefficient_low","coefficient_high","coefficient_bounds","word_integer","vector_signed","vector_words","words_vector","signedEquiv","bound_signed","unbounded_integer_transport_false","halves_are_not_interleaved"]),
    (`FT1536.Source3.KeygenInt16Reads076,["Read","low_byte","high_byte","stored_read","read_stored","decoder_read","narrow_read"]),
    (`FT1536.Source3.KeygenInt16Words076,["element","CodecWords","element_zero","element_add","from_reads","to_reads","words_iff_reads"]),
    (`FT1536.Source3.KeygenInt16Representation076,["wordList","Indexed","wordList_length","wordList_get","represented_stored","represents_indexed","indexed_represents","indexed_words","words_indexed","represents_words","words_represents","represents_iff_words","represents_unique"]),
    (`FT1536.Source3.KeygenInt16Construct076,["trace_exists","raw_array_exists","actual_signed_read","mathematical_array_exists"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenMaterial.Represents,
    ``FT1536.Source3.KeygenPublicInputMaterial.coefficient,
    ``FT1536.Source3.KeygenDecodeMemory.bytes_reconstruct,
    ``FT1536.Source3.KeygenCodecStaticMemoryIdentity.source_in_place_identity]
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
