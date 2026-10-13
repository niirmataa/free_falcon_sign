import BankStep020E3

namespace FT1536.S05.BankExecute020E3
open WordRAM020 ArenaTypes020E1 ArenaHeap020E1 NodeFrames020E2
open BoundedStack020E3 BankStep020E3 ControlStack020E ControlSpace020E

/-- Only bounded banks and State are threaded through the execution loop. -/
def execute {cap capacity : Nat} (a : Arena cap) (i : Input) : Nat → Frames cap capacity → State → Option State
  | 0,st,s => if st.sp.val=0 then some s else none
  | fuel+1,st,s => if st.sp.val=0 then some s else
      (step a i s st).bind (fun q => execute a i fuel q.1 q.2)

theorem uncons {cap : Nat} (a : Arena cap) (mu : Meaning) (fs : List (Frame cap))
    (c : Code) (cs : List Code) (h : Related a mu fs (c::cs)) :
    ∃ f,∃ rest,fs=f::rest ∧ Rel a mu f c ∧ Related a mu rest cs := by
  cases h with
  | cons hf ht => exact ⟨_,_,rfl,hf,ht⟩

theorem empty_sp {cap capacity : Nat} (a : Arena cap) (mu : Meaning) (st : Frames cap capacity)
    (h : Related a mu (view st) []) : st.sp.val=0 := by
  have hl := h.length_eq
  rw [view_length] at hl
  exact hl

theorem nonempty_sp {cap capacity : Nat} (a : Arena cap) (mu : Meaning) (st : Frames cap capacity)
    (c : Code) (cs : List Code) (h : Related a mu (view st) (c::cs)) : st.sp.val≠0 := by
  have hl := h.length_eq
  rw [view_length,List.length_cons] at hl
  omega

/-- The reserve invariant proves every bounded-stack write has room. -/
theorem correct {cap capacity : Nat} (a : Arena cap) (i : Input) (mu : Meaning) (hh : HeapValid a mu)
    (fuel : Nat) (st : Frames cap capacity) (cs : List Code) (s : State)
    (h : Related a mu (view st) cs) (room : reserve cs≤capacity) :
    execute a i fuel st s=ControlStack020E.execute i fuel cs s := by
  induction fuel generalizing st cs s with
  | zero =>
    cases cs with
    | nil => rw [execute,ite_eq_left (empty_sp a mu st h)];rfl
    | cons c cs => rw [execute,ite_eq_right (nonempty_sp a mu st c cs h)];rfl
  | succ fuel ih =>
    cases cs with
    | nil => rw [execute,ite_eq_left (empty_sp a mu st h)];rfl
    | cons c cs =>
      obtain ⟨f,fs,hv,hf,ht⟩ := uncons a mu (view st) c cs h
      obtain ⟨t,hstep,hr⟩ := BankStep020E3.correct a i s mu hh st f fs c cs hv hf ht room
      rw [execute,ite_eq_right (nonempty_sp a mu st c cs h),hstep,Option.bind_some,ControlStack020E.execute]
      exact ih t _ _ hr ((next_reserve i c cs s).trans room)

end FT1536.S05.BankExecute020E3
