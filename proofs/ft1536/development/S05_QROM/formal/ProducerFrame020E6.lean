import ProducerPrimitive020E6

namespace FT1536.S05.ProducerFrame020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6 ProducerExpr020E6 ProducerPrimitive020E6

def Above {regions codeSize : Nat} (base : Nat) (code : List (Instruction regions codeSize)) : Prop :=
  ∀ i∈code,∀ d,destination i=some d → base≤d.val

theorem append_above {regions codeSize : Nat} (base : Nat) (xs ys : List (Instruction regions codeSize))
    (hx : Above base xs) (hy : Above base ys) : Above base (xs++ys) := by
  intro i hi d hd
  rcases List.mem_append.mp hi with h|h
  · exact hx i h d hd
  · exact hy i h d hd

theorem weaken {regions codeSize : Nat} {a b : Nat} {xs : List (Instruction regions codeSize)}
    (h : a≤b) (hx : Above b xs) : Above a xs := by
  intro i hi d hd
  exact le_trans h (hx i hi d hd)

theorem compiled {regions codeSize : Nat} (e : Expr regions) (base : Nat) (h : base+need e≤64) :
    Above base (compile (codeSize:=codeSize) e base h) := by
  induction e generalizing base with
  | literal w =>
    simp only [compile,Above,List.mem_cons,List.not_mem_nil,or_false]
    intro i hi d hd
    subst i
    cases hd
    exact le_rfl
  | load r a ih =>
    apply append_above _ _ _ (ih base h)
    simp only [Above,List.mem_cons,List.not_mem_nil,or_false]
    intro i hi d hd
    subst i;cases hd;exact le_rfl
  | binary o a b ha hb =>
    apply append_above
    · exact append_above _ _ _ (ha base _) (weaken (by omega) (hb (base+1) _))
    · simp only [Above,List.mem_cons,List.not_mem_nil,or_false]
      intro i hi d hd
      subst i;cases hd;exact le_rfl
  | select c z n hc hz hn =>
    apply append_above
    · apply append_above
      · exact append_above _ _ _ (hc base _) (weaken (by omega) (hz (base+1) _))
      · exact weaken (by omega) (hn (base+2) _)
    · simp only [Above,List.mem_cons,List.not_mem_nil,or_false]
      intro i hi d hd
      subst i;cases hd;exact le_rfl

theorem execute_below {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (base : Nat) (code : List (Instruction regions codeSize)) (h : Above base code)
    (q : State codeSize) (j : Register) (hj : j.val<base) :
    read (executeList sources code q).regs j=read q.regs j := by
  induction code generalizing q with
  | nil => rfl
  | cons i is ih =>
    rw [executeList,ih (by intro x hx;exact h x (List.mem_cons_of_mem _ hx))]
    exact below sources q i base (h i List.mem_cons_self) j hj

theorem compiled_below {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (e : Expr regions) (base : Nat) (h : base+need e≤64) (q : State codeSize) (j : Register) (hj : j.val<base) :
    read (executeList sources (compile e base h) q).regs j=read q.regs j :=
  execute_below sources base _ (compiled e base h) q j hj

end FT1536.S05.ProducerFrame020E6
