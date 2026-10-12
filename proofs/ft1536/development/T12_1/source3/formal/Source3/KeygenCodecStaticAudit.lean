import Source3.KeygenCodecStaticCountdown
import Source3.KeygenCodecScalarCalculation
import Source3.KeygenCodecStaticUnaryBit
import Source3.KeygenCodecStaticProfile
import Source3.KeygenCodecStaticUnaryAppend
import Source3.KeygenCodecStaticPending
import Source3.KeygenCodecStaticUnaryInvariant
import Source3.KeygenCodecStaticByte
import Source3.CertificateM0Environment
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated068 full terms for source STATIC unary invariant, profile and local byte content.
   Internal audit only; full coefficient/outer STATIC invariant, lengths, decoders and public source codecs remain open. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenCodecStaticCountdown,
      ["Cell","signed_exact","self_convert","decrement","guard_eval","body_frame","normal_exit"]),
    (`FT1536.Source3.KeygenCodecScalarCalculation,
      ["IV","unary_unique","binary_unique","Ordinary","Computes","computes_eval","assign_set"]),
    (`FT1536.Source3.KeygenCodecStaticUnaryBit,
      ["expression","bit","cast_counter","shifted_counter","masked_counter","calculation","rhs_eval","source_rhs"]),
    (`FT1536.Source3.KeygenCodecStaticProfile,
      ["IV","Cell","assignment","declarations","branch_j","prologue_split","prologue_j_frame"]),
    (`FT1536.Source3.KeygenCodecStaticUnaryAppend,
      ["IV","shift_word","add_word","shift_step","bit_step","bit_bound","low_append","source_append"]),
    (`FT1536.Source3.KeygenCodecStaticPending,
      ["IV","Cell","addition","test_eval","normal_seq","emit_reset","counter_step","body_pending","loop_pending"]),
    (`FT1536.Source3.KeygenCodecStaticUnaryInvariant,
      ["Acc","appended","finish","body_state","finish_step","loop_state","finish_pending","unary_invariant","finishLow","low_step","finish_low","unary_low_suffix"]),
    (`FT1536.Source3.KeygenCodecStaticByte,
      ["byte","promoted","byte_again","byte_low","cast_calculation","store_byte","full_unary_byte","padded_byte"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecExecution.Exec,
    ``FT1536.Source3.KeygenCodecExecution.StoreByte,
    ``FT1536.Source3.KeygenCodecValues.Eval,
    ``FT1536.Source3.KeygenCodecValues.Update,
    ``FT1536.Source3.KeygenCodecValues.Assigned,
    ``FT1536.Source3.KeygenCodecValues.Args,
    ``FT1536.Source3.KeygenCodecValues.Load16,
    ``FT1536.Source3.KeygenCodecStaticBinding.source_bound,
    ``FT1536.Source3.KeygenCodecStaticBinding.node040_source,
    ``FT1536.Source3.KeygenCodecStaticBinding.node061_source,
    ``FT1536.Source3.KeygenCodecStaticBinding.node062_source,
    ``FT1536.Source3.KeygenCodecStaticBinding.guard087_source,
    ``FT1536.Source3.KeygenCodecStaticBinding.guard081_source,
    ``FT1536.Source3.KeygenCodecStaticBinding.node068_source,
    ``FT1536.Source3.KeygenCodecStaticSuffix.low_append,
    ``FT1536.Source3.KeygenCodecStaticSuffix.low_shl,
    ``FT1536.Source3.KeygenCodecStaticSuffix.whole_word_bound_false,
    ``FT1536.Source3.KeygenCodecStaticAppend.append_low,
    ``FT1536.Source3.KeygenCodecStaticTerminal.terminal_exit,
    ``FT1536.Source3.KeygenCodecStaticWindow.static_window]
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
