import Source3.StepAddSectionKeep196

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepFirstColumns196
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open Word32Memory176 (Separate)
open SelectedStepLayout187 (fd gd fs gs gm)
open StepCopyBody190 (addr elem)
open SelectedTopInit178 (p p0i r2)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open StepAddBody195 (resultWords)

/-- Both old product columns at the same concrete CRT exit used by 578. -/
theorem crt_columns : ∃ (after2 after3 : State),
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨after2,.normal⟩ ∧
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 3) after2 ⟨after3,.normal⟩ ∧
    StepAddReady195.Entry after3 StepAddConcrete195.inputF StepAddConcrete195.inputG ∧
    StepProductFixed191.Image after3 fd 0 2 256 p p0i r2 SelectedStepProduct191.fvs 256 ∧
    StepProductFixed191.Image after3 gd 0 2 256 p p0i r2 SelectedStepChainKeep194.gvs 256 := by
  obtain ⟨after2,after3,part2,part3,ready⟩ := StepAddConcrete195.entry
  obtain ⟨a2,a3,run2,run3,fLoads,gLoads,keep,locals,arrays,tables⟩ := StepAddEntry195.crt_source
  have same2 : a2=after2 := congrArg C99ProcedureReference.Result.state
    (KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step) _ _ _ _
      KeygenMakeFgArity099.step2 run2 part2)
  subst a2
  have same3 : a3=after3 := congrArg C99ProcedureReference.Result.state
    (KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step) _ _ _ _
      KeygenMakeFgArity099.step3 run3 part3)
  subst a3
  obtain ⟨prior,b2,fullRun,loopRun,part2b,uCell,nCell,hnCell,slenCell,tlenCell,lognCell,
    terCell,inCell,outCell,localsExit,arraysExit,xCell,fsImage,fdImage,gsImage,gdImage,writable⟩ :=
    SelectedStepFsFd194.source
  have same : b2=after2 := congrArg C99ProcedureReference.Result.state
    (KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step) _ _ _ _
      KeygenMakeFgArity099.step2 part2b part2)
  subst b2
  refine ⟨after2,after3,part2,part3,ready,?_,?_⟩
  · intro i bound
    apply keep _ _ _ _ _ (fdImage i bound)
    · change 31≠31 ∨ (0+4*(670+0+i.val*2))+4≤0+4*2718 ∨
        (0+4*2718)+4≤0+4*(670+0+i.val*2)
      omega
    · intro j hj
      change 31≠31 ∨ (0+4*(1694+j))+4≤0+4*(670+0+i.val*2) ∨
        (0+4*(670+0+i.val*2))+4≤0+4*(1694+j)
      omega
    · intro j hj
      change 31≠31 ∨ (0+4*(2206+j))+4≤0+4*(670+0+i.val*2) ∨
        (0+4*(670+0+i.val*2))+4≤0+4*(2206+j)
      omega
  · intro i bound
    apply keep _ _ _ _ _ (gdImage i bound)
    · change 31≠31 ∨ (0+4*(1182+0+i.val*2))+4≤0+4*2718 ∨
        (0+4*2718)+4≤0+4*(1182+0+i.val*2)
      omega
    · intro j hj
      change 31≠31 ∨ (0+4*(1694+j))+4≤0+4*(1182+0+i.val*2) ∨
        (0+4*(1182+0+i.val*2))+4≤0+4*(1694+j)
      omega
    · intro j hj
      change 31≠31 ∨ (0+4*(2206+j))+4≤0+4*(1182+0+i.val*2) ∨
        (0+4*(1182+0+i.val*2))+4≤0+4*(2206+j)
      omega

/-- The two primes' fd/gd columns all survive to the same part-4 exit. -/
theorem source : ∃ (after2 after3 out : State) (gvs : Fin 512 → BitVec 32),
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨after2,.normal⟩ ∧
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 3) after2 ⟨after3,.normal⟩ ∧
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 4) after3 ⟨out,.normal⟩ ∧
    StepProductFixed191.Image out fd 0 2 256 p p0i r2 SelectedStepProduct191.fvs 256 ∧
    StepProductFixed191.Image out gd 0 2 256 p p0i r2 SelectedStepChainKeep194.gvs 256 ∧
    StepProductFixed191.Image out fd 1 2 256 p1 p0i1 r21 (resultWords StepAddConcrete195.inputF gvs) 256 ∧
    StepProductFixed191.Image out gd 1 2 256 p1 p0i1 r21 (resultWords StepAddConcrete195.inputG gvs) 256 := by
  obtain ⟨after2,after3,part2,part3,ready,fd0,gd0⟩ := crt_columns
  obtain ⟨out,gvs,part4,uCell,fd1,gd1,keep⟩ := StepAddSectionKeep196.part4_keep
    after3 StepAddConcrete195.inputF StepAddConcrete195.inputG ready
  refine ⟨after2,after3,out,gvs,part2,part3,part4,?_,?_,fd1,gd1⟩
  · intro i bound
    apply keep _ rfl _ _ _ _ (fd0 i bound)
    · change 0+4*(670+0+i.val*2)+4≤0+4*2718
      omega
    · intro j hj
      change 31≠31 ∨ (0+4*(670+1+j*2))+4≤0+4*(670+0+i.val*2) ∨
        (0+4*(670+0+i.val*2))+4≤0+4*(670+1+j*2)
      omega
    · intro j hj
      change 31≠31 ∨ (0+4*(1182+1+j*2))+4≤0+4*(670+0+i.val*2) ∨
        (0+4*(670+0+i.val*2))+4≤0+4*(1182+1+j*2)
      omega
  · intro i bound
    apply keep _ rfl _ _ _ _ (gd0 i bound)
    · change 0+4*(1182+0+i.val*2)+4≤0+4*2718
      omega
    · intro j hj
      change 31≠31 ∨ (0+4*(670+1+j*2))+4≤0+4*(1182+0+i.val*2) ∨
        (0+4*(1182+0+i.val*2))+4≤0+4*(670+1+j*2)
      omega
    · intro j hj
      change 31≠31 ∨ (0+4*(1182+1+j*2))+4≤0+4*(1182+0+i.val*2) ∨
        (0+4*(1182+0+i.val*2))+4≤0+4*(1182+1+j*2)
      omega

end FT1536.Source3.StepFirstColumns196
