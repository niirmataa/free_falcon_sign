import ArenaCommit020E1

namespace FT1536.S05.ArenaInvariant020E1
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaToken020E1 ArenaTokenLaw020E1
open ArenaStack020E1 ArenaStackRead020E1 ArenaHeap020E1 ArenaStep020E1 ArenaCommit020E1

def Inv {cap : Nat} (s : Arena cap) (mu : Meaning) (ps : List Piece) : Prop :=
  HeapValid s mu ∧ StackValid s ∧ s.sp.val≤s.used.val ∧
    (view s).map (fun p => mu p.val)=ps

theorem logical_length {cap : Nat} (s : Arena cap) (mu : Meaning) (ps : List Piece) (h : Inv s mu ps) :
    ps.length=s.sp.val := by
  rw [←h.2.2.2,List.length_map,view_length]

theorem empty_inv (cap : Nat) (mu : Meaning) : Inv (empty cap) mu [] :=
  ⟨ArenaHeap020E1.empty_valid cap mu,ArenaStackRead020E1.empty_valid cap,le_rfl,rfl⟩

/-- Exact source push, fresh bounded allocation and concrete type checks.
    The Meaning table is constructed in the proof and never passed to step. -/
theorem step_refines {cap : Nat} (s : Arena cap) (mu : Meaning) (ps qs : List Piece) (t : Token)
    (ht : SyntaxCells020E.Legal t) (hi : Inv s mu ps) (hu : s.used.val<cap)
    (hpush : push t ps=some qs) :
    ∃ q : Arena cap,∃ nu : Meaning,step t s=some q ∧ Inv q nu qs ∧ q.used.val=s.used.val+1 := by
  obtain ⟨v,hv,hqs⟩ := push_result t ps qs hpush
  have hn : arity t≤s.sp.val := by
    have h := push_arity t ps qs hpush
    rw [logical_length s mu ps hi] at h
    exact h
  have hr : s.sp.val-arity t<cap := by have hb := hi.2.2.1;omega
  have hp : assemble t ((children t (freshNode s t)).map (fun p => mu p.val))=some v := by
    rw [children_take s t hn,List.map_take,hi.2.2.2]
    exact hv
  refine ⟨commit s t hu hr,Function.update mu s.used.val v,
    step_eq s t mu v hi.1 hi.2.1 hu hn hr hp,?_,commit_used s t hu hr⟩
  refine ⟨commit_heap s t mu v ht hi.1 hi.2.1 hu hn hr hp,
    commit_stack s t hi.2.1 hu hn hr,commit_depth s t hi.2.2.1 hu hr,?_⟩
  rw [commit_meaning s t mu v hi.2.1 hu hn hr,hi.2.2.2]
  exact hqs.symm

end FT1536.S05.ArenaInvariant020E1
