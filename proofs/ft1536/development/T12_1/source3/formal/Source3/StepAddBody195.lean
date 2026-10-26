import Source3.StepAddReady195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepAddBody195
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open Word32Memory176 (Separate)
open SelectedStepLayout187 (fd gd fs gs gm t1)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open StepAddBasic195 (Basic marchWords)
open StepCopyBody190 (elem addr)

theorem t1_gm (i j : Nat) (hi : i<512) (hj : j<512) : Separate (elem t1 i) (elem gm j) := by
  change 31≠31 ∨ (0+4*(3742+i))+4≤0+4*(2718+j) ∨
    (0+4*(2718+j))+4≤0+4*(3742+i)
  omega

theorem t1_gs (i j : Nat) (hi : i<512) (hj : j<512) : Separate (elem t1 i) (elem gs j) := by
  change 31≠31 ∨ (0+4*(3742+i))+4≤0+4*(2206+j) ∨
    (0+4*(2206+j))+4≤0+4*(3742+i)
  omega

theorem t1_fd (i j : Nat) (hi : i<512) (hj : j<256) : Separate (elem t1 i) (addr fd 1 j 2) := by
  change 31≠31 ∨ (0+4*(3742+i))+4≤0+4*(670+1+j*2) ∨
    (0+4*(670+1+j*2))+4≤0+4*(3742+i)
  omega

theorem fd_gm (i j : Nat) (hi : i<256) (hj : j<512) : Separate (addr fd 1 i 2) (elem gm j) := by
  change 31≠31 ∨ (0+4*(670+1+i*2))+4≤0+4*(2718+j) ∨
    (0+4*(2718+j))+4≤0+4*(670+1+i*2)
  omega

theorem fd_gs (i j : Nat) (hi : i<256) (hj : j<512) : Separate (addr fd 1 i 2) (elem gs j) := by
  change 31≠31 ∨ (0+4*(670+1+i*2))+4≤0+4*(2206+j) ∨
    (0+4*(2206+j))+4≤0+4*(670+1+i*2)
  omega

theorem gd_fd (i j : Nat) (hi : i<256) (hj : j<256) : Separate (addr gd 1 i 2) (addr fd 1 j 2) := by
  change 31≠31 ∨ (0+4*(1182+1+i*2))+4≤0+4*(670+1+j*2) ∨
    (0+4*(670+1+j*2))+4≤0+4*(1182+1+i*2)
  omega

def resultWords (F : Fin 512 → BitVec 32) (gvs : Fin 512 → BitVec 32) : Nat → BitVec 32 :=
  StepAddForwardProduct195.words (marchWords F) gvs

