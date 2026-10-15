import Source3.ShakeBlockChunks116
import Source3.GeneratedProcess129G08Round00
import Source3.GeneratedProcess129G08Round01
import Source3.GeneratedProcess129G08Round02
import Source3.GeneratedProcess129G08Round03
import Source3.GeneratedProcess129G08Round04
import Source3.GeneratedProcess129G08Round05
import Source3.GeneratedProcess129G08Round06
import Source3.GeneratedProcess129G08Round07
import Source3.GeneratedProcess129G08Round08
import Source3.GeneratedProcess129G08Round09
import Source3.GeneratedProcess129G08Round10
import Source3.GeneratedProcess129G08Round11

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ProcessSource129G08
open C99CompactState115 (State reference)
open ShakeBlock (Exec)

def caller := NormalizedProcessSite129G08.caller
def pointer := NormalizedProcessSite129G08.pointer
def table := NormalizedProcessSite129G08.table
def finalState := GeneratedProcess129G08Round11.next
def after : State := {caller with heap := finalState.heap}

theorem static_checked : ShakeProcessCompute116.StaticGuard caller.heap table := NormalizedProcessSite129G08.static_checked

theorem final_guard : ShakeBlock.Eval (reference finalState) ShakeBlock.condition (.int32 0) :=
  ShakeBlockComputeRead116.evaluate_sound finalState ShakeBlock.condition (.i32 0) (by decide +kernel)

theorem loop12 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference finalState) (reference finalState) :=
  .loopFalse _ _ _ _ (.int32 0) final_guard (by decide +kernel)

theorem loop11 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round11.ready) (reference finalState) := by
  have rest := loop12
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round11.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round11.finished) (reference GeneratedProcess129G08Round11.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round11.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round11.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round11.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round11.finished GeneratedProcess129G08Round11.next GeneratedProcess129G08Round11.increment_computed) rest

theorem loop10 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round10.ready) (reference finalState) := by
  have rest := loop11
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round10.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round10.finished) (reference GeneratedProcess129G08Round10.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round10.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round10.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round10.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round10.finished GeneratedProcess129G08Round10.next GeneratedProcess129G08Round10.increment_computed) rest

theorem loop09 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round09.ready) (reference finalState) := by
  have rest := loop10
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round09.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round09.finished) (reference GeneratedProcess129G08Round09.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round09.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round09.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round09.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round09.finished GeneratedProcess129G08Round09.next GeneratedProcess129G08Round09.increment_computed) rest

theorem loop08 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round08.ready) (reference finalState) := by
  have rest := loop09
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round08.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round08.finished) (reference GeneratedProcess129G08Round08.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round08.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round08.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round08.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round08.finished GeneratedProcess129G08Round08.next GeneratedProcess129G08Round08.increment_computed) rest

theorem loop07 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round07.ready) (reference finalState) := by
  have rest := loop08
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round07.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round07.finished) (reference GeneratedProcess129G08Round07.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round07.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round07.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round07.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round07.finished GeneratedProcess129G08Round07.next GeneratedProcess129G08Round07.increment_computed) rest

theorem loop06 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round06.ready) (reference finalState) := by
  have rest := loop07
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round06.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round06.finished) (reference GeneratedProcess129G08Round06.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round06.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round06.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round06.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round06.finished GeneratedProcess129G08Round06.next GeneratedProcess129G08Round06.increment_computed) rest

theorem loop05 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round05.ready) (reference finalState) := by
  have rest := loop06
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round05.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round05.finished) (reference GeneratedProcess129G08Round05.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round05.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round05.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round05.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round05.finished GeneratedProcess129G08Round05.next GeneratedProcess129G08Round05.increment_computed) rest

theorem loop04 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round04.ready) (reference finalState) := by
  have rest := loop05
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round04.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round04.finished) (reference GeneratedProcess129G08Round04.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round04.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round04.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round04.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round04.finished GeneratedProcess129G08Round04.next GeneratedProcess129G08Round04.increment_computed) rest

theorem loop03 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round03.ready) (reference finalState) := by
  have rest := loop04
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round03.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round03.finished) (reference GeneratedProcess129G08Round03.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round03.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round03.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round03.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round03.finished GeneratedProcess129G08Round03.next GeneratedProcess129G08Round03.increment_computed) rest

theorem loop02 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round02.ready) (reference finalState) := by
  have rest := loop03
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round02.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round02.finished) (reference GeneratedProcess129G08Round02.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round02.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round02.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round02.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round02.finished GeneratedProcess129G08Round02.next GeneratedProcess129G08Round02.increment_computed) rest

theorem loop01 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round01.ready) (reference finalState) := by
  have rest := loop02
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round01.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round01.finished) (reference GeneratedProcess129G08Round01.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round01.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round01.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round01.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round01.finished GeneratedProcess129G08Round01.next GeneratedProcess129G08Round01.increment_computed) rest

theorem loop00 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round00.ready) (reference finalState) := by
  have rest := loop01
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess129G08Round00.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess129G08Round00.finished) (reference GeneratedProcess129G08Round00.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess129G08Round00.ready ShakeBlock.condition (.i32 1) GeneratedProcess129G08Round00.guard_computed)
    (by decide +kernel) GeneratedProcess129G08Round00.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess129G08Round00.finished GeneratedProcess129G08Round00.next GeneratedProcess129G08Round00.increment_computed) rest

theorem source_body : Exec ShakeBlockProgram.code
    (ShakeExtractSource.blockEntry (reference caller) pointer table) (reference finalState) := by
  have prologue := ShakeBlockCompute116.run_sound 64 (ShakeBlock.chain ShakeBlock.prologue)
    (ShakeProcessCompute116.entry caller pointer table) GeneratedProcess129G08Round00.declared
    GeneratedProcess129G08Round00.prologue_computed
  have initial := ShakeBlockCompute116.run_sound 64 ShakeBlock.initial GeneratedProcess129G08Round00.declared
    GeneratedProcess129G08Round00.ready GeneratedProcess129G08Round00.initial_computed
  unfold ShakeBlockProgram.code ShakeBlock.assemble
  apply ShakeBlockChunks116.append _ _ _ _ _ prologue
  exact .seq _ _ _ (reference finalState) _
    (.seq _ _ _ (reference GeneratedProcess129G08Round00.ready) _ initial loop00) (.skip _)

theorem source_process : ShakeExtractSource.Process (reference caller) pointer (reference after) :=
  .run table (reference finalState) NormalizedProcessSite129G08.table_binding (ShakeProcessCompute116.static_sound _ _ static_checked) source_body

end FT1536.Source3.ProcessSource129G08
