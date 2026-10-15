import ProducerStored020E6

namespace FT1536.S05.ProducerCount020E13
open ArrayBank020E4 ProducerMachine020E6

/-- Proof instrumentation of the actual fetch/execute recursion. One counted
    cycle invokes two Fetch.step transitions. These are not primitive ticks. -/
def run {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) : Nat →
      ProducerFetch020E6.State regions codeSize → ProducerFetch020E6.State regions codeSize × Nat
  | 0,q => (q,0)
  | fuel+1,q => if q.vm.pc.val=codeSize then (q,0) else
      let r := run sources code fuel (ProducerFetch020E6.cycle sources code q)
      (r.1,r.2+1)

theorem value {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (fuel : Nat)
    (q : ProducerFetch020E6.State regions codeSize) :
    (run sources code fuel q).1=ProducerFetch020E6.run sources code fuel q := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih =>
    simp only [run,ProducerFetch020E6.run]
    split
    · rfl
    · exact ih _

theorem bound {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (fuel : Nat)
    (q : ProducerFetch020E6.State regions codeSize) : (run sources code fuel q).2≤fuel := by
  induction fuel generalizing q with
  | zero => exact Nat.le_refl 0
  | succ fuel ih =>
    simp only [run]
    split
    · exact Nat.zero_le _
    · exact Nat.add_le_add_right (ih _) 1

def invoke {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) :=
  run sources code codeSize (ProducerFetch020E6.start (initial codeSize))

theorem invoke_value {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) :
    (invoke sources code).1=ProducerStored020E6.invoke sources code := value _ _ _ _

theorem invoke_bound {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) : (invoke sources code).2≤codeSize := bound _ _ _ _

theorem transitions_bound {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) : 2*(invoke sources code).2≤2*codeSize :=
  Nat.mul_le_mul_left 2 (invoke_bound sources code)

theorem stopped {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (fuel : Nat)
    (q : ProducerFetch020E6.State regions codeSize) (h : q.vm.pc.val=codeSize) : run sources code fuel q=(q,0) := by
  cases fuel with
  | zero => rfl
  | succ fuel => simp only [run,h,ite_true]

end FT1536.S05.ProducerCount020E13
