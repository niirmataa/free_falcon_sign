import ProducerBatch020E6

namespace FT1536.S05.ProducerExecution020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6 ProducerExpr020E6

theorem execute_pc {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (i : Instruction regions codeSize) (q : State codeSize) : (execute sources i q).pc=next q.pc := by
  cases i with
  | literal d w => rfl
  | copy d s => rfl
  | binary d o a b => rfl
  | load d r a => unfold execute;dsimp only;cases WordRAM020.address (extent r) (read q.regs a) <;> rfl
  | output d s => rfl
  | select d c z n => rfl

def meaning {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : State codeSize) :=
  executeList sources ((List.ofFn (read code)).drop q.pc.val) q

theorem step_meaning {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : State codeSize) :
    meaning sources code (step sources code q)=meaning sources code q := by
  unfold step
  split
  · rename_i h
    have hlen : q.pc.val<(List.ofFn (read code)).length := by simpa only [List.length_ofFn] using h
    unfold meaning
    rw [execute_pc]
    simp only [next,min_eq_right (by omega : q.pc.val+1≤codeSize)]
    rw [List.drop_eq_getElem_cons hlen,List.getElem_ofFn]
    rfl
  · rfl

theorem run_meaning {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (fuel : Nat) (q : State codeSize) :
    meaning sources code (ProducerMachine020E6.run sources code fuel q)=meaning sources code q := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih =>
    unfold ProducerMachine020E6.run
    split
    · rfl
    · exact (ih _).trans (step_meaning sources code q)

theorem done {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (fuel : Nat) (q : State codeSize) (h : codeSize-q.pc.val≤fuel) :
    (ProducerMachine020E6.run sources code fuel q).pc.val=codeSize := by
  induction fuel generalizing q with
  | zero => change q.pc.val=codeSize;have := q.pc.isLt;omega
  | succ fuel ih =>
    unfold ProducerMachine020E6.run
    split
    · assumption
    · rename_i he
      apply ih
      have hpc : q.pc.val<codeSize := by have := q.pc.isLt;omega
      rw [step,dite_eq_left hpc,execute_pc]
      simp only [next]
      omega

theorem terminal_meaning {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : State codeSize) (h : q.pc.val=codeSize) :
    meaning sources code q=q := by
  have hl : (List.ofFn (read code)).length≤codeSize := by rw [List.length_ofFn]
  rw [meaning,h,List.drop_eq_nil_of_le hl]
  rfl

theorem executes {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : State codeSize) (h : q.pc.val=0) :
    ProducerMachine020E6.run sources code codeSize q=executeList sources (List.ofFn (read code)) q := by
  have hm := run_meaning sources code codeSize q
  rw [terminal_meaning _ _ _ (done _ _ _ q (by omega))] at hm
  simpa only [meaning,h,List.drop_zero] using hm

end FT1536.S05.ProducerExecution020E6
