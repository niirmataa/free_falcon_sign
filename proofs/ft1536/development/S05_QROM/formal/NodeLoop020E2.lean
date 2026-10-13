import NodeAction020E2
import ControlNext020E2

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.NodeLoop020E2
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 NodeFrames020E2 NodeAction020E2

theorem correct {cap : Nat} (a : Arena cap) (s : State) (mu : Meaning) (hh : HeapValid a mu)
    (pc body guard : Ptr cap) (limit remaining : Nat) (g : Expr) (b : Code)
    (hp : pc.val<a.used.val) (hpc : mu pc.val=.code (.loop limit g b))
    (hlimit : SyntaxLegal020E.maxCap (.loop limit g b)<2^511)
    (hb : body.val<a.used.val) (hbody : mu body.val=.code b)
    (hg : guard.val<a.used.val) (hguard : mu guard.val=.expr g) (hn : remaining≤limit) :
    ∃ fs : List (Frame cap),loopAction a s pc body guard remaining=some (fs,s) ∧
      Related a mu fs (ControlNext020E2.loopJobs s remaining g b) := by
  have hbl : SyntaxLegal020E.maxCap b<2^511 := by
    simp only [SyntaxLegal020E.maxCap] at hlimit
    omega
  cases remaining with
  | zero => exact ⟨[],rfl,List.Forall₂.nil⟩
  | succ n =>
    have heval := NodeExpr020E2.correct a.used.val a mu s hh guard g hg hg hguard
    by_cases hz : eval s g=0
    · refine ⟨[],?_,?_⟩
      · simp [loopAction,heval,hz]
      · rw [ControlNext020E2.loopJobs,ite_eq_right (Nat.succ_ne_zero n),ite_eq_left hz]
        exact List.Forall₂.nil
    · have hnb : n<2^511 := by simp only [SyntaxLegal020E.maxCap] at hlimit;omega
      let k : Count := ⟨n,hnb⟩
      refine ⟨[.run body,.again pc k],?_,?_⟩
      · simp only [loopAction,Nat.succ_ne_zero,ite_false,heval,Option.bind_some,ite_eq_right hz,Nat.add_sub_cancel]
        rw [count_eq n hnb]
        rfl
      · have hr : Related a mu [.run body,.again pc k] [b,.loop n g b] :=
          List.Forall₂.cons (Rel.run body b hb hbody hbl)
            (List.Forall₂.cons (Rel.again pc k limit g b hp hpc hlimit (by change n≤limit;omega)) List.Forall₂.nil)
        rw [ControlNext020E2.loopJobs,ite_eq_right (Nat.succ_ne_zero n),ite_eq_right hz,Nat.add_sub_cancel]
        exact hr

end FT1536.S05.NodeLoop020E2
