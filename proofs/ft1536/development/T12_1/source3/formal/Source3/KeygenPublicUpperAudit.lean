import Source3.KeygenPublicUpperFrames
import Source3.KeygenPublicUpperLoops
import Source3.KeygenPublicUpperFinish
import Lean.Util.CollectAxioms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option pp.proofs true
set_option pp.deepTerms true
set_option pp.fullNames true
set_option pp.universes true
set_option pp.maxSteps 200000

/- Generated BATCH_036 seal-ceremony audit; whole upper loops and the exceptional
   finish core. Inherited interfaces are audited at their exact consumed names. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let groups : Array (Lean.Name × List String) := #[
    (`FT1536.Source3.KeygenPublicUpperFrames,
      ["OutsideFull","UpperFrame","frame_refl","frame_trans","from_last","full_write_frame","store_frame","cube_frame","square_frame"]),
    (`FT1536.Source3.KeygenPublicUpperLoops,
      ["PairCells","Common","common_same","bind_other","bind_slot","bind_uslot","bind_w","common_bind","common_key","bind_counter","uslot_declared","exact_minus","sub_one_u64","u_increment","u_decrement","logn_minus_two","k_plus_one","power_value","cube_limit_value","square_start_value","init_k_result","init_cube_result","init_square_result","cube_guard_value","square_guard_value","CubeInv","SquareInv","cube_progress","square_progress","cube_step","square_step","cube_source_loop","square_source_loop","source_upper","source_tables"]),
    (`FT1536.Source3.KeygenPublicUpperFinish,
      ["clit","gStore","wSet","addExpr","subExpr","iStore","source_finish","index_zero","index_one","load_two","add_normal","sub_normal","add_word","sub_word","div_word","te_zero","te_one","two_first_root_nonzero","exceptional","add_field","sub_field","division_scaled"])]
  let inherited : Array Lean.Name := #[
    ``FT1536.Source3.C99ArrayReference.Name,
    ``FT1536.Source3.C99ArrayReference.State,
    ``FT1536.Source3.C99ArrayReference.bindValue,
    ``FT1536.Source3.C99IntegerReference.Ty,
    ``FT1536.Source3.C99IntegerReference.Value,
    ``FT1536.Source3.C99IntegerReference.Value.integer,
    ``FT1536.Source3.C99IntegerReference.convert,
    ``FT1536.Source3.C99IntegerReference.compare,
    ``FT1536.Source3.C99IntegerReference.exact,
    ``FT1536.Source3.C99IntegerReference.promote,
    ``FT1536.Source3.C99IntegerReference.usual,
    ``FT1536.Source3.C99IntegerReference.ArithmeticExec,
    ``FT1536.Source3.C99IntegerReference.arithmetic_iff,
    ``FT1536.Source3.C99ScalarReference.boolean,
    ``FT1536.Source3.C99ScalarReference.set,
    ``FT1536.Source3.C99CountedWords.comparison_result,
    ``FT1536.Source3.C99MemoryReference.Memory,
    ``FT1536.Source3.C99MemoryReference.ArrayPointer,
    ``FT1536.Source3.C99ProcedureReference.Result,
    ``FT1536.Source3.C99NarrowReads.Load16,
    ``FT1536.Source3.C99NarrowReads.unsignedPromotion,
    ``FT1536.Source3.C99NarrowReads.load16_deterministic,
    ``FT1536.Source3.KeygenWordExpr.Expr,
    ``FT1536.Source3.KeygenPublicScalar.Call,
    ``FT1536.Source3.KeygenPublicScalar.name,
    ``FT1536.Source3.KeygenPublicWord.Eval,
    ``FT1536.Source3.KeygenPublicWord.scalar,
    ``FT1536.Source3.KeygenPublicWord.narrow,
    ``FT1536.Source3.KeygenPublicExec.Stmt,
    ``FT1536.Source3.KeygenPublicExec.Exec,
    ``FT1536.Source3.KeygenPublicExec.chain,
    ``FT1536.Source3.KeygenPublicTableAtoms.Slot,
    ``FT1536.Source3.KeygenPublicTableAtoms.var,
    ``FT1536.Source3.KeygenPublicTableAtoms.literal,
    ``FT1536.Source3.KeygenPublicTableAtoms.mont,
    ``FT1536.Source3.KeygenPublicTableAtoms.divide,
    ``FT1536.Source3.KeygenPublicTableAtoms.literal_value,
    ``FT1536.Source3.KeygenPublicTableAtoms.variable_value,
    ``FT1536.Source3.KeygenPublicTableAtoms.assign_result,
    ``FT1536.Source3.KeygenPublicTableAtoms.slot_after,
    ``FT1536.Source3.KeygenPublicTableIndex.literal,
    ``FT1536.Source3.KeygenPublicTableIndex.word64,
    ``FT1536.Source3.KeygenPublicTableIndex.address,
    ``FT1536.Source3.KeygenPublicTableControl.seq_inv,
    ``FT1536.Source3.KeygenPublicTableControl.supported,
    ``FT1536.Source3.KeygenPublicTableControl.writes,
    ``FT1536.Source3.KeygenPublicTableControl.frame,
    ``FT1536.Source3.KeygenPublicTableControl.assign_heap,
    ``FT1536.Source3.KeygenPublicTableStore.Word,
    ``FT1536.Source3.KeygenPublicTableStore.Pointers,
    ``FT1536.Source3.KeygenPublicTableStore.Separate,
    ``FT1536.Source3.KeygenPublicTableStore.LastFrame,
    ``FT1536.Source3.KeygenPublicTableStore.pointers_after,
    ``FT1536.Source3.KeygenPublicTableCells.Cell,
    ``FT1536.Source3.KeygenPublicTableCells.promoted_cell,
    ``FT1536.Source3.KeygenSmallOutput.Store16,
    ``FT1536.Source3.KeygenSmallOutput.element,
    ``FT1536.Source3.KeygenNttLoopSupport.USlot,
    ``FT1536.Source3.KeygenNttLoopSupport.u64,
    ``FT1536.Source3.KeygenNttLoopSupport.u64_integer,
    ``FT1536.Source3.KeygenNttLoopSupport.convert_u64_self,
    ``FT1536.Source3.KeygenNttLoopSupport.convert_u64_nat,
    ``FT1536.Source3.KeygenNttLoopSupport.add_one_literal,
    ``FT1536.Source3.KeygenNttForwardExec.shift_left_value,
    ``FT1536.Source3.KeygenModpAddSub.result,
    ``FT1536.Source3.KeygenPublicAlgebra.R,
    ``FT1536.Source3.KeygenPublicAlgebra.value,
    ``FT1536.Source3.KeygenPublicAlgebra.Canonical,
    ``FT1536.Source3.KeygenPublicAlgebra.radix,
    ``FT1536.Source3.KeygenPublicAlgebra.call_leaf,
    ``FT1536.Source3.KeygenPublicAlgebra.source_add,
    ``FT1536.Source3.KeygenPublicAlgebra.source_sub,
    ``FT1536.Source3.KeygenPublicAlgebra.radix_inverse,
    ``FT1536.Source3.KeygenPublicMontgomery.modulus,
    ``FT1536.Source3.KeygenPublicArguments.U32,
    ``FT1536.Source3.KeygenPublicArguments.u32_self,
    ``FT1536.Source3.KeygenPublicArguments.u32_literal,
    ``FT1536.Source3.KeygenPublicArguments.call_leaf_conversion,
    ``FT1536.Source3.KeygenPublicLeafWords.source_add,
    ``FT1536.Source3.KeygenPublicLeafWords.source_sub,
    ``FT1536.Source3.KeygenPublicDivisionAlgebra.Scaled,
    ``FT1536.Source3.KeygenPublicDivisionAlgebra.normalize_call,
    ``FT1536.Source3.KeygenPublicDivisionAlgebra.division_power,
    ``FT1536.Source3.KeygenPublicDivisionAlgebra.nonzero_value,
    ``FT1536.Source3.KeygenPublicDivisionWords.division,
    ``FT1536.Source3.KeygenPublicDivisionWords.source_exact,
    ``FT1536.Source3.KeygenPublicRoots.root,
    ``FT1536.Source3.KeygenPublicRoots.firstRoot,
    ``FT1536.Source3.KeygenPublicRoots.first_root_relation,
    ``FT1536.Source3.KeygenMkgm3Indices.tableExponent,
    ``FT1536.Source3.KeygenMkgm3Layout.DisjointBytes,
    ``FT1536.Source3.KeygenPublicSource.program,
    ``FT1536.Source3.KeygenPublicSource.code,
    ``FT1536.Source3.KeygenPublicLastEntry.assign64_result,
    ``FT1536.Source3.KeygenPublicLastEntry.bind_heap,
    ``FT1536.Source3.KeygenPublicLastEntry.size_one,
    ``FT1536.Source3.KeygenPublicLastRow.source_last_row,
    ``FT1536.Source3.KeygenPublicUpperProgram.u,
    ``FT1536.Source3.KeygenPublicUpperProgram.doubleU,
    ``FT1536.Source3.KeygenPublicUpperProgram.cubeBody,
    ``FT1536.Source3.KeygenPublicUpperProgram.powerK,
    ``FT1536.Source3.KeygenPublicUpperProgram.upper,
    ``FT1536.Source3.KeygenPublicUpperProgram.cubeCondition,
    ``FT1536.Source3.KeygenPublicUpperProgram.cubeIncrement,
    ``FT1536.Source3.KeygenPublicUpperProgram.cubeLoop,
    ``FT1536.Source3.KeygenPublicUpperProgram.squareBody,
    ``FT1536.Source3.KeygenPublicUpperProgram.squareCondition,
    ``FT1536.Source3.KeygenPublicUpperProgram.squareIncrement,
    ``FT1536.Source3.KeygenPublicUpperProgram.squareLoop,
    ``FT1536.Source3.KeygenPublicUpperProgram.initK,
    ``FT1536.Source3.KeygenPublicUpperProgram.initCube,
    ``FT1536.Source3.KeygenPublicUpperProgram.initSquare,
    ``FT1536.Source3.KeygenPublicUpperProgram.finish,
    ``FT1536.Source3.KeygenPublicUpperProgram.afterRows,
    ``FT1536.Source3.KeygenPublicUpperAtoms.declaration_heap,
    ``FT1536.Source3.KeygenPublicUpperAtoms.index_value,
    ``FT1536.Source3.KeygenPublicUpperBody.PairCell,
    ``FT1536.Source3.KeygenPublicUpperBody.RowUpdate,
    ``FT1536.Source3.KeygenPublicUpperBody.counter_after,
    ``FT1536.Source3.KeygenPublicUpperBody.cube_body,
    ``FT1536.Source3.KeygenPublicUpperBody.square_body]
  let names := groups.flatMap fun (ns,decls) => decls.toArray.map (Lean.Name.str ns)
  let allowed : Array Lean.Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let render (e : Lean.Expr) := do
    let text := (← Lean.Meta.ppExpr e).pretty
    if text.contains '⋯' then throwError "Truncated audit text"
    pure text
  let mut rows : Array Lean.Json := #[]
  for name in names ++ inherited do
    IO.FS.writeFile "../PUBLIC_UPPER_AUDIT_PROGRESS.json" (Lean.toJson name.toString |>.pretty)
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
    IO.FS.withFile "../PUBLIC_UPPER_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../PUBLIC_UPPER_AUDIT.json" (Lean.Json.arr rows |>.pretty)
