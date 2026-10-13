import ControlStack020E

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ControlNext020E2
open WordRAM020

def loopJobs (s : State) (n : Nat) (g : Expr) (b : Code) : List Code :=
  if n=0 then [] else if eval s g=0 then [] else [b,.loop (n-1) g b]

theorem loop_shape (i : Input) (s : State) (n : Nat) (g : Expr) (b : Code) :
    ControlStack020E.next i (.loop n g b) [] s=(loopJobs s n g b,s) := by
  cases n with
  | zero => rfl
  | succ n =>
    simp only [ControlStack020E.next,loopJobs,Nat.add_eq_zero_iff,Nat.one_ne_zero,and_false,
      ite_false,ExprBackend020E.value_eq,Nat.add_sub_cancel]
    split_ifs <;> rfl

theorem next_tail (i : Input) (c : Code) (cs : List Code) (s : State) :
    ControlStack020E.next i c cs s=
      ((ControlStack020E.next i c [] s).1++cs,(ControlStack020E.next i c [] s).2) := by
  cases c with
  | atom a => rfl
  | seq a b => rfl
  | branch e a b =>
    simp only [ControlStack020E.next]
    split_ifs <;> rfl
  | loop n g b =>
    cases n with
    | zero => rfl
    | succ n =>
      simp only [ControlStack020E.next]
      split_ifs <;> rfl

end FT1536.S05.ControlNext020E2
