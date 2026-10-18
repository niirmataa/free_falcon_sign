import Source3.Gen0RowPreludeFacts189
import Source3.Gen0RowLoop189
import Source3.Gen0RawInitialized189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGen0Prelude189
open C99ArrayReference (State)
open C99ModularReference (Exec chainOf)
open SelectedTopInit178 (p p0i)
open StepGeneratorSquare188 (g1)
open StepGeneratorInverseCall188 (ig)

noncomputable abbrev before := StepGeneratorInverseCall188.after
noncomputable def after := Gen0RowPrelude189.after before g1 ig p p0i

theorem input : Gen0RowPrelude189.Input before g1 ig p p0i :=
  ⟨StepGeneratorReady188.g_cell,StepGeneratorReady188.ig_cell,StepGeneratorReady188.p_cell,
    StepGeneratorReady188.i_cell,StepGeneratorReady188.logn_cell,some (.uint32 12),StepGeneratorReady188.k_cell⟩

theorem source : Exec (chainOf KeygenMkgm3RowInit.rowPrelude) before ⟨after,.normal⟩ :=
  Gen0RowPreludeFacts189.source before g1 ig p p0i input

theorem heap : after.heap=SelectedStepMove187.after.heap :=
  (Gen0RowPreludeFacts189.heap before g1 ig p p0i input).trans StepGeneratorReady188.heap

theorem arrays : after.arrays=before.arrays := Gen0RowPreludeFacts189.arrays before g1 ig p p0i input

theorem u_declared : after.locals "u".toList=some (.uint64,none) :=
  (Gen0RowPreludeFacts189.u_cell before g1 ig p p0i input).trans StepGeneratorReady188.u_declared

end FT1536.Source3.SelectedGen0Prelude189
