import Source3.SelectedStepMove187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedStepPrefix187
open KeygenMakeFgSource (Exec)
open SelectedStepMove187 (after)

theorem part_source : Exec (KeygenMakeFgSource.part .step 1) SelectedStepSizes187.before ⟨after,.normal⟩ := by
  rw [StepPrefixProgram187.shape]
  exact .seqNormal _ _ SelectedStepSizes187.before SelectedStepSizes187.withN _ SelectedStepSizes187.n_source
    (.seqNormal _ _ SelectedStepSizes187.withN SelectedStepSizes187.after _ SelectedStepSizes187.hn_source
      (.seqNormal _ _ SelectedStepSizes187.after SelectedStepLengths187.after _ SelectedStepLengths187.source
        (MakeFgSequence187.source StepPrefixProgram187.pointers SelectedStepLayout187.before SelectedStepLayout187.after
          SelectedStepLayout187.pointers _ ⟨after,.normal⟩
          (.seqNormal _ _ SelectedStepMove187.before after _ SelectedStepMove187.source
            (MakeFgDeclarations176.array_source .skip after after (.skip after))))))

def remaining := KeygenMakeFgSource.chain [KeygenMakeFgSource.part .step 2,KeygenMakeFgSource.part .step 3,KeygenMakeFgSource.part .step 4]

theorem continue_step (out : C99ProcedureReference.Result) (rest : Exec remaining after out) :
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry out :=
  .seqNormal _ _ FirstStepEntry187.entry SelectedStepSizes187.before out (StepDeclarations187.source FirstStepEntry187.entry)
    (.seqNormal _ _ SelectedStepSizes187.before after out part_source rest)

end FT1536.Source3.SelectedStepPrefix187
