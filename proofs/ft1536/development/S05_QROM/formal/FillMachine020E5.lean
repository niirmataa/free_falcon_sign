import WordCodec020E5

namespace FT1536.S05.FillMachine020E5
open ArrayBank020E4

structure State (A : Type) (n : Nat) where
  bank : Bank A n
  cursor : Fin (n+1)

def step {A : Type} {n : Nat} (f : Fin n → A) (q : State A n) : State A n :=
  if h : q.cursor.val<n then ⟨write q.bank ⟨q.cursor.val,h⟩ (f ⟨q.cursor.val,h⟩),⟨q.cursor.val+1,by omega⟩⟩ else q

def run {A : Type} {n : Nat} (f : Fin n → A) : Nat → State A n → State A n
  | 0,q => q
  | fuel+1,q => run f fuel (step f q)

def Good {A : Type} {n : Nat} (f : Fin n → A) (q : State A n) : Prop :=
  ∀ j : Fin n,j.val<q.cursor.val → read q.bank j=f j

theorem step_good {A : Type} {n : Nat} (f : Fin n → A) (q : State A n) (h : Good f q) : Good f (step f q) := by
  unfold step
  split
  · rename_i hk
    intro j hj
    change j.val<q.cursor.val+1 at hj
    change read (write q.bank ⟨q.cursor.val,hk⟩ (f ⟨q.cursor.val,hk⟩)) j=f j
    rw [read_write]
    by_cases he : j.val=q.cursor.val
    · have he' : j=(⟨q.cursor.val,hk⟩:Fin n) := Fin.ext he
      simp [he']
    · rw [Function.update_of_ne (by intro e;exact he (congrArg Fin.val e))]
      exact h j (by omega)
  · exact h

theorem run_good {A : Type} {n : Nat} (f : Fin n → A) (fuel : Nat) (q : State A n) (h : Good f q) : Good f (run f fuel q) := by
  induction fuel generalizing q with
  | zero => exact h
  | succ fuel ih => exact ih _ (step_good f q h)

theorem cursor_step {A : Type} {n : Nat} (f : Fin n → A) (q : State A n) :
    (step f q).cursor.val=min n (q.cursor.val+1) := by
  unfold step
  split <;> (try dsimp) <;> have := q.cursor.isLt <;> omega

theorem complete {A : Type} {n : Nat} (f : Fin n → A) (fuel : Nat) (q : State A n)
    (h : n-q.cursor.val≤fuel) : (run f fuel q).cursor.val=n := by
  induction fuel generalizing q with
  | zero => change q.cursor.val=n;have := q.cursor.isLt;omega
  | succ fuel ih =>
    apply ih (step f q)
    rw [cursor_step]
    have := q.cursor.isLt
    omega

def start {A : Type} {n : Nat} (a : Bank A n) : State A n := ⟨a,0⟩

theorem fills {A : Type} {n : Nat} (f : Fin n → A) (a : Bank A n) :
    (run f n (start a)).bank=load f := by
  have good : Good f (start a) := by intro j hj;change j.val<0 at hj;omega
  have hg := run_good f n (start a) good
  have hc := complete f n (start a) (by exact le_rfl)
  apply ArrayBank020E4.ext
  funext j
  rw [read_load]
  exact hg j (by rw [hc];exact j.isLt)

end FT1536.S05.FillMachine020E5
