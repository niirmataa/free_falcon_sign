import ExprBackend020E

namespace FT1536.S05.ControlStack020E
open WordRAM020

abbrev Jobs := List Code

def next (i : Input) (c : Code) (rest : Jobs) (s : State) : Jobs × State :=
  match c with
  | .atom a => (rest,ExprBackend020E.atom i a s)
  | .seq a b => (a::b::rest,s)
  | .branch e a b => (if ExprBackend020E.value s e=0 then b::rest else a::rest,s)
  | .loop 0 _ _ => (rest,s)
  | .loop (n+1) g b =>
    if ExprBackend020E.value s g=0 then (rest,s) else (b::.loop n g b::rest,s)

/-- Fuel counts control transitions, not the complete cost of a transition. -/
def work : Code → Nat
  | .atom _ => 1
  | .seq a b => 1+work a+work b
  | .branch _ a b => 1+max (work a) (work b)
  | .loop n _ b => 1+n*(1+work b)

def total : Jobs → Nat
  | [] => 0
  | c::cs => work c+total cs

def denote (i : Input) : Jobs → State → State
  | [],s => s
  | c::cs,s => denote i cs (run i c s).1

def execute (i : Input) : Nat → Jobs → State → Option State
  | _,[],s => some s
  | 0,_::_,_ => none
  | n+1,c::cs,s =>
    let q := next i c cs s
    execute i n q.1 q.2

theorem work_positive (c : Code) : 0<work c := by
  cases c <;> simp only [work] <;> omega

theorem decreases (i : Input) (c : Code) (cs : Jobs) (s : State) :
    total (next i c cs s).1+1≤total (c::cs) := by
  cases c with
  | atom a => simp [next,total,work]
  | seq a b => simp [next,total,work];omega
  | branch e a b =>
    simp only [next,total,work]
    split <;> simp only [total]
    · omega
    · omega
  | loop n g b =>
    cases n with
    | zero => simp [next,total,work]
    | succ n =>
      simp only [next,total,work]
      split <;> simp only [total,work]
      · omega
      · nlinarith

theorem preserves (i : Input) (c : Code) (cs : Jobs) (s : State) :
    denote i (next i c cs s).1 (next i c cs s).2=denote i (c::cs) s := by
  cases c with
  | atom a => simp only [next,denote,run,ExprBackend020E.atom_eq]
  | seq a b => rfl
  | branch e a b =>
    simp only [next,ExprBackend020E.value_eq,denote,run]
    split <;> rfl
  | loop n g b =>
    cases n with
    | zero => rfl
    | succ n =>
      simp only [next,ExprBackend020E.value_eq,denote,run,iterate]
      split <;> rfl

theorem correct (i : Input) (fuel : Nat) (cs : Jobs) (s : State) (hf : total cs≤fuel) :
    execute i fuel cs s=some (denote i cs s) := by
  induction fuel generalizing cs s with
  | zero =>
    cases cs with
    | nil => rfl
    | cons c cs => have hp := work_positive c;simp only [total] at hf;omega
  | succ n ih =>
    cases cs with
    | nil => rfl
    | cons c cs =>
      rw [execute,ih _ _ (by have hd := decreases i c cs s;omega),preserves]

theorem singleton (i : Input) (c : Code) (s : State) :
    execute i (work c) [c] s=some (run i c s).1 :=
  correct i (work c) [c] s (by simp [total])

end FT1536.S05.ControlStack020E
