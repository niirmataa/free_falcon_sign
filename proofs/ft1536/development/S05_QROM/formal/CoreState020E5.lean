import FixedAction020E5
import ArrayExecute020E4

namespace FT1536.S05.CoreState020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5

inductive Phase where
  | check | clear | scan | act | push | done | bad
  deriving DecidableEq

/-- The complete mutable execution state. Continuations are tags/counters,
    not a recursive host stack, saved States, or growing expression lists. -/
structure Core (cap capacity limit : Nat) where
  state : ArrayState020E4.State
  frames : ArrayFrames020E4.Stack (Frame cap) capacity
  values : ArrayValues020E4.Values cap
  phase : Phase
  cursor : Fin (cap+1)
  left : Fin (limit+1)
  pending : Pending cap

def start {cap capacity : Nat} (limit : Nat) (s : ArrayState020E4.State)
    (st : ArrayFrames020E4.Stack (Frame cap) capacity) (v : ArrayValues020E4.Values cap) : Core cap capacity limit :=
  ⟨s,st,v,.check,0,⟨limit,by omega⟩,.none⟩

def terminal {cap capacity limit : Nat} (q : Core cap capacity limit) : Prop :=
  q.phase=.done ∨ q.phase=.bad
instance {cap capacity limit : Nat} (q : Core cap capacity limit) : Decidable (terminal q) := inferInstanceAs (Decidable (_ ∨ _))

def result {cap capacity limit : Nat} (q : Core cap capacity limit) : Option ArrayState020E4.State :=
  if q.phase=.done then some q.state else none

def Ready {cap capacity limit : Nat} (q : Core cap capacity limit) : Prop :=
  0<q.left.val ∧ 0<q.frames.sp.val

def Cleared {cap capacity limit : Nat} (q : Core cap capacity limit) : Prop :=
  ∀ j : Fin cap,j.val<q.cursor.val → ArrayBank020E4.read q.values j=none

def Inv {cap capacity limit : Nat} (q : Core cap capacity limit) : Prop := match q.phase with
  | .clear => Ready q ∧ Cleared q
  | .scan | .act => Ready q
  | _ => True

theorem start_inv {cap capacity : Nat} (limit : Nat) (s : ArrayState020E4.State)
    (st : ArrayFrames020E4.Stack (Frame cap) capacity) (v : ArrayValues020E4.Values cap) :
    Inv (start limit s st v) := True.intro

theorem cleared_all {cap capacity limit : Nat} (q : Core cap capacity limit)
    (h : Cleared q) (he : q.cursor.val=cap) : q.values=ArrayBank020E4.zero cap none := by
  apply ArrayBank020E4.ext
  funext j
  rw [ArrayBank020E4.zero,ArrayBank020E4.read_load]
  exact h j (by rw [he];exact j.isLt)

end FT1536.S05.CoreState020E5
