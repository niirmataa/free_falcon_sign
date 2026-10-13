import NodeRead020E2

namespace FT1536.S05.NodeControlShape020E2
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 ArenaToken020E1

theorem seq_shape {cap : Nat} (n : Node cap) (t : Token) (mu : Meaning) (a b : Code)
    (h : assemble t ((children t n).map (fun p => mu p.val))=some (.code (.seq a b))) :
    t=.seq ∧ mu n.first.val=.code b ∧ mu n.second.val=.code a := by
  cases t <;> cases h1 : mu n.first.val <;> cases h2 : mu n.second.val <;> cases h3 : mu n.third.val <;>
    simp_all [assemble,children,arity,needs,push]

theorem branch_shape {cap : Nat} (n : Node cap) (t : Token) (mu : Meaning) (g : Expr) (a b : Code)
    (h : assemble t ((children t n).map (fun p => mu p.val))=some (.code (.branch g a b))) :
    t=.branch ∧ mu n.first.val=.code b ∧ mu n.second.val=.code a ∧ mu n.third.val=.expr g := by
  cases t <;> cases h1 : mu n.first.val <;> cases h2 : mu n.second.val <;> cases h3 : mu n.third.val <;>
    simp_all [assemble,children,arity,needs,push]

theorem loop_shape {cap : Nat} (n : Node cap) (t : Token) (mu : Meaning) (limit : Nat) (g : Expr) (b : Code)
    (h : assemble t ((children t n).map (fun p => mu p.val))=some (.code (.loop limit g b))) :
    t=.loop limit ∧ mu n.first.val=.code b ∧ mu n.second.val=.expr g := by
  cases t <;> cases h1 : mu n.first.val <;> cases h2 : mu n.second.val <;> cases h3 : mu n.third.val <;>
    simp_all [assemble,children,arity,needs,push]

end FT1536.S05.NodeControlShape020E2
