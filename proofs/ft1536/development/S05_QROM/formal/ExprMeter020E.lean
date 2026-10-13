import ExprStack020E

namespace FT1536.S05.ExprMeter020E
open WordRAM020 ExprStack020E

structure Report where
  answer : Option (List Word)
  executed : Nat
  peak : Nat

def measured (s : State) : List Instr → List Word → Report
  | [],vs => ⟨some vs,0,vs.length⟩
  | x::xs,vs => match step s x vs with
    | none => ⟨none,1,vs.length⟩
    | some ws =>
      let r := measured s xs ws
      ⟨r.answer,1+r.executed,max vs.length r.peak⟩

theorem step_growth (s : State) (x : Instr) (vs ws : List Word)
    (h : step s x vs=some ws) : ws.length≤vs.length+1 := by
  cases x with
  | literal w => cases h; simp
  | register r => cases h; simp
  | binary o =>
    cases vs with
    | nil => cases h
    | cons b bs =>
      cases bs with
      | nil => cases h
      | cons a rest => cases h; simp

theorem answer_eq (s : State) (xs : List Instr) (vs : List Word) :
    (measured s xs vs).answer=execute s xs vs := by
  induction xs generalizing vs with
  | nil => rfl
  | cons x xs ih =>
    simp only [measured,execute]
    cases h : step s x vs with
    | none => rfl
    | some ws => exact ih ws

theorem resource_bounds (s : State) (xs : List Instr) (vs : List Word) :
    (measured s xs vs).executed≤xs.length ∧
      (measured s xs vs).peak≤vs.length+xs.length := by
  induction xs generalizing vs with
  | nil => simp [measured]
  | cons x xs ih =>
    simp only [measured]
    cases h : step s x vs with
    | none => simp
    | some ws =>
      have b := ih ws
      have growth := step_growth s x vs ws h
      simp only [List.length_cons]
      exact ⟨by omega,max_le (by omega) (by omega)⟩

theorem compiled (s : State) (e : Expr) :
    (measured s (compile e) []).answer=some [eval s e] ∧
      (measured s (compile e) []).executed≤exprNodes e ∧
      (measured s (compile e) []).peak≤exprNodes e := by
  have b := resource_bounds s (compile e) []
  rw [ExprStack020E.length] at b
  exact ⟨(answer_eq _ _ _).trans (correct _ _ _),b.1,by simpa using b.2⟩

end FT1536.S05.ExprMeter020E
