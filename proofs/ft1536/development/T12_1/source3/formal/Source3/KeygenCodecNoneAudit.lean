import Source3.KeygenCodecCellFrame
import Source3.KeygenCodecControl
import Source3.KeygenCodecStateFrame
import Source3.KeygenCodecNoneResult
import Source3.KeygenCodecNoneCursor
import Source3.KeygenCodecNonePair
import Source3.KeygenCodecNoneLoop
import Source3.KeygenCodecNoneWhole
import Source3.KeygenCodecNoneReturn
import Source3.KeygenCodecNoneDispatch
import Source3.KeygenCodecStaticSuffix
import Source3.KeygenCodecStaticAppend
import Source3.KeygenCodecStaticTerminal
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated067 full terms for complete NONE source result/windows and local STATIC low-suffix steps.
   Internal audit only; full STATIC invariant, lengths, decoder round-trips and public source codecs remain open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCodecCellFrame,
      ["expression","parts","update_frame","eval_frame","objects","declare_frame","statement","exec_frame"]),
    (`FT1536.Source3.KeygenCodecControl,
      ["normalOnly","normal_flow","seq_split","lengths","LengthFlow","return_len","length_flow"]),
    (`FT1536.Source3.KeygenCodecStateFrame,
      ["preserves","Same","exec_same","heap_frame","buf_frame"]),
    (`FT1536.Source3.KeygenCodecNoneResult,
      ["q_eval","q_test","declaration_len","assign_length","branch_length","full_split","none_result","returned_length"]),
    (`FT1536.Source3.KeygenCodecNoneCursor,
      ["IV","Cursor","Len","test","index","len_eval","test_eval","signed_nat32","signed_nat64","unsigned_nat64","plus_value","index_eval","update_cursor","initialize_cursor"]),
    (`FT1536.Source3.KeygenCodecNonePair,
      ["store_window","pair_body"]),
    (`FT1536.Source3.KeygenCodecNoneLoop,
      ["loopCode","while_fold","loop_window"]),
    (`FT1536.Source3.KeygenCodecNoneWhole,
      ["prefixCode","Ready","prefix_ready","split_full","out_eval","null_eval","null_test","null_step","capacity_test","capacity_step","writes_tail","suffix_window","none_window"]),
    (`FT1536.Source3.KeygenCodecNoneReturn,
      ["result","ret_len","return_tail","writes_return","capacity_flow","after_null_return","null_test_true","query_flow","suffix_return","none_return"]),
    (`FT1536.Source3.KeygenCodecNoneDispatch,
      ["comp_eval","switch_call","call_split","dispatch_result","dispatch_window","segments_nonzero","invocation_none"]),
    (`FT1536.Source3.KeygenCodecStaticSuffix,
      ["low","low_bound","low_shl","low_append","low_remove","whole_word_bound_false","first_part_source","unary_shift_source","unary_bit_source"]),
    (`FT1536.Source3.KeygenCodecStaticAppend,
      ["amount","shifted","rhs","integer_cell","amount_eval","shift_word","or_word","shifted_eval","rhs_eval","convert_word","append_step","append_low"]),
    (`FT1536.Source3.KeygenCodecStaticTerminal,
      ["decrement_rule","postdecrement","terminal_test","terminal_exit"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecExecution.Exec,
    ``FT1536.Source3.KeygenCodecExecution.Call,
    ``FT1536.Source3.KeygenCodecExecution.StoreByte,
    ``FT1536.Source3.KeygenCodecValues.Args,
    ``FT1536.Source3.KeygenCodecValues.Eval,
    ``FT1536.Source3.KeygenCodecValues.Update,
    ``FT1536.Source3.KeygenCodecNoneBinding.source_bound,
    ``FT1536.Source3.KeygenCodecStaticBinding.source_bound,
    ``FT1536.Source3.KeygenCodecDispatchBinding.source_bound,
    ``FT1536.Source3.KeygenCodecInvocation.Invocation,
    ``FT1536.Source3.KeygenCodecInvocation.invocation_calls,
    ``FT1536.Source3.KeygenCodecInvocation.invocation_trace,
    ``FT1536.Source3.KeygenCodecStaticWindow.static_window,
    ``FT1536.Source3.KeygenCodecStaticBinding.node040_source,
    ``FT1536.Source3.KeygenCodecStaticBinding.guard087_source]
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
