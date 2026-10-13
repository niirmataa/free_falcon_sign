import ProducerEval020E7

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerAddress020E7
open WordRAM020 ProducerExpr020E6 ProducerScalar020E6 ProducerEval020E7 ProducerWordLaws020E6

theorem some_word {n : Nat} (w : Word) (j : Fin n) (h : address n w=Option.some j) : w=word j.val := by
  unfold address at h
  split at h
  · rename_i hc
    have hj := congrArg Fin.val (Option.some.inj h)
    change w.toInt.toNat=j.val at hj
    rw [←hj,Int.toNat_of_nonneg hc.1,ProducerClamp020E6.word_toInt]
  · contradiction

theorem valid_eval {r : Nat} {extent : Fin r → Nat} (s : ProducerMachine020E6.Sources extent)
    (n : Nat) (hn : n<2^511) (e : E r) :
    eval s (validAddress n e)=WordCodec020E5.boolWord (address n (eval s e)).isSome := by
  simp only [validAddress,and_eval,not_eval,lt_eval,literal,op,
    InputLayout020.nat_word_exact n hn]
  by_cases ha : (eval s e).toInt<0
  · have hc : ¬(0≤(eval s e).toInt ∧ (eval s e).toInt.toNat<n) := by omega
    simp [ha,address,hc,WordCodec020E5.boolWord,word_zero,word_one]
  · by_cases hb : (eval s e).toInt<(n : Int)
    · have hc : 0≤(eval s e).toInt ∧ (eval s e).toInt.toNat<n := by omega
      simp [ha,hb,address,hc,WordCodec020E5.boolWord,word_zero,word_one]
    · have hc : ¬(0≤(eval s e).toInt ∧ (eval s e).toInt.toNat<n) := by omega
      simp [ha,hb,address,hc,WordCodec020E5.boolWord,word_zero,word_one]

end FT1536.S05.ProducerAddress020E7
