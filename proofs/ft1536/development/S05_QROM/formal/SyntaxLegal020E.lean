import SyntaxCells020E
import ControlStack020E

set_option exponentiation.threshold 512
namespace FT1536.S05.SyntaxLegal020E
open WordRAM020 SyntaxTape020E SyntaxCells020E ControlStack020E

def maxCap : Code → Nat
  | .atom _ => 0
  | .seq a b | .branch _ a b => max (maxCap a) (maxCap b)
  | .loop n _ b => max n (maxCap b)

def All (ts : List Token) : Prop := ∀ t∈ts,Legal t

theorem all_append (xs ys : List Token) : All (xs++ys) ↔ All xs ∧ All ys := by
  simp only [All,List.mem_append,or_imp,forall_and]

theorem expr_legal (e : Expr) : All (expression e) := by
  induction e with
  | lit w => simp [All,expression,Legal]
  | reg r => simp [All,expression,Legal]
  | bin o a b ha hb => simp only [expression,all_append];exact ⟨⟨ha,hb⟩,by simp [All,Legal]⟩

theorem atom_legal (a : Atom) : All (atomic a) := by
  cases a <;> simp only [atomic,all_append]
  all_goals first
    | exact ⟨expr_legal _,by simp [All,Legal]⟩
    | exact ⟨⟨expr_legal _,expr_legal _⟩,by simp [All,Legal]⟩

theorem code_legal (c : Code) (hc : maxCap c<2^511) : All (program c) := by
  induction c with
  | atom a => exact atom_legal a
  | seq a b ha hb =>
    simp only [maxCap] at hc
    simp only [program,all_append]
    exact ⟨⟨ha (by omega),hb (by omega)⟩,by simp [All,Legal]⟩
  | branch e a b ha hb =>
    simp only [maxCap] at hc
    simp only [program,all_append]
    exact ⟨⟨⟨expr_legal e,ha (by omega)⟩,hb (by omega)⟩,by simp [All,Legal]⟩
  | loop n g b hb =>
    simp only [maxCap] at hc
    simp only [program,all_append]
    exact ⟨⟨expr_legal g,hb (by omega)⟩,by simpa [All,Legal] using (show n<2^511 by omega)⟩

def JobsLegal (cs : Jobs) : Prop := ∀ c∈cs,maxCap c<2^511

theorem next_legal (i : Input) (c : Code) (cs : Jobs) (s : State) (h : JobsLegal (c::cs)) :
    JobsLegal (next i c cs s).1 := by
  have hc : maxCap c<2^511 := h c (by simp)
  have ht : JobsLegal cs := fun x hx => h x (by simp [hx])
  cases c with
  | atom a => exact ht
  | seq a b =>
    simp only [JobsLegal,next,List.mem_cons,forall_eq_or_imp]
    exact ⟨lt_of_le_of_lt (le_max_left _ _) hc,lt_of_le_of_lt (le_max_right _ _) hc,ht⟩
  | branch e a b =>
    simp only [next]
    split <;> simp only [JobsLegal,List.mem_cons,forall_eq_or_imp]
    · exact ⟨lt_of_le_of_lt (le_max_right _ _) hc,ht⟩
    · exact ⟨lt_of_le_of_lt (le_max_left _ _) hc,ht⟩
  | loop n g b =>
    cases n with
    | zero => exact ht
    | succ n =>
      simp only [next]
      split
      · exact ht
      · simp only [JobsLegal,List.mem_cons,forall_eq_or_imp]
        simp only [maxCap] at hc ⊢
        exact ⟨by omega,by omega,ht⟩

theorem decode_map (ts : List Token) (h : All ts) :
    (ts.map encode).map decode=ts.map some := by
  simp only [List.map_map]
  apply List.map_congr_left
  intro t ht
  exact roundtrip t (h t ht)

end FT1536.S05.SyntaxLegal020E