theorem remaining (s : State) (b : Basic s) (input : StepU1Entry195.Input s)
    (F G : Fin 512 → BitVec 32)
    (fLoads : ∀ i : Fin 512, Load32 s.heap (elem fs i.val) (F i))
    (gLoads : ∀ i : Fin 512, Load32 s.heap (elem gs i.val) (G i)) :
    ∃ (out : State) (gvs : Fin 512 → BitVec 32),
      KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.remaining s ⟨out,.normal⟩ ∧ Basic out ∧
      StepProductFixed191.Image out fd 1 2 256 p1 p0i1 r21 (resultWords F gvs) 256 ∧
      StepProductFixed191.Image out gd 1 2 256 p1 p0i1 r21 (resultWords G gvs) 256 := by
  obtain ⟨gen,gvs,genRun,b0,gm0,genKeep⟩ := StepAddGenerator195.source s b input
  have f0 (i : Fin 512) : Load32 gen.heap (elem fs i.val) (F i) := by
    apply genKeep _ rfl _ _ (fLoads i)
    change 0+4*(1694+i.val)+4≤0+4*2718
    omega
  have g0 (i : Fin 512) : Load32 gen.heap (elem gs i.val) (G i) := by
    apply genKeep _ rfl _ _ (gLoads i)
    change 0+4*(2206+i.val)+4≤0+4*2718
    omega
  obtain ⟨wf,walkF,b1,fImage,walkFKeep⟩ := StepAddOps195.walk_fs gen b0 F f0
  have gm1 (i : Fin 512) : Load32 wf.heap (elem gm i.val) (gvs i) :=
    walkFKeep _ (fun j hj => t1_gm j i.val hj i.isLt) _ (gm0 i)
  have gs1 (i : Fin 512) : Load32 wf.heap (elem gs i.val) (G i) :=
    walkFKeep _ (fun j hj => t1_gs j i.val hj i.isLt) _ (g0 i)
  obtain ⟨pf,fRun,b2,fdImage,ft1,fKeep⟩ := StepAddOps195.fd_section wf b1 (marchWords F) fImage gvs gm1
  have gm2 (i : Fin 512) : Load32 pf.heap (elem gm i.val) (gvs i) := by
    apply fKeep _ rfl _ (fun j hj => fd_gm j i.val hj i.isLt) _ (gm1 i)
    change 0+4*(2718+i.val)+4≤0+4*3742
    omega
  have gs2 (i : Fin 512) : Load32 pf.heap (elem gs i.val) (G i) := by
    apply fKeep _ rfl _ (fun j hj => fd_gs j i.val hj i.isLt) _ (gs1 i)
    change 0+4*(2206+i.val)+4≤0+4*3742
    omega
  obtain ⟨wg,walkG,b3,gImage,walkGKeep⟩ := StepAddOps195.walk_gs pf b2 G gs2
  have gm3 (i : Fin 512) : Load32 wg.heap (elem gm i.val) (gvs i) :=
    walkGKeep _ (fun j hj => t1_gm j i.val hj i.isLt) _ (gm2 i)
  have fd3 : StepProductFixed191.Image wg fd 1 2 256 p1 p0i1 r21 (resultWords F gvs) 256 := by
    intro i bound
    exact walkGKeep _ (fun j hj => t1_fd j i.val hj i.isLt) _ (fdImage i bound)
  obtain ⟨pg,gRun,b4,gdImage,gt1,gKeep⟩ := StepAddOps195.gd_section wg b3 (marchWords G) gImage gvs gm3
  have fd4 : StepProductFixed191.Image pg fd 1 2 256 p1 p0i1 r21 (resultWords F gvs) 256 := by
    intro i bound
    apply gKeep _ rfl _ (fun j hj => gd_fd j i.val hj i.isLt) _ (fd3 i bound)
    change 0+4*(670+1+i.val*2)+4≤0+4*3742
    omega
  obtain ⟨fmid,nttF,productF⟩ := SelectedStepLoopTail194.seq_inv fRun
  obtain ⟨gmid,nttG,productG⟩ := SelectedStepLoopTail194.seq_inv gRun
  have skip := StepAddForwardProduct195.out_skip pg b4.outCell
  refine ⟨pg,gvs,?_,b4,fd4,gdImage⟩
  rw [MakeFgAddPrimeShape194.r0_split,MakeFgAddPrimeShape194.r1_split,
    MakeFgAddPrimeShape194.r2_split,MakeFgAddPrimeShape194.r3_split,
    MakeFgAddPrimeShape194.r4_split,MakeFgAddPrimeShape194.r5_split,
    MakeFgAddPrimeShape194.r6_split,MakeFgAddPrimeShape194.r7_split,MakeFgAddPrimeShape194.r8_skip]
  refine .seqNormal _ _ s gen _ genRun ?_
  refine .seqNormal _ _ gen wf _ walkF ?_
  refine .seqNormal _ _ wf fmid _ nttF ?_
  refine .seqNormal _ _ fmid pf _ productF ?_
  refine .seqNormal _ _ pf wg _ walkG ?_
  refine .seqNormal _ _ wg gmid _ nttG ?_
  refine .seqNormal _ _ gmid pg _ productG ?_
  exact .seqNormal _ _ pg pg _ skip (SelectedStepAddPrime195.skip_run pg)

end FT1536.Source3.StepAddBody195
