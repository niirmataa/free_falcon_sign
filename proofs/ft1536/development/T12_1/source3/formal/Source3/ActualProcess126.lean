import Source3.ShakeBlockChunks116
import Source3.ShakeBlockFixture116
import Source3.GeneratedActualProcess126Round00
import Source3.GeneratedActualProcess126Round01
import Source3.GeneratedActualProcess126Round02
import Source3.GeneratedActualProcess126Round03
import Source3.GeneratedActualProcess126Round04
import Source3.GeneratedActualProcess126Round05
import Source3.GeneratedActualProcess126Round06
import Source3.GeneratedActualProcess126Round07
import Source3.GeneratedActualProcess126Round08
import Source3.GeneratedActualProcess126Round09
import Source3.GeneratedActualProcess126Round10
import Source3.GeneratedActualProcess126Round11

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ActualProcess126
open C99CompactState115 (State reference)
open ShakeBlock (Exec)

def caller := ActualExtractPrep126.processBefore
def pointer := ActualExtractPrep126.aPointer
def table := ActualExtractPrep126.rcPointer
def finalState := GeneratedActualProcess126Round11.next
def after : State := {caller with heap := finalState.heap}

theorem static_checked : ShakeProcessCompute116.StaticGuard caller.heap table := by decide +kernel

theorem final_guard : ShakeBlock.Eval (reference finalState) ShakeBlock.condition (.int32 0) :=
  ShakeBlockComputeRead116.evaluate_sound finalState ShakeBlock.condition (.i32 0) (by decide +kernel)

theorem loop12 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference finalState) (reference finalState) :=
  .loopFalse _ _ _ _ (.int32 0) final_guard (by decide +kernel)

theorem loop11 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round11.ready) (reference finalState) := by
  have rest := loop12
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round11.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round11.finished) (reference GeneratedActualProcess126Round11.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round11.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round11.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round11.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round11.finished GeneratedActualProcess126Round11.next GeneratedActualProcess126Round11.increment_computed) rest

theorem loop10 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round10.ready) (reference finalState) := by
  have rest := loop11
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round10.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round10.finished) (reference GeneratedActualProcess126Round10.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round10.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round10.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round10.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round10.finished GeneratedActualProcess126Round10.next GeneratedActualProcess126Round10.increment_computed) rest

theorem loop09 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round09.ready) (reference finalState) := by
  have rest := loop10
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round09.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round09.finished) (reference GeneratedActualProcess126Round09.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round09.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round09.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round09.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round09.finished GeneratedActualProcess126Round09.next GeneratedActualProcess126Round09.increment_computed) rest

theorem loop08 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round08.ready) (reference finalState) := by
  have rest := loop09
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round08.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round08.finished) (reference GeneratedActualProcess126Round08.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round08.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round08.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round08.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round08.finished GeneratedActualProcess126Round08.next GeneratedActualProcess126Round08.increment_computed) rest

theorem loop07 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round07.ready) (reference finalState) := by
  have rest := loop08
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round07.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round07.finished) (reference GeneratedActualProcess126Round07.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round07.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round07.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round07.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round07.finished GeneratedActualProcess126Round07.next GeneratedActualProcess126Round07.increment_computed) rest

theorem loop06 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round06.ready) (reference finalState) := by
  have rest := loop07
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round06.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round06.finished) (reference GeneratedActualProcess126Round06.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round06.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round06.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round06.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round06.finished GeneratedActualProcess126Round06.next GeneratedActualProcess126Round06.increment_computed) rest

theorem loop05 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round05.ready) (reference finalState) := by
  have rest := loop06
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round05.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round05.finished) (reference GeneratedActualProcess126Round05.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round05.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round05.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round05.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round05.finished GeneratedActualProcess126Round05.next GeneratedActualProcess126Round05.increment_computed) rest

theorem loop04 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round04.ready) (reference finalState) := by
  have rest := loop05
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round04.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round04.finished) (reference GeneratedActualProcess126Round04.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round04.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round04.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round04.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round04.finished GeneratedActualProcess126Round04.next GeneratedActualProcess126Round04.increment_computed) rest

theorem loop03 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round03.ready) (reference finalState) := by
  have rest := loop04
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round03.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round03.finished) (reference GeneratedActualProcess126Round03.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round03.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round03.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round03.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round03.finished GeneratedActualProcess126Round03.next GeneratedActualProcess126Round03.increment_computed) rest

theorem loop02 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round02.ready) (reference finalState) := by
  have rest := loop03
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round02.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round02.finished) (reference GeneratedActualProcess126Round02.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round02.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round02.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round02.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round02.finished GeneratedActualProcess126Round02.next GeneratedActualProcess126Round02.increment_computed) rest

theorem loop01 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round01.ready) (reference finalState) := by
  have rest := loop02
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round01.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round01.finished) (reference GeneratedActualProcess126Round01.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round01.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round01.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round01.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round01.finished GeneratedActualProcess126Round01.next GeneratedActualProcess126Round01.increment_computed) rest

theorem loop00 : Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round00.ready) (reference finalState) := by
  have rest := loop01
  change Exec (.loop ShakeBlock.condition (.scope [] (ShakeBlock.chain ShakeBlockProgram.steps)) ShakeBlock.increment)
    (reference GeneratedActualProcess126Round00.next) (reference finalState) at rest
  exact .loopNext _ _ _ _ (reference GeneratedActualProcess126Round00.finished) (reference GeneratedActualProcess126Round00.next) _ (.int32 1)
    (ShakeBlockComputeRead116.evaluate_sound GeneratedActualProcess126Round00.ready ShakeBlock.condition (.i32 1) GeneratedActualProcess126Round00.guard_computed)
    (by decide +kernel) GeneratedActualProcess126Round00.source
    (ShakeBlockCompute116.run_sound 64 ShakeBlock.increment GeneratedActualProcess126Round00.finished GeneratedActualProcess126Round00.next GeneratedActualProcess126Round00.increment_computed) rest

theorem source_body : Exec ShakeBlockProgram.code
    (ShakeExtractSource.blockEntry (reference caller) pointer table) (reference finalState) := by
  have prologue := ShakeBlockCompute116.run_sound 64 (ShakeBlock.chain ShakeBlock.prologue)
    (ShakeProcessCompute116.entry caller pointer table) GeneratedActualProcess126Round00.declared
    GeneratedActualProcess126Round00.prologue_computed
  have initial := ShakeBlockCompute116.run_sound 64 ShakeBlock.initial GeneratedActualProcess126Round00.declared
    GeneratedActualProcess126Round00.ready GeneratedActualProcess126Round00.initial_computed
  unfold ShakeBlockProgram.code ShakeBlock.assemble
  apply ShakeBlockChunks116.append _ _ _ _ _ prologue
  exact .seq _ _ _ (reference finalState) _
    (.seq _ _ _ (reference GeneratedActualProcess126Round00.ready) _ initial loop00) (.skip _)

theorem source_process : ShakeExtractSource.Process (reference caller) pointer (reference after) :=
  .run table (reference finalState) (by decide +kernel) (ShakeProcessCompute116.static_sound _ _ static_checked) source_body

/-- Exact25-word output of the original source call, compared with the
    pinned native first-block output fixture at the ACTUAL first extract call.
    No native result is a premise. -/
theorem output_image : ∀ i : Fin 25,
    C99FiniteRead114.read64 after.heap (KeygenSmallOutput.element pointer i.val)=some (ShakeBlockFixture116.afterWords[i.val]!) := by decide +kernel

end FT1536.Source3.ActualProcess126
