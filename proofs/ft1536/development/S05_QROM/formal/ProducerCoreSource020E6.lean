import ProducerCoreRead020E6

set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerCoreSource020E6
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerCoreView020E6 ProducerCoreRead020E6

theorem control_eval (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 16) :
    eval (sources d fresh) (control j.val)=
      (CoreEncoding020E5.metaCodec 877 28941 1106642201817 hc hf hl).encode (CoreEncoding020E5.metadata d.core) j := by
  change readWord (sources d fresh) (0 : Fin 7) (word ((143906+j.val : Nat) : Int))=_
  rw [←metaPtr_val j]
  exact (ProducerWordLaws020E6.load_nat (sources d fresh) 0 (by norm_num [extent]) (metaPtr j)).trans (meta_read d.core j)

theorem value_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 877) (field : Fin 2) :
    readWord (sources d fresh) (0 : Fin 7) (word ((142152+2*j.val+field.val : Nat) : Int))=
      BankStorage020E3.valueWords (read d.core.values j) field := by
  rw [←valuePtr_val j field]
  exact (ProducerWordLaws020E6.load_nat (sources d fresh) 0 (by norm_num [extent]) (valuePtr j field)).trans (value_read d.core j field)

theorem frame_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 28941) (field : Fin 3) :
    readWord (sources d fresh) (0 : Fin 7) (word ((55329+3*j.val+field.val : Nat) : Int))=
      BankStorage020E3.frameWords (read d.core.frames.bank j) field := by
  rw [←framePtr_val j field]
  exact (ProducerWordLaws020E6.load_nat (sources d fresh) 0 (by norm_num [extent]) (framePtr j field)).trans (frame_read d.core j field)

end FT1536.S05.ProducerCoreSource020E6
