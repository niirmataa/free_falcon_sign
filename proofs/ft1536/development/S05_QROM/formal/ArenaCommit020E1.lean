import ArenaStep020E1

namespace FT1536.S05.ArenaCommit020E1
open SyntaxTape020E ArenaTypes020E1 ArenaToken020E1 ArenaTokenLaw020E1
open ArenaStack020E1 ArenaStackRead020E1 ArenaHeap020E1 ArenaStep020E1

theorem check_children {cap : Nat} (s : Arena cap) (t : Token) (mu : Meaning)
    (hh : HeapValid s mu) (hv : StackValid s) (hn : arity t≤s.sp.val) (v : Piece)
    (hp : assemble t ((children t (freshNode s t)).map (fun p => mu p.val))=some v) :
    (children t (freshNode s t)).map (checkedKind s)=(needs t).map some := by
  have hb := children_valid s t hn hv
  have hk := assemble_needs t _ v hp
  calc
    _ = (children t (freshNode s t)).map (fun p => some (pieceKind (mu p.val))) := by
      apply List.map_congr_left
      intro p hp
      exact checked_kind s mu hh p (hb p hp)
    _ = _ := by rw [←hk,List.map_map,List.map_map];rfl

theorem commit_heap {cap : Nat} (s : Arena cap) (t : Token) (mu : Meaning) (v : Piece)
    (ht : SyntaxCells020E.Legal t) (hh : HeapValid s mu) (hv : StackValid s)
    (hu : s.used.val<cap) (hn : arity t≤s.sp.val) (hr : s.sp.val-arity t<cap)
    (hp : assemble t ((children t (freshNode s t)).map (fun p => mu p.val))=some v) :
    HeapValid (commit s t hu hr) (Function.update mu s.used.val v) := by
  apply put_valid (replace s (arity t) s.used hr) (freshNode s t) hu mu v hh
  exact represents_new (freshNode s t) t mu v s.used.val
    (SyntaxCells020E.roundtrip t ht) (children_valid s t hn hv) hp

theorem commit_stack {cap : Nat} (s : Arena cap) (t : Token)
    (hv : StackValid s) (hu : s.used.val<cap) (hn : arity t≤s.sp.val) (hr : s.sp.val-arity t<cap) :
    StackValid (commit s t hu hr) := by
  unfold StackValid
  rw [commit_view s t hu hn hr,commit_used]
  intro p hp
  rcases List.mem_cons.mp hp with he|he
  · subst p;omega
  · have hb := hv p (List.mem_of_mem_drop he)
    omega

theorem commit_depth {cap : Nat} (s : Arena cap) (t : Token)
    (hs : s.sp.val≤s.used.val) (hu : s.used.val<cap) (hr : s.sp.val-arity t<cap) :
    (commit s t hu hr).sp.val≤(commit s t hu hr).used.val := by
  rw [commit_sp,commit_used]
  omega

theorem commit_meaning {cap : Nat} (s : Arena cap) (t : Token) (mu : Meaning) (v : Piece)
    (hv : StackValid s) (hu : s.used.val<cap) (hn : arity t≤s.sp.val) (hr : s.sp.val-arity t<cap) :
    (view (commit s t hu hr)).map (fun p => Function.update mu s.used.val v p.val)=
      v::((view s).map (fun p => mu p.val)).drop (arity t) := by
  rw [commit_view s t hu hn hr,List.map_cons,Function.update_self]
  rw [map_update_below _ mu s.used.val v (fun p hp => hv p (List.mem_of_mem_drop hp))]
  rw [List.map_drop]

theorem step_eq {cap : Nat} (s : Arena cap) (t : Token) (mu : Meaning) (v : Piece)
    (hh : HeapValid s mu) (hv : StackValid s) (hu : s.used.val<cap)
    (hn : arity t≤s.sp.val) (hr : s.sp.val-arity t<cap)
    (hp : assemble t ((children t (freshNode s t)).map (fun p => mu p.val))=some v) :
    step t s=some (commit s t hu hr) := by
  rw [step,dite_eq_left hu,ite_eq_left hn,dite_eq_left hr,
    ite_eq_left (check_children s t mu hh hv hn v hp)]

end FT1536.S05.ArenaCommit020E1
