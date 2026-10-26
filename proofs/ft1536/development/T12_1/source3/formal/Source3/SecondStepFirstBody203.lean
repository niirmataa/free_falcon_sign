import Source3.SecondStepPair203
import Source3.SecondStepFirstColumn203

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepFirstBody203
open C99ArrayReference (State Name restoreScope)
open C99MemoryReference (Load32)
open KeygenMakeFgSource (Exec)
open KeygenNttLoopSupport (USlot)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (addr elem)
open SecondStepLayout197 (fd gd fs gs igm)
open SelectedTopInit178 (p p0i r2)
open SecondStepBasic203 (Basic)
open SecondStepFirstColumn203 (tableWord inputWord)
open NttInverseWholeBridges201 (scaledWord)

noncomputable def gInputWord (oldWords : Fin 512 → BitVec 32) (j : Nat) := StepFirstImage196.gdWords oldWords (j*2)

theorem inner_source (callee : State) (oldWords : Fin 512 → BitVec 32)
    (firstRun : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fOld : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords oldWords))
    (gOld : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords oldWords)) :
    ∃ (out : State) (ivs : Fin 256 → BitVec 32),
      Exec StepPrimeShape188.inner (SecondStepPrime200.initial callee) ⟨out,.normal⟩ ∧ Basic out 0 p p0i r2 ∧
      StepProductFixed203.Image out fd 0 3 128 p p0i r2 (inputWord oldWords) 128 ∧
      StepProductFixed203.Image out gd 0 3 128 p p0i r2 (gInputWord oldWords) 128 ∧
      (∀ j<256, Load32 out.heap (addr fs 0 j 2) (scaledWord 7 (inputWord oldWords) (tableWord ivs) p p0i j)) ∧
      (∀ j<256, Load32 out.heap (addr gs 0 j 2) (scaledWord 7 (gInputWord oldWords) (tableWord ivs) p p0i j)) := by
  have movedF:=SecondStepMove197.f_image callee oldWords firstRun fOld gOld
  have movedG:=SecondStepMove197.g_image callee oldWords firstRun fOld gOld
  obtain ⟨generated,gvs,ivs,generator,locals,arrays,gRead,iRead,fImage,gImage⟩ :=
    SecondStepGeneratorKeep203.source callee firstRun _ _ movedF movedG
  have basic:=SecondStepBasic203.transport (SecondStepBasic203.prime_before callee firstRun) generator
    (fun name _ => congrFun locals name) (fun name _ => congrFun arrays name)
  have v : generated.locals "v".toList=some (.uint64,none) := (congrFun locals "v".toList).trans rfl
  have twLoads : ∀ k<256, Load32 generated.heap (elem igm k) (tableWord ivs k) := by
    intro k bound
    simpa only [tableWord,Nat.mod_eq_of_lt bound,KeygenSmallOutput.element,StepCopyBody190.elem] using iRead ⟨k,bound⟩
  have fData : ∀ j<256, Load32 generated.heap (addr fs 0 j 2) (inputWord oldWords j) := by
    intro j bound
    change Load32 generated.heap (elem fs (j*2)) (StepFirstImage196.fdWords oldWords (j*2))
    exact fImage (j*2) (by omega)
  have gData : ∀ j<256, Load32 generated.heap (addr gs 0 j 2) (gInputWord oldWords j) := by
    intro j bound
    change Load32 generated.heap (elem gs (j*2)) (StepFirstImage196.gdWords oldWords (j*2))
    exact gImage (j*2) (by omega)
  obtain ⟨out,tailRun,outBasic,_,fProduct,gProduct,fResult,gResult,_,_⟩ :=
    SecondStepPair203.source generated 0 p p0i r2 basic (by decide) (tableWord ivs)
      (inputWord oldWords) (gInputWord oldWords) twLoads fData gData none v
  have inner : Exec StepPrimeShape188.inner (SecondStepPrime200.initial callee) ⟨out,.normal⟩ := by
    apply SecondStepPrime200.continue_inner callee firstRun
    rw [StepPrimeShape188.remaining_shape]
    exact .seqNormal _ _ (SecondStepGenerator200.before callee) generated _ generator tailRun
  exact ⟨out,ivs,inner,outBasic,fProduct,gProduct,fResult,gResult⟩

def bodyState (before out : State) := restoreScope before out StepPrimeShape188.localNames StepPrimeShape188.pointerNames
def next (before out : State) := FftLocalCells140.put (bodyState before out) "u".toList (C99NatWord141.word 1)

theorem scope_heap (before out : State) : (bodyState before out).heap=out.heap := rfl
theorem next_heap (before out : State) : (next before out).heap=out.heap := rfl

theorem scope_locals (before out : State) (name : Name) (absent : name∉StepPrimeShape188.localNames) :
    (bodyState before out).locals name=out.locals name := by
  simp only [bodyState,restoreScope,C99ScalarReference.restore,List.contains_iff_mem,absent,ite_false]

