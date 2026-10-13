import Source3.KeygenDecodeWrite16
import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenDecodeStaticSequence
import Source3.KeygenDecodeStaticCoefficient
import Source3.KeygenDecodeStaticOuterCounter
import Source3.KeygenDecodeStaticPaddingBits
import Source3.KeygenDecodeStaticPaddingReturn
import Source3.KeygenDecodeStaticOuterSuffix
import Source3.KeygenDecodeStaticOuterScope
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
    (`FT1536.Source3.KeygenDecodeStaticSequence,["chain","append_run","split_run","append_checked"]),
    (`FT1536.Source3.KeygenDecodeStaticCoefficient,["plug","code","source_partition","complete"]),
    (`FT1536.Source3.KeygenDecodeStaticOuterCounter,["next","self64","comparison","calculation","source_nonfinal"]),
    (`FT1536.Source3.KeygenDecodeStaticPaddingBits,["zeros_value","exhausted","mask","mask_word","masked_zero"]),
    (`FT1536.Source3.KeygenDecodeStaticPaddingReturn,["maskExpr","mask_calculation","neq_zero","guard_calculation","source_guard","source_return","complete"]),
    (`FT1536.Source3.KeygenDecodeStaticOuterSuffix,["advanced_wire","nonfinal","final"]),
    (`FT1536.Source3.KeygenDecodeStaticOuterScope,["objects","scalar_preserved","reader","wire","cursor"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenDecodeStaticUnaryLoop.loop,
    ``FT1536.Source3.KeygenDecodeStaticCoefficientStore.source_store,
    ``FT1536.Source3.KeygenDecodeStaticPrefixConservation.complete_with_count,
    ``FT1536.Source3.KeygenCodecStaticBitStream.encoded_bits]
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
