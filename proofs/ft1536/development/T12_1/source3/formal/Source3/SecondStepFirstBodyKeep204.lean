import Source3.SecondStepFirstBody203
import Source3.SecondStepOuter204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepFirstBodyKeep204
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open KeygenNttLoopSupport (USlot)
open C99LoopScalar141 (Cell)
open SecondStepFirstBody203 (fragment next bodyState next_heap next_u next_guard scope_source increment)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open SecondStepLayout197 (fd gd fs gs igm)
open SelectedTopInit178 (p p0i r2)
open SecondStepBasic203 (Basic)
open SecondStepFirstColumn203 (tableWord inputWord)
open SecondStepFirstBody203 (gInputWord)
open NttInverseWholeBridges201 (scaledWord)

theorem addr_elem (base : ArrayPointer) (u j stride : Nat) : addr base u j stride=elem base (u+j*stride) :=
  congrArg (fun index : Nat => ({base with index:=index} : ArrayPointer)) (Nat.add_assoc _ _ _)

theorem different_columns (side : Side) (u v j k : Nat) (ub : u<2) (vb : v<2) (different : u≠v) :
    Word32Memory176.Separate (addr (SecondStepCopy203.root side) u j 2) (addr (SecondStepCopy203.root side) v k 2) := by
  rw [SecondStepGeometry203.data_shape,SecondStepGeometry203.data_shape]
  change 31≠31 ∨ 0+4*((SecondStepCopy203.root side).index+u+j*2)+4 ≤ 0+4*((SecondStepCopy203.root side).index+v+k*2) ∨
    0+4*((SecondStepCopy203.root side).index+v+k*2)+4 ≤ 0+4*((SecondStepCopy203.root side).index+u+j*2)
  omega

theorem inner_source (callee : State) (oldWords : Fin 512 → BitVec 32)
    (firstRun : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fOld : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords oldWords))
    (gOld : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords oldWords)) :
    ∃ (out : State) (ivs : Fin 256 → BitVec 32),
      Exec StepPrimeShape188.inner (SecondStepPrime200.initial callee) ⟨out,.normal⟩ ∧ Basic out 0 p p0i r2 ∧
      StepProductFixed203.Image out fd 0 3 128 p p0i r2 (inputWord oldWords) 128 ∧
      StepProductFixed203.Image out gd 0 3 128 p p0i r2 (gInputWord oldWords) 128 ∧
      (∀ j<256, Load32 out.heap (addr fs 0 j 2) (scaledWord 7 (inputWord oldWords) (tableWord ivs) p p0i j)) ∧
      (∀ j<256, Load32 out.heap (addr gs 0 j 2) (scaledWord 7 (gInputWord oldWords) (tableWord ivs) p p0i j)) ∧
      (∀ j<256, Load32 out.heap (addr fs 1 j 2) (StepFirstImage196.fdWords oldWords (1+j*2))) ∧
      (∀ j<256, Load32 out.heap (addr gs 1 j 2) (StepFirstImage196.gdWords oldWords (1+j*2))) := by
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
  obtain ⟨out,tailRun,outBasic,_,fProduct,gProduct,fResult,gResult,_,keeps⟩ :=
    SecondStepPair203.source generated 0 p p0i r2 basic (by decide) (tableWord ivs)
      (inputWord oldWords) (gInputWord oldWords) twLoads fData gData none v
  have inner : Exec StepPrimeShape188.inner (SecondStepPrime200.initial callee) ⟨out,.normal⟩ := by
    apply SecondStepPrime200.continue_inner callee firstRun
    rw [StepPrimeShape188.remaining_shape]
    exact .seqNormal _ _ (SecondStepGenerator200.before callee) generated _ generator tailRun
  refine ⟨out,ivs,inner,outBasic,fProduct,gProduct,fResult,gResult,?_,?_⟩
  · intro j bound
    apply keeps (addr fs 1 j 2) (SecondStepGeometry203.copy_data .f 1 j (by decide) bound)
      (fun i => SecondStepGeometry203.product_data .f .f 0 i.val 1 j (by decide) i.isLt)
      (fun i => SecondStepGeometry203.product_data .g .f 0 i.val 1 j (by decide) i.isLt)
      (fun k _ => different_columns .f 0 1 k j (by decide) (by decide) (by decide))
      (fun k _ => StepCopyFixed190.separate_symm (SecondStepPair203.fs_gs 1 j 0 k (by decide) bound))
    rw [addr_elem]
    exact fImage (1+j*2) (by omega)
  · intro j bound
    apply keeps (addr gs 1 j 2) (SecondStepGeometry203.copy_data .g 1 j (by decide) bound)
      (fun i => SecondStepGeometry203.product_data .f .g 0 i.val 1 j (by decide) i.isLt)
      (fun i => SecondStepGeometry203.product_data .g .g 0 i.val 1 j (by decide) i.isLt)
      (fun k kb => SecondStepPair203.fs_gs 0 k 1 j (by decide) kb)
      (fun k _ => different_columns .g 0 1 k j (by decide) (by decide) (by decide))
    rw [addr_elem]
    exact gImage (1+j*2) (by omega)

theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ∧
    Exec fragment (SecondStepEntry196.entry (SecondStepLengths197.caller callee)) ⟨out,.normal⟩ ∧
    C99ArrayReference.scalar (SecondStepPrime200.initial callee) StepPrimeShape188.condition (.int32 1) ∧
    C99ArrayReference.scalar out StepPrimeShape188.condition (.int32 1) ∧ Cell out "u".toList 1 ∧ SecondStepOuter204.Outer out 1 ∧
    StepProductFixed203.Image out fd 0 3 128 p p0i r2 (inputWord oldWords) 128 ∧
    StepProductFixed203.Image out gd 0 3 128 p p0i r2 (gInputWord oldWords) 128 ∧
    (∀ j<256, Load32 out.heap (addr fs 0 j 2) (scaledWord 7 (inputWord oldWords) (tableWord ivs) p p0i j)) ∧
    (∀ j<256, Load32 out.heap (addr gs 0 j 2) (scaledWord 7 (gInputWord oldWords) (tableWord ivs) p p0i j)) ∧
    (∀ j<256, Load32 out.heap (addr fs 1 j 2) (StepFirstImage196.fdWords oldWords (1+j*2))) ∧
    (∀ j<256, Load32 out.heap (addr gs 1 j 2) (StepFirstImage196.gdWords oldWords (1+j*2))) := by
  obtain ⟨callee,oldWords,firstRun,fOld,gOld⟩ := StepFirstImage196.source
  obtain ⟨inner,ivs,innerRun,basic,fProduct,gProduct,fImage,gImage,fOdd,gOdd⟩ := inner_source callee oldWords firstRun fOld gOld
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
    run,SecondStepPrime200.guard callee,next_guard initial inner basic.slenCell,next_u initial inner,SecondStepOuter204.of_next initial inner p p0i r2 basic,?_,?_,?_,?_,?_,?_⟩
  · intro i bound; rw [next_heap]; exact fProduct i bound
  · intro i bound; rw [next_heap]; exact gProduct i bound
  · intro j bound; rw [next_heap]; exact fImage j bound
  · intro j bound; rw [next_heap]; exact gImage j bound
  · intro j bound; rw [next_heap]; exact fOdd j bound
  · intro j bound; rw [next_heap]; exact gOdd j bound

end FT1536.Source3.SecondStepFirstBodyKeep204
