import Source3.NttForwardCompose211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardFirstFrame211
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (elem)
open StepNttFirstLoop195

theorem step_frame (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (slot : v < hn) (w p pi : BitVec 32) (width : a.elementBytes=4) :
    NttWriteFrame182.Frame a (2*hn) s.heap (stepAt s a hn v fv slot w p pi).heap := by
  exact NttWriteFrame182.trans a (2*hn) _ _ _
    (NttWriteFrame182.write s.heap a (2*hn) ⟨v,by omega⟩ (StepNttFirst195.lowWordAt hn fv w p pi v slot) width)
    (NttWriteFrame182.write _ a (2*hn) ⟨hn+v,by omega⟩ (StepNttFirst195.highWordAt hn fv w p pi v slot) width)

theorem remaining (count v : Nat) (s : State) (a gm : ArrayPointer) (hn gmn : Nat)
    (fv : Fin (2*hn) → BitVec 32) (gvs : Fin gmn → BitVec 32) (w pw p0i : BitVec 32)
    (fixed : StepNttFirst195.Fixed s a gm hn gmn fv gvs w pw p0i)
    (counter : Cell s "u".toList v)
    (r1Binding : s.arrays "r1".toList=some (elem a v))
    (r2Binding : s.arrays "r2".toList=some (elem a (hn+v)))
    (copied : StepNttFirst195.Image s a fv w pw p0i v) (finish : v+count=hn) :
    ∃ after, Exec StepNttBody195.firstWalk s ⟨after,.normal⟩ ∧
      StepNttFirst195.Fixed after a gm hn gmn fv gvs w pw p0i ∧
      StepNttFirst195.Image after a fv w pw p0i hn ∧
      Cell after "u".toList hn ∧
      after.arrays "r1".toList=some (elem a hn) ∧
      after.arrays "r2".toList=some (elem a (hn+hn)) ∧
      (∀ name : Name, name≠"u".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"r1".toList → name≠"r2".toList → after.arrays name=s.arrays name) ∧ NttWriteFrame182.Frame a (2*hn) s.heap after.heap := by
  induction count generalizing v s with
  | zero =>
      have equal : v=hn := by omega
      subst v
      have guardFalse : C99ArrayReference.scalar s StepNttBody195.firstGuard (.int32 0) := by
        simpa [C99ScalarReference.boolean] using
          guard s hn hn fixed.hnBound fixed.hnBound counter fixed.hnCell
      exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guardFalse (by decide),fixed,copied,counter,
        r1Binding,r2Binding,fun _ _ => rfl,fun _ _ _ => rfl,NttWriteFrame182.refl a (2*hn) s.heap⟩
  | succ count ih =>
      have slot : v<hn := by omega
      have nonzero : (C99ScalarReference.boolean (decide (v<hn))).integer≠0 := by
        simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
      have guardTrue : C99ArrayReference.scalar s StepNttBody195.firstGuard
          (C99ScalarReference.boolean (decide (v<hn))) :=
        guard s v hn (by have h := fixed.hnBound; omega) fixed.hnBound counter fixed.hnCell
      have bodyRun : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody) s
          ⟨bodyAt s a hn v fv slot w pw p0i,.normal⟩ :=
        body_run s a gm hn gmn fv gvs w pw p0i v slot fixed r1Binding r2Binding copied
      have updateRun : Exec StepNttBody195.stepU (bodyAt s a hn v fv slot w pw p0i)
          ⟨stepAt s a hn v fv slot w pw p0i,.normal⟩ :=
        increment_run s a hn v fv slot w pw p0i fixed.hnBound counter fixed.strideCell
          fixed.aCapacity r1Binding r2Binding
      obtain ⟨after,rest,finalFixed,finalImage,finalU,finalR1,finalR2,finalLocals,finalArrays,finalFrame⟩ :=
        ih (v+1) (stepAt s a hn v fv slot w pw p0i)
          (next_fixed s a gm hn gmn fv gvs w pw p0i v slot fixed)
          (stepAt_u s a hn v fv slot w pw p0i)
          (stepAt_r1 s a hn v fv slot w pw p0i)
          (stepAt_r2 s a hn v fv slot w pw p0i)
          (next_image s a hn v fv slot w pw p0i fixed.aWidth fixed.aWritable copied)
          (by omega)
      refine ⟨after,?_,finalFixed,finalImage,finalU,finalR1,finalR2,?_,?_,NttWriteFrame182.trans a (2*hn) _ _ _ (step_frame s a hn v fv slot w pw p0i fixed.aWidth) finalFrame⟩
      · refine .loopNormal _ _ _ s (bodyAt s a hn v fv slot w pw p0i)
          (stepAt s a hn v fv slot w pw p0i) ⟨after,.normal⟩
          (C99ScalarReference.boolean (decide (v<hn))) guardTrue nonzero bodyRun updateRun rest
      · intro name different
        exact (finalLocals name different).trans
          (stepAt_locals s a hn v fv slot w pw p0i name different)
      · intro name first second
        exact (finalArrays name first second).trans
          (stepAt_arrays s a hn v fv slot w pw p0i name first second)

