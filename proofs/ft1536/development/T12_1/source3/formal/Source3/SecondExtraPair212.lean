import Source3.SecondExtraSide212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraPair212
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec Stmt)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open SecondStepBasic203 (Basic)
open SecondStepLayout197 (fd gd fs gs gm)
open StepCopyBody190 (elem addr)
open SecondExtraGeometry212 (Safe)
open ZintNormWalkFlat208 (Data)
open SecondExtraSide212 (words)

theorem normal_seq (a b : Stmt) (s out : State) (run : Exec (.seq a b) s ⟨out,.normal⟩) :
    ∃ mid, Exec a s ⟨mid,.normal⟩ ∧ Exec b mid ⟨out,.normal⟩ := by
  cases run with
  | seqNormal _ _ _ mid _ first second => exact ⟨mid,first,second⟩
  | seqExit _ _ _ _ _ exit => exact False.elim (exit rfl)

theorem continue_side (side : SecondStepCopy203.Side) (s out : State) (run : Exec (SecondExtraSide212.code side) s ⟨out,.normal⟩)
    (tail : Stmt) (result : C99ProcedureReference.Result) (rest : Exec tail out result) :
    Exec (.seq (SecondExtraWalk212.code side) (.seq MakeFgAddPrimeShape194.nttBranch (.seq (SecondExtraProduct212.code side) tail))) s result := by
  obtain ⟨a,walk,afterWalk⟩:=normal_seq _ _ s out run
  obtain ⟨b,forward,product⟩:=normal_seq _ _ a out afterWalk
  exact .seqNormal _ _ _ _ _ walk (.seqNormal _ _ _ _ _ forward (.seqNormal _ _ _ _ _ product rest))

theorem out_skip (s : State) (p pi r2 : BitVec 32) (h : Basic s 2 p pi r2) :
    Exec MakeFgAddPrimeShape194.outBranch s ⟨s,.normal⟩ := by
  rw [MakeFgAddPrimeShape194.outBranch_guard]
  exact .branchFalse _ _ _ s _ (.int32 0) (.logicalNot _ (.int32 1) (.variable _ _ _ h.outCell)) rfl
    (SelectedStepAddPrime195.skip_run s)

theorem source (s : State) (p pi r2 rx : BitVec 32) (F G : Nat → BitVec 32) (gvs : Fin 256 → BitVec 32)
    (h : Basic s 2 p pi r2) (rxCell : Slot s "Rx" rx) (fdata : Data s fs 512 F) (gdata : Data s gs 512 G)
    (gloads : ∀ i, Load32 s.heap (elem gm i.val) (gvs i))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec MakeFgAddPrimeShape194.r1 s ⟨out,.normal⟩ ∧ Basic out 2 p pi r2 ∧
      StepProductFixed203.Image out fd 2 3 128 p pi r2 (words F gvs p pi r2 rx) 128 ∧
      StepProductFixed203.Image out gd 2 3 128 p pi r2 (words G gvs p pi r2 rx) 128 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, Safe q → Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨fout,frun,fb,frx,fv,fimage,fls,fas,fkeep⟩:=SecondExtraSide212.source .f s p pi r2 rx F gvs h rxCell fdata gloads old declared
  have gdataAfter : Data fout gs 512 G := fun i bound => fkeep _ _ (SecondExtraGeometry212.data .f .g i bound) (gdata i bound)
  have gloadsAfter (i : Fin 256) : Load32 fout.heap (elem gm i.val) (gvs i) :=
    fkeep _ _ (SecondExtraGeometry212.twiddle .f i) (gloads i)
  obtain ⟨out,grun,gb,_,_,gimage,gls,gas,gkeep⟩:=SecondExtraSide212.source .g fout p pi r2 rx G gvs fb frx gdataAfter gloadsAfter
    (some (.uint64 (C99NatWord141.word 128))) fv
  have finish : Exec MakeFgAddPrimeShape194.r7 out ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.r7_split,MakeFgAddPrimeShape194.r8_skip]
    exact .seqNormal _ _ _ _ _ (out_skip out p pi r2 gb) (SelectedStepAddPrime195.skip_run out)
  have run : Exec MakeFgAddPrimeShape194.r1 s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.r1_split,MakeFgAddPrimeShape194.r2_split,MakeFgAddPrimeShape194.r3_split,
      MakeFgAddPrimeShape194.r4_split,MakeFgAddPrimeShape194.r5_split,MakeFgAddPrimeShape194.r6_split,
      MakeFgAddPrimeShape194.walkFs_shape,MakeFgAddPrimeShape194.nttFs_shape,MakeFgAddPrimeShape194.productFd_shape,
      MakeFgAddPrimeShape194.walkGs_shape,MakeFgAddPrimeShape194.nttGs_shape,MakeFgAddPrimeShape194.productGd_shape]
    exact continue_side .f s fout frun _ _ (continue_side .g fout out grun _ _ finish)
  refine ⟨out,run,gb,?_,gimage,?_,?_,?_⟩
  · intro i bound
    exact gkeep _ _ (SecondExtraGeometry212.f_after_g i.val i.isLt) (fimage i bound)
  · intro name different
    exact (gls name different).trans (fls name different)
  · intro name different
    exact (gas name different).trans (fas name different)
  · intro q old safe loaded
    exact gkeep q old safe.2 (fkeep q old safe.1 loaded)

end FT1536.Source3.SecondExtraPair212
