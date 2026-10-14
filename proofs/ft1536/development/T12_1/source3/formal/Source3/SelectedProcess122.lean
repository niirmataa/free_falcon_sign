import Source3.ShakeBlockChunks116
import Source3.ShakeBlockFixture116
import Source3.GeneratedProcess122Round00
import Source3.GeneratedProcess122Round01
import Source3.GeneratedProcess122Round02
import Source3.GeneratedProcess122Round03
import Source3.GeneratedProcess122Round04
import Source3.GeneratedProcess122Round05
import Source3.GeneratedProcess122Round06
import Source3.GeneratedProcess122Round07
import Source3.GeneratedProcess122Round08
import Source3.GeneratedProcess122Round09
import Source3.GeneratedProcess122Round10
import Source3.GeneratedProcess122Round11

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedProcess122
open C99CompactState115 (State reference)
open ShakeBlock (Exec)

def caller := GeneratedSeed119Fixture.flipped
def pointer := ShakeExtractSource.field GeneratedSeed119Fixture.ctx .a
def table := GeneratedSeed119Fixture.rcPointer
def finalState := GeneratedProcess122Round11.next
def after : State := {caller with heap := finalState.heap}

theorem static_checked : ShakeProcessCompute116.StaticGuard caller.heap table := by decide +kernel

theorem final_guard : ShakeBlock.Eval (reference finalState) ShakeBlock.condition (.int32 0) :=
  ShakeBlockComputeRead116.evaluate_sound finalState ShakeBlock.condition (.i32 0) (by decide +kernel)

theorem loop12 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference finalState) (reference finalState) :=
  .loopFalse _ _ _ _ (.int32 0) final_guard (by decide +kernel)

theorem loop11 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round11.ready) (reference finalState) := by
  have rest := loop12
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round11.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round11.finished) (reference GeneratedProcess122Round11.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round11.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round11.guard_computed)
    (by decide +kernel) GeneratedProcess122Round11.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round11.finished GeneratedProcess122Round11.next GeneratedProcess122Round11.increment_computed) rest

theorem loop10 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round10.ready) (reference finalState) := by
  have rest := loop11
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round10.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round10.finished) (reference GeneratedProcess122Round10.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round10.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round10.guard_computed)
    (by decide +kernel) GeneratedProcess122Round10.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round10.finished GeneratedProcess122Round10.next GeneratedProcess122Round10.increment_computed) rest

theorem loop09 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round09.ready) (reference finalState) := by
  have rest := loop10
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round09.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round09.finished) (reference GeneratedProcess122Round09.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round09.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round09.guard_computed)
    (by decide +kernel) GeneratedProcess122Round09.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round09.finished GeneratedProcess122Round09.next GeneratedProcess122Round09.increment_computed) rest

theorem loop08 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round08.ready) (reference finalState) := by
  have rest := loop09
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round08.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round08.finished) (reference GeneratedProcess122Round08.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round08.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round08.guard_computed)
    (by decide +kernel) GeneratedProcess122Round08.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round08.finished GeneratedProcess122Round08.next GeneratedProcess122Round08.increment_computed) rest

theorem loop07 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round07.ready) (reference finalState) := by
  have rest := loop08
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round07.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round07.finished) (reference GeneratedProcess122Round07.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round07.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round07.guard_computed)
    (by decide +kernel) GeneratedProcess122Round07.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round07.finished GeneratedProcess122Round07.next GeneratedProcess122Round07.increment_computed) rest

theorem loop06 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round06.ready) (reference finalState) := by
  have rest := loop07
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round06.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round06.finished) (reference GeneratedProcess122Round06.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round06.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round06.guard_computed)
    (by decide +kernel) GeneratedProcess122Round06.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round06.finished GeneratedProcess122Round06.next GeneratedProcess122Round06.increment_computed) rest

theorem loop05 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round05.ready) (reference finalState) := by
  have rest := loop06
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round05.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round05.finished) (reference GeneratedProcess122Round05.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round05.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round05.guard_computed)
    (by decide +kernel) GeneratedProcess122Round05.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round05.finished GeneratedProcess122Round05.next GeneratedProcess122Round05.increment_computed) rest

theorem loop04 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round04.ready) (reference finalState) := by
  have rest := loop05
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round04.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round04.finished) (reference GeneratedProcess122Round04.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round04.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round04.guard_computed)
    (by decide +kernel) GeneratedProcess122Round04.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round04.finished GeneratedProcess122Round04.next GeneratedProcess122Round04.increment_computed) rest

theorem loop03 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round03.ready) (reference finalState) := by
  have rest := loop04
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round03.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round03.finished) (reference GeneratedProcess122Round03.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round03.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round03.guard_computed)
    (by decide +kernel) GeneratedProcess122Round03.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round03.finished GeneratedProcess122Round03.next GeneratedProcess122Round03.increment_computed) rest

theorem loop02 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round02.ready) (reference finalState) := by
  have rest := loop03
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round02.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round02.finished) (reference GeneratedProcess122Round02.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round02.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round02.guard_computed)
    (by decide +kernel) GeneratedProcess122Round02.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round02.finished GeneratedProcess122Round02.next GeneratedProcess122Round02.increment_computed) rest

theorem loop01 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round01.ready) (reference finalState) := by
  have rest := loop02
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round01.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round01.finished) (reference GeneratedProcess122Round01.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round01.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round01.guard_computed)
    (by decide +kernel) GeneratedProcess122Round01.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round01.finished GeneratedProcess122Round01.next GeneratedProcess122Round01.increment_computed) rest

theorem loop00 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round00.ready) (reference finalState) := by
  have rest := loop01
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedProcess122Round00.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedProcess122Round00.finished) (reference GeneratedProcess122Round00.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedProcess122Round00.ready ShakeBlock.condition (.i32 1) GeneratedProcess122Round00.guard_computed)
    (by decide +kernel) GeneratedProcess122Round00.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedProcess122Round00.finished GeneratedProcess122Round00.next GeneratedProcess122Round00.increment_computed) rest

theorem source_body : Exec ShakeBlockProgram.code
    (ShakeExtractSource.blockEntry (reference caller) pointer table) (reference finalState) := by
  have prologue := ShakeBlockCompute116.run_sound 64 (ShakeBlock.chain ShakeBlock.prologue)
    (ShakeProcessCompute116.entry caller pointer table) GeneratedProcess122Round00.declared
    GeneratedProcess122Round00.prologue_computed
  have initial := ShakeBlockCompute116.run_sound 64 ShakeBlock.initial GeneratedProcess122Round00.declared
    GeneratedProcess122Round00.ready GeneratedProcess122Round00.initial_computed
  unfold ShakeBlockProgram.code ShakeBlock.assemble
  apply ShakeBlockChunks116.append _ _ _ _ _ prologue
  exact .seq _ _ _ (reference finalState) _
    (.seq _ _ _ (reference GeneratedProcess122Round00.ready) _ initial loop00) (.skip _)

theorem source_process : ShakeExtractSource.Process (reference caller) pointer (reference after) :=
  .run table (reference finalState) (by rfl) (ShakeProcessCompute116.static_sound _ _ static_checked) source_body

/-- Exact25-word output of the original source call, compared with the
    pinned native first-block output fixture. No native result is a premise. -/
theorem output_image : ∀ i : Fin 25,
    C99FiniteRead114.read64 after.heap (KeygenSmallOutput.element pointer i.val)=some (ShakeBlockFixture116.afterWords[i.val]!) := by decide +kernel

end FT1536.Source3.SelectedProcess122
