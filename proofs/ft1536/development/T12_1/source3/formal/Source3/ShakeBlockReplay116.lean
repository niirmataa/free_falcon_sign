import Source3.ShakeTrace116Start
import Source3.ShakeTrace116Round00
import Source3.ShakeTrace116Round01
import Source3.ShakeTrace116Round02
import Source3.ShakeTrace116Round03
import Source3.ShakeTrace116Round04
import Source3.ShakeTrace116Round05
import Source3.ShakeTrace116Round06
import Source3.ShakeTrace116Round07
import Source3.ShakeTrace116Round08
import Source3.ShakeTrace116Round09
import Source3.ShakeTrace116Round10
import Source3.ShakeTrace116Round11

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeBlockReplay116
open C99CompactState115 (reference)
open ShakeBlock (Exec)

def finalState := ShakeTrace116Round11.state50

theorem final_guard : ShakeBlock.Eval (reference finalState) ShakeBlock.condition (.int32 0) :=
  ShakeBlockComputeRead116.evaluate_sound finalState ShakeBlock.condition (.i32 0) (by decide +kernel)

theorem loop12 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference finalState) (reference finalState) :=
  .loopFalse _ _ _ _ (.int32 0) final_guard (by decide +kernel)

theorem loop11 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round11.state00) (reference finalState) := by
  have rest := loop12
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round11.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round11.state49) (reference ShakeTrace116Round11.state50) _ (.int32 1)
    ShakeTrace116Round11.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round11.body) ShakeTrace116Round11.increment rest

theorem loop10 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round10.state00) (reference finalState) := by
  have rest := loop11
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round10.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round10.state49) (reference ShakeTrace116Round10.state50) _ (.int32 1)
    ShakeTrace116Round10.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round10.body) ShakeTrace116Round10.increment rest

theorem loop09 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round09.state00) (reference finalState) := by
  have rest := loop10
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round09.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round09.state49) (reference ShakeTrace116Round09.state50) _ (.int32 1)
    ShakeTrace116Round09.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round09.body) ShakeTrace116Round09.increment rest

theorem loop08 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round08.state00) (reference finalState) := by
  have rest := loop09
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round08.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round08.state49) (reference ShakeTrace116Round08.state50) _ (.int32 1)
    ShakeTrace116Round08.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round08.body) ShakeTrace116Round08.increment rest

theorem loop07 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round07.state00) (reference finalState) := by
  have rest := loop08
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round07.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round07.state49) (reference ShakeTrace116Round07.state50) _ (.int32 1)
    ShakeTrace116Round07.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round07.body) ShakeTrace116Round07.increment rest

theorem loop06 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round06.state00) (reference finalState) := by
  have rest := loop07
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round06.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round06.state49) (reference ShakeTrace116Round06.state50) _ (.int32 1)
    ShakeTrace116Round06.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round06.body) ShakeTrace116Round06.increment rest

theorem loop05 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round05.state00) (reference finalState) := by
  have rest := loop06
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round05.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round05.state49) (reference ShakeTrace116Round05.state50) _ (.int32 1)
    ShakeTrace116Round05.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round05.body) ShakeTrace116Round05.increment rest

theorem loop04 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round04.state00) (reference finalState) := by
  have rest := loop05
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round04.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round04.state49) (reference ShakeTrace116Round04.state50) _ (.int32 1)
    ShakeTrace116Round04.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round04.body) ShakeTrace116Round04.increment rest

theorem loop03 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round03.state00) (reference finalState) := by
  have rest := loop04
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round03.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round03.state49) (reference ShakeTrace116Round03.state50) _ (.int32 1)
    ShakeTrace116Round03.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round03.body) ShakeTrace116Round03.increment rest

theorem loop02 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round02.state00) (reference finalState) := by
  have rest := loop03
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round02.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round02.state49) (reference ShakeTrace116Round02.state50) _ (.int32 1)
    ShakeTrace116Round02.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round02.body) ShakeTrace116Round02.increment rest

theorem loop01 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round01.state00) (reference finalState) := by
  have rest := loop02
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round01.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round01.state49) (reference ShakeTrace116Round01.state50) _ (.int32 1)
    ShakeTrace116Round01.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round01.body) ShakeTrace116Round01.increment rest

theorem loop00 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round00.state00) (reference finalState) := by
  have rest := loop01
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference ShakeTrace116Round00.state50) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference ShakeTrace116Round00.state49) (reference ShakeTrace116Round00.state50) _ (.int32 1)
    ShakeTrace116Round00.guard (by decide +kernel) (ShakeBlockChunks116.scope _ _ _ ShakeTrace116Round00.body) ShakeTrace116Round00.increment rest

theorem source_body : Exec ShakeBlockProgram.code
    (ShakeExtractSource.blockEntry (reference ShakeBlockFixture116.before) ShakeBlockFixture116.pointer ShakeBlockFixture116.table)
    (reference finalState) := by
  unfold ShakeBlockProgram.code ShakeBlock.assemble
  apply ShakeBlockChunks116.append _ _ _ _ _ ShakeTrace116Start.declarations
  exact .seq _ _ _ (reference finalState) _
    (.seq _ _ _ (reference ShakeTrace116Start.ready) _ ShakeTrace116Start.initial loop00) (.skip _)

theorem final_heap : (reference finalState).heap=(reference ShakeBlockFixture116.after).heap := by
  have equal : finalState.heap=ShakeBlockFixture116.after.heap := by decide +kernel
  exact congrArg C99FiniteMemory114.memory equal

/-- A concrete original-source process_block call, with the pinned readonly
    RC table and all 24 rounds. Its local input A words are public evidence;
    the full seed initialization and KeyGen witness remain separate obligations. -/
theorem source_process : ShakeExtractSource.Process (reference ShakeBlockFixture116.before)
    ShakeBlockFixture116.pointer (reference ShakeBlockFixture116.after) := by
  have actual := ShakeExtractSource.Process.run (before := reference ShakeBlockFixture116.before)
    (p := ShakeBlockFixture116.pointer) ShakeBlockFixture116.table (reference finalState)
    (by rfl) (ShakeProcessCompute116.static_sound _ _ ShakeBlockFixture116.static_checked) source_body
  rw [final_heap] at actual
  exact actual

end FT1536.Source3.ShakeBlockReplay116
