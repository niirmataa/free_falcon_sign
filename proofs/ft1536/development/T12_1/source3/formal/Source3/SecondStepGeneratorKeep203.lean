import Source3.MkgmCallKeep203
import Source3.SecondStepGeneratorPrefix200

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepGeneratorKeep203
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open KeygenSmallOutput (element)
open SecondStepLayout197 (fs gs gm igm)
open KeygenFullData127 (rev)
open SelectedTopInit178 (p p0i)
open SecondStepGenerator200 (before)

/-- Both moved source arrays precede both generator output roots. -/
theorem source_outside (j : Nat) (bound : j<512) :
    MkgmCallKeep203.Outside gm (element fs j) ∧ MkgmCallKeep203.Outside igm (element fs j) ∧
    MkgmCallKeep203.Outside gm (element gs j) ∧ MkgmCallKeep203.Outside igm (element gs j) := by
  refine ⟨?_,?_,?_,?_⟩
  · intro byte
    right; left
    change 0+4*(1438+j)+byte.val<0+4*2462
    have b:=byte.isLt
    omega
  · intro byte
    right; left
    change 0+4*(1438+j)+byte.val<0+4*2718
    have b:=byte.isLt
    omega
  · intro byte
    right; left
    change 0+4*(1950+j)+byte.val<0+4*2462
    have b:=byte.isLt
    omega
  · intro byte
    right; left
    change 0+4*(1950+j)+byte.val<0+4*2718
    have b:=byte.isLt
    omega

theorem source (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fv gv : Nat → BitVec 32)
    (fImage : StepNttImage195.Image (SecondStepMove197.after callee) fs fv)
    (gImage : StepNttImage195.Image (SecondStepMove197.after callee) gs gv) :
    ∃ (out : State) (gvs ivs : Fin 256 → BitVec 32),
      Exec StepPrimeShape188.generateBranch (before callee) ⟨out,.normal⟩ ∧
      out.locals=(before callee).locals ∧ out.arrays=(before callee).arrays ∧
      (∀ i, Load32 out.heap (element gm i.val) (gvs i)) ∧
      (∀ i, Load32 out.heap (element igm i.val) (ivs i)) ∧
      StepNttImage195.Image out fs fv ∧ StepNttImage195.Image out gs gv := by
  obtain ⟨out,exec,locals,arrays,reads,keeps⟩ := MkgmCallKeep203.branch_source 7 (before callee) gm igm rev
    KeygenFirstPrime.generator p p0i (SecondStepGenerator200.input callee run) rfl
  have gRead (i : Fin 256) : ∃ w, Load32 out.heap (element gm i.val) w := (reads i.val i.isLt).1
  have iRead (i : Fin 256) : ∃ w, Load32 out.heap (element igm i.val) w := (reads i.val i.isLt).2
  refine ⟨out,(fun i => Classical.choose (gRead i)),(fun i => Classical.choose (iRead i)),exec,locals,arrays,
    (fun i => Classical.choose_spec (gRead i)),(fun i => Classical.choose_spec (iRead i)),?_,?_⟩
  · intro j bound
    apply keeps (element fs j) (source_outside j bound).1 (source_outside j bound).2.1
    rw [SecondStepPrime200.heap]
    exact fImage j bound
  · intro j bound
    apply keeps (element gs j) (source_outside j bound).2.2.1 (source_outside j bound).2.2.2
    rw [SecondStepPrime200.heap]
    exact gImage j bound

theorem prefix_source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (gvs ivs : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ∧
    Exec SecondStepGeneratorPrefix200.fragment (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ⟨out,.normal⟩ ∧
    (∀ i, Load32 out.heap (element gm i.val) (gvs i)) ∧
    (∀ i, Load32 out.heap (element igm i.val) (ivs i)) ∧
    StepNttImage195.Image out fs (StepFirstImage196.fdWords oldWords) ∧
    StepNttImage195.Image out gs (StepFirstImage196.gdWords oldWords) := by
  obtain ⟨callee,oldWords,firstRun,binding,prefixRun,fImage,gImage⟩ := SecondStepPrefix197.source
  obtain ⟨out,gvs,ivs,generator,locals,arrays,gRead,iRead,fd,gd⟩ := source callee firstRun _ _ fImage gImage
  have inner : Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps
      (.seq StepPrimeShape188.generateBranch KeygenMakeFgSource.skip)) (SecondStepPrime200.initial callee)
      ⟨out,.normal⟩ := SecondStepPrime200.append_source callee firstRun _ _
    (.seqNormal _ _ (before callee) out _ generator (SelectedStepAddPrime195.skip_run out))
  exact ⟨callee,out,oldWords,gvs,ivs,firstRun,binding,
    .seqNormal _ _ _ (SecondStepMove197.after callee) _ prefixRun
      (.seqNormal _ _ _ (SecondStepPrime200.initial callee) _ (SecondStepPrime200.initial_source callee) inner),
    gRead,iRead,fd,gd⟩

end FT1536.Source3.SecondStepGeneratorKeep203
