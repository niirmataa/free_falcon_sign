import FillStore020E5

namespace FT1536.S05.ZeroCodec020E5
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5

theorem bank_zero {A : Type} {w : Nat} (c : Codec A w) (n : Nat) (d : A)
    (hd : ∀ j,c.encode d j=0) : pack (bank c n) (zero n d)=zero (n*w) (0 : Word) := by
  apply ArrayBank020E4.ext
  funext k
  rw [pack_bank]
  conv_rhs => rw [zero,read_load]
  obtain ⟨⟨i,j⟩,rfl⟩ := (finProdFinEquiv : Fin n × Fin w ≃ Fin (n*w)).surjective k
  rw [BankWordLayout020E5.at_cell,zero,read_load]
  exact hd j

theorem join_zero (m n : Nat) : WordJoin020E5.join (zero m (0 : Word)) (zero n (0 : Word))=zero (m+n) (0 : Word) := by
  apply ArrayBank020E4.ext
  funext k
  refine Fin.addCases ?_ ?_ k
  · intro j;simp only [WordJoin020E5.left_read,zero,read_load]
  · intro j;simp only [WordJoin020E5.right_read,zero,read_load]

theorem fill_start {A : Type} {n w : Nat} (c : Codec A w) (hn : n<2^511) (d : A)
    (hd : ∀ j,c.encode d j=0) :
    FillStore020E5.image c hn (FillMachine020E5.start (zero n d))=zero (n*w+1) (0 : Word) := by
  change pack (pair (bank c n) (finCodec (n+1) _)) (zero n d,(0 : Fin (n+1)))=_
  rw [pack_pair,bank_zero c n d hd]
  have hz : pack (finCodec (n+1) (show n+1≤2^511 by omega)) (0 : Fin (n+1))=zero 1 (0 : Word) := by
    apply ArrayBank020E4.ext
    funext k
    simp only [pack_read,finCodec,zero,read_load]
    rfl
  rw [hz,join_zero]

end FT1536.S05.ZeroCodec020E5
