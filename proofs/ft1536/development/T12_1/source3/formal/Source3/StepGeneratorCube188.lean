import Source3.StepGeneratorScalar188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepGeneratorCube188
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenMkgm3Program
open ModularAtoms178 (set cell assign mont)
open SelectedTopInit178 (p p0i)
open StepGeneratorScalar188 (g0)

def square := KeygenModpWord.montgomery g0 g0 p p0i
def gCube := KeygenModpWord.montgomery g0 square p p0i
noncomputable abbrev before := StepGeneratorScalar188.after
noncomputable def cubed := set before "g" gCube
noncomputable def after := set cubed "k" 10

theorem cube_source : Exec (.assign "g".toList tripleGG) before ⟨cubed,.normal⟩ :=
  assign before "g" (some (.uint32 g0)) _ gCube rfl
    (mont before _ _ g0 square p p0i (cell before "g" g0 rfl)
      (mont before _ _ g0 g0 p p0i (cell before "g" g0 rfl) (cell before "g" g0 rfl) rfl rfl) rfl rfl)

theorem increment9 : Exec (inc "k") cubed ⟨after,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 9)) (.uint32 10) rfl
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
      (.step .plus (.uint32 9) (.int32 1) .uint32 rfl (.uint32 9) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible)))))

theorem scoped_source : Exec (.scope [] (C99ModularReference.chainOf [.assign "g".toList tripleGG,inc "k"])) before ⟨after,.normal⟩ := by
  have inner : Exec (C99ModularReference.chainOf [.assign "g".toList tripleGG,inc "k"]) before ⟨after,.normal⟩ :=
    .seqNormal _ _ before cubed _ cube_source (.seqNormal _ _ cubed after _ increment9 (.base .skip after after (.skip after)))
  have run := C99ModularReference.GenExec.scope [] _ before ⟨after,.normal⟩ inner
  simpa only [KeygenPublicForwardCall.restore_empty] using run

theorem source : Exec ifNotFull before ⟨after,.normal⟩ :=
  .branchTrue _ _ _ before ⟨after,.normal⟩ (.int32 1)
    (.logicalNot _ (.uint32 0) (.variable _ _ _ rfl)) (by decide) scoped_source

end FT1536.Source3.StepGeneratorCube188
