import Source3.StepNttForwardImage195
import Source3.StepAddProduct195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Direct composition: the forward engine constructs the exact source image
   consumed by concrete additional-prime products. No output image or forward
   execution is an input hypothesis. Section-entry discharge is separate. -/
namespace FT1536.Source3.StepAddForwardProduct195
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open SelectedStepLayout187 (fd gd t1 gm)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open StepCopyBody190 (elem)
open StepNttForwardImage195 (forwardWords)

def words (W : Nat → BitVec 32) (gvs : Fin 512 → BitVec 32) : Nat → BitVec 32 :=
  forwardWords (fun i => W i.val) gvs p1 p0i1 (by decide)

theorem gm_separate (i j : Fin 512) : Separate (elem gm i.val) (elem t1 j.val) := by
  change 31≠31 ∨ (0+4*(2718+i.val))+4≤0+4*(3742+j.val) ∨
    (0+4*(3742+j.val))+4≤0+4*(2718+i.val)
  omega

/-- Same output witnesses the wrapper call, taken source branch and image. -/
theorem forward (before : State) (W : Nat → BitVec 32) (gvs : Fin 512 → BitVec 32)
    (input : StepAddProduct195.Input before W)
    (gmBinding : before.arrays "gm".toList=some gm)
    (gmLoads : ∀ i : Fin 512, Load32 before.heap (elem gm i.val) (gvs i))
    (logn : Slot before "logn" 9) (ter : Slot before "ter" 1) :
    ∃ after, KeygenLevelCalls.Call .forward before MakeFgAddPrimeShape194.forwardArgs after ∧
      KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.nttBranch before ⟨after,.normal⟩ ∧
      StepAddProduct195.Input after (words W gvs) ∧
      after.locals=before.locals ∧ after.arrays=before.arrays := by
  have pending : StepNttFirst195.Pending0 (hn:=256)
      (StepNttFirstLoop195.frame before t1 gm p1 p0i1) t1 (fun i => W i.val) := by
    intro j
    exact ⟨input.image j.val (by omega),input.image (256+j.val) (by omega)⟩
  obtain ⟨after,call,instruction,locals,arrays,image⟩ := StepNttForwardImage195.call_image
    before t1 gm (fun i => W i.val) gvs p1 p0i1 (by decide) rfl (by decide) input.writable
    gm_separate gmLoads pending (by decide) input.t1Binding gmBinding logn input.pCell input.iCell
  have stable := StepNttForwardImage195.call_stable call
  have writable : after.heap.writable 31=true := by
    rw [stable.writable]
    exact input.writable
  have nextInput : StepAddProduct195.Input after (words W gvs) := by
    refine ⟨image,writable,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
    · rw [arrays]; exact input.fdBinding
    · rw [arrays]; exact input.gdBinding
    · rw [arrays]; exact input.t1Binding
    · show after.locals _=_; rw [locals]; exact input.hnCell
    · show after.locals _=_; rw [locals]; exact input.tlenCell
    · show after.locals _=_; rw [locals]; exact input.uCell
    · rw [locals]; exact input.vDeclared
    · show after.locals _=_; rw [locals]; exact input.pCell
    · show after.locals _=_; rw [locals]; exact input.iCell
    · show after.locals _=_; rw [locals]; exact input.rCell
  exact ⟨after,call,(StepNttForwardImage195.branch_image instruction image ter).1,
    nextInput,locals,arrays⟩

theorem fd_section (before : State) (W : Nat → BitVec 32) (gvs : Fin 512 → BitVec 32)
    (input : StepAddProduct195.Input before W)
    (gmBinding : before.arrays "gm".toList=some gm)
    (gmLoads : ∀ i : Fin 512, Load32 before.heap (elem gm i.val) (gvs i))
    (logn : Slot before "logn" 9) (ter : Slot before "ter" 1) :
    ∃ after out, KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.nttFs before ⟨after,.normal⟩ ∧
      KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.productFd after ⟨out,.normal⟩ ∧
      KeygenMakeFgSource.Exec (.seq MakeFgAddPrimeShape194.nttFs MakeFgAddPrimeShape194.productFd)
        before ⟨out,.normal⟩ ∧
      StepProductFixed191.Image out fd 1 2 256 p1 p0i1 r21 (words W gvs) 256 ∧
      StepNttImage195.Image out t1 (words W gvs) ∧ Cell out "v".toList 256 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=before.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=before.arrays name) := by
  obtain ⟨after,call,ntt,nextInput,locals,arrays⟩ := forward before W gvs input gmBinding gmLoads logn ter
  obtain ⟨out,product,image,sourceImage,vCell,finalLocals,finalArrays⟩ :=
    StepAddProduct195.fd_source after (words W gvs) nextInput
  have nttRun : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.nttFs before ⟨after,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.nttFs_shape]
    exact ntt
  refine ⟨after,out,nttRun,product,.seqNormal _ _ before after _ nttRun product,
    image,sourceImage,vCell,?_,?_⟩
  · intro name different
    exact (finalLocals name different).trans (congrFun locals name)
  · intro name different
    exact (finalArrays name different).trans (congrFun arrays name)

