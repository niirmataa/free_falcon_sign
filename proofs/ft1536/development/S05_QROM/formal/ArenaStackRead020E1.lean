import ArenaStack020E1

namespace FT1536.S05.ArenaStackRead020E1
open SyntaxTape020E ArenaTypes020E1 ArenaStack020E1

def freshNode {cap : Nat} (s : Arena cap) (t : Token) : Node cap :=
  ⟨SyntaxCells020E.encode t,peek s 0,peek s 1,peek s 2⟩

theorem child_get {cap : Nat} (s : Arena cap) (t : Token) (j : Nat)
    (hj : j<(children t (freshNode s t)).length) :
    (children t (freshNode s t))[j]=peek s j := by
  rw [children_length] at hj
  cases t <;> simp only [arity,needs,List.length_cons,List.length_nil] at hj
  all_goals interval_cases j <;> rfl

theorem children_take {cap : Nat} (s : Arena cap) (t : Token) (hn : arity t≤s.sp.val) :
    children t (freshNode s t)=(view s).take (arity t) := by
  apply List.ext_getElem
  · rw [children_length,List.length_take,view_length,min_eq_left hn]
  · intro j hj hj'
    rw [child_get,List.getElem_take,view_get]

def StackValid {cap : Nat} (s : Arena cap) : Prop :=
  ∀ p∈view s,p.val<s.used.val

theorem children_valid {cap : Nat} (s : Arena cap) (t : Token) (hn : arity t≤s.sp.val)
    (hv : StackValid s) : ∀ p∈children t (freshNode s t),p.val<s.used.val := by
  rw [children_take s t hn]
  intro p hp
  exact hv p (List.mem_of_mem_take hp)

theorem empty_valid (cap : Nat) : StackValid (empty cap) := by
  simp [StackValid,empty_view]

end FT1536.S05.ArenaStackRead020E1
