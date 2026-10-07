import Source3.KeygenNttTransform
import Source3.KeygenNttEvaluation
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal complete type/term/axiom audit of the new transform closure.
   The unchanged prime proof and its lossless DAG remain pinned in BATCH_018. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.KeygenNttControl.localsWritten,
    ``FT1536.Source3.KeygenNttControl.pointersWritten,
    ``FT1536.Source3.KeygenNttControl.supported,
    ``FT1536.Source3.KeygenNttControl.Frame,
    ``FT1536.Source3.KeygenNttControl.frame,
    ``FT1536.Source3.KeygenNttControl.seq_inv,
    ``FT1536.Source3.KeygenNttControl.keep_u64,
    ``FT1536.Source3.KeygenNttControl.keep_u32,
    ``FT1536.Source3.KeygenNttControl.keep_pointer,
    ``FT1536.Source3.KeygenNttMiddleValues.root,
    ``FT1536.Source3.KeygenNttMiddleValues.blockValues,
    ``FT1536.Source3.KeygenNttMiddleValues.blocks,
    ``FT1536.Source3.KeygenNttMiddleValues.rounds,
    ``FT1536.Source3.KeygenNttMiddleValues.Args,
    ``FT1536.Source3.KeygenNttMiddleValues.argsSafe,
    ``FT1536.Source3.KeygenNttMiddleValues.args_keep,
    ``FT1536.Source3.KeygenNttMiddleValues.block_extent,
    ``FT1536.Source3.KeygenNttMiddleValues.counter_extent,
    ``FT1536.Source3.KeygenNttMiddleValues.inner_values,
    ``FT1536.Source3.KeygenNttMiddleValues.u1_trace_values,
    ``FT1536.Source3.KeygenNttMiddleValues.u1_values,
    ``FT1536.Source3.KeygenNttMiddleValues.round_values,
    ``FT1536.Source3.KeygenNttMiddleValues.m_trace_values,
    ``FT1536.Source3.KeygenNttMiddleValues.intermediate_values,
    ``FT1536.Source3.KeygenNttTripleValues.root,
    ``FT1536.Source3.KeygenNttTripleValues.tripleValue,
    ``FT1536.Source3.KeygenNttTripleValues.values,
    ``FT1536.Source3.KeygenNttTripleValues.Snapshot,
    ``FT1536.Source3.KeygenNttTripleValues.snapshot_zero,
    ``FT1536.Source3.KeygenNttTripleValues.snapshot_final,
    ``FT1536.Source3.KeygenNttTripleValues.snapshot_step,
    ``FT1536.Source3.KeygenNttTripleValues.trace_values,
    ``FT1536.Source3.KeygenNttTripleValues.loop_values,
    ``FT1536.Source3.KeygenNttTripleValues.square_value,
    ``FT1536.Source3.KeygenNttTripleValues.pass_values,
    ``FT1536.Source3.KeygenNttExecution.transform,
    ``FT1536.Source3.KeygenNttExecution.glue_chain,
    ``FT1536.Source3.KeygenNttExecution.first_trace_exit,
    ``FT1536.Source3.KeygenNttExecution.first_exit,
    ``FT1536.Source3.KeygenNttExecution.source_values,
    ``FT1536.Source3.KeygenNttTwiddleCert.OddFact,
    ``FT1536.Source3.KeygenNttTwiddleCert.chunks,
    ``FT1536.Source3.KeygenNttTwiddleCert.all_indices,
    ``FT1536.Source3.KeygenNttTwiddleTree.nodeRoot,
    ``FT1536.Source3.KeygenNttTwiddleTree.half_order_negative,
    ``FT1536.Source3.KeygenNttTwiddleTree.power_mod,
    ``FT1536.Source3.KeygenNttTwiddleTree.even_square,
    ``FT1536.Source3.KeygenNttTwiddleTree.odd_square,
    ``FT1536.Source3.KeygenNttTwiddleTree.even_cube,
    ``FT1536.Source3.KeygenNttTwiddleTree.odd_cube,
    ``FT1536.Source3.KeygenNttTwiddleTree.top_low,
    ``FT1536.Source3.KeygenNttTwiddleTree.top_high,
    ``FT1536.Source3.KeygenNttTwiddleTree.parent_square,
    ``FT1536.Source3.KeygenNttTwiddleTree.child_indices,
    ``FT1536.Source3.KeygenNttTwiddleTree.children,
    ``FT1536.Source3.KeygenNttTwiddleTree.leaf_power,
    ``FT1536.Source3.KeygenNttRoundPolynomial.splitValue,
    ``FT1536.Source3.KeygenNttRoundPolynomial.firstArray,
    ``FT1536.Source3.KeygenNttRoundPolynomial.Invariant,
    ``FT1536.Source3.KeygenNttRoundPolynomial.before_block,
    ``FT1536.Source3.KeygenNttRoundPolynomial.after_block,
    ``FT1536.Source3.KeygenNttRoundPolynomial.blocks_values,
    ``FT1536.Source3.KeygenNttRoundPolynomial.low_round,
    ``FT1536.Source3.KeygenNttRoundPolynomial.high_round,
    ``FT1536.Source3.KeygenNttRoundPolynomial.half_of_cells,
    ``FT1536.Source3.KeygenNttRoundPolynomial.first_low,
    ``FT1536.Source3.KeygenNttRoundPolynomial.first_high,
    ``FT1536.Source3.KeygenNttRoundPolynomial.first_invariant,
    ``FT1536.Source3.KeygenNttRoundPolynomial.next_invariant,
    ``FT1536.Source3.KeygenNttRoundPolynomial.rounds_invariant,
    ``FT1536.Source3.KeygenNttRoundPolynomial.transform_evaluation,
    ``FT1536.Source3.KeygenNttTransform.Image,
    ``FT1536.Source3.KeygenNttTransform.Contract,
    ``FT1536.Source3.KeygenNttTransform.source_transform,
    ``FT1536.Source3.KeygenNttTransform.generated_converted_transform,
    ``FT1536.Source3.KeygenMkgm3.Entry,
    ``FT1536.Source3.KeygenMkgm3Layout.Legal,
    ``FT1536.Source3.KeygenMkgm3Atoms.Params,
    ``FT1536.Source3.KeygenMkgm3Frame.Bindings,
    ``FT1536.Source3.KeygenMkgm3RevMemory.SourceTable,
    ``FT1536.Source3.KeygenResidueRanges.Layout,
    ``FT1536.Source3.KeygenResidueTrace.Inputs,
    ``FT1536.Source3.KeygenMaterial.Represents,
    ``FT1536.Source3.KeygenIntegerLift.Bound,
    ``FT1536.Source3.KeygenNttFirstComposition.Entry,
    ``FT1536.Source3.KeygenNinv31.SourceExec,
    ``FT1536.Source3.KeygenNttForwardPrograms.forwardBody,
    ``FT1536.Source3.KeygenNttForwardPrograms.body_source,
    ``FT1536.Source3.KeygenNttButterflyPrograms.wrapper_source,
    ``FT1536.Source3.KeygenMkgm3Program.source_bound,
    ``FT1536.Source3.KeygenResidueProgram.source_bound,
    ``FT1536.Source3.KeygenNttSubpolynomial.degree_bound,
    ``FT1536.Source3.KeygenNttSubpolynomial.low_remainder,
    ``FT1536.Source3.KeygenNttSubpolynomial.high_remainder,
    ``FT1536.Source3.KeygenNttRoots.point,
    ``FT1536.Source3.KeygenNttRoots.points_distinct,
    ``FT1536.Source3.KeygenNttRoots.points_are_roots,
    ``FT1536.Source3.KeygenNttRoots.coefficient_injective,
    ``FT1536.Source3.KeygenNttEvaluation.equation_of_pointwise]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  let chunks := (List.range 32).toArray.map fun i =>
    Lean.Name.str `FT1536.Source3.KeygenNttTwiddleCert ("chunk" ++ (if i<10 then "0" else "") ++ toString i)
  for name in names ++ chunks do
    IO.FS.writeFile "../NTT_TRANSFORM_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.writeFile "../NTT_TRANSFORM_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)
  IO.FS.writeFile "../NTT_TRANSFORM_AUDIT.json" (Lean.Json.arr rows |>.pretty)
