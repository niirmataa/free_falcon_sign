import Source3.KeygenNttFirstComposition
import Source3.KeygenNttSubpolynomial
import Source3.KeygenNttRoots
import Source3.ExprAuditDag
import Source3.KeygenNttEvaluation
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Internal audit, including expanded structure constructor types. Kernel
   inductives have no definition term; this is recorded rather than faked. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let names : Array Lean.Name := #[
    ``FT1536.Source3.KeygenNttCells.Cell,
    ``FT1536.Source3.KeygenNttCells.Cells,
    ``FT1536.Source3.KeygenNttCells.Separate,
    ``FT1536.Source3.KeygenNttCells.Preserves,
    ``FT1536.Source3.KeygenNttCells.quadratic,
    ``FT1536.Source3.KeygenNttCells.first,
    ``FT1536.Source3.KeygenNttCells.binary,
    ``FT1536.Source3.KeygenNttCells.triple,
    ``FT1536.Source3.KeygenNttFirstValues.Args,
    ``FT1536.Source3.KeygenNttFirstValues.Snapshot,
    ``FT1536.Source3.KeygenNttFirstValues.values,
    ``FT1536.Source3.KeygenNttFirstValues.Frame,
    ``FT1536.Source3.KeygenNttFirstValues.firstRoot,
    ``FT1536.Source3.KeygenNttFirstValues.trace_values,
    ``FT1536.Source3.KeygenNttFirstValues.pass_values,
    ``FT1536.Source3.KeygenNttPolynomial.castVec,
    ``FT1536.Source3.KeygenNttPolynomial.coefficient,
    ``FT1536.Source3.KeygenNttPolynomial.halfPolynomial,
    ``FT1536.Source3.KeygenNttPolynomial.lowPolynomial,
    ``FT1536.Source3.KeygenNttPolynomial.highPolynomial,
    ``FT1536.Source3.KeygenNttPolynomial.halfModulus,
    ``FT1536.Source3.KeygenNttPolynomial.FirstImage,
    ``FT1536.Source3.KeygenNttPolynomial.RemainderImage,
    ``FT1536.Source3.KeygenNttPolynomial.converted_cells,
    ``FT1536.Source3.KeygenNttPolynomial.half_coefficient,
    ``FT1536.Source3.KeygenNttPolynomial.half_degree,
    ``FT1536.Source3.KeygenNttPolynomial.first_decomposition,
    ``FT1536.Source3.KeygenNttPolynomial.first_remainder,
    ``FT1536.Source3.KeygenNttPolynomial.eval_low,
    ``FT1536.Source3.KeygenNttPolynomial.eval_high,
    ``FT1536.Source3.KeygenNttPolynomial.first_root_relation,
    ``FT1536.Source3.KeygenNttPolynomial.first_factorization,
    ``FT1536.Source3.KeygenNttPolynomial.image_remainders,
    ``FT1536.Source3.KeygenNttPolynomial.source_first_pass,
    ``FT1536.Source3.KeygenNttFirstComposition.Entry,
    ``FT1536.Source3.KeygenNttFirstComposition.Contract,
    ``FT1536.Source3.KeygenNttFirstComposition.table_preserved,
    ``FT1536.Source3.KeygenNttFirstComposition.source_prefix,
    ``FT1536.Source3.KeygenNttFirstComposition.generated_converted_prefix,
    ``FT1536.Source3.KeygenNttGeometry.m,
    ``FT1536.Source3.KeygenNttGeometry.t,
    ``FT1536.Source3.KeygenNttGeometry.ht,
    ``FT1536.Source3.KeygenNttGeometry.lowIndex,
    ``FT1536.Source3.KeygenNttGeometry.highIndex,
    ``FT1536.Source3.KeygenNttGeometry.twiddleIndex,
    ``FT1536.Source3.KeygenNttGeometry.header_product,
    ``FT1536.Source3.KeygenNttGeometry.seam_product,
    ``FT1536.Source3.KeygenNttGeometry.source_header_product,
    ``FT1536.Source3.KeygenNttGeometry.active_twiddle,
    ``FT1536.Source3.KeygenNttGeometry.butterfly_indices,
    ``FT1536.Source3.KeygenNttGeometry.block_covers,
    ``FT1536.Source3.KeygenNttGeometry.intermediate_exit,
    ``FT1536.Source3.KeygenNttRoots.modulusPrime,
    ``FT1536.Source3.KeygenNttRoots.pointExponent,
    ``FT1536.Source3.KeygenNttRoots.point,
    ``FT1536.Source3.KeygenNttRoots.unity,
    ``FT1536.Source3.KeygenNttRoots.triple_order,
    ``FT1536.Source3.KeygenNttRoots.points_distinct,
    ``FT1536.Source3.KeygenNttRoots.points_are_roots,
    ``FT1536.Source3.KeygenNttRoots.unity_cube,
    ``FT1536.Source3.KeygenNttRoots.polynomial_injective,
    ``FT1536.Source3.KeygenNttRoots.coefficient_injective,
    ``FT1536.Source3.KeygenNttBinaryValues.values,
    ``FT1536.Source3.KeygenNttBinaryValues.Snapshot,
    ``FT1536.Source3.KeygenNttBinaryValues.Args,
    ``FT1536.Source3.KeygenNttBinaryValues.trace_values,
    ``FT1536.Source3.KeygenNttBinaryValues.loop_values,
    ``FT1536.Source3.KeygenNttBinaryValues.load_twiddle,
    ``FT1536.Source3.KeygenNttSubpolynomial.polynomial,
    ``FT1536.Source3.KeygenNttSubpolynomial.modulus,
    ``FT1536.Source3.KeygenNttSubpolynomial.RemainderImage,
    ``FT1536.Source3.KeygenNttSubpolynomial.degree_bound,
    ``FT1536.Source3.KeygenNttSubpolynomial.low_decomposition,
    ``FT1536.Source3.KeygenNttSubpolynomial.low_remainder,
    ``FT1536.Source3.KeygenNttSubpolynomial.high_remainder,
    ``FT1536.Source3.KeygenNttSubpolynomial.eval_low,
    ``FT1536.Source3.KeygenNttSubpolynomial.eval_high,
    ``FT1536.Source3.KeygenNttSubpolynomial.source_remainders,
    ``FT1536.Source3.KeygenNttSubpolynomial.triple_polynomial,
    ``FT1536.Source3.KeygenNttEvaluation.evaluate,
    ``FT1536.Source3.KeygenNttEvaluation.eval_remainder,
    ``FT1536.Source3.KeygenNttEvaluation.evaluate_multiply,
    ``FT1536.Source3.KeygenNttEvaluation.evaluate_sub,
    ``FT1536.Source3.KeygenNttEvaluation.evaluate_constant,
    ``FT1536.Source3.KeygenNttEvaluation.equation_of_pointwise]
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names do
    IO.FS.writeFile "../NTT_VALUES_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
    let info ← Lean.getConstInfo name
    let axes ← Lean.collectAxioms name
    for ax in axes do
      unless allowed.contains ax do throwError "Unexpected axiom {ax} in {name}"
    let typeText ← render info.type
    let body ← match info.value? (allowOpaque := true) with
      | some term =>
          if name == ``FT1536.Source3.KeygenNttRoots.modulusPrime then
            match FT1536.Source3.ExprAuditDag.encodeChecked term with
            | .error message => throwError "{message}"
            | .ok dag =>
                IO.FS.writeFile "../NTT_PRIME_TERM_DAG.json" dag.pretty
                pure (Lean.Json.mkObj [("kind",Lean.toJson "definition_or_theorem"),
                  ("term_dag",Lean.toJson "NTT_PRIME_TERM_DAG.json"),
                  ("roundtrip_structural_equality",Lean.toJson true)])
          else pure (Lean.Json.mkObj [("kind",Lean.toJson "definition_or_theorem"),
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
      ("name",Lean.toJson name.toString),("type",Lean.toJson typeText),
      ("body",body),("axioms",Lean.toJson (axes.map Lean.Name.toString))])
    IO.FS.writeFile "../NTT_VALUES_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)
  IO.FS.writeFile "../NTT_VALUES_AUDIT.json" (Lean.Json.arr rows |>.pretty)
