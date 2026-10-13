import Source3.KeygenCodecStaticInit
import Source3.KeygenCodecStaticDrain
import Source3.KeygenCodecStaticCoefficient
import Source3.KeygenCodecStaticLow9
import Source3.KeygenCodecStaticIteration
import Source3.KeygenCodecByteHistory
import Source3.KeygenCodecStaticStores
import Source3.KeygenCodecStaticOuterControl
import Source3.KeygenCodecStaticOuterState
import Source3.KeygenCodecStaticOuterSuffix
import Source3.KeygenCodecStaticFullState
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated069 full terms for source STATIC initialization, coefficient, normal outer suffix, raw byte history and stores.
   Internal audit only; expected byte/cursor histories and rejection-prefix invariant, lengths, decoders and public codecs remain open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCodecStaticInit,
      ["Initialized","n_calculation","mask_calculation","branch_n","size_declarations","word_declarations","initialization"]),
    (`FT1536.Source3.KeygenCodecStaticDrain,
      ["signed_arithmetic","append_count","subtract_count","test_eval","body_count","drain_pending","append_and_drain"]),
    (`FT1536.Source3.KeygenCodecStaticCoefficient,
      ["magnitude","signWord","W","magnitude_bounds","input_read","negative_eval","negate_calculation","sign_magnitude","quotient_calculation","quotient"]),
    (`FT1536.Source3.KeygenCodecStaticLow9,
      ["magnitudeBits","packed","and_word","band_calculation","or_value","low9_step","magnitude_bits_value","packed_value","packed_bound"]),
    (`FT1536.Source3.KeygenCodecStaticIteration,
      ["nextPending","nextWord","single_declaration","body_state"]),
    (`FT1536.Source3.KeygenCodecByteHistory,
      ["Write","Trace","append","execution","outside"]),
    (`FT1536.Source3.KeygenCodecStaticStores,
      ["left_word","right_word","padding_count","padding_calculation","drain_calculation","store_calculated","padding_store","drain_store"]),
    (`FT1536.Source3.KeygenCodecStaticOuterControl,
      ["Remaining","self_unsigned64","decrement_value","decrement","test_eval","body_remaining"]),
    (`FT1536.Source3.KeygenCodecStaticOuterState,
      ["fold","fold_pending","outer_state","initialized_state"]),
    (`FT1536.Source3.KeygenCodecStaticOuterSuffix,
      ["nextLow","suffixFold","next_low","fold_low","source_low_suffix"]),
    (`FT1536.Source3.KeygenCodecStaticFullState,
      ["Completed","EarlyReturn","complete_source"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecExecution.Exec,
    ``FT1536.Source3.KeygenCodecExecution.StoreByte,
    ``FT1536.Source3.KeygenCodecValues.Eval,
    ``FT1536.Source3.KeygenCodecValues.Update,
    ``FT1536.Source3.KeygenCodecValues.Assigned,
    ``FT1536.Source3.KeygenCodecValues.Args,
    ``FT1536.Source3.KeygenCodecValues.Load16,
    ``FT1536.Source3.KeygenCodecStaticBinding.source_bound,
    ``FT1536.Source3.KeygenCodecStaticUnaryInvariant.unary_invariant,
    ``FT1536.Source3.KeygenCodecStaticUnaryInvariant.unary_low_suffix,
    ``FT1536.Source3.KeygenCodecStaticUnaryInvariant.finish_low,
    ``FT1536.Source3.KeygenCodecStaticByte.padded_byte,
    ``FT1536.Source3.KeygenCodecStaticAppend.append_step,
    ``FT1536.Source3.KeygenCodecStaticAppend.append_low,
    ``FT1536.Source3.KeygenCodecStaticSuffix.whole_word_bound_false,
    ``FT1536.Source3.KeygenCodecStaticWindow.static_window,
    ``FT1536.Source3.KeygenCodecCellFrame.exec_frame,
    ``FT1536.Source3.KeygenCodecStateFrame.heap_frame,
    ``FT1536.Source3.KeygenCodecScalarCalculation.computes_eval,
    ``FT1536.Source3.KeygenCodecStaticProfile.assignment]
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