theorem scope_source (s out : State) (run : Exec StepPrimeShape188.inner s ⟨out,.normal⟩) :
    Exec StepPrimeShape188.body s ⟨bodyState s out,.normal⟩ := by
  rw [StepPrimeShape188.body_shape]
  exact .scope _ _ _ s ⟨out,.normal⟩ run

theorem increment (before out : State) (u : Cell out "u".toList 0) :
    Exec StepPrimeShape188.increment (bodyState before out) ⟨next before out,.normal⟩ := by
  have cell : Cell (bodyState before out) "u".toList 0 := (scope_locals before out "u".toList (by decide)).trans u
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (MakeFgTailShape190.num 1))) (bodyState before out) (next before out) := by
    cases C99LoopScalar141.increment (fun _ => none) (bodyState before out) "u".toList 0 (by omega) cell with
    | base _ _ _ source => exact source
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem next_u (before out : State) : Cell (next before out) "u".toList 1 := FftLocalCells140.cell_at _ _ _

theorem next_guard (before out : State) (slen : Cell out "slen".toList 2) :
    C99ArrayReference.scalar (next before out) StepPrimeShape188.condition (.int32 1) := by
  have kept : Cell (next before out) "slen".toList 2 :=
    (FftLocalCells140.outside (bodyState before out) "u".toList "slen".toList _ (by decide)).trans
      ((scope_locals before out "slen".toList (by decide)).trans slen)
  exact .compare .lt _ _ _ _ _ (.variable _ _ _ (next_u before out)) (.variable _ _ _ kept)
    (.step .lt (.uint64 1) (.uint64 2) .uint64 rfl (.uint64 1) (.uint64 2) rfl rfl)

def fragment : KeygenMakeFgSource.Stmt :=
  .seq (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
    (.seq StepPrimeShape188.initial (.seq StepPrimeShape188.body StepPrimeShape188.increment))

theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ∧
    Exec fragment (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ⟨out,.normal⟩ ∧
    C99ArrayReference.scalar (SecondStepPrime200.initial callee) StepPrimeShape188.condition (.int32 1) ∧
    C99ArrayReference.scalar out StepPrimeShape188.condition (.int32 1) ∧ Cell out "u".toList 1 ∧
    StepProductFixed203.Image out fd 0 3 128 p p0i r2 (inputWord oldWords) 128 ∧
    StepProductFixed203.Image out gd 0 3 128 p p0i r2 (gInputWord oldWords) 128 ∧
    (∀ j<256, Load32 out.heap (addr fs 0 j 2) (scaledWord 7 (inputWord oldWords) (tableWord ivs) p p0i j)) ∧
    (∀ j<256, Load32 out.heap (addr gs 0 j 2) (scaledWord 7 (gInputWord oldWords) (tableWord ivs) p p0i j)) := by
  obtain ⟨callee,oldWords,firstRun,fOld,gOld⟩ := StepFirstImage196.source
  obtain ⟨inner,ivs,innerRun,basic,fProduct,gProduct,fImage,gImage⟩ := inner_source callee oldWords firstRun fOld gOld
  let initial:=SecondStepPrime200.initial callee
  let out:=next initial inner
  have scopeRun:=scope_source initial inner innerRun
  have update:=increment initial inner basic.uCell
  have run : Exec fragment (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ⟨out,.normal⟩ :=
    .seqNormal _ _ _ (SecondStepMove197.after callee) _ (SecondStepPrefix197.prefix_run callee oldWords firstRun fOld gOld)
      (.seqNormal _ _ _ initial _ (SecondStepPrime200.initial_source callee)
        (.seqNormal _ _ initial (bodyState initial inner) _ scopeRun update))
  have dataBind : (SecondStepLengths197.caller callee).arrays "data".toList=some SelectedMakeFgSetup176.ft :=
    SelectedTopContinuation186.data_binding
  have logn : KeygenModpR2Exec.Slot (SecondStepLengths197.caller callee) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 2 (by decide)).trans SelectedTopContinuation186.logn_cell
  have depth : KeygenModpR2Exec.Slot (SecondStepLengths197.caller callee) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  refine ⟨callee,out,oldWords,ivs,firstRun,SecondStepEntry196.binding _ dataBind logn (FirstStepReturn196.d_two _) depth,
    run,SecondStepPrime200.guard callee,next_guard initial inner basic.slenCell,next_u initial inner,?_,?_,?_,?_⟩
  · intro i bound; rw [next_heap]; exact fProduct i bound
  · intro i bound; rw [next_heap]; exact gProduct i bound
  · intro j bound; rw [next_heap]; exact fImage j bound
  · intro j bound; rw [next_heap]; exact gImage j bound

end FT1536.Source3.SecondStepFirstBody203
