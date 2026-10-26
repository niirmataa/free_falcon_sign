import Source3.StepAddBody195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepAddConcrete195
open C99ArrayReference (State Name)
open C99MemoryReference (Load32 Allocated)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open SelectedStepLayout187 (fd gd fs gs gm igm t1)
open KeygenFullData127 (primes rev)
open StepCopyBody190 (elem)
open StepAddReady195 (Entry)

noncomputable def inputF (i : Fin 512) : BitVec 32 :=
  ZintNormWord194.normWord SelectedTopInit178.p (SelectedStepCrtRun194.fsWords i.val)
noncomputable def inputG (i : Fin 512) : BitVec 32 :=
  ZintNormWord194.normWord SelectedTopInit178.p (SelectedStepCrtRun194.gsWords i.val)

theorem entry : ∃ (next final : State),
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨next,.normal⟩ ∧
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 3) next ⟨final,.normal⟩ ∧
    Entry final inputF inputG := by
  obtain ⟨next,final,part2,part3,fLoads,gLoads,keep,locals,arrays,tables⟩ := StepAddEntry195.crt_source
  obtain ⟨prior,next2,fullRun,loopRun,part2b,uCell,nCell,hnCell,slenCell,tlenCell,lognCell,
    terCell,inCell,outCell,localsExit,arraysExit,xCell,fsImage,fdImage,gsImage,gdImage,writable⟩ :=
    SelectedStepFsFd194.source
  have same : next2=next := congrArg C99ProcedureReference.Result.state
    (KeygenMakeFgDeterminism099.execution (KeygenMakeFgArity099.body .step) _ _ _ _
      KeygenMakeFgArity099.step2 part2b part2)
  subst next2
  have stable := KeygenMemoryStability.trans _ _ _ (KeygenHelperStability.make _ _ _ part2)
    (KeygenHelperStability.make _ _ _ part3)
  have preserves := C99InitializationTrace.preserves_trans _ _ _ (StepMemoryInit195.make _ _ _ part2)
    (StepMemoryInit195.make _ _ _ part3)
  have frame2 := KeygenMakeFgSource.frame _ _ _ part2 KeygenMakeFgSource.writable
    (KeygenMakeFgSource.part_checked .step 2 KeygenMakeFgSource.step_audit2) 0 0
    StepAddEntry195.initial_outside (StepAddEntry195.tables_zero _ StepAddEntry195.initial_tables)
  have table2 := frame2.2.1.trans StepAddEntry195.initial_tables
  have frame3 := KeygenMakeFgSource.frame _ _ _ part3 KeygenMakeFgSource.writable
    (KeygenMakeFgSource.part_checked .step 3 KeygenMakeFgSource.step_audit3) 0 0 frame2.1
    (StepAddEntry195.tables_zero _ table2)
  have primeBlock : KeygenMakeObjects.Block SelectedStepMove187.after.heap final.heap primes.block :=
    ⟨congrFun stable.size _,congrFun stable.writable _,
      fun offset => stable.readonly _ offset SelectedStepReady187.prime_object.2.2.2.1⟩
  have revBlock : KeygenMakeObjects.Block SelectedStepMove187.after.heap final.heap rev.block :=
    ⟨congrFun stable.size _,congrFun stable.writable _,
      fun offset => stable.readonly _ offset SelectedStepReady187.rev_source.1⟩
  have raw : GeneratorSquareDomains181.From SelectedStepMove187.after.heap gm igm 0 := by
    intro j lower upper
    obtain ⟨g,rg⟩ := Gen0RawInitialized189.copied_g j upper
    obtain ⟨i,ri⟩ := Gen0RawInitialized189.copied_i j upper
    exact ⟨NttReadFacts182.initialized _ _ _ rg,NttReadFacts182.initialized _ _ _ ri⟩
  refine ⟨next,final,part2,part3,?_,frame3.1,?_,?_,
    KeygenMakeEntry.prime_block _ _ _ primeBlock SelectedStepReady187.prime_object,
    KeygenMakeEntry.rev_block _ _ _ revBlock SelectedStepReady187.rev_source,
    GeneratorSquareDomains181.from_transport _ _ gm igm 0 preserves raw,
    ?_,?_,?_, ?_, ?_, ?_, ?_, ?_,?_,?_, ?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ⟩
  · exact frame3.2.1.trans table2
  · rw [stable.writable]; exact SelectedStepReady187.scratch_writable
  · intro i bound
    unfold Allocated
    rw [stable.size]
    exact SelectedStepMove187.allocated i bound
  · intro i; exact fLoads i.val i.isLt
  · intro i; exact gLoads i.val i.isLt
  · exact (congrFun locals "n".toList).trans nCell
  · exact (congrFun locals "hn".toList).trans hnCell
  · exact (congrFun locals "slen".toList).trans slenCell
  · exact (congrFun locals "tlen".toList).trans tlenCell
  · exact (congrFun locals "u".toList).trans uCell
  · exact (congrFun locals "logn".toList).trans lognCell
  · exact (congrFun locals "ter".toList).trans terCell
  · exact (congrFun locals "out_ntt".toList).trans outCell
  · exact (congrFun arrays "fd".toList).trans ((arraysExit "fd".toList (by decide)).trans SelectedGen0Ready189.fd_binding)
  · exact (congrFun arrays "gd".toList).trans ((arraysExit "gd".toList (by decide)).trans SelectedGen0Ready189.gd_binding)
  · exact (congrFun arrays "fs".toList).trans ((arraysExit "fs".toList (by decide)).trans SelectedGen0Ready189.fs_binding)
  · exact (congrFun arrays "gs".toList).trans ((arraysExit "gs".toList (by decide)).trans SelectedGen0Ready189.gs_binding)
  · exact (congrFun arrays "gm".toList).trans ((arraysExit "gm".toList (by decide)).trans SelectedGen0Ready189.gm_binding)
  · exact (congrFun arrays "igm".toList).trans ((arraysExit "igm".toList (by decide)).trans SelectedGen0Ready189.igm_binding)
  · exact (congrFun arrays "t1".toList).trans ((arraysExit "t1".toList (by decide)).trans SelectedGen0Ready189.t1_binding)
  · exact (congrFun arrays "primes".toList).trans ((arraysExit "primes".toList (by decide)).trans SelectedStepReady187.prime_binding)
end FT1536.Source3.StepAddConcrete195
