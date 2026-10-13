import ProducerReads020E7
import ProducerSnapshot020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerValueRead020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreView020E6
open ProducerWordLaws020E6 ProducerEval020E7 ProducerReads020E7

/-- Both words, including the zero payload for an absent value. -/
theorem valueAt_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) (e : E 7)
    (p : ArenaTypes020E1.Ptr 877) (he : eval (sources d fresh) e=word p.val) :
    eval (sources d fresh) (valueAt e).present=ProducerSnapshot020E6.present (ArrayValues020E4.lookup d.parser.arena d.core.values p) ∧
    eval (sources d fresh) (valueAt e).value=ProducerSnapshot020E6.value (ArrayValues020E4.lookup d.parser.arena d.core.values p) := by
  have hp : p.val<2^511 := lt_trans p.isLt (by norm_num)
  have hu : d.parser.arena.used.val<2^511 := lt_trans d.parser.arena.used.isLt (by norm_num)
  have hm : op .mul (word (2 : Nat)) (word p.val)=word (2*p.val : Nat) := mul_nat (by norm_num) hp
  have ha : op .add (word (142152 : Nat)) (word (2*p.val : Nat))=word (142152+2*p.val : Nat) := add_nat (by norm_num) (by omega)
  have hb : op .add (word (142152+2*p.val : Nat)) (word (1 : Nat))=word (142152+2*p.val+1 : Nat) := add_nat (by omega) (by norm_num)
  simp only [valueAt,guarded,ProducerScalar020E6.and,choose_eval,lt_eval,used_eval,he,
    lt_nat hp hu,load_eval,add_eval,mul_eval,literal,valueBase,hm,ha,hb]
  by_cases h : p.val<d.parser.arena.used.val
  · have hpc : p.val<877 := by have := d.parser.arena.used.isLt;omega
    let j : Fin 877 := ⟨p.val,hpc⟩
    have h0 := ProducerCoreSource020E6.value_word d fresh j 0
    have h1 := ProducerCoreSource020E6.value_word d fresh j 1
    change readWord (sources d fresh) 0 (word (142152+2*p.val : Nat))=_ at h0
    change readWord (sources d fresh) 0 (word (142152+2*p.val+1 : Nat))=_ at h1
    simp only [h,ite_true]
    have h10 : (1 : Word)≠0 := by decide +kernel
    simp only [h10,ite_false,h0,h1,ArrayValues020E4.lookup,dite_eq_left h]
    cases hv : read d.core.values j <;> simp [BankStorage020E3.valueWords,ProducerSnapshot020E6.present,
      ProducerSnapshot020E6.value,WordCodec020E5.boolWord,word_zero]
  · simp [h,ArrayValues020E4.lookup,ProducerSnapshot020E6.present,ProducerSnapshot020E6.value,
      WordCodec020E5.boolWord,word_zero]

end FT1536.S05.ProducerValueRead020E7
