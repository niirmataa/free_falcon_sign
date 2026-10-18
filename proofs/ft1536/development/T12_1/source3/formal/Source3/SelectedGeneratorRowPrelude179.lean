import Source3.GeneratorRowPreludeFacts179
import Source3.GeneratorRowLoop179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorRowPrelude179
open C99ArrayReference (State)
open C99ModularReference (Exec chainOf)
open KeygenModpR2Exec (Slot)
open SelectedTopInit178 (p p0i)
open SelectedGeneratorSquare178 (g1)
open SelectedGeneratorInverseCall178 (ig)

noncomputable def before := SelectedGeneratorInverseCall178.after
noncomputable def after := GeneratorRowPrelude179.after before g1 ig p p0i

theorem keep (name : C99ArrayReference.Name)
    (outside : name∉KeygenMkgm3Control.writes (chainOf SelectedGeneratorInverse178.steps)) :
    before.locals name=SelectedGeneratorEntry178.entry.locals name :=
  (KeygenMkgm3Control.frame _ _ _ (by decide) SelectedGeneratorInverse178.prefix_source).2.2 name outside

theorem input : GeneratorRowPrelude179.Input before g1 ig p p0i :=
  ⟨SelectedGeneratorInverseFacts178.g_cell,SelectedGeneratorInverseFacts178.ig_cell,
    (keep _ (by decide)).trans rfl,(keep _ (by decide)).trans rfl,(keep _ (by decide)).trans rfl,
    some (.uint32 12),SelectedGeneratorInverseFacts178.k_cell⟩

theorem source : Exec (chainOf KeygenMkgm3RowInit.rowPrelude) before ⟨after,.normal⟩ :=
  GeneratorRowPreludeFacts179.source before g1 ig p p0i input

theorem heap : after.heap=SelectedGeneratorEntry178.entry.heap :=
  (GeneratorRowPreludeFacts179.heap before g1 ig p p0i input).trans SelectedGeneratorInverseFacts178.heap

theorem arrays : after.arrays=SelectedGeneratorEntry178.entry.arrays :=
  (GeneratorRowPreludeFacts179.arrays before g1 ig p p0i input).trans
    (KeygenMkgm3Control.frame _ _ _ (by decide) SelectedGeneratorInverse178.prefix_source).2.1

theorem u_before : before.locals "u".toList=some (.uint64,none) := by
  have fromInverse := ModularAtoms178.outside SelectedGeneratorInverseCall178.before "ig" "u" ig (by decide)
  have fromSquare := (KeygenMkgm3Control.frame _ _ _ (by decide)
    (ModularSequence178.complete _ _ _ _ SelectedGeneratorSquare178.source)).2.2 "u".toList (by decide)
  have fromScalar := (KeygenMkgm3Control.frame _ _ _ (by decide)
    (ModularSequence178.complete _ _ _ _ SelectedGeneratorScalar178.source)).2.2 "u".toList (by decide)
  exact fromInverse.trans (fromSquare.trans (fromScalar.trans rfl))

theorem u_declared : after.locals "u".toList=some (.uint64,none) :=
  (GeneratorRowPreludeFacts179.u_cell before g1 ig p p0i input).trans u_before

end FT1536.Source3.SelectedGeneratorRowPrelude179
