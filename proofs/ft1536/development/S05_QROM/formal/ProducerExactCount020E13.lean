import ProducerPairCount020E13

namespace FT1536.S05.ProducerExactCount020E13
open ArrayBank020E4 ProducerMachine020E6

theorem cycle_pc {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : ProducerFetch020E6.State regions codeSize)
    (hp : q.executePhase=false) (h : q.vm.pc.val<codeSize) :
    (ProducerFetch020E6.cycle sources code q).vm.pc.val=q.vm.pc.val+1 := by
  rw [ProducerFetch020E6.cycle_vm _ _ q hp,ProducerMachine020E6.step,dite_eq_left h,ProducerExecution020E6.execute_pc]
  simp only [next]
  omega

/-- Straight-line stored instructions increment pc even when a load faults.
    This exact count does not assume generated code or valid addresses. -/
theorem exact_cycles {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (fuel : Nat)
    (q : ProducerFetch020E6.State regions codeSize) (hp : q.executePhase=false) :
    (ProducerCount020E13.run sources code fuel q).2=min fuel (codeSize-q.vm.pc.val) := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih =>
    simp only [ProducerCount020E13.run]
    split
    · rename_i h
      simp only [h,Nat.sub_self,Nat.min_zero]
    · rename_i hn
      have h : q.vm.pc.val<codeSize := by have := q.vm.pc.isLt;omega
      rw [ih _ (ProducerFetch020E6.cycle_phase _ _ q hp),cycle_pc _ _ q hp h]
      omega

theorem invoke_cycles {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) :
    (ProducerCount020E13.invoke sources code).2=codeSize := by
  rw [ProducerCount020E13.invoke,exact_cycles _ _ _ _ rfl]
  simp only [ProducerFetch020E6.start,initial,Fin.val_zero,Nat.sub_zero,min_self]

theorem pair_cycles {regions firstSize secondSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (firstCode : Bank (Instruction regions firstSize) firstSize)
    (secondCode : Bank (Instruction 1 secondSize) secondSize) :
    (ProducerPairCount020E13.run sources firstCode secondCode).2=firstSize+secondSize := by
  simp only [ProducerPairCount020E13.run,invoke_cycles]

theorem core_cycles (sources : Sources ProducerCoreView020E6.extent) :
    (ProducerPairCount020E13.run sources ProducerStored020E6.windowCode ProducerStored020E6.slotCode).2=14733 := by
  rw [pair_cycles,ProducerNumbers020E6.window_size,ProducerNumbers020E6.slot_size]

end FT1536.S05.ProducerExactCount020E13
