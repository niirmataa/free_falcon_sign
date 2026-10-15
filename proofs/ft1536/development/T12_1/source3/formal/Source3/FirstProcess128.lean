import Source3.ShakeBlockChunks116
import Source3.ShakeBlockFixture116
import Source3.GeneratedEventProcess128Round00
import Source3.GeneratedEventProcess128Round01
import Source3.GeneratedEventProcess128Round02
import Source3.GeneratedEventProcess128Round03
import Source3.GeneratedEventProcess128Round04
import Source3.GeneratedEventProcess128Round05
import Source3.GeneratedEventProcess128Round06
import Source3.GeneratedEventProcess128Round07
import Source3.GeneratedEventProcess128Round08
import Source3.GeneratedEventProcess128Round09
import Source3.GeneratedEventProcess128Round10
import Source3.GeneratedEventProcess128Round11

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FirstProcess128
open C99CompactState115 (State reference)
open ShakeBlock (Exec)

def caller := FirstProcessSite128.caller
def pointer := FirstProcessSite128.pointer
def table := FirstProcessSite128.table
def finalState := GeneratedEventProcess128Round11.next
def after : State := {caller with heap := finalState.heap}

theorem static_checked : ShakeProcessCompute116.StaticGuard caller.heap table := FirstProcessSite128.static_checked

theorem final_guard : ShakeBlock.Eval (reference finalState) ShakeBlock.condition (.int32 0) :=
  ShakeBlockComputeRead116.evaluate_sound finalState ShakeBlock.condition (.i32 0) (by decide +kernel)

theorem loop12 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference finalState) (reference finalState) :=
  .loopFalse _ _ _ _ (.int32 0) final_guard (by decide +kernel)

theorem loop11 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round11.ready) (reference finalState) := by
  have rest := loop12
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round11.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round11.finished) (reference GeneratedEventProcess128Round11.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round11.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round11.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round11.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round11.finished GeneratedEventProcess128Round11.next GeneratedEventProcess128Round11.increment_computed) rest

theorem loop10 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round10.ready) (reference finalState) := by
  have rest := loop11
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round10.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round10.finished) (reference GeneratedEventProcess128Round10.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round10.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round10.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round10.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round10.finished GeneratedEventProcess128Round10.next GeneratedEventProcess128Round10.increment_computed) rest

theorem loop09 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round09.ready) (reference finalState) := by
  have rest := loop10
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round09.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round09.finished) (reference GeneratedEventProcess128Round09.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round09.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round09.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round09.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round09.finished GeneratedEventProcess128Round09.next GeneratedEventProcess128Round09.increment_computed) rest

theorem loop08 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round08.ready) (reference finalState) := by
  have rest := loop09
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round08.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round08.finished) (reference GeneratedEventProcess128Round08.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round08.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round08.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round08.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round08.finished GeneratedEventProcess128Round08.next GeneratedEventProcess128Round08.increment_computed) rest

theorem loop07 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round07.ready) (reference finalState) := by
  have rest := loop08
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round07.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round07.finished) (reference GeneratedEventProcess128Round07.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round07.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round07.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round07.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round07.finished GeneratedEventProcess128Round07.next GeneratedEventProcess128Round07.increment_computed) rest

theorem loop06 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round06.ready) (reference finalState) := by
  have rest := loop07
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round06.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round06.finished) (reference GeneratedEventProcess128Round06.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round06.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round06.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round06.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round06.finished GeneratedEventProcess128Round06.next GeneratedEventProcess128Round06.increment_computed) rest

theorem loop05 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round05.ready) (reference finalState) := by
  have rest := loop06
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round05.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round05.finished) (reference GeneratedEventProcess128Round05.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round05.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round05.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round05.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round05.finished GeneratedEventProcess128Round05.next GeneratedEventProcess128Round05.increment_computed) rest

theorem loop04 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round04.ready) (reference finalState) := by
  have rest := loop05
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round04.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round04.finished) (reference GeneratedEventProcess128Round04.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round04.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round04.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round04.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round04.finished GeneratedEventProcess128Round04.next GeneratedEventProcess128Round04.increment_computed) rest

theorem loop03 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round03.ready) (reference finalState) := by
  have rest := loop04
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round03.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round03.finished) (reference GeneratedEventProcess128Round03.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round03.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round03.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round03.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round03.finished GeneratedEventProcess128Round03.next GeneratedEventProcess128Round03.increment_computed) rest

theorem loop02 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round02.ready) (reference finalState) := by
  have rest := loop03
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round02.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round02.finished) (reference GeneratedEventProcess128Round02.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round02.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round02.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round02.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round02.finished GeneratedEventProcess128Round02.next GeneratedEventProcess128Round02.increment_computed) rest

theorem loop01 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round01.ready) (reference finalState) := by
  have rest := loop02
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round01.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round01.finished) (reference GeneratedEventProcess128Round01.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round01.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round01.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round01.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round01.finished GeneratedEventProcess128Round01.next GeneratedEventProcess128Round01.increment_computed) rest

theorem loop00 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round00.ready) (reference finalState) := by
  have rest := loop01
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedEventProcess128Round00.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedEventProcess128Round00.finished) (reference GeneratedEventProcess128Round00.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedEventProcess128Round00.ready ShakeBlock.condition (.i32 1) GeneratedEventProcess128Round00.guard_computed)
    (by decide +kernel) GeneratedEventProcess128Round00.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedEventProcess128Round00.finished GeneratedEventProcess128Round00.next GeneratedEventProcess128Round00.increment_computed) rest

theorem source_body : Exec ShakeBlockProgram.code
    (ShakeExtractSource.blockEntry (reference caller) pointer table) (reference finalState) := by
  have prologue := ShakeBlockCompute116.run_sound 64 (ShakeBlock.chain ShakeBlock.prologue)
    (ShakeProcessCompute116.entry caller pointer table) GeneratedEventProcess128Round00.declared
    GeneratedEventProcess128Round00.prologue_computed
  have initial := ShakeBlockCompute116.run_sound 64 ShakeBlock.initial GeneratedEventProcess128Round00.declared
    GeneratedEventProcess128Round00.ready GeneratedEventProcess128Round00.initial_computed
  unfold ShakeBlockProgram.code ShakeBlock.assemble
  apply ShakeBlockChunks116.append _ _ _ _ _ prologue
  exact .seq _ _ _ (reference finalState) _
    (.seq _ _ _ (reference GeneratedEventProcess128Round00.ready) _ initial loop00) (.skip _)

theorem source_process : ShakeExtractSource.Process (reference caller) pointer (reference after) :=
  .run table (reference finalState) FirstProcessSite128.table_binding (ShakeProcessCompute116.static_sound _ _ static_checked) source_body

/-- Exact25-word output of the original source call, compared with the
    pinned native first-block output fixture at the exact logged full-input process event.
    No native result is a premise. -/
theorem output_image : ∀ i : Fin 25,
    C99FiniteRead114.read64 after.heap (KeygenSmallOutput.element pointer i.val)=some (ShakeBlockFixture116.afterWords[i.val]!) := by decide +kernel

end FT1536.Source3.FirstProcess128
