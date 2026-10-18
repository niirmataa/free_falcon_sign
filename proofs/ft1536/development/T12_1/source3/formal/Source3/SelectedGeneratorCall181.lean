import Source3.SelectedGeneratorTop181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorCall181
open C99ArrayReference (State)
open SelectedTopLayout177 (gm igm)
open KeygenFullData127 (rev)
open SelectedTopInit178 (p0i)

noncomputable def before := SelectedTopInit178.after
noncomputable def after : State := {before with heap:=SelectedGeneratorTop181.after.heap}

theorem source : KeygenLevelCalls.Call .generate before TopInitShape178.args after :=
  SelectedGeneratorEntry178.source_call ⟨SelectedGeneratorTop181.after,.normal⟩
    SelectedGeneratorTop181.body_source .voidEnd

theorem instruction : KeygenLevelExec.Exec TopInitShape178.generate before ⟨after,.normal⟩ :=
  .call .generate TopInitShape178.args before after source

theorem forward_table : KeygenMkgm3Table.Initialized after.heap gm :=
  (KeygenMkgm3Assembly.source_table SelectedGeneratorEntry178.entry ⟨SelectedGeneratorTop181.after,.normal⟩
    p0i gm igm rev ⟨rfl,rfl⟩ rfl rfl rfl ⟨rfl,rfl⟩ SelectedGeneratorEntry178.rev_binding
    SelectedGeneratorEntry178.rev_source (by decide) (by decide) SelectedGeneratorRowTable179.separate
    (KeygenNinv31.source_exists KeygenNinv31.prime) SelectedGeneratorTop181.body_source).2

theorem both_initialized : GeneratorSquareDomains181.From after.heap gm igm 0 := SelectedGeneratorTop181.initialized

theorem continue_top (out : C99ProcedureReference.Result)
    (rest : KeygenLevelExec.Exec TopInitShape178.remaining after out) :
    KeygenLevelExec.Exec KeygenMakeFgTop.code SelectedMakeFgTopEntry176.entry out :=
  SelectedTopInit178.continue_top out (.seqNormal _ _ before after out instruction rest)

end FT1536.Source3.SelectedGeneratorCall181
