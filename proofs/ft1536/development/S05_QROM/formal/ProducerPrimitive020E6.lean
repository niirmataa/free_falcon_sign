import ProducerExpr020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerPrimitive020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6

/-- Fixed-width RAM primitives write into already allocated registers.
    The signed Word512 ALU is exactly WordRAM020.op, not a host callback. -/
def destination {regions codeSize : Nat} : Instruction regions codeSize → Option Register
  | .literal d _ | .copy d _ | .binary d _ _ _ | .load d _ _ | .select d _ _ _ => some d
  | .output _ _ => none

theorem write_below {n : Nat} (a : Bank Word n) (dst j : Fin n) (w : Word) (h : j.val<dst.val) :
    read (write a dst w) j=read a j := by
  rw [read_write,Function.update_of_ne (by intro he;have := congrArg Fin.val he;omega)]

theorem literal_value {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (q : State codeSize) (d : Register) (w : Word) :
    read (execute sources (.literal d w) q).regs d=w := by
  change read (write q.regs d w) d=w
  rw [read_write,Function.update_self]

theorem load_value {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (q : State codeSize) (d a : Register) (r : Fin regions) :
    read (execute sources (.load d r a) q).regs d=ProducerExpr020E6.readWord sources r (read q.regs a) := by
  unfold execute ProducerExpr020E6.readWord
  cases ha : WordRAM020.address (extent r) (read q.regs a) <;>
    simp only [ha,read_write,Function.update_self]

theorem binary_value {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (q : State codeSize) (d a b : Register) (o : Op) :
    read (execute sources (.binary d o a b) q).regs d=WordRAM020.op o (read q.regs a) (read q.regs b) := by
  change read (write q.regs d _) d=_
  rw [read_write,Function.update_self]

theorem select_value {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (q : State codeSize) (d c z n : Register) :
    read (execute sources (.select d c z n) q).regs d=if read q.regs c=0 then read q.regs z else read q.regs n := by
  change read (write q.regs d _) d=_
  rw [read_write,Function.update_self]
  split <;> rfl

theorem below {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (q : State codeSize) (i : Instruction regions codeSize) (base : Nat)
    (hd : ∀ d,destination i=some d → base≤d.val) (j : Register) (hj : j.val<base) :
    read (execute sources i q).regs j=read q.regs j := by
  cases i with
  | literal d w => exact write_below _ _ _ _ (lt_of_lt_of_le hj (hd d rfl))
  | copy d s => exact write_below _ _ _ _ (lt_of_lt_of_le hj (hd d rfl))
  | binary d o a b => exact write_below _ _ _ _ (lt_of_lt_of_le hj (hd d rfl))
  | load d r a =>
    unfold execute
    dsimp only
    cases ha : WordRAM020.address (extent r) (read q.regs a) <;>
      exact write_below _ _ _ _ (lt_of_lt_of_le hj (hd d rfl))
  | output d s => rfl
  | select d c z n => exact write_below _ _ _ _ (lt_of_lt_of_le hj (hd d rfl))

end FT1536.S05.ProducerPrimitive020E6
