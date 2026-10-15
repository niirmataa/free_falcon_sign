import CommandConsumer020E11

namespace FT1536.S05.ConsumerCount020E13
open WordRAM020 ArrayBank020E4 CommandConsumer020E11

/-- Counts are ghost instrumentation, not yet allocated backend storage.
    steps includes absorbing/error transitions; scans counts decoded slots;
    writes counts actual target writes. No successful-output conditioning. -/
structure Report (α : Type) where
  value : α
  steps : Nat
  scans : Nat
  writes : Nat

def step {n capacity : Nat} (q : State n capacity) : Report (State n capacity) :=
  if q.bad then ⟨q,1,0,0⟩ else
  if h : q.cursor.val<capacity then
    match CommandDecode020E11.decode n (slot q.encoded ⟨q.cursor.val,h⟩) with
    | none => ⟨{q with bad:=true},1,1,0⟩
    | some w => ⟨{q with target:=ScriptBuffer020E5.action w q.target,cursor:=⟨q.cursor.val+1,by omega⟩},1,1,if w.isSome then 1 else 0⟩
  else ⟨q,1,0,0⟩

theorem step_value {n capacity : Nat} (q : State n capacity) : (step q).value=CommandConsumer020E11.step q := by
  unfold step CommandConsumer020E11.step
  split
  · rfl
  · split
    · split <;> simp_all only []
    · rfl

theorem step_bound {n capacity : Nat} (q : State n capacity) :
    (step q).steps=1 ∧ (step q).scans≤1 ∧ (step q).writes≤(step q).scans := by
  unfold step
  split
  · exact ⟨rfl,Nat.zero_le _,Nat.le_refl _⟩
  · split
    · split
      · exact ⟨rfl,Nat.le_refl _,Nat.zero_le _⟩
      · dsimp only
        refine ⟨rfl,Nat.le_refl _,?_⟩
        split <;> omega
    · exact ⟨rfl,Nat.zero_le _,Nat.le_refl _⟩

def run {n capacity : Nat} : Nat → State n capacity → Report (State n capacity)
  | 0,q => ⟨q,0,0,0⟩
  | fuel+1,q =>
    let s := step q
    let r := run fuel s.value
    ⟨r.value,s.steps+r.steps,s.scans+r.scans,s.writes+r.writes⟩

theorem value {n capacity : Nat} (fuel : Nat) (q : State n capacity) :
    (run fuel q).value=CommandConsumer020E11.run fuel q := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih => simp only [run,CommandConsumer020E11.run,ih,step_value]

theorem bound {n capacity : Nat} (fuel : Nat) (q : State n capacity) :
    (run fuel q).steps=fuel ∧ (run fuel q).scans≤fuel ∧ (run fuel q).writes≤(run fuel q).scans := by
  induction fuel generalizing q with
  | zero => exact ⟨rfl,Nat.le_refl _,Nat.le_refl _⟩
  | succ fuel ih =>
    have hs := step_bound q
    have hr := ih (step q).value
    simp only [run]
    exact ⟨by omega,by omega,by omega⟩

def consume {n capacity : Nat} (a : Bank Word n) (b : Bank Word (capacity*3)) : Report (Option (Bank Word n)) :=
  let r := run capacity (start a b)
  ⟨finish r.value,r.steps,r.scans,r.writes⟩

theorem consume_value {n capacity : Nat} (a : Bank Word n) (b : Bank Word (capacity*3)) :
    (consume a b).value=CommandConsumer020E11.consume a b := by
  simp only [consume,CommandConsumer020E11.consume,value]

theorem consume_bound {n capacity : Nat} (a : Bank Word n) (b : Bank Word (capacity*3)) :
    (consume a b).steps=capacity ∧ (consume a b).scans≤capacity ∧
    (consume a b).writes≤(consume a b).scans := bound capacity (start a b)

end FT1536.S05.ConsumerCount020E13
