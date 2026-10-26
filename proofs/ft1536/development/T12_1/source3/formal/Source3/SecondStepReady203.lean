import Source3.SecondStepColumn203

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepReady203
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open KeygenMakeFgSource (Exec)
open SecondStepLayout197 (fs gs gm igm)
open SelectedTopInit178 (p p0i r2)
open StepCopyBody190 (elem)
open SecondStepBasic203 (Basic)

theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (gvs ivs : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ∧
    Exec SecondStepGeneratorPrefix200.fragment (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ⟨out,.normal⟩ ∧
    Basic out 0 p p0i r2 ∧ out.locals "v".toList=some (.uint64,none) ∧
    (∀ i, Load32 out.heap (elem gm i.val) (gvs i)) ∧
    (∀ i, Load32 out.heap (elem igm i.val) (ivs i)) ∧
    StepNttImage195.Image out fs (StepFirstImage196.fdWords oldWords) ∧
    StepNttImage195.Image out gs (StepFirstImage196.gdWords oldWords) := by
  obtain ⟨callee,oldWords,firstRun,binding,prefixRun,fImage,gImage⟩ := SecondStepPrefix197.source
  obtain ⟨out,gvs,ivs,generator,locals,arrays,gRead,iRead,fd,gd⟩ :=
    SecondStepGeneratorKeep203.source callee firstRun _ _ fImage gImage
  have basic := SecondStepBasic203.transport (SecondStepBasic203.prime_before callee firstRun) generator
    (fun name _ => congrFun locals name) (fun name _ => congrFun arrays name)
  have v : out.locals "v".toList=some (.uint64,none) := (congrFun locals "v".toList).trans rfl
  have inner : Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps
      (.seq StepPrimeShape188.generateBranch KeygenMakeFgSource.skip)) (SecondStepPrime200.initial callee)
      ⟨out,.normal⟩ := SecondStepPrime200.append_source callee firstRun _ _
    (.seqNormal _ _ (SecondStepGenerator200.before callee) out _ generator (SelectedStepAddPrime195.skip_run out))
  exact ⟨callee,out,oldWords,gvs,ivs,firstRun,binding,
    .seqNormal _ _ _ (SecondStepMove197.after callee) _ prefixRun
      (.seqNormal _ _ _ (SecondStepPrime200.initial callee) _ (SecondStepPrime200.initial_source callee) inner),
    basic,v,gRead,iRead,fd,gd⟩

end FT1536.Source3.SecondStepReady203
