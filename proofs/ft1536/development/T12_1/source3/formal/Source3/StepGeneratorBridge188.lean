import Source3.StepGeneratorReady188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepGeneratorBridge188
open C99ArrayReference (State restoreScope)
open KeygenMakeFgSource (Exec)

noncomputable def returnedState (out : C99ProcedureReference.Result) : State :=
  {SelectedStepPrime188.after with heap:=out.state.heap}

theorem branch_source (out : C99ProcedureReference.Result)
    (rest : C99ModularReference.Exec (C99ModularReference.chainOf StepGeneratorPrefix188.remaining) StepGeneratorInverseCall188.after out)
    (returned : C99ProcedureReference.ReturnValue none out.flow none) :
    Exec StepPrimeShape188.generateBranch SelectedStepPrime188.after ⟨returnedState out,.normal⟩ := by
  have call := StepGeneratorEntry188.source_call out (StepGeneratorPrefix188.continue_generator out rest) returned
  have instruction : Exec StepPrimeShape188.generate SelectedStepPrime188.after ⟨returnedState out,.normal⟩ :=
    .level _ _ _ (.call .generate StepPrimeShape188.args SelectedStepPrime188.after (returnedState out) call)
  have scopedRun : Exec (.scope [] [] (.seq StepPrimeShape188.generate KeygenMakeFgSource.skip))
      SelectedStepPrime188.after ⟨returnedState out,.normal⟩ :=
    MakeFgScope187.source _ SelectedStepPrime188.after (returnedState out)
      (.seqNormal _ _ SelectedStepPrime188.after (returnedState out) _ instruction
        (MakeFgDeclarations176.array_source .skip (returnedState out) (returnedState out) (.skip (returnedState out))))
  exact .branchTrue _ _ _ SelectedStepPrime188.after ⟨returnedState out,.normal⟩ (.uint32 1)
    (.variable _ _ _ rfl) (by decide) scopedRun

theorem continue_inner (generatorOut out : C99ProcedureReference.Result)
    (generatorRest : C99ModularReference.Exec (C99ModularReference.chainOf StepGeneratorPrefix188.remaining)
      StepGeneratorInverseCall188.after generatorOut)
    (returned : C99ProcedureReference.ReturnValue none generatorOut.flow none)
    (rest : Exec StepPrimeShape188.tail (returnedState generatorOut) out) :
    Exec StepPrimeShape188.inner SelectedStepPrime188.initial out := by
  apply SelectedStepPrime188.continue_inner out
  rw [StepPrimeShape188.remaining_shape]
  exact .seqNormal _ _ SelectedStepPrime188.after (returnedState generatorOut) out (branch_source generatorOut generatorRest returned) rest

theorem scoped_iteration (out : State) (rest : Exec StepPrimeShape188.remaining SelectedStepPrime188.after ⟨out,.normal⟩) :
    Exec StepPrimeShape188.body SelectedStepPrime188.initial
      ⟨restoreScope SelectedStepPrime188.initial out StepPrimeShape188.localNames StepPrimeShape188.pointerNames,.normal⟩ := by
  rw [StepPrimeShape188.body_shape]
  exact .scope _ _ _ SelectedStepPrime188.initial ⟨out,.normal⟩ (SelectedStepPrime188.continue_inner _ rest)

end FT1536.Source3.StepGeneratorBridge188
