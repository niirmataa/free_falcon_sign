import BankWordLayout020E5

namespace FT1536.S05.WordPatch020E5
open WordRAM020 ArrayBank020E4

abbrev Write (n : Nat) := Fin n × Word

def apply {n : Nat} : List (Write n) → Bank Word n → Bank Word n
  | [],a => a
  | (j,v)::xs,a => apply xs (write a j v)

theorem extent {n : Nat} (xs : List (Write n)) (a : Bank Word n) : (apply xs a).cells.size=n :=
  (apply xs a).size_eq

/-- A store list contains actual addresses and payload words. Agreement
    outside its support and at its stores proves the complete resulting data. -/
theorem realizes {n : Nat} (xs : List (Write n)) (a b : Bank Word n)
    (values : ∀ x∈xs,x.2=read b x.1)
    (outside : ∀ j,(∀ x∈xs,x.1≠j) → read a j=read b j) : apply xs a=b := by
  induction xs generalizing a with
  | nil =>
    apply ArrayBank020E4.ext
    funext j
    exact outside j (by simp)
  | cons x xs ih =>
    apply ih (write a x.1 x.2)
    · intro y hy
      exact values y (List.mem_cons_of_mem _ hy)
    · intro j hj
      rw [read_write]
      by_cases he : j=x.1
      · subst j
        rw [Function.update_self]
        exact values x (List.mem_cons_self)
      · rw [Function.update_of_ne he]
        apply outside j
        intro y hy
        rcases List.mem_cons.mp hy with hy|hy
        · subst y;exact Ne.symm he
        · exact hj y hy

def singleton {n : Nat} (j : Fin n) (v : Word) : List (Write n) := [(j,v)]

theorem singleton_apply {n : Nat} (a : Bank Word n) (j : Fin n) (v : Word) :
    apply (singleton j v) a=write a j v := rfl

/-- The operational trace records only stores to existing cells. It never
    appends a bank or keeps previous snapshots as live machine objects. -/
inductive Stores {n : Nat} : Bank Word n → List (Bank Word n) → Bank Word n → Prop where
  | nil (a : Bank Word n) : Stores a [] a
  | cons {a b : Bank Word n} {hist : List (Bank Word n)} (j : Fin n) (v : Word) :
      Stores (write a j v) hist b → Stores a ((write a j v)::hist) b

theorem has_trace {n : Nat} (xs : List (Write n)) (a : Bank Word n) :
    ∃ hist,Stores a hist (apply xs a) ∧ hist.length=xs.length := by
  induction xs generalizing a with
  | nil => exact ⟨[],.nil a,rfl⟩
  | cons x xs ih =>
    obtain ⟨hist,h,hl⟩ := ih (write a x.1 x.2)
    exact ⟨write a x.1 x.2::hist,.cons x.1 x.2 h,congrArg Nat.succ hl⟩

theorem every_payload_size {n : Nat} {a b : Bank Word n} {hist : List (Bank Word n)}
    (_trace : Stores a hist b) : ∀ x∈hist,x.cells.size=n := by
  intro x hx
  exact x.size_eq

end FT1536.S05.WordPatch020E5
