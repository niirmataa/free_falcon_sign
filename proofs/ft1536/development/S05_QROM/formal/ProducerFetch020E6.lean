import ProducerStore020E6
import ProducerExecution020E6

namespace FT1536.S05.ProducerFetch020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6

/-- The fetched instruction is stored explicitly. executePhase=false means
    fetch; true means execute the already stored instruction. -/
structure State (regions codeSize : Nat) where
  vm : ProducerMachine020E6.State codeSize
  ir : Option (Instruction regions codeSize)
  executePhase : Bool

def start {regions codeSize : Nat} (q : ProducerMachine020E6.State codeSize) : State regions codeSize := ⟨q,none,false⟩

def step {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : State regions codeSize) : State regions codeSize :=
  if q.executePhase then
    match q.ir with
    | some ins => ⟨execute sources ins q.vm,q.ir,false⟩
    | none => ⟨{q.vm with pc:=⟨codeSize,by omega⟩,fault:=true},none,false⟩
  else if h : q.vm.pc.val<codeSize then ⟨q.vm,some (read code ⟨q.vm.pc.val,h⟩),true⟩ else q

def cycle {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : State regions codeSize) :=
  step sources code (step sources code q)

theorem cycle_vm {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : State regions codeSize) (h : q.executePhase=false) :
    (cycle sources code q).vm=ProducerMachine020E6.step sources code q.vm := by
  unfold cycle step
  simp only [h,Bool.false_eq_true,ite_false]
  split
  · rename_i hpc
    simp only [ite_true]
    rw [ProducerMachine020E6.step,dite_eq_left hpc]
  · rename_i hn
    simp only [h,Bool.false_eq_true,ite_false]
    rw [ProducerMachine020E6.step,dite_eq_right hn]

theorem cycle_phase {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : State regions codeSize) (h : q.executePhase=false) :
    (cycle sources code q).executePhase=false := by
  unfold cycle step
  simp only [h,Bool.false_eq_true,ite_false]
  split
  · rfl
  · simp only [h,Bool.false_eq_true,ite_false]

def run {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) : Nat → State regions codeSize → State regions codeSize
  | 0,q => q
  | fuel+1,q => if q.vm.pc.val=codeSize then q else run sources code fuel (cycle sources code q)

theorem refines {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (fuel : Nat) (q : State regions codeSize) (h : q.executePhase=false) :
    (run sources code fuel q).vm=ProducerMachine020E6.run sources code fuel q.vm := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih =>
    unfold run ProducerMachine020E6.run
    split
    · rfl
    · rw [ih _ (cycle_phase sources code q h),cycle_vm sources code q h]

end FT1536.S05.ProducerFetch020E6
