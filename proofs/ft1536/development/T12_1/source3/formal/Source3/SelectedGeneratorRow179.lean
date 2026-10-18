import Source3.SelectedGeneratorRowLoop179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorRow179
open C99ArrayReference (State restoreScope)
open C99ModularReference (Exec chainOf)
open KeygenMkgm3Program

noncomputable def before := SelectedGeneratorInverseCall178.after
def names := ["x","ix","g2","g4","ig2","ig4","b"].map String.toList
noncomputable def after := restoreScope before SelectedGeneratorRowLoop179.after names []
def remaining := [kFromLogn,ifFull,squareLoop]++topElements

theorem else_shape : elseRow=.scope names (chainOf (KeygenMkgm3RowInit.rowPrelude++[lastRowLoop])) := rfl

theorem else_source : Exec elseRow before ⟨after,.normal⟩ := by
  rw [else_shape]
  apply C99ModularReference.GenExec.scope names _ before ⟨SelectedGeneratorRowLoop179.after,.normal⟩
  exact ModularSequence178.source _ _ _ _
    (GeneratorRowPrelude179.source before SelectedGeneratorSquare178.g1 SelectedGeneratorInverseCall178.ig
      SelectedTopInit178.p SelectedTopInit178.p0i SelectedGeneratorRowPrelude179.input)
    [lastRowLoop] _ (.seqNormal _ _ SelectedGeneratorRowLoop179.before SelectedGeneratorRowLoop179.after _
      SelectedGeneratorRowLoop179.source (.base .skip _ _ (.skip _)))

theorem source : Exec rowSelect before ⟨after,.normal⟩ :=
  .branchFalse _ _ _ before ⟨after,.normal⟩ (.int32 0)
    (.compare .eq _ _ _ _ _ (.variable _ _ _ SelectedGeneratorRowPrelude179.input.logn) (.literal .int32 1)
      (.step .eq (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl))
    rfl else_source

theorem continue_generator (out : C99ProcedureReference.Result) (rest : Exec (chainOf remaining) after out) :
    Exec KeygenMkgm3Program.code SelectedGeneratorEntry178.entry out :=
  SelectedGeneratorInverse178.continue_generator out (.seqNormal _ _ before after out source rest)

end FT1536.Source3.SelectedGeneratorRow179
