import Source3.SelectedGen0Top189
import Source3.StepGeneratorBridge188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGen0Call189
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)

noncomputable abbrev before := SelectedStepPrime188.after
noncomputable def after : State := {before with heap:=SelectedGen0Top189.after.heap}

theorem source : KeygenLevelCalls.Call .generate before StepPrimeShape188.args after :=
  StepGeneratorEntry188.source_call ⟨SelectedGen0Top189.after,.normal⟩ SelectedGen0Top189.body_source .voidEnd

theorem instruction : Exec StepPrimeShape188.generate before ⟨after,.normal⟩ :=
  .level _ _ _ (.call .generate StepPrimeShape188.args before after source)

theorem branch_source : Exec StepPrimeShape188.generateBranch before ⟨after,.normal⟩ :=
  StepGeneratorBridge188.branch_source ⟨SelectedGen0Top189.after,.normal⟩ SelectedGen0Top189.remainder_source .voidEnd

theorem continue_inner (out : C99ProcedureReference.Result) (rest : Exec StepPrimeShape188.tail after out) :
    Exec StepPrimeShape188.inner SelectedStepPrime188.initial out :=
  StepGeneratorBridge188.continue_inner ⟨SelectedGen0Top189.after,.normal⟩ out SelectedGen0Top189.remainder_source .voidEnd rest

end FT1536.Source3.SelectedGen0Call189
