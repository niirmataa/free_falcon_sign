import Run2.FieldMachine

namespace FT1536.Run2.FieldProgram
open BitArithmetic
abbrev F := ZMod 18433

/- A sequential input-file lookup. No unbounded RAM access is charged as a
single step: the static unary address is consumed together with the file. -/
def load : List (List Bool) → ℕ → Result
  | [],_ => ⟨[],1⟩
  | w::_,0 => ⟨w,2*w.length+1⟩
  | _::ws,n+1 => let r:=load ws n; ⟨r.bits,4+r.steps⟩

theorem load_correct (ws : List (List Bool)) (n : ℕ) :
    (load ws n).bits=ws[n]?.getD [] := by
  induction ws generalizing n with
  | nil => simp [load]
  | cons w ws ih => cases n <;> simp [load,ih]

theorem load_length (ws : List (List Bool)) (n K : ℕ)
    (h : ∀ w∈ws,w.length≤K) : (load ws n).bits.length≤K := by
  induction ws generalizing n with
  | nil => simp [load]
  | cons w ws ih =>
    cases n with
    | zero => exact h w (List.mem_cons_self ..)
    | succ n => exact ih n (fun v hv => h v (List.mem_cons_of_mem _ hv))

theorem load_steps (ws : List (List Bool)) (n K : ℕ)
    (h : ∀ w∈ws,w.length≤K) : (load ws n).steps≤4*n+2*K+1 := by
  induction ws generalizing n with
  | nil => simp [load]
  | cons w ws ih =>
    cases n with
    | zero => have hh:=h w (List.mem_cons_self ..); simp only [load]; omega
    | succ n =>
      have hh:=ih n (fun v hv => h v (List.mem_cons_of_mem _ hv))
      simp only [load]; omega

inductive Expr where
  | zero | one | negOne
  | input : ℕ → Expr
  | add : Expr → Expr → Expr
  | mul : Expr → Expr → Expr

/- Addresses are represented in unary in this reference program. The weight
also includes the literal data and instruction tags in its fixed code. -/
def weight : Expr → ℕ
  | .zero | .one | .negOne => 1
  | .input n => n+1
  | .add a b | .mul a b => weight a+weight b+1

def meaning (ws : List (List Bool)) : Expr → F
  | .zero => 0
  | .one => 1
  | .negOne => -1
  | .input n => (value (ws[n]?.getD []) : F)
  | .add a b => meaning ws a+meaning ws b
  | .mul a b => meaning ws a*meaning ws b

def execute (ws : List (List Bool)) : Expr → Result
  | .zero => ⟨[],1⟩
  | .one => ⟨[true],3⟩
  | .negOne => ⟨negOneBits,31⟩
  | .input n => load ws n
  | .add a b =>
      let x:=execute ws a; let y:=execute ws b
      let r:=fieldAdd x.bits y.bits
      ⟨r.bits,x.steps+y.steps+r.steps+4⟩
  | .mul a b =>
      let x:=execute ws a; let y:=execute ws b
      let r:=fieldMultiply x.bits y.bits
      ⟨r.bits,x.steps+y.steps+r.steps+4⟩

theorem execute_correct (ws : List (List Bool)) (p : Expr) :
    (value (execute ws p).bits : F)=meaning ws p := by
  induction p with
  | zero => rfl
  | one => rfl
  | negOne =>
    simp only [execute,meaning,negOneBits_value]
    decide
  | input n => simp only [execute,meaning,load_correct]
  | add a b ia ib =>
    simp only [execute,meaning,fieldAdd_correct,ia,ib]
  | mul a b ia ib =>
    simp only [execute,meaning,fieldMultiply_correct,ia,ib]

theorem execute_length (ws : List (List Bool)) (p : Expr)
    (h : ∀ w∈ws,w.length≤16) : (execute ws p).bits.length≤16 := by
  cases p with
  | zero => norm_num [execute]
  | one => norm_num [execute]
  | negOne => exact Nat.le_trans (Nat.le_of_eq negOneBits_length) (by decide)
  | input n => exact load_length ws n 16 h
  | add a b => exact (fieldAdd_length _ _).trans (by decide)
  | mul a b => exact (fieldMultiply_length _ _).trans (by decide)

theorem execute_steps (ws : List (List Bool)) (p : Expr)
    (h : ∀ w∈ws,w.length≤16) : (execute ws p).steps≤(2^20+4)*weight p := by
  induction p with
  | zero => norm_num [execute,weight]
  | one => norm_num [execute,weight]
  | negOne => norm_num [execute,weight]
  | input n =>
    have hh:=load_steps ws n 16 h
    simp only [execute,weight]
    omega
  | add a b ia ib =>
    have ha:=execute_length ws a h; have hb:=execute_length ws b h
    have hh:=fieldAdd_steps (execute ws a).bits (execute ws b).bits ha hb
    simp only [execute,weight]
    omega
  | mul a b ia ib =>
    have ha:=execute_length ws a h; have hb:=execute_length ws b h
    have hh:=fieldMultiply_steps (execute ws a).bits (execute ws b).bits ha hb
    simp only [execute,weight]
    omega

def sum (xs : List Expr) : Expr := xs.foldr Expr.add .zero

theorem meaning_sum (ws : List (List Bool)) (xs : List Expr) :
    meaning ws (sum xs)=(xs.map (meaning ws)).sum := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp only [sum,List.foldr_cons,meaning,List.map_cons,List.sum_cons] at *; rw [ih]

theorem weight_sum (xs : List Expr) :
    weight (sum xs)=(xs.map weight).sum+xs.length+1 := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    simp only [sum,List.foldr_cons,weight,List.map_cons,List.sum_cons,List.length_cons] at *
    omega

theorem weight_sum_bound (xs : List Expr) (M : ℕ) (h : ∀ x∈xs,weight x≤M) :
    weight (sum xs)≤(M+1)*xs.length+1 := by
  induction xs with
  | nil => simp [sum,weight]
  | cons x xs ih =>
    have hx:=h x (List.mem_cons_self ..)
    have ht:=ih (fun y hy => h y (List.mem_cons_of_mem _ hy))
    simp only [sum,List.foldr_cons,weight,List.length_cons] at *
    nlinarith

end FT1536.Run2.FieldProgram
