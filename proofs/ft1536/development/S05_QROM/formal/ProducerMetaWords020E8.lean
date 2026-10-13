import ProducerSlotLayout020E7

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerMetaWords020E8
open WordRAM020 CoreEncoding020E5 FixedAction020E5

def pending {cap : Nat} (p : Pending cap) (j : Nat) : Word := match p with
  | .none => 0
  | .one f => match j with
      | 0 => 1 | 2 => BankStorage020E3.frameWords f 0 | 3 => BankStorage020E3.frameWords f 1
      | 4 => BankStorage020E3.frameWords f 2 | _ => 0
  | .two f g => match j with
      | 0 | 1 => 1
      | 5 => BankStorage020E3.frameWords f 0 | 6 => BankStorage020E3.frameWords f 1 | 7 => BankStorage020E3.frameWords f 2
      | 8 => BankStorage020E3.frameWords g 0 | 9 => BankStorage020E3.frameWords g 1 | 10 => BankStorage020E3.frameWords g 2
      | _ => 0

theorem pending_codec {cap : Nat} (hc : cap<2^511) (p : Pending cap) (j : Fin 11) :
    (pendingCodec cap hc).encode p j=pending p j.val := by
  fin_cases j <;> cases p <;> rfl

def words {cap capacity limit : Nat} (m : Meta cap capacity limit) (j : Nat) : Word := match j with
  | 0 => word (phaseTag m.1).val
  | 1 => word m.2.1.val
  | 2 => word m.2.2.1.val
  | 3 => word m.2.2.2.1.val
  | 15 => WordCodec020E5.boolWord m.2.2.2.2.2
  | _ => pending m.2.2.2.2.1 (j-4)

theorem meta_codec {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (m : Meta cap capacity limit) (j : Fin 16) :
    (metaCodec cap capacity limit hc hf hl).encode m j=words m j.val := by
  fin_cases j <;> first | rfl | exact pending_codec hc m.2.2.2.2.1 _

/-- Small scalar read rule: no unfolding of the bank codec is needed by consumers. -/
theorem read_control (d : BoundaryPayload020E5.Data) (k : Nat) (hk : k<16) :
    ProducerExpr020E6.eval (ProducerReference020E7.env d) (ProducerCoreCircuit020E6.w k)=
      words (metadata d.core) k := by
  have h := ProducerReference020E7.word_read d k (by omega)
  have hp : ProducerSnapshot020E6.fields d ⟨k,by omega⟩=
      (metaCodec 877 28941 1106642201817 ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl).encode (metadata d.core) ⟨k,hk⟩ := by
    simp only [ProducerSnapshot020E6.fields,dite_eq_left hk]
  exact h.trans (hp.trans (meta_codec _ _ _ _ ⟨k,hk⟩))

end FT1536.S05.ProducerMetaWords020E8
