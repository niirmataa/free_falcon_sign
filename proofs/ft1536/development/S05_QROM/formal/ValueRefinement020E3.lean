import ValueBank020E3

namespace FT1536.S05.ValueRefinement020E3
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1

theorem expr_unused {cap : Nat} (a : Arena cap) (s : State) (p : Ptr cap) (fuel : Nat)
    (hp : a.used.val≤p.val) : NodeExpr020E2.evaluate fuel a s p=none := by
  cases fuel with
  | zero => rfl
  | succ fuel =>
    rw [NodeExpr020E2.evaluate,NodeRead020E2.inspect,NodeRead020E2.read,dite_eq_right (by omega)]
    rfl

theorem expr_code {cap : Nat} (a : Arena cap) (s : State) (mu : Meaning) (hh : HeapValid a mu)
    (p : Ptr cap) (hp : p.val<a.used.val) (c : Code) (hc : mu p.val=.code c) (fuel : Nat) :
    NodeExpr020E2.evaluate fuel a s p=none := by
  cases fuel with
  | zero => rfl
  | succ fuel =>
    obtain ⟨n,t,ht,_,hs⟩ := NodeRead020E2.inspect_exists a mu hh p hp
    rw [hc] at hs
    have hk := ArenaToken020E1.assemble_kind t _ (.code c) hs
    rw [NodeExpr020E2.evaluate,ht,Option.bind_some]
    cases t <;> first | rfl | cases hk

/-- The table contains the exact answer even for non-expression or unused
    pointers, so substitution inside every dispatch branch is justified. -/
theorem evaluator_eq {cap : Nat} (a : Arena cap) (s : State) (mu : Meaning) (hh : HeapValid a mu)
    (p : Ptr cap) :
    ValueBank020E3.lookup a (ValueBank020E3.build a s) p=NodeExpr020E2.evaluate a.used.val a s p := by
  by_cases hp : p.val<a.used.val
  · rw [ValueBank020E3.lookup_correct a s mu hh p hp]
    cases hm : mu p.val with
    | expr e => exact (NodeExpr020E2.correct a.used.val a mu s hh p e hp hp hm).symm
    | code c => exact (expr_code a s mu hh p hp c hm a.used.val).symm
  · rw [ValueBank020E3.unused_reject a _ p (by omega),expr_unused a s p _ (by omega)]

end FT1536.S05.ValueRefinement020E3
