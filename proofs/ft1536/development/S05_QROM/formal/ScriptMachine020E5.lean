import ScriptBuffer020E5

namespace FT1536.S05.ScriptMachine020E5
open WordRAM020 ArrayBank020E4 ScriptBuffer020E5

structure State (n capacity : Nat) where
  target : Bank Word n
  script : Buffer n capacity
  cursor : Fin (capacity+1)

def step {n capacity : Nat} (q : State n capacity) : State n capacity :=
  if h : q.cursor.val<capacity then
    ⟨action (read q.script ⟨q.cursor.val,h⟩) q.target,q.script,⟨q.cursor.val+1,by omega⟩⟩
  else q

def run {n capacity : Nat} : Nat → State n capacity → State n capacity
  | 0,q => q
  | fuel+1,q => run fuel (step q)

def meaning {n capacity : Nat} (q : State n capacity) : Bank Word n :=
  scan ((List.ofFn (read q.script)).drop q.cursor.val) q.target

theorem step_meaning {n capacity : Nat} (q : State n capacity) : meaning (step q)=meaning q := by
  unfold step
  split
  · rename_i h
    have hl : q.cursor.val<(List.ofFn (read q.script)).length := by simpa only [List.length_ofFn] using h
    unfold meaning
    rw [List.drop_eq_getElem_cons hl,List.getElem_ofFn]
    rfl
  · rfl

theorem run_meaning {n capacity : Nat} (fuel : Nat) (q : State n capacity) : meaning (run fuel q)=meaning q := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih => exact (ih (step q)).trans (step_meaning q)

theorem step_cursor {n capacity : Nat} (q : State n capacity) :
    (step q).cursor.val=min capacity (q.cursor.val+1) := by
  unfold step
  split <;> (try dsimp) <;> have := q.cursor.isLt <;> omega

theorem done {n capacity : Nat} (fuel : Nat) (q : State n capacity) (h : capacity-q.cursor.val≤fuel) :
    (run fuel q).cursor.val=capacity := by
  induction fuel generalizing q with
  | zero => change q.cursor.val=capacity;have := q.cursor.isLt;omega
  | succ fuel ih =>
    apply ih
    rw [step_cursor]
    omega

theorem terminal_meaning {n capacity : Nat} (q : State n capacity) (h : q.cursor.val=capacity) : meaning q=q.target := by
  have hl : (List.ofFn (read q.script)).length≤capacity := by rw [List.length_ofFn]
  rw [meaning,h,List.drop_eq_nil_of_le hl]
  rfl

def start {n capacity : Nat} (a : Bank Word n) (b : Buffer n capacity) : State n capacity := ⟨a,b,0⟩

theorem executes {n capacity : Nat} (a : Bank Word n) (b : Buffer n capacity) :
    (run capacity (start a b)).target=ScriptBuffer020E5.execute b a := by
  have hm := run_meaning capacity (start a b)
  rw [terminal_meaning _ (done _ _ (by exact le_rfl))] at hm
  exact hm

theorem script_executes {n capacity : Nat} (a : Bank Word n) (xs : List (WordPatch020E5.Write n)) (h : xs.length≤capacity) :
    (run capacity (start a (buffer capacity xs))).target=WordPatch020E5.apply xs a :=
  (executes a _).trans (ScriptBuffer020E5.executes xs h a)

end FT1536.S05.ScriptMachine020E5
