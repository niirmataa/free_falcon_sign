import Source3.SecondStepMove197

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepPrefix197
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open SecondStepLengths197 (caller)
open SecondStepLayout197 (fd gd fs gs gm igm t1)

/-- The actual d=2 part 1 after its declarations, with the overlapping copy. -/
theorem part1 (callee : State) (gvs : Fin 512 → BitVec 32)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fImage : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs))
    (gImage : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs)) :
    Exec (KeygenMakeFgSource.part .step 1) (SecondStepStart196.declared (caller callee))
      ⟨SecondStepMove197.after callee,.normal⟩ := by
  apply SecondStepStart196.part1_continue (caller callee)
  exact .seqNormal _ _ (SecondStepLengths197.before callee) (SecondStepLengths197.after callee) _
    (SecondStepLengths197.source callee run)
    (MakeFgSequence187.source StepPrefixProgram187.pointers (SecondStepLayout197.before callee)
      (SecondStepLayout197.after callee) (SecondStepLayout197.pointers callee) _ _
      (.seqNormal _ _ (SecondStepMove197.before callee) (SecondStepMove197.after callee) _
        (SecondStepMove197.move_source callee gvs run fImage gImage) (SelectedStepAddPrime195.skip_run _)))

theorem prefix_run (callee : State) (gvs : Fin 512 → BitVec 32)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fImage : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs))
    (gImage : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs)) :
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (SecondStepEntry196.entry (caller callee)) ⟨SecondStepMove197.after callee,.normal⟩ :=
  .seqNormal _ _ _ (SecondStepStart196.declared (caller callee)) _
    (StepDeclarations187.source _) (part1 callee gvs run fImage gImage)

/-- Concrete first execution and its actual next call's complete layout/move prefix. -/
theorem source : ∃ (callee : State) (gvs : Fin 512 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepEntry196.entry (caller callee)) ∧
    Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (SecondStepEntry196.entry (caller callee)) ⟨SecondStepMove197.after callee,.normal⟩ ∧
    StepNttImage195.Image (SecondStepMove197.after callee) fs (StepFirstImage196.fdWords gvs) ∧
    StepNttImage195.Image (SecondStepMove197.after callee) gs (StepFirstImage196.gdWords gvs) := by
  obtain ⟨callee,gvs,run,fImage,gImage⟩ := StepFirstImage196.source
  have data : (caller callee).arrays "data".toList=some SelectedMakeFgSetup176.ft :=
    SelectedTopContinuation186.data_binding
  have logn : KeygenModpR2Exec.Slot (caller callee) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 2 (by decide)).trans SelectedTopContinuation186.logn_cell
  have depth : KeygenModpR2Exec.Slot (caller callee) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  exact ⟨callee,gvs,run,SecondStepEntry196.binding _ data logn (FirstStepReturn196.d_two _) depth,
    prefix_run callee gvs run fImage gImage,SecondStepMove197.f_image callee gvs run fImage gImage,
    SecondStepMove197.g_image callee gvs run fImage gImage⟩

end FT1536.Source3.SecondStepPrefix197
