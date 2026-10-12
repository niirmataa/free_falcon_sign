import ReadSemantics020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.FlagCore020C
open WordRAM020 PairProgram020 ReadSemantics020A

def observe {A : Type} (flag : Reg) (payload : State → A) (s : State) : Option A :=
  if s.reg flag=0 then none else some (payload s)
def guard (flag : Reg) : Expr := eq (r flag) (lit 0)

theorem observe_none {A : Type} (flag : Reg) (payload : State → A) (s : State) :
    observe flag payload s=none ↔ s.reg flag=0 := by
  unfold observe
  split <;> simp_all

theorem guard_on (flag : Reg) (s : State) (hs : s.reg flag=0) : eval s (guard flag)≠0 := by
  change word (if s.reg flag=0 then 1 else 0)≠0
  rw [ite_eq_left hs]
  decide

theorem guard_off (flag : Reg) (s : State) (hs : s.reg flag≠0) : eval s (guard flag)=0 := by
  change word (if s.reg flag=0 then 1 else 0)=0
  rw [ite_eq_right hs]
  rfl

theorem guard_iff {A : Type} (flag : Reg) (payload : State → A) (s : State) :
    eval s (guard flag)=0 ↔ observe flag payload s≠none := by
  constructor
  · intro hz he
    exact guard_on flag s ((observe_none flag payload s).mp he) hz
  · intro he
    exact guard_off flag s (fun hz => he ((observe_none flag payload s).mpr hz))

end FT1536.S05.FlagCore020C
