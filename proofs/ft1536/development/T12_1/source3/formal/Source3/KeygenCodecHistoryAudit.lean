import Source3.KeygenCodecStaticWriteStep
import Source3.KeygenCodecStaticCursor
import Source3.KeygenCodecStaticEmit
import Source3.KeygenCodecStaticAdvance
import Source3.KeygenCodecStaticPadding
import Source3.KeygenCodecStaticHistory
import Source3.KeygenCodecStaticDrainHistory
import Source3.KeygenCodecStaticUnaryHistory
import Source3.KeygenCodecStaticPrefix
import Source3.KeygenCodecStaticCoefficientHistory
import Source3.KeygenCodecStaticStreamByte
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated070 full terms for actual STATIC coefficient byte/cursor histories, rejected prefixes and complete padding tail.
   Internal audit only; full outer history and original-material identity remain open, then lengths/decoders and public last. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCodecStaticWriteStep,
      ["Cursor","Capacity","Written","Rejected","Outcome","guard_true_bound","guard_outcome","calculated_store","guarded_outcome","written_trace"]),
    (`FT1536.Source3.KeygenCodecStaticCursor,
      ["increment","source_sites","increment_cursor","return_cursor"]),
    (`FT1536.Source3.KeygenCodecStaticEmit,
      ["test","optional","Ready","writes","Emitted","Result","buffer_eval","test_eval","optional_result","source_sites"]),
    (`FT1536.Source3.KeygenCodecStaticAdvance,
      ["code","Completed","Result","ready_increment","source_result","source_sites"]),
    (`FT1536.Source3.KeygenCodecStaticPadding,
      ["finalCursor","paddingWrites","Completed","Rejection","BranchResult","TailResult","test_eval","branch_result","tail_result"]),
    (`FT1536.Source3.KeygenCodecStaticHistory,
      ["single","positions","Progress","emit_single","nil_progress","rejected_progress","cons_progress","positions_append","append_progress","extend_rejection"]),
    (`FT1536.Source3.KeygenCodecStaticDrainHistory,
      ["bytes","bytes_step","ready_frame","body_history","drain_history"]),
    (`FT1536.Source3.KeygenCodecStaticUnaryHistory,
      ["bytes","BodyResult","emit_reset_history","counter_history","before_skip","body_history","bytes_step","trace_empty","loop_history"]),
    (`FT1536.Source3.KeygenCodecStaticPrefix,
      ["packedWord","Prepared","preparation"]),
    (`FT1536.Source3.KeygenCodecStaticCoefficientHistory,
      ["firstBytes","lastBytes","bytes","drain_size","remainder_history","scope_progress","coefficient_history"]),
    (`FT1536.Source3.KeygenCodecStaticStreamByte,
      ["drain_low"])]
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
