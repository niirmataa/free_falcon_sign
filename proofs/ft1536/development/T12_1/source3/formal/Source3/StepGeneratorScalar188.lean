import Source3.GeneratorDeclarations178
import Source3.StepGeneratorEntry188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepGeneratorScalar188
open C99ArrayReference (State)
open C99ModularReference (Exec ModCall)
open KeygenMkgm3Program
open ModularAtoms178 (set cell assign mont)
open SelectedTopInit178 (p p0i r2)

def r := KeygenModpR.word p
def g0 := KeygenModpWord.montgomery KeygenFirstPrime.generator r2 p p0i
noncomputable def before := GeneratorDeclarations178.after StepGeneratorEntry188.entry
noncomputable def withR := set before "R" r
noncomputable def withR2 := set withR "R2" r2
noncomputable def converted := set withR2 "g" g0
noncomputable def after := set converted "k" 9

theorem r_source : Exec rAssign before ⟨withR,.normal⟩ :=
  assign before "R" none _ r rfl
    (.call1 _ _ _ _ (cell before "p" p rfl) (.r _ _ (KeygenModpR.source_exists p)))

theorem r2_source : Exec r2Assign withR ⟨withR2,.normal⟩ :=
  assign withR "R2" none _ r2 rfl
    (.call2 _ _ _ _ _ _ (cell withR "p" p rfl) (cell withR "p0i" p0i rfl)
      (.r2 _ _ (KeygenModpR2Exec.source_exists withR p p0i)))

theorem convert_source : Exec gConvert withR2 ⟨converted,.normal⟩ :=
  assign withR2 "g" (some (.uint32 KeygenFirstPrime.generator)) _ g0 rfl
    (mont withR2 _ _ KeygenFirstPrime.generator r2 p p0i
      (cell withR2 "g" KeygenFirstPrime.generator rfl) (cell withR2 "R2" r2 rfl) rfl rfl)

theorem k_source : Exec kFromLogn0 converted ⟨after,.normal⟩ :=
  assign converted "k" none _ 9 rfl (cell converted "logn" 9 rfl)

theorem source : ModularSequence178.Run ModCall [rAssign,r2Assign,gConvert,kFromLogn0] before after :=
  .cons _ _ _ _ _ r_source (.cons _ _ _ _ _ r2_source
    (.cons _ _ _ _ _ convert_source (.cons _ _ _ _ _ k_source (.nil after))))

end FT1536.Source3.StepGeneratorScalar188
