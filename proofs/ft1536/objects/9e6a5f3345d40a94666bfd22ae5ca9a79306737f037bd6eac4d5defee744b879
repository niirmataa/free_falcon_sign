import Source3.KeygenPublicTableControl
import Source3.KeygenPublicLastProgram
import Source3.KeygenPublicTableIndex
import Source3.KeygenPublicTableStore
import Source3.KeygenPublicLastBody
import Source3.KeygenPublicLastLoop
import Source3.KeygenPublicLastEntry
import Source3.KeygenPublicLastRow
import Source3.KeygenPublicUpperProgram
import Source3.KeygenPublicUpperAtoms
import Source3.KeygenPublicUpperBody
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated internal audit; last-row and upper-body scope, not full tables or NTT. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenPublicTableControl,
      ["writes","supported","Frame","declare_frame","frame","seq_inv","assign_heap"]),
    (`FT1536.Source3.KeygenPublicLastProgram,
      ["scalarVar","shifted","index","u","nextU","store","advance","steps","body","condition","increment","loop","initK","initB","initU","remaining","source_remaining","source_body","body_supported","loop_supported","body_writes"]),
    (`FT1536.Source3.KeygenPublicTableIndex,
      ["variable_value","variable64","word64","literal","plus_literal","next_value","shifted_value","plus_reverse","index_value","address","index_address"]),
    (`FT1536.Source3.KeygenPublicTableStore,
      ["Word","EvalWord","Pointers","Separate","Update","PairUpdate","OutsideLast","LastFrame","frame_refl","frame_trans","last_write_frame","word_after","pointers_after","variable_word","mont_word","assign_word","word_declared","advance_word","separate_symm","separated_bytes","cross_preserves","paired_writes","source_store"]),
    (`FT1536.Source3.KeygenPublicLastBody,
      ["Fixed","fixed_after","counter_after","halfSteps","half","half_supported","half_writes","stores","half_result","split_prepend","PairImages","pair_images","body_result"]),
    (`FT1536.Source3.KeygenPublicLastLoop,
      ["Processed","LowerFrame","Invariant","guard","increment_result","increment_counter","processed_step","lower_step","body_invariant","step","source_loop"]),
    (`FT1536.Source3.KeygenPublicLastEntry,
      ["start","kReady","bReady","ready","bind_heap","rows_heap","ready_heap","start_profile","start_k","kReady_profile","kReady_b","bReady_u","k_value","logn_minus_one","size_one","b_value","assign64_result","init_k","init_b","init_u","ready_other","ready_word","ready_k","ready_b","ready_u","ready_fixed","initial_invariant","remaining_result"]),
    (`FT1536.Source3.KeygenPublicLastRow,
      ["Images","entry_w","physical_images","source_last_row"]),
    (`FT1536.Source3.KeygenPublicUpperProgram,
      ["u","doubleU","cubeSteps","cubeBody","powerK","upper","cubeCondition","cubeIncrement","cubeLoop","squareSteps","squareBody","squareCondition","squareIncrement","squareLoop","initK","initCube","initSquare","finish","afterRows","source_after_rows","cube_supported","square_supported"]),
    (`FT1536.Source3.KeygenPublicUpperAtoms,
      ["Argument","word_argument","load_argument","mont_arguments","assign_argument","index_value","double_value","stored_word","declaration_heap","declared_member","local_frame"]),
    (`FT1536.Source3.KeygenPublicUpperBody,
      ["PairCell","RowUpdate","counter_after","cube_word","cube_body","v_value","square_body"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.KeygenPublicTableRows.source_last_row_entry,
    ``FT1536.Source3.KeygenPublicTableRows.remaining,
    ``FT1536.Source3.KeygenPublicTableRows.afterRows,
    ``FT1536.Source3.KeygenPublicTableRows.ready,
    ``FT1536.Source3.KeygenPublicTableRows.scaled_seeds,
    ``FT1536.Source3.KeygenPublicTableSeed.ready,
    ``FT1536.Source3.KeygenPublicTableSeed.root_scaled,
    ``FT1536.Source3.KeygenPublicTableSeed.inverse_scaled,
    ``FT1536.Source3.KeygenPublicSource.program,
    ``FT1536.Source3.KeygenPublicSource.code,
    ``FT1536.Source3.KeygenPublicSource.code_checked,
    ``FT1536.Source3.KeygenPublicScalar.Call,
    ``FT1536.Source3.KeygenPublicWord.scalar,
    ``FT1536.Source3.KeygenPublicWord.Eval,
    ``FT1536.Source3.KeygenPublicWord.Address,
    ``FT1536.Source3.KeygenPublicExec.Stmt,
    ``FT1536.Source3.KeygenPublicExec.Exec,
    ``FT1536.Source3.KeygenPublicRevCert.source_last_index,
    ``FT1536.Source3.KeygenPublicTableCells.Cell,
    ``FT1536.Source3.KeygenPublicTableCells.written_cell,
    ``FT1536.Source3.KeygenPublicTableCells.preserves_cell,
    ``FT1536.Source3.KeygenPublicDivisionAlgebra.Scaled,
    ``FT1536.Source3.KeygenPublicDivisionAlgebra.scaled_product,
    ``FT1536.Source3.KeygenSmallOutput.Store16,
    ``FT1536.Source3.C99NarrowReads.Load16,
    ``FT1536.Source3.KeygenMkgm3IndexCert.all_indices,
    ``FT1536.Source3.KeygenMkgm3Indices.tableExponent,
    ``FT1536.Source3.KeygenMkgm3Table.last_injective,
    ``FT1536.Source3.KeygenMkgm3Table.last_covers]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../PUBLIC_LAST_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.withFile "../PUBLIC_LAST_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../PUBLIC_LAST_AUDIT.json" (Lean.Json.arr rows |>.pretty)
