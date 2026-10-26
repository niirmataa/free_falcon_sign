import Source3.SecondStepEarlier204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepLoop204
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (addr)
open SecondStepLayout197 (fd gd fs gs)
open SelectedTopInit178 (p p0i r2)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open SecondStepFirstColumn203 (inputWord tableWord)
open SecondStepFirstBody203 (gInputWord)
open NttInverseWholeBridges201 (scaledWord)

noncomputable def oddF (oldWords : Fin 512 → BitVec 32) (j : Nat) := StepFirstImage196.fdWords oldWords (1+j*2)
noncomputable def oddG (oldWords : Fin 512 → BitVec 32) (j : Nat) := StepFirstImage196.gdWords oldWords (1+j*2)

def fragment : KeygenMakeFgSource.Stmt :=
  .seq (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1)) (KeygenMakeFgSource.part .step 2)

theorem binding (callee : State) :
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepStatics204.entry callee) := by
  have dataBind : (SecondStepLengths197.caller callee).arrays "data".toList=some SelectedMakeFgSetup176.ft :=
    SelectedTopContinuation186.data_binding
  have logn : KeygenModpR2Exec.Slot (SecondStepLengths197.caller callee) "logn" 10 :=
    (ModularAtoms178.outside _ "d" "logn" 2 (by decide)).trans SelectedTopContinuation186.logn_cell
  have depth : KeygenModpR2Exec.Slot (SecondStepLengths197.caller callee) "depth" 10 :=
    (ModularAtoms178.outside _ "d" "depth" 2 (by decide)).trans SelectedTopContinuation186.depth_cell
  exact SecondStepEntry196.binding _ dataBind logn (FirstStepReturn196.d_two _) depth

theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepStatics204.entry callee) ∧
    Exec fragment (SecondStepStatics204.entry callee) ⟨out,.normal⟩ ∧
    SecondStepOuter204.Outer out 2 ∧ Cell out "u".toList 2 ∧
    StepProductFixed203.Image out fd 0 3 128 p p0i r2 (inputWord oldWords) 128 ∧
    StepProductFixed203.Image out fd 1 3 128 p1 p0i1 r21 (oddF oldWords) 128 ∧
    StepProductFixed203.Image out gd 0 3 128 p p0i r2 (gInputWord oldWords) 128 ∧
    StepProductFixed203.Image out gd 1 3 128 p1 p0i1 r21 (oddG oldWords) 128 ∧
    (∀ j<256, Load32 out.heap (addr fs 0 j 2) (scaledWord 7 (inputWord oldWords) (tableWord ivs0) p p0i j)) ∧
    (∀ j<256, Load32 out.heap (addr fs 1 j 2) (scaledWord 7 (oddF oldWords) (tableWord ivs1) p1 p0i1 j)) ∧
    (∀ j<256, Load32 out.heap (addr gs 0 j 2) (scaledWord 7 (gInputWord oldWords) (tableWord ivs0) p p0i j)) ∧
    (∀ j<256, Load32 out.heap (addr gs 1 j 2) (scaledWord 7 (oddG oldWords) (tableWord ivs1) p1 p0i1 j)) := by
  obtain ⟨callee,oldWords,firstRun,fOld,gOld⟩ := StepFirstImage196.source
  obtain ⟨inner0,ivs0,innerRun0,basic0,fd0,gd0,fs0,gs0,fOdd,gOdd⟩ :=
    SecondStepFirstBodyKeep204.inner_source callee oldWords firstRun fOld gOld
  let initial:=SecondStepPrime200.initial callee
  let one:=SecondStepFirstBody203.next initial inner0
  have oneHeap : one.heap=inner0.heap := SecondStepFirstBody203.next_heap initial inner0
  have outer1:=SecondStepOuter204.of_next initial inner0 p p0i r2 basic0
  have scope0:=SecondStepFirstBody203.scope_source initial inner0 innerRun0
  have update0:=SecondStepFirstBody203.increment initial inner0 basic0.uCell
  have prefix0 : Exec SecondStepFirstBody203.fragment (SecondStepStatics204.entry callee) ⟨one,.normal⟩ :=
    .seqNormal _ _ _ (SecondStepMove197.after callee) _ (SecondStepPrefix197.prefix_run callee oldWords firstRun fOld gOld)
      (.seqNormal _ _ _ initial _ (SecondStepPrime200.initial_source callee)
        (.seqNormal _ _ initial (SecondStepFirstBody203.bodyState initial inner0) _ scope0 update0))
  have fData : ∀ j<256, Load32 one.heap (addr fs 1 j 2) (oddF oldWords j) := by
    intro j bound; rw [oneHeap]; exact fOdd j bound
  have gData : ∀ j<256, Load32 one.heap (addr gs 1 j 2) (oddG oldWords j) := by
    intro j bound; rw [oneHeap]; exact gOdd j bound
  obtain ⟨inner1,ivs1,innerRun1,basic1,fd1,gd1,fs1,gs1,keeps1⟩ := SecondStepOneBody204.source one outer1
    (SecondStepStatics204.prime_object callee one firstRun prefix0)
    (SecondStepStatics204.rev_binding callee one prefix0) (SecondStepStatics204.rev_source callee one firstRun prefix0)
    (oddF oldWords) (oddG oldWords) fData gData
  let out:=SecondStepOuter204.counter one inner1 2
  have outHeap : out.heap=inner1.heap := SecondStepOuter204.counter_heap one inner1 2
  have scope1:=SecondStepFirstBody203.scope_source one inner1 innerRun1
  have update1:=SecondStepExit204.increment one inner1 basic1.uCell
  have loop1 : Exec StepPrimeShape188.loop one ⟨out,.normal⟩ :=
    .loopNormal _ _ _ one (SecondStepFirstBody203.bodyState one inner1) out _ (.int32 1)
      (SecondStepFirstBody203.next_guard initial inner0 basic0.slenCell) (by decide) scope1 update1
      (SecondStepExit204.loop_end one inner1 basic1.slenCell)
  have loop0 : Exec StepPrimeShape188.loop initial ⟨out,.normal⟩ :=
    .loopNormal _ _ _ initial (SecondStepFirstBody203.bodyState initial inner0) one _ (.int32 1)
      (SecondStepPrime200.guard callee) (by decide) scope0 update0 loop1
  have part2 : Exec (KeygenMakeFgSource.part .step 2) (SecondStepMove197.after callee) ⟨out,.normal⟩ := by
    rw [StepPrimeShape188.loop_shape]
    exact .seqNormal _ _ _ out _
      (.seqNormal _ _ _ initial _ (SecondStepPrime200.initial_source callee) loop0) (SelectedStepAddPrime195.skip_run out)
  have run : Exec fragment (SecondStepStatics204.entry callee) ⟨out,.normal⟩ :=
    .seqNormal _ _ _ (SecondStepMove197.after callee) _ (SecondStepPrefix197.prefix_run callee oldWords firstRun fOld gOld) part2
  refine ⟨callee,out,oldWords,ivs0,ivs1,firstRun,binding callee,run,
    SecondStepOuter204.of_counter one inner1 1 2 p1 p0i1 r21 basic1,SecondStepExit204.u_two one inner1,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · intro i bound; rw [outHeap]
    apply SecondStepEarlier204.product one inner1 keeps1 .f i
    rw [oneHeap]; exact fd0 i bound
  · intro i bound; rw [outHeap]; exact fd1 i bound
  · intro i bound; rw [outHeap]
    apply SecondStepEarlier204.product one inner1 keeps1 .g i
    rw [oneHeap]; exact gd0 i bound
  · intro i bound; rw [outHeap]; exact gd1 i bound
  · intro j bound; rw [outHeap]
    apply SecondStepEarlier204.data one inner1 keeps1 .f ⟨j,bound⟩
    rw [oneHeap]; exact fs0 j bound
  · intro j bound; rw [outHeap]; exact fs1 j bound
  · intro j bound; rw [outHeap]
    apply SecondStepEarlier204.data one inner1 keeps1 .g ⟨j,bound⟩
    rw [oneHeap]; exact gs0 j bound
  · intro j bound; rw [outHeap]; exact gs1 j bound

end FT1536.Source3.SecondStepLoop204
