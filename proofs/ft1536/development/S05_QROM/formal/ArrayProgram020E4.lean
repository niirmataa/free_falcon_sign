import ArrayExecute020E4
import BankProgram020E3

set_option maxRecDepth 8192
namespace FT1536.S05.ArrayProgram020E4
open WordRAM020 ArenaTypes020E1 NodeFrames020E2

def fromArena {cap : Nat} (capacity : Nat) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (fuel : Nat) (s : ArrayState020E4.State) : Option ArrayState020E4.State :=
  if a.sp.val=1 then
    (ArrayFrames020E4.push (ArrayFrames020E4.empty capacity (Frame.run (0 : Ptr cap)))
      (.run (ArenaStack020E1.peek (ArrayArena020E4.model a) 0))).bind
      (fun st => ArrayExecute020E4.execute a i fuel st s)
  else none

theorem fromArena_eq {cap : Nat} (capacity : Nat) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (fuel : Nat) (s : ArrayState020E4.State) :
    (fromArena capacity a i fuel s).map ArrayState020E4.model=
      BankProgram020E3.fromArena capacity (ArrayArena020E4.model a) (ArrayState020E4.input i) fuel (ArrayState020E4.model s) := by
  unfold fromArena BankProgram020E3.fromArena
  by_cases hz : a.sp.val=1
  · simp only [show (ArrayArena020E4.model a).sp.val=a.sp.val from rfl,hz,ite_true]
    have hp := ArrayFrames020E4.push_eq (ArrayFrames020E4.empty capacity (Frame.run (0 : Ptr cap)))
      (.run (ArenaStack020E1.peek (ArrayArena020E4.model a) 0))
    rw [ArrayFrames020E4.empty_eq] at hp
    cases h : ArrayFrames020E4.push (ArrayFrames020E4.empty capacity (Frame.run (0 : Ptr cap)))
        (.run (ArenaStack020E1.peek (ArrayArena020E4.model a) 0)) with
    | none =>
      rw [h,Option.map_none] at hp
      rw [←hp];rfl
    | some st =>
      rw [h,Option.map_some] at hp
      rw [←hp,Option.bind_some]
      exact ArrayExecute020E4.execute_eq a i fuel st s
  · simp only [show (ArrayArena020E4.model a).sp.val=a.sp.val from rfl,hz,ite_false,Option.map_none]

def actual (i : ArrayState020E4.Input) (s : ArrayState020E4.State) : Option ArrayState020E4.State :=
  (ArrayArena020E4.parse (ArenaProgram020E1.image PairProgram020.program) (ArrayArena020E4.empty 877)).bind
    (fun a => fromArena BankProgram020E3.frameCapacity a i NodeProgram020E2.controlLimit s)

theorem actual_eq (i : ArrayState020E4.Input) (s : ArrayState020E4.State) :
    (actual i s).map ArrayState020E4.model=BankProgram020E3.actual (ArrayState020E4.input i) (ArrayState020E4.model s) := by
  unfold actual BankProgram020E3.actual ArenaProgram020E1.actual ArenaProgram020E1.build
  have hp := ArrayArena020E4.parse_eq (ArrayArena020E4.empty 877) (ArenaProgram020E1.image PairProgram020.program)
  rw [ArrayArena020E4.empty_eq] at hp
  cases h : ArrayArena020E4.parse (ArenaProgram020E1.image PairProgram020.program) (ArrayArena020E4.empty 877) with
  | none =>
    rw [h,Option.map_none] at hp
    rw [←hp];rfl
  | some a =>
    rw [h,Option.map_some] at hp
    rw [←hp,Option.bind_some]
    exact fromArena_eq _ a i _ s

theorem actual_correct (i : ArrayState020E4.Input) (s : ArrayState020E4.State) :
    ∃ t,actual i s=some t ∧ ArrayState020E4.model t=
      (WordRAM020.run (ArrayState020E4.input i) PairProgram020.program (ArrayState020E4.model s)).1 := by
  have h := (actual_eq i s).trans (BankProgram020E3.actual_correct _ _)
  cases hr : actual i s with
  | none => rw [hr,Option.map_none] at h;cases h
  | some t =>
    rw [hr,Option.map_some] at h
    exact ⟨t,rfl,Option.some.inj h⟩

end FT1536.S05.ArrayProgram020E4
