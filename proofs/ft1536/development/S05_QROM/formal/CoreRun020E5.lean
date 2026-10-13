import CorePreservation020E5
import CoreRank020E5

namespace FT1536.S05.CoreRun020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5 CoreState020E5 CoreMeaning020E5 CoreRank020E5

/-- Semantic iteration of the first-order RAM transition. The counter is
    the loop controller; a mathematical trace is never stored by the machine. -/
def run {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) :
    Nat → Core cap capacity limit → Core cap capacity limit
  | 0,q => q
  | fuel+1,q => if terminal q then q else run a i fuel (CoreStep020E5.step a i q)

theorem invariant {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (fuel : Nat) (q : Core cap capacity limit) (h : Inv q) : Inv (run a i fuel q) := by
  induction fuel generalizing q with
  | zero => exact h
  | succ fuel ih =>
    unfold run
    split
    · exact h
    · exact ih _ (CoreStep020E5.inv a i q h)

theorem meaning {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (fuel : Nat) (q : Core cap capacity limit) (h : Inv q) : denote a i (run a i fuel q)=denote a i q := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih =>
    unfold run
    split
    · rfl
    · exact (ih _ (CoreStep020E5.inv a i q h)).trans (CorePreservation020E5.preserves a i q h)

theorem halts {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (fuel : Nat) (q : Core cap capacity limit) (h : rank q≤fuel) : terminal (run a i fuel q) := by
  induction fuel generalizing q with
  | zero =>
    by_contra hn
    have hp := positive q hn
    omega
  | succ fuel ih =>
    unfold run
    split
    · assumption
    · rename_i ht
      exact ih _ (by have hd := decreases a i q ht;omega)

def execute {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (fuel : Nat) (st : ArrayFrames020E4.Stack (Frame cap) capacity) (s : ArrayState020E4.State)
    (v : ArrayValues020E4.Values cap) : Option ArrayState020E4.State :=
  result (run a i (fuel*cycle cap+1) (start fuel s st v))

theorem execute_refines {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (fuel : Nat) (st : ArrayFrames020E4.Stack (Frame cap) capacity) (s : ArrayState020E4.State)
    (v : ArrayValues020E4.Values cap) :
    execute a i fuel st s v=ArrayExecute020E4.execute a i fuel st s := by
  have hi := start_inv fuel s st v
  have ht := halts a i (fuel*cycle cap+1) (start fuel s st v) (by exact le_rfl)
  have hm := meaning a i (fuel*cycle cap+1) (start fuel s st v) hi
  exact (terminal_meaning a i _ ht).symm.trans hm

end FT1536.S05.CoreRun020E5
