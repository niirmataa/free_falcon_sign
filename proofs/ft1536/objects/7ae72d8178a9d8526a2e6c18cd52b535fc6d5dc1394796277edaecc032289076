import Source3.StableBinaryByteView

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryByteLayout
open FT1536.Source3.StableBinary

theorem allowed_index (l : Layout) (a : Nat) (h : l.allowed a) :
    (∃ i<l.length, a=addr l.values i) ∨
    (∃ i<l.length, a=addr l.scratch i) := by
  unfold Layout.allowed at h
  rcases (Bool.or_eq_true _ _).mp h with hv | hs
  · obtain ⟨i,hi,heq⟩ := List.any_eq_true.mp hv
    exact Or.inl ⟨i,List.mem_range.mp hi,by simpa using heq⟩
  · obtain ⟨i,hi,heq⟩ := List.any_eq_true.mp hs
    exact Or.inr ⟨i,List.mem_range.mp hi,by simpa using heq⟩

theorem array_bad_separated (base count bad : Nat)
    (hn : 0<count)
    (h0 : ¬inBytes base count bad)
    (h3 : ¬inBytes base count (bad+3)) :
    bad+4≤base ∨ base+8*count≤bad := by
  unfold inBytes at h0 h3
  omega

theorem allowed_bad_separated (l : Layout) (k a : Nat)
    (hl : l.wellFormed k) (ha : l.allowed a) :
    a+8≤l.bad ∨ l.bad+4≤a := by
  obtain ⟨hlen,_,_,_,_,_,_,_,_,hv0,hs0,hv3,hs3⟩ := hl
  have hcount : 0<l.length := by
    rw [hlen]
    exact pow_pos (by decide : 0<2) k
  have hval := array_bad_separated l.values l.length l.bad hcount hv0 hv3
  have hscr := array_bad_separated l.scratch l.length l.bad hcount hs0 hs3
  rcases allowed_index l a ha with ⟨i,hi,rfl⟩ | ⟨i,hi,rfl⟩
  · dsimp [addr]
    omega
  · dsimp [addr]
    omega

theorem allowed_pair_separated (l : Layout) (k a b : Nat)
    (hl : l.wellFormed k) (ha : l.allowed a) (hb : l.allowed b)
    (neq : a≠b) : a+8≤b ∨ b+8≤a := by
  obtain ⟨_,_,_,_,_,_,_,_,hsep,_,_,_,_⟩ := hl
  rcases allowed_index l a ha with ⟨i,hi,rfl⟩ | ⟨i,hi,rfl⟩ <;>
    rcases allowed_index l b hb with ⟨j,hj,rfl⟩ | ⟨j,hj,rfl⟩ <;>
    dsimp [addr] at neq ⊢ <;> omega

end FT1536.Source3.StableBinaryByteLayout

#print axioms FT1536.Source3.StableBinaryByteLayout.allowed_bad_separated
#print axioms FT1536.Source3.StableBinaryByteLayout.allowed_pair_separated
