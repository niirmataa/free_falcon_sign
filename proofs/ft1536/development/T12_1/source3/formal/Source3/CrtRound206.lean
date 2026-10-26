import Source3.CrtMulImage206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtRound206
open C99ArrayReference (State Name restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open CrtPrimePrefix206 (s1)
open CrtWalkIncrement206 (cell)
open CrtWalkFixed206 (Pending Written high)
open CrtRoundReady206 (Input entry)
open KeygenZintCall (Exec)

theorem source {n : Nat} (s : State) (root tmp : ArrayPointer)
    (av bv : Fin n → BitVec 32) (t : BitVec 32) (input : Input s root tmp n t)
    (pending : Pending s root av bv 0) :
    ∃ out, Exec ZintRebuildCrt194.coBody s ⟨out,.normal⟩ ∧
      Written out root av bv t p1 p0i1 r21 s1 n ∧
      Load32 out.heap tmp (ZintMulWord205.low t p1) ∧
      Load32 out.heap (ZintAddMulWord205.next tmp) (ZintMulWord205.carry t p1) ∧
      out.locals=s.locals ∧ out.arrays "x".toList=some (cell root n) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i : Fin n, Separate (cell root i.val) q ∧ Separate (high root i.val) q) →
        Separate tmp q → Separate (ZintAddMulWord205.next tmp) q →
        Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨walked,walkRun,walkFixed,walkV,walkX,walkWritten,walkLocals,walkArrays,walkKeep⟩:=
    CrtWalkLoop206.source (entry s root) root tmp av bv t p1 p0i1 r21 s1
      (CrtRoundReady206.fixed s root tmp n t input) (CrtRoundReady206.counter s root)
      (CrtRoundReady206.pointer s root) pending
  have stable:=KeygenMemoryStability.zint _ _ _ walkRun
  have tmpWritable : walked.heap.writable tmp.block=true := by
    rw [stable.writable]
    exact input.tmpWritable
  have mulImage:=CrtMulImage206.source walked tmp t p1 walkFixed.tmpBinding walkFixed.uCell walkFixed.pCell
    walkFixed.tmpRead input.tmpCapacity tmpWritable
  let finish : State := {walked with heap:=CrtMulCall205.finalHeap walked tmp t p1}
  let out : State := restoreScope s finish CrtRoundShape205.localNames []
  have tail : Exec (.seq CrtRoundShape205.mulCall CrtRoundShape205.skip) walked ⟨finish,.normal⟩ :=
    .seqNormal _ _ _ _ _ mulImage.1 (.word _ _ _ (ZintSubWord194.skip_run _))
  have rest : Exec (.seq (.seq CrtRoundShape205.walkInit CrtRoundShape205.walk)
      (.seq CrtRoundShape205.mulCall CrtRoundShape205.skip)) (CrtPrimePrefix206.after s) ⟨finish,.normal⟩ :=
    .seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ (CrtRoundReady206.init_source s root tmp n t input) walkRun) tail
  have inner : Exec CrtRoundShape205.inner s ⟨finish,.normal⟩ := by
    rw [CrtPrimePrefix206.inner_shape]
    exact CrtPrimePrefix206.source s input.uCell input.primesBinding input.primeObject _ _ rest
  have run : Exec ZintRebuildCrt194.coBody s ⟨out,.normal⟩ := by
    rw [CrtRoundShape205.shape]
    exact .scope _ _ _ _ _ inner
  refine ⟨out,run,?_,mulImage.2.1,mulImage.2.2.1,?_,walkX,?_,?_⟩
  · intro i before
    have words:=walkWritten i before
    have sep:=input.apart i
    have highSep:=input.highApart i
    exact ⟨mulImage.2.2.2 _ _ (StepCopyFixed203.separate_symm sep.1) (StepCopyFixed203.separate_symm highSep.1) words.1,
      mulImage.2.2.2 _ _ (StepCopyFixed203.separate_symm sep.2) (StepCopyFixed203.separate_symm highSep.2) words.2⟩
  · funext name
    by_cases member : name∈CrtRoundShape205.localNames
    · simp only [out,restoreScope,C99ScalarReference.restore,List.contains_iff_mem,member,ite_true]
    · rw [show out.locals name=finish.locals name from WordControl205.restored _ _ _ name member]
      exact (walkLocals name (fun eq => member (eq ▸ (by decide)))).trans (CrtRoundReady206.locals s root name member)
  · intro name different
    exact (walkArrays name different).trans (CrtRoundReady206.arrays s root name different)
  · intro q old rowApart tmpApart highApart read
    exact mulImage.2.2.2 q old tmpApart highApart (walkKeep q old rowApart read)

end FT1536.Source3.CrtRound206