theorem first_run (s : State) (a gm : ArrayPointer) (hn gmn : Nat) (fv : Fin (2*hn) → BitVec 32)
    (gvs : Fin gmn → BitVec 32) (w pw p0i : BitVec 32)
    (fixed : StepNttFirst195.Fixed s a gm hn gmn fv gvs w pw p0i)
    (uDeclared : ∃ old, s.locals "u".toList=some (.uint64,old))
    (pending : StepNttFirst195.Pending0 s a fv) :
    ∃ after, Exec KeygenNttForwardPrograms.firstLoop s ⟨after,.normal⟩ ∧
      StepNttFirst195.Fixed after a gm hn gmn fv gvs w pw p0i ∧
      StepNttFirst195.Image after a fv w pw p0i hn ∧
      Cell after "u".toList hn ∧
      after.arrays "r1".toList=some (elem a hn) ∧
      after.arrays "r2".toList=some (elem a (hn+hn)) ∧
      (∀ name : Name, name≠"u".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"r1".toList → name≠"r2".toList → after.arrays name=s.arrays name) ∧ NttWriteFrame182.Frame a (2*hn) s.heap after.heap := by
  have initRun : Exec KeygenNttForwardPrograms.firstInit s
      ⟨StepNttPrologue195.initState s a hn,.normal⟩ :=
    StepNttPrologue195.init_run s a hn fixed.hnBound fixed.hnCell fixed.strideCell uDeclared
      fixed.aBinding fixed.aCapacity
  have midFixed : StepNttFirst195.Fixed (StepNttPrologue195.initState s a hn) a gm hn gmn fv gvs
      w pw p0i := init_fixed s a gm hn gmn fv gvs w pw p0i fixed
  have pending0 : StepNttFirst195.Pending0 (StepNttPrologue195.initState s a hn) a fv := pending
  have zero0 : StepNttFirst195.Image (StepNttPrologue195.initState s a hn) a fv w pw p0i 0 :=
    StepNttFirst195.pending_image (StepNttPrologue195.initState s a hn) a fv w pw p0i pending0
  obtain ⟨after,rest,finalFixed,finalImage,finalU,finalR1,finalR2,finalLocals,finalArrays,finalFrame⟩ :=
    remaining hn 0 (StepNttPrologue195.initState s a hn) a gm hn gmn fv gvs w pw p0i midFixed
      (StepNttPrologue195.init_u s a hn) (StepNttPrologue195.init_r1 s a hn)
      (StepNttPrologue195.init_r2 s a hn) zero0 (by omega)
  refine ⟨after,?_,finalFixed,finalImage,finalU,finalR1,finalR2,?_,?_,finalFrame⟩
  · refine .seqNormal _ _ s (StepNttPrologue195.initState s a hn) ⟨after,.normal⟩ initRun rest
  · intro name different
    exact (finalLocals name different).trans
      (StepNttPrologue195.init_locals s a hn name different)
  · intro name first second
    exact (finalArrays name first second).trans
      (StepNttPrologue195.init_arrays s a hn name first second)


end FT1536.Source3.NttForwardFirstFrame211
