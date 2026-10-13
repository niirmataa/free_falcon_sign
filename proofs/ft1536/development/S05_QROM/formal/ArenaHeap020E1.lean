import ArenaTokenLaw020E1
import ArenaStack020E1

namespace FT1536.S05.ArenaHeap020E1
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaToken020E1 ArenaTokenLaw020E1 ArenaStack020E1

/-- Proof-only denotation. It is absent from Node, Arena, and executable steps. -/
abbrev Meaning := Nat → Piece

def Represents {cap : Nat} (n : Node cap) (index : Nat) (mu : Meaning) : Prop :=
  ∃ t,SyntaxCells020E.decode n.cell=some t ∧
    (∀ p∈children t n,p.val< index) ∧
    assemble t ((children t n).map (fun p => mu p.val))=some (mu index)

def HeapValid {cap : Nat} (s : Arena cap) (mu : Meaning) : Prop :=
  ∀ k : Fin cap,k.val<s.used.val → Represents (s.bank k) k.val mu

def putNode {cap : Nat} (s : Arena cap) (n : Node cap) (room : s.used.val<cap) : Arena cap :=
  { s with
    bank := Function.update s.bank ⟨s.used.val,room⟩ n
    used := ⟨s.used.val+1,by omega⟩ }

theorem put_used {cap : Nat} (s : Arena cap) (n : Node cap) (room : s.used.val<cap) :
    (putNode s n room).used.val=s.used.val+1 := rfl

theorem put_here {cap : Nat} (s : Arena cap) (n : Node cap) (room : s.used.val<cap) :
    (putNode s n room).bank ⟨s.used.val,room⟩=n := by
  change (Function.update s.bank ⟨s.used.val,room⟩ n) ⟨s.used.val,room⟩=n
  simp

theorem put_old {cap : Nat} (s : Arena cap) (n : Node cap) (room : s.used.val<cap)
    (k : Fin cap) (hk : k.val<s.used.val) : (putNode s n room).bank k=s.bank k := by
  apply Function.update_of_ne
  intro he
  have h := congrArg Fin.val he
  dsimp at h
  omega

theorem put_view {cap : Nat} (s : Arena cap) (n : Node cap) (room : s.used.val<cap) :
    view (putNode s n room)=view s := rfl

theorem map_update_below {cap : Nat} (ps : List (Ptr cap)) (mu : Meaning) (index : Nat) (v : Piece)
    (hb : ∀ p∈ps,p.val< index) :
    ps.map (fun p => Function.update mu index v p.val)=ps.map (fun p => mu p.val) := by
  apply List.map_congr_left
  intro p hp
  exact Function.update_of_ne (by have := hb p hp;omega) _ _

theorem represents_lower {cap : Nat} (n : Node cap) (k index : Nat) (mu : Meaning) (v : Piece)
    (hk : k< index) (h : Represents n k mu) : Represents n k (Function.update mu index v) := by
  obtain ⟨t,ht,hc,hp⟩ := h
  refine ⟨t,ht,hc,?_⟩
  rw [map_update_below _ mu index v (fun p hp => (hc p hp).trans hk)]
  rw [Function.update_of_ne (by omega : k≠index)]
  exact hp

theorem represents_new {cap : Nat} (n : Node cap) (t : Token) (mu : Meaning) (v : Piece) (index : Nat)
    (ht : SyntaxCells020E.decode n.cell=some t)
    (hc : ∀ p∈children t n,p.val< index)
    (hp : assemble t ((children t n).map (fun p => mu p.val))=some v) :
    Represents n index (Function.update mu index v) := by
  refine ⟨t,ht,hc,?_⟩
  rw [map_update_below _ mu index v hc]
  simpa only [Function.update_self] using hp

theorem put_valid {cap : Nat} (s : Arena cap) (n : Node cap) (room : s.used.val<cap)
    (mu : Meaning) (v : Piece) (hs : HeapValid s mu)
    (hn : Represents n s.used.val (Function.update mu s.used.val v)) :
    HeapValid (putNode s n room) (Function.update mu s.used.val v) := by
  intro k hk
  by_cases he : k.val=s.used.val
  · have ke : k=(⟨s.used.val,room⟩:Fin cap) := Fin.ext he
    subst k
    rw [put_here]
    exact hn
  · have hold : k.val<s.used.val := by rw [put_used] at hk;omega
    rw [put_old s n room k hold]
    exact represents_lower _ _ _ _ _ hold (hs k hold)

theorem node_kind {cap : Nat} (n : Node cap) (k : Nat) (mu : Meaning) (h : Represents n k mu) :
    nodeKind n=some (pieceKind (mu k)) := by
  obtain ⟨t,ht,_,hp⟩ := h
  simp only [nodeKind,ht,Option.map_some]
  exact congrArg some (assemble_kind t _ _ hp).symm

theorem empty_valid (cap : Nat) (mu : Meaning) : HeapValid (empty cap) mu := by
  intro k hk
  change k.val<0 at hk
  omega

end FT1536.S05.ArenaHeap020E1
