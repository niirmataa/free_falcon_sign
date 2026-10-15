import CommandDecode020E11

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CommandConsumer020E11
open WordRAM020 ArrayBank020E4

/-- Only one three-word slot is decoded per transition; no decoded script list
    or history is constructed by this machine. -/
structure State (n capacity : Nat) where
  target : Bank Word n
  encoded : Bank Word (capacity*3)
  cursor : Fin (capacity+1)
  bad : Bool

def slot {capacity : Nat} (b : Bank Word (capacity*3)) (j : Fin capacity) : Fin 3 → Word :=
  fun f => read b (finProdFinEquiv (j,f))

def step {n capacity : Nat} (q : State n capacity) : State n capacity :=
  if q.bad then q else
  if h : q.cursor.val<capacity then
    match CommandDecode020E11.decode n (slot q.encoded ⟨q.cursor.val,h⟩) with
    | none => {q with bad:=true}
    | some w => {q with target:=ScriptBuffer020E5.action w q.target,cursor:=⟨q.cursor.val+1,by omega⟩}
  else q

def run {n capacity : Nat} : Nat → State n capacity → State n capacity
  | 0,q => q
  | fuel+1,q => run fuel (step q)

def start {n capacity : Nat} (a : Bank Word n) (b : Bank Word (capacity*3)) : State n capacity := ⟨a,b,0,false⟩

def finish {n capacity : Nat} (q : State n capacity) : Option (Bank Word n) :=
  if q.bad then none else if q.cursor.val=capacity then some q.target else none

def consume {n capacity : Nat} (a : Bank Word n) (b : Bank Word (capacity*3)) : Option (Bank Word n) :=
  finish (run capacity (start a b))

theorem bad_step {n capacity : Nat} (q : State n capacity) (h : q.bad=true) : step q=q := by
  simp only [step,h,ite_true]

theorem bad_run {n capacity : Nat} (fuel : Nat) (q : State n capacity) (h : q.bad=true) : run fuel q=q := by
  induction fuel with
  | zero => rfl
  | succ fuel ih => rw [run,bad_step q h,ih]

theorem bad_finish {n capacity : Nat} (q : State n capacity) (h : q.bad=true) : finish q=none := by
  simp only [finish,h,ite_true]

theorem malformed {n capacity : Nat} (q : State n capacity) (hb : q.bad=false) (h : q.cursor.val<capacity)
    (he : CommandDecode020E11.decode n (slot q.encoded ⟨q.cursor.val,h⟩)=none) :
    step q={q with bad:=true} := by
  simp only [step,hb,Bool.false_eq_true,ite_false,dite_eq_left h,he]

theorem frozen_script {n capacity : Nat} (q : State n capacity) : (step q).encoded=q.encoded := by
  unfold step
  split
  · rfl
  · split
    · split <;> rfl
    · rfl

theorem completed {n capacity : Nat} (q : State n capacity) (h : q.cursor.val=capacity) : step q=q := by
  have hc : ¬q.cursor.val<capacity := by omega
  simp only [step,dite_eq_right hc,ite_self]

end FT1536.S05.CommandConsumer020E11
