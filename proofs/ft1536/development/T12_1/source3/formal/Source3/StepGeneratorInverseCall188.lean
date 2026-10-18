import Source3.StepGeneratorSquare188
import Source3.ModpDivTotal178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepGeneratorInverseCall188
open C99ArrayReference (State)
open C99ModularReference (Exec ModCall chainOf)
open KeygenMkgm3Program
open ModularAtoms178 (set cell assign)
open SelectedTopInit178 (p p0i r2)
open StepGeneratorScalar188 (r)
open StepGeneratorSquare188 (g1)

def ig := ModpDivTotal178.word r2 g1 p p0i r
noncomputable def before := StepGeneratorSquare188.after
noncomputable def after := set before "ig" ig

theorem source : Exec igAssign before ⟨after,.normal⟩ :=
  assign before "ig" none _ ig rfl
    (.call5 _ _ _ _ _ _ _ _ _ _ _ _ (cell before "R2" r2 rfl) (cell before "g" g1 rfl)
      (cell before "p" p rfl) (cell before "p0i" p0i rfl)
      (.call1 _ _ _ _ (cell before "p" p rfl) (.r _ _ (KeygenModpR.source_exists p)))
      (.div _ _ (ModpDivTotal178.source_exists before r2 g1 p p0i r)))


end FT1536.Source3.StepGeneratorInverseCall188
