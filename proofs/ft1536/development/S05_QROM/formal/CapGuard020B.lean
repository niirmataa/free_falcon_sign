import CapCore020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CapGuard020B
open WordRAM020 PairProgram020 ReadSemantics020A

def observe (s : State) : Option (Word × Word) :=
  if s.reg 15=0 then none else some (s.reg 13,s.reg 14)

theorem observe_none (s : State) : observe s=none ↔ s.reg 15=0 := by
  unfold observe
  split <;> simp_all

theorem guard_on (s : State) (h : s.reg 15=0) :
    eval s (eq (r 15) (lit 0))≠0 := by
  change word (if s.reg 15=0 then 1 else 0)≠0
  rw [ite_eq_left h]
  decide

theorem guard_off (s : State) (h : s.reg 15≠0) :
    eval s (eq (r 15) (lit 0))=0 := by
  change word (if s.reg 15=0 then 1 else 0)=0
  rw [ite_eq_right h]
  rfl

theorem guard_iff (s : State) :
    eval s (eq (r 15) (lit 0))=0 ↔ observe s≠none := by
  constructor
  · intro hz hn
    exact guard_on s ((observe_none s).mp hn) hz
  · intro hn
    exact guard_off s (fun hz => hn ((observe_none s).mpr hz))

def Preserves (s t : State) : Prop := Frame s t ∧
  ∀ rr : Reg, (rr.val<2 ∨ 15<rr.val) → rr≠30 → t.reg rr=s.reg rr

theorem preserves_refl (s : State) : Preserves s s :=
  ⟨frame_refl s,fun _ _ _ => rfl⟩

theorem preserves_trans {s t u : State} (h : Preserves s t) (h' : Preserves t u) :
    Preserves s u :=
  ⟨frame_trans h.1 h'.1,fun rr hr h30 => (h'.2 rr hr h30).trans (h.2 rr hr h30)⟩

end FT1536.S05.CapGuard020B
