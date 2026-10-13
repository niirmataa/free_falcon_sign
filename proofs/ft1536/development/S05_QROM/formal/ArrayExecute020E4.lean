import ArrayAction020E4
import ArrayFrames020E4
import BankExecute020E3

namespace FT1536.S05.ArrayExecute020E4
open WordRAM020 NodeFrames020E2
abbrev Frames (cap capacity : Nat) := ArrayFrames020E4.Stack (Frame cap) capacity

def model {cap capacity : Nat} (q : Frames cap capacity × ArrayState020E4.State) :
    BankStep020E3.Frames cap capacity × State := (ArrayFrames020E4.model q.1,ArrayState020E4.model q.2)

def step {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (st : Frames cap capacity) : Option (Frames cap capacity × ArrayState020E4.State) :=
  (ArrayFrames020E4.top st).bind (fun f => (ArrayAction020E4.action a i s f).bind (fun q =>
    (ArrayFrames020E4.pushMany (ArrayFrames020E4.drop st 1) q.1).map (fun t => (t,q.2))))

def execute {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) :
    Nat → Frames cap capacity → ArrayState020E4.State → Option ArrayState020E4.State
  | 0,st,s => if st.sp.val=0 then some s else none
  | fuel+1,st,s => if st.sp.val=0 then some s else
      (step a i s st).bind (fun q => execute a i fuel q.1 q.2)

theorem step_eq {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (st : Frames cap capacity) :
    (step a i s st).map model=BankStep020E3.step (ArrayArena020E4.model a) (ArrayState020E4.input i)
      (ArrayState020E4.model s) (ArrayFrames020E4.model st) := by
  unfold step BankStep020E3.step
  simp only [←ArrayFrames020E4.top_eq]
  cases ht : ArrayFrames020E4.top st with
  | none => rfl
  | some f =>
    simp only [Option.bind_some]
    have h := ArrayAction020E4.action_eq a i s f
    cases ha : ArrayAction020E4.action a i s f with
    | none =>
      rw [ha,Option.map_none] at h
      rw [←h];rfl
    | some q =>
      rw [ha,Option.map_some] at h
      rw [←h]
      simp only [Option.bind_some,ArrayAction020E4.model]
      have hp := ArrayFrames020E4.pushMany_eq (ArrayFrames020E4.drop st 1) q.1
      rw [ArrayFrames020E4.drop_eq] at hp
      cases hx : ArrayFrames020E4.pushMany (ArrayFrames020E4.drop st 1) q.1 with
      | none =>
        rw [hx,Option.map_none] at hp
        rw [←hp];rfl
      | some r =>
        rw [hx,Option.map_some] at hp
        rw [←hp];rfl

theorem execute_eq {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (fuel : Nat) (st : Frames cap capacity) (s : ArrayState020E4.State) :
    (execute a i fuel st s).map ArrayState020E4.model=
      BankExecute020E3.execute (ArrayArena020E4.model a) (ArrayState020E4.input i) fuel
        (ArrayFrames020E4.model st) (ArrayState020E4.model s) := by
  induction fuel generalizing st s with
  | zero =>
    unfold execute BankExecute020E3.execute
    change (if st.sp.val=0 then some s else none).map ArrayState020E4.model=
      if st.sp.val=0 then some (ArrayState020E4.model s) else none
    split <;> rfl
  | succ fuel ih =>
    unfold execute BankExecute020E3.execute
    by_cases hz : st.sp.val=0
    · simp only [ArrayFrames020E4.model,hz,ite_true,Option.map_some]
    · simp only [ArrayFrames020E4.model,hz,ite_false]
      have h := step_eq a i s st
      simp only [ArrayFrames020E4.model] at h
      cases hs : step a i s st with
      | none =>
        rw [hs,Option.map_none] at h
        rw [←h];rfl
      | some q =>
        rw [hs,Option.map_some] at h
        rw [←h,Option.bind_some]
        exact ih q.1 q.2

end FT1536.S05.ArrayExecute020E4