theorem gd_section (before : State) (W : Nat → BitVec 32) (gvs : Fin 512 → BitVec 32)
    (input : StepAddProduct195.Input before W)
    (gmBinding : before.arrays "gm".toList=some gm)
    (gmLoads : ∀ i : Fin 512, Load32 before.heap (elem gm i.val) (gvs i))
    (logn : Slot before "logn" 9) (ter : Slot before "ter" 1) :
    ∃ after out, KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.nttGs before ⟨after,.normal⟩ ∧
      KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.productGd after ⟨out,.normal⟩ ∧
      KeygenMakeFgSource.Exec (.seq MakeFgAddPrimeShape194.nttGs MakeFgAddPrimeShape194.productGd)
        before ⟨out,.normal⟩ ∧
      StepProductFixed191.Image out gd 1 2 256 p1 p0i1 r21 (words W gvs) 256 ∧
      StepNttImage195.Image out t1 (words W gvs) ∧ Cell out "v".toList 256 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=before.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=before.arrays name) := by
  obtain ⟨after,call,ntt,nextInput,locals,arrays⟩ := forward before W gvs input gmBinding gmLoads logn ter
  obtain ⟨out,product,image,sourceImage,vCell,finalLocals,finalArrays⟩ :=
    StepAddProduct195.gd_source after (words W gvs) nextInput
  have nttRun : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.nttGs before ⟨after,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.nttGs_shape]
    exact ntt
  refine ⟨after,out,nttRun,product,.seqNormal _ _ before after _ nttRun product,
    image,sourceImage,vCell,?_,?_⟩
  · intro name different
    exact (finalLocals name different).trans (congrFun locals name)
  · intro name different
    exact (finalArrays name different).trans (congrFun arrays name)

/-- The additional-prime inverse-pair branch is skipped at out_ntt=1. -/
theorem out_skip (s : State)
    (outNtt : s.locals "out_ntt".toList=some (.int32,some (.int32 1))) :
    KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.outBranch s ⟨s,.normal⟩ := by
  rw [MakeFgAddPrimeShape194.outBranch_guard]
  exact .branchFalse _ _ _ s ⟨s,.normal⟩ (.int32 0)
    (.logicalNot _ (.int32 1) (.variable _ _ _ outNtt)) rfl
    (SelectedStepAddPrime195.skip_run s)

/-- The gd image survives the actual r5 suffix and its false inverse guard. -/
theorem gd_suffix (before : State) (W : Nat → BitVec 32) (gvs : Fin 512 → BitVec 32)
    (input : StepAddProduct195.Input before W)
    (gmBinding : before.arrays "gm".toList=some gm)
    (gmLoads : ∀ i : Fin 512, Load32 before.heap (elem gm i.val) (gvs i))
    (logn : Slot before "logn" 9) (ter : Slot before "ter" 1)
    (outNtt : before.locals "out_ntt".toList=some (.int32,some (.int32 1))) :
    ∃ out, KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.r5 before ⟨out,.normal⟩ ∧
      StepProductFixed191.Image out gd 1 2 256 p1 p0i1 r21 (words W gvs) 256 ∧
      StepNttImage195.Image out t1 (words W gvs) ∧ Cell out "v".toList 256 := by
  obtain ⟨after,out,ntt,product,combined,image,sourceImage,vCell,locals,arrays⟩ :=
    gd_section before W gvs input gmBinding gmLoads logn ter
  have skip : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.outBranch out ⟨out,.normal⟩ :=
    out_skip out ((locals "out_ntt".toList (by decide)).trans outNtt)
  have suffix : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.r7 out ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.r7_split,MakeFgAddPrimeShape194.r8_skip]
    exact .seqNormal _ _ out out _ skip (SelectedStepAddPrime195.skip_run out)
  refine ⟨out,?_,image,sourceImage,vCell⟩
  rw [MakeFgAddPrimeShape194.r5_split,MakeFgAddPrimeShape194.r6_split]
  exact .seqNormal _ _ before after _ ntt (.seqNormal _ _ after out _ product suffix)

end FT1536.Source3.StepAddForwardProduct195
