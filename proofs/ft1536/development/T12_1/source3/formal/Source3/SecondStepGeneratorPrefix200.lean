import Source3.SecondStepGenerator200

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepGeneratorPrefix200
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open KeygenMakeFgSource (Exec)
open KeygenSmallOutput (element)
open SecondStepLayout197 (gm igm)
open SecondStepLengths197 (caller)

def fragment : KeygenMakeFgSource.Stmt :=
  .seq (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
    (.seq StepPrimeShape188.initial (MakeFgSequence187.append StepPrimeShape188.prefixSteps
      (.seq StepPrimeShape188.generateBranch KeygenMakeFgSource.skip)))

theorem source : ∃ (callee : State) (out : State) (gvs ivs : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepEntry196.entry (caller callee)) ∧
    Exec fragment (SecondStepEntry196.entry (caller callee)) ⟨out,.normal⟩ ∧
    (∀ i, Load32 out.heap (element gm i.val) (gvs i)) ∧
    (∀ i, Load32 out.heap (element igm i.val) (ivs i)) := by
  obtain ⟨callee,oldWords,firstRun,binding,prefixRun,fImage,gImage⟩ := SecondStepPrefix197.source
  obtain ⟨out,gvs,ivs,generator,locals,arrays,gRead,iRead⟩ := SecondStepGenerator200.source callee firstRun
  have inner : Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps
      (.seq StepPrimeShape188.generateBranch KeygenMakeFgSource.skip)) (SecondStepPrime200.initial callee)
      ⟨out,.normal⟩ := SecondStepPrime200.append_source callee firstRun _ _
    (.seqNormal _ _ (SecondStepGenerator200.before callee) out _ generator (SelectedStepAddPrime195.skip_run out))
  exact ⟨callee,out,gvs,ivs,firstRun,binding,
    .seqNormal _ _ _ (SecondStepMove197.after callee) _ prefixRun
      (.seqNormal _ _ _ (SecondStepPrime200.initial callee) _ (SecondStepPrime200.initial_source callee) inner),gRead,iRead⟩

end FT1536.Source3.SecondStepGeneratorPrefix200
