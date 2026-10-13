import ArenaHeap020E1

namespace FT1536.S05.NodeRead020E2
open SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1

/-- Only used nodes can be read; the code arena is a read-only argument. -/
def read {cap : Nat} (a : Arena cap) (p : Ptr cap) : Option (Node cap) :=
  if hp : p.val<a.used.val then some (a.bank ⟨p.val,by have := a.used.isLt;omega⟩) else none

def inspect {cap : Nat} (a : Arena cap) (p : Ptr cap) : Option (Node cap × Token) :=
  (read a p).bind (fun n => (SyntaxCells020E.decode n.cell).map (fun t => (n,t)))

theorem valid_read {cap : Nat} (a : Arena cap) (p : Ptr cap) (hp : p.val<a.used.val) :
    read a p=some (a.bank ⟨p.val,by have := a.used.isLt;omega⟩) := by
  rw [read,dite_eq_left hp]

theorem inspect_exists {cap : Nat} (a : Arena cap) (mu : Meaning) (h : HeapValid a mu)
    (p : Ptr cap) (hp : p.val<a.used.val) :
    ∃ n : Node cap,∃ t : Token,inspect a p=some (n,t) ∧
      (∀ q∈children t n,q.val<p.val) ∧
      ArenaToken020E1.assemble t ((children t n).map (fun q => mu q.val))=some (mu p.val) := by
  let k : Fin cap := ⟨p.val,by have := a.used.isLt;omega⟩
  obtain ⟨t,ht,hc,hp'⟩ := h k hp
  refine ⟨a.bank k,t,?_,hc,hp'⟩
  rw [inspect,valid_read a p hp]
  change (SyntaxCells020E.decode (a.bank k).cell).map (fun u => (a.bank k,u))=some (a.bank k,t)
  rw [ht]
  rfl

end FT1536.S05.NodeRead020E2
