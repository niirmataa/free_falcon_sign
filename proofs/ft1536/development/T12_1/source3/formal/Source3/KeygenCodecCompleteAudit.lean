import Source3.KeygenCodecPointerFrame
import Source3.KeygenCodecStaticJoint
import Source3.KeygenCodecStaticBudget
import Source3.KeygenCodecStaticOuterHistory
import Source3.KeygenCodecStaticEntry
import Source3.KeygenCodecStaticReadPrefix
import Source3.KeygenCodecStaticReadJoint
import Source3.KeygenCodecStaticMaterial
import Source3.KeygenCodecStaticOuterMaterial
import Source3.KeygenCodecStaticReturnHistory
import Source3.KeygenCodecStaticComplete
import Source3.KeygenCodecStaticCall
import Source3.KeygenCodecStaticCalls
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated071 full terms for complete STATIC histories on original physical input words, all capacity returns and padding.
   Internal audit only; physical array semantics are source-bound; exact lengths/decoders and vector-to-WORD transport follow, public last. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCodecPointerFrame,
      ["expression","parts","update_frame","eval_frame","declare_frame","statement","exec_frame"]),
    (`FT1536.Source3.KeygenCodecStaticJoint,
      ["NormalState","remainder_state","scope_state","coefficient"]),
    (`FT1536.Source3.KeygenCodecStaticBudget,
      ["unary_size","coefficient_size"]),
    (`FT1536.Source3.KeygenCodecStaticOuterHistory,
      ["bytes","NormalState","outer_history"]),
    (`FT1536.Source3.KeygenCodecStaticEntry,
      ["prologue","entry"]),
    (`FT1536.Source3.KeygenCodecStaticReadPrefix,
      ["preparation"]),
    (`FT1536.Source3.KeygenCodecStaticReadJoint,
      ["Read","coefficient"]),
    (`FT1536.Source3.KeygenCodecStaticMaterial,
      ["Words","Separated","Preserved","load_unique","add_unique","trace_sizes","positions_away","progress_preserved","load_preserved","words_preserved"]),
    (`FT1536.Source3.KeygenCodecStaticOuterMaterial,
      ["outer_material"]),
    (`FT1536.Source3.KeygenCodecStaticReturnHistory,
      ["padding","Result","padding_size","padding_positions","tail_history","append_result","rejected_result"]),
    (`FT1536.Source3.KeygenCodecStaticComplete,
      ["encoded","Outcome","stream_bound","residual","complete_source","source_outcome"]),
    (`FT1536.Source3.KeygenCodecStaticCall,
      ["call_outcome"]),
    (`FT1536.Source3.KeygenCodecStaticCalls,
      ["Originals","Separate","allocated_separation","call_preserves","segment_originals","chain_static"])]
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
