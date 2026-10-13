import NodeRead020E2

set_option exponentiation.threshold 512
namespace FT1536.S05.NodeFrames020E2
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1

abbrev Count := Fin (2^511)

inductive Frame (cap : Nat) where
  | run (pc : Ptr cap)
  | again (pc : Ptr cap) (remaining : Count)
  deriving Repr

def count (n : Nat) : Option Count := if hn : n<2^511 then some ⟨n,hn⟩ else none

theorem count_eq (n : Nat) (hn : n<2^511) : count n=some ⟨n,hn⟩ := by rw [count,dite_eq_left hn]

/-- Proof-only relation. Live frames contain neither Code nor Meaning. -/
inductive Rel {cap : Nat} (a : Arena cap) (mu : Meaning) : Frame cap → Code → Prop where
  | run (p : Ptr cap) (c : Code) (hp : p.val<a.used.val) (hm : mu p.val=.code c)
      (hc : SyntaxLegal020E.maxCap c<2^511) : Rel a mu (.run p) c
  | again (p : Ptr cap) (remaining : Count) (limit : Nat) (g : Expr) (b : Code)
      (hp : p.val<a.used.val) (hm : mu p.val=.code (.loop limit g b))
      (hc : SyntaxLegal020E.maxCap (.loop limit g b)<2^511) (hn : remaining.val≤limit) :
      Rel a mu (.again p remaining) (.loop remaining.val g b)

def Related {cap : Nat} (a : Arena cap) (mu : Meaning) := List.Forall₂ (Rel a mu)

theorem rel_legal {cap : Nat} (a : Arena cap) (mu : Meaning) (f : Frame cap) (c : Code) (h : Rel a mu f c) :
    SyntaxLegal020E.maxCap c<2^511 := by
  cases h with
  | run _ _ _ _ hc => exact hc
  | again p n limit g b _ _ hc hn =>
    simp only [SyntaxLegal020E.maxCap] at hc ⊢
    have hn' := n.isLt
    omega

theorem related_length {cap : Nat} (a : Arena cap) (mu : Meaning)
    (fs : List (Frame cap)) (cs : List Code) (h : Related a mu fs cs) : fs.length=cs.length := h.length_eq

end FT1536.S05.NodeFrames020E2
