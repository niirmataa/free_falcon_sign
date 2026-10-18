import Source3.TopProductControl186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopProductLoop186
open C99ArrayReference (State)
open KeygenLevelExec (Exec)
open KeygenNttLoopSupport (USlot)
open TopProductFixed186 (Fixed)
open SelectedTopLayout177 (fd)

theorem source (n j : Nat) (count : j+n=512) (s : State) (p p0i r3 : BitVec 32)
    (fixed : Fixed s p p0i r3) (uc : USlot s "u" (3*j)) (vc : USlot s "v" j) :
    ∃ out, Exec TopProductProgram186.loop s ⟨out,.normal⟩ ∧ Fixed out p p0i r3 ∧
      USlot out "u" 1536 ∧ USlot out "v" 512 ∧ TopProductMemory186.Frame s.heap out.heap := by
  induction n generalizing j s with
  | zero =>
    have equal : j=512 := by omega
    subst j
    exact ⟨s,.loopFalse _ _ _ s (.int32 0)
      (C99LoopScalar141.less s (.var "u".toList) (.var "n".toList) 1536 1536 (by decide) (by decide)
        (.variable _ _ _ uc) (.variable _ _ _ fixed.nCell)) rfl,
      fixed,uc,vc,NttWriteFrame182.refl fd 1024 s.heap⟩
  | succ n ih =>
    have bound : j<512 := by omega
    obtain ⟨middle,iteration,middleFixed,memory,locals,arrays⟩ := TopProductBody186.source s p p0i r3 j bound fixed uc vc
    let next := TopProductControl186.after middle j
    have update := TopProductControl186.source middle j bound ((congrFun locals _).trans uc) ((congrFun locals _).trans vc)
    obtain ⟨out,rest,fo,uo,vo,frame⟩ := ih (j+1) (by omega) next
      (TopProductControl186.fixed middle p p0i r3 j middleFixed)
      (TopProductControl186.u_cell middle j bound) (TopProductControl186.v_cell middle j bound)
    refine ⟨out,?_,fo,uo,vo,NttWriteFrame182.trans fd 1024 _ _ _ memory frame⟩
    have nonzero : (C99ScalarReference.boolean (decide (3*j<1536))).integer≠0 := by
      have h : 3*j<1536 := by omega
      simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (C99LoopScalar141.less s (.var "u".toList) (.var "n".toList) (3*j) 1536 (by omega) (by decide)
        (.variable _ _ _ uc) (.variable _ _ _ fixed.nCell)) nonzero iteration (.modular _ _ _ update) rest

theorem full (s : State) (p p0i r3 : BitVec 32) (fixed : Fixed s p p0i r3)
    (oldU oldV : Option C99IntegerReference.Value)
    (du : s.locals "u".toList=some (.uint64,oldU)) (dv : s.locals "v".toList=some (.uint64,oldV)) :
    ∃ out, Exec TopProductShape185.loop s ⟨out,.normal⟩ ∧ Fixed out p p0i r3 ∧
      USlot out "u" 1536 ∧ USlot out "v" 512 ∧ TopProductMemory186.Frame s.heap out.heap := by
  obtain ⟨out,run,fo,uo,vo,frame⟩ := source 512 0 rfl (TopProductControl186.initial s) p p0i r3
    (TopProductControl186.initial_fixed s p p0i r3 fixed) rfl rfl
  refine ⟨out,?_,fo,uo,vo,frame⟩
  rw [TopProductProgram186.loop_shape]
  exact .seqNormal _ _ s (TopProductControl186.initial s) _
    (.modular _ _ _ (TopProductControl186.init s oldU oldV du dv)) run

theorem tail (s : State) (p p0i r3 : BitVec 32) (fixed : Fixed s p p0i r3) :
    Exec TopProductShape185.tail s ⟨s,.normal⟩ := by
  rw [TopProductProgram186.tail_shape]
  have guard : C99ArrayReference.scalar s (.lnot (TopProductProgram186.var "out_ntt")) (.int32 0) :=
    .logicalNot _ (.int32 1) (.variable _ _ _ fixed.outCell)
  have skip : Exec KeygenLevelExec.skip s ⟨s,.normal⟩ := .modular _ _ _ (.base .skip s s (.skip s))
  exact .seqNormal _ _ s s _ (.branchFalse _ _ _ s ⟨s,.normal⟩ (.int32 0) guard rfl skip) skip

end FT1536.Source3.TopProductLoop186
