import ArenaHeap020E1
import ArenaStackRead020E1

namespace FT1536.S05.ArenaStep020E1
open SyntaxTape020E ArenaTypes020E1 ArenaStack020E1 ArenaStackRead020E1 ArenaHeap020E1

def checkedKind {cap : Nat} (s : Arena cap) (p : Ptr cap) : Option Kind :=
  if hp : p.val<s.used.val then nodeKind (s.bank ⟨p.val,by have := s.used.isLt;omega⟩) else none

def commit {cap : Nat} (s : Arena cap) (t : Token)
    (heapRoom : s.used.val<cap) (stackRoom : s.sp.val-arity t<cap) : Arena cap :=
  putNode (replace s (arity t) s.used stackRoom) (freshNode s t) heapRoom

/-- Runtime reads only stored cells/addresses and their tags. No Meaning
    parameter, AST reconstruction, or proof oracle occurs in this step. -/
def step {cap : Nat} (t : Token) (s : Arena cap) : Option (Arena cap) :=
  if hu : s.used.val<cap then
    if arity t≤s.sp.val then
      if hr : s.sp.val-arity t<cap then
        if (children t (freshNode s t)).map (checkedKind s)=(needs t).map some then
          some (commit s t hu hr)
        else none
      else none
    else none
  else none

def stepCell {cap : Nat} (cell : SyntaxCells020E.Cell) (s : Arena cap) : Option (Arena cap) :=
  (SyntaxCells020E.decode cell).bind (fun t => step t s)

theorem checked_kind {cap : Nat} (s : Arena cap) (mu : Meaning) (h : HeapValid s mu)
    (p : Ptr cap) (hp : p.val<s.used.val) : checkedKind s p=some (pieceKind (mu p.val)) := by
  rw [checkedKind,dite_eq_left hp]
  exact node_kind _ _ _ (h ⟨p.val,by have := s.used.isLt;omega⟩ hp)

theorem commit_used {cap : Nat} (s : Arena cap) (t : Token)
    (hu : s.used.val<cap) (hr : s.sp.val-arity t<cap) :
    (commit s t hu hr).used.val=s.used.val+1 := rfl

theorem commit_sp {cap : Nat} (s : Arena cap) (t : Token)
    (hu : s.used.val<cap) (hr : s.sp.val-arity t<cap) :
    (commit s t hu hr).sp.val=s.sp.val-arity t+1 := rfl

theorem commit_view {cap : Nat} (s : Arena cap) (t : Token)
    (hu : s.used.val<cap) (hn : arity t≤s.sp.val) (hr : s.sp.val-arity t<cap) :
    view (commit s t hu hr)=s.used::(view s).drop (arity t) :=
  view_replace s (arity t) s.used hn hr

theorem encoded_step {cap : Nat} (s : Arena cap) (t : Token) (ht : SyntaxCells020E.Legal t) :
    stepCell (SyntaxCells020E.encode t) s=step t s := by
  rw [stepCell,SyntaxCells020E.roundtrip t ht]
  rfl

end FT1536.S05.ArenaStep020E1
