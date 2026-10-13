import Source3.KeygenDecodeWrite16
import Source3.KeygenCodecStaticBitInverse
import Source3.KeygenDecodeStaticReady
import Source3.KeygenDecodeStaticInputGate
import Source3.KeygenDecodeStaticCounterOps
import Source3.KeygenDecodeStaticRefill
import Source3.KeygenDecodeStaticWire
import Source3.KeygenDecodeStaticPrefixLoop
import Source3.KeygenDecodeStaticBitSlice
import Source3.KeygenDecodeStaticPrefixValues
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
    (`FT1536.Source3.KeygenDecodeStaticReady,["IV","Cell","Context","Ready","Checks","context_frame","empty_scope"]),
    (`FT1536.Source3.KeygenDecodeStaticInputGate,["comparison","calculation","source_prefix","unary"]),
    (`FT1536.Source3.KeygenDecodeStaticCounterOps,["plus_nat32","minus_nat32","compare32","boolean_truth","decrement32"]),
    (`FT1536.Source3.KeygenDecodeStaticRefill,["afterRead","afterRefill","body"]),
    (`FT1536.Source3.KeygenDecodeStaticWire,["Reads","Wire","remaining","bytes_length","head","tail","store_preserved","refill_remaining"]),
    (`FT1536.Source3.KeygenDecodeStaticPrefixLoop,["test_calculation","loop"]),
    (`FT1536.Source3.KeygenDecodeStaticBitSlice,["shifted_low","head_bits","tail_bits","mask"]),
    (`FT1536.Source3.KeygenDecodeStaticPrefixValues,["signRhs","lowRhs","sign_calculation","low_calculation","sign_bit","low_bits","source_sign","source_low"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenCodecStaticBitStream.encoded_bits,
    ``FT1536.Source3.KeygenCodecStaticBitInverse.encoded_inverse,
    ``FT1536.Source3.KeygenDecodeStaticRead.source_append,
    ``FT1536.Source3.KeygenDecodeStaticCertifiedStore.store]
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
