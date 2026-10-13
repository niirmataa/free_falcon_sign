import ControlSpace020E
import SyntaxLegal020E

namespace FT1536.S05.ControlMeter020E
open WordRAM020 ControlStack020E ControlSpace020E SyntaxLegal020E

structure Report where
  answer : Option State
  transitions : Nat
  peakSyntax : Nat

def measured (i : Input) : Nat → Jobs → State → Report
  | _,[],s => ⟨some s,0,0⟩
  | 0,cs,_ => ⟨none,0,footprint cs⟩
  | n+1,c::cs,s =>
    let q := next i c cs s
    let r := measured i n q.1 q.2
    ⟨r.answer,1+r.transitions,max (footprint (c::cs)+footprint q.1) r.peakSyntax⟩

theorem answer_eq (i : Input) (fuel : Nat) (cs : Jobs) (s : State) :
    (measured i fuel cs s).answer=execute i fuel cs s := by
  induction fuel generalizing cs s with
  | zero => cases cs <;> rfl
  | succ n ih =>
    cases cs with
    | nil => rfl
    | cons c cs => exact ih _ _

theorem bounds (i : Input) (fuel : Nat) (cs : Jobs) (s : State) :
    (measured i fuel cs s).transitions≤fuel ∧
      (measured i fuel cs s).peakSyntax≤2*reserve cs := by
  induction fuel generalizing cs s with
  | zero =>
    cases cs with
    | nil => exact ⟨le_rfl,le_rfl⟩
    | cons c cs => exact ⟨le_rfl,by change footprint (c::cs)≤2*reserve (c::cs);have := footprint_le (c::cs);omega⟩
  | succ n ih =>
    cases cs with
    | nil => exact ⟨Nat.zero_le _,le_rfl⟩
    | cons c cs =>
      have b := ih (next i c cs s).1 (next i c cs s).2
      have r := next_reserve i c cs s
      exact ⟨by change 1+_≤n+1;omega,
        max_le (transition_footprint i c cs s) (by omega)⟩

theorem correct_with_peak (i : Input) (c : Code) (s : State) :
    (measured i (work c) [c] s).answer=some (run i c s).1 ∧
      (measured i (work c) [c] s).transitions≤work c ∧
      (measured i (work c) [c] s).peakSyntax≤2*space c := by
  have b := bounds i (work c) [c] s
  simp only [reserve,footprint,Nat.add_zero,max_eq_left (Nat.zero_le _)] at b
  exact ⟨(answer_eq _ _ _ _).trans (singleton _ _ _),b⟩

/-- Every finite execution prefix preserves the cap-width invariant. -/
inductive Reach (i : Input) (cs0 : Jobs) (s0 : State) : Jobs → State → Prop where
  | start : Reach i cs0 s0 cs0 s0
  | step {c : Code} {cs : Jobs} {s : State} : Reach i cs0 s0 (c::cs) s →
      Reach i cs0 s0 (next i c cs s).1 (next i c cs s).2

theorem reachable_resources (i : Input) (cs0 cs : Jobs) (s0 s : State)
    (h : Reach i cs0 s0 cs s) (h0 : JobsLegal cs0) :
    reserve cs≤reserve cs0 ∧ JobsLegal cs := by
  induction h with
  | start => exact ⟨le_rfl,h0⟩
  | step prev ih => exact ⟨(next_reserve _ _ _ _).trans ih.1,next_legal _ _ _ _ ih.2⟩

end FT1536.S05.ControlMeter020E
