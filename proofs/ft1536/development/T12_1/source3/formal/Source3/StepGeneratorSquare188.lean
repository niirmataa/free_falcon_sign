import Source3.StepGeneratorCube188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepGeneratorSquare188
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenMkgm3Program
open ModularAtoms178 (set cell assign mont)
open SelectedTopInit178 (p p0i)
open StepGeneratorCube188 (gCube)

def g1 := KeygenModpWord.montgomery gCube gCube p p0i
noncomputable def before := StepGeneratorCube188.after
noncomputable def advanced := set before "k" 11
noncomputable def squared := set advanced "g" g1
noncomputable def after := set squared "k" 12

theorem increment10 : Exec (inc "k") before ⟨advanced,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 10)) (.uint32 11) rfl
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
      (.step .plus (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible)))))

theorem square_source : Exec (.assign "g".toList montGG) advanced ⟨squared,.normal⟩ :=
  assign advanced "g" (some (.uint32 gCube)) _ g1 rfl
    (mont advanced _ _ gCube gCube p p0i (cell advanced "g" gCube rfl) (cell advanced "g" gCube rfl) rfl rfl)

theorem scoped_source : Exec (.scope [] (C99ModularReference.chainOf [.assign "g".toList montGG])) advanced ⟨squared,.normal⟩ := by
  have inner : Exec (C99ModularReference.chainOf [.assign "g".toList montGG]) advanced ⟨squared,.normal⟩ :=
    .seqNormal _ _ advanced squared ⟨squared,.normal⟩ square_source (.base .skip squared squared (.skip squared))
  have run := C99ModularReference.GenExec.scope [] _ advanced ⟨squared,.normal⟩ inner
  simpa only [KeygenPublicForwardCall.restore_empty] using run

theorem increment11 : Exec (inc "k") squared ⟨after,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 11)) (.uint32 12) rfl
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
      (.step .plus (.uint32 11) (.int32 1) .uint32 rfl (.uint32 11) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible)))))

theorem loop_source : Exec whileK before ⟨after,.normal⟩ :=
  .seqNormal _ _ before squared ⟨after,.normal⟩
    (.loopNormal _ _ _ before squared squared ⟨squared,.normal⟩ (.int32 1)
      (.compare .lt _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 11)
        (.step .lt (.uint32 10) (.int32 11) .uint32 rfl (.uint32 10) (.uint32 11) rfl rfl))
      (by decide)
      (.seqNormal _ _ before advanced ⟨squared,.normal⟩ increment10 scoped_source)
      (.base .skip squared squared (.skip squared))
      (.loopFalse _ _ _ squared (.int32 0)
        (.compare .lt _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 11)
          (.step .lt (.uint32 11) (.int32 11) .uint32 rfl (.uint32 11) (.uint32 11) rfl rfl)) rfl))
    increment11

theorem k_cell : after.locals "k".toList=some (.uint32,some (.uint32 12)) := rfl
theorem g_cell : after.locals "g".toList=some (.uint32,some (.uint32 g1)) := rfl

end FT1536.Source3.StepGeneratorSquare188
