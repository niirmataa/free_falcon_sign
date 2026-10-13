import ProducerScalar020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerWordLaws020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6 ProducerExpr020E6

theorem word_zero : word 0=(0 : Word) := rfl
theorem word_one : word 1=(1 : Word) := rfl

theorem word_injective {a b : Nat} (ha : a<2^511) (hb : b<2^511) : word a=word b ↔ a=b := by
  constructor
  · intro h
    have hh := congrArg (fun w : Word => w.toInt) h
    rw [InputLayout020.nat_word_exact a ha,InputLayout020.nat_word_exact b hb] at hh
    exact_mod_cast hh
  · intro h;rw [h]

theorem add_nat {a b : Nat} (ha : a<2^511) (hb : b<2^511) : WordRAM020.op .add (word a) (word b)=word ((a+b : Nat) : Int) := by
  simp only [WordRAM020.op,InputLayout020.nat_word_exact a ha,InputLayout020.nat_word_exact b hb,Nat.cast_add]

theorem mul_nat {a b : Nat} (ha : a<2^511) (hb : b<2^511) : WordRAM020.op .mul (word a) (word b)=word ((a*b : Nat) : Int) := by
  simp only [WordRAM020.op,InputLayout020.nat_word_exact a ha,InputLayout020.nat_word_exact b hb,Nat.cast_mul]

theorem lt_nat {a b : Nat} (ha : a<2^511) (hb : b<2^511) :
    WordRAM020.op .lt (word a) (word b)=if a<b then (1 : Word) else 0 := by
  have cmp : (a : Int)<b ↔ a<b := by omega
  simp only [WordRAM020.op,InputLayout020.nat_word_exact a ha,InputLayout020.nat_word_exact b hb,cmp]
  split <;> rfl

theorem eq_nat {a b : Nat} (ha : a<2^511) (hb : b<2^511) :
    WordRAM020.op .eq (word a) (word b)=if a=b then (1 : Word) else 0 := by
  simp only [WordRAM020.op,word_injective ha hb]
  split <;> rfl

theorem address_nat {n : Nat} (hn : n≤2^511) (j : Fin n) : WordRAM020.address n (word j.val)=some j := by
  have he := InputLayout020.nat_word_exact j.val (lt_of_lt_of_le j.isLt hn)
  unfold WordRAM020.address
  split
  · apply congrArg some
    apply Fin.ext
    change (word j.val).toInt.toNat=j.val
    rw [he]
    rfl
  · rename_i h
    apply False.elim
    apply h
    rw [he]
    exact ⟨Nat.cast_nonneg _,by simpa only [Int.toNat_natCast] using j.isLt⟩

theorem load_nat {regions : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (r : Fin regions) (hn : extent r≤2^511) (j : Fin (extent r)) :
    readWord sources r (word j.val)=read (sources r) j := by
  unfold readWord
  rw [address_nat hn j]

theorem read_encoded_cell {A : Type} {n w : Nat} (c : WordCodec020E5.Codec A w) (a : Bank A n) (i : Fin n) (j : Fin w) :
    read (VerifiedPatch020E5.pack (WordCodec020E5.bank c n) a) (finProdFinEquiv (i,j))=c.encode (read a i) j := by
  rw [VerifiedPatch020E5.pack_bank,BankWordLayout020E5.at_cell]

end FT1536.S05.ProducerWordLaws020E6
