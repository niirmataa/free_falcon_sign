import ProducerReads020E7
import ProducerAddress020E7

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerMemoryRead020E7
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 ProducerExpr020E6 ProducerCoreView020E6
open ProducerWordLaws020E6 ProducerCoreRead020E6

def fillPtr {n : Nat} (j : Fin n) : Fin (n*1+1) := Fin.castAdd 1 (finProdFinEquiv (j,(0 : Fin 1)))

theorem fill_read {A : Type} {n : Nat} (c : Codec A 1) (hn : n<2^511)
    (q : FillMachine020E5.State A n) (j : Fin n) :
    read (FillStore020E5.image c hn q) (fillPtr j)=c.encode (read q.bank j) 0 := by
  change read (pack (pair (bank c n) (finCodec (n+1) (by omega))) (q.bank,q.cursor)) (fillPtr j)=_
  unfold fillPtr
  rw [pack_pair,WordJoin020E5.left_read,read_encoded_cell]

theorem ram_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin ramSize) :
    readWord (sources d fresh) (0 : Fin 7) (word ((32+j.val : Nat) : Int))=read d.core.state.ram j := by
  have hp : (ProducerBankRead020E6.ramPtr (cap:=877) (capacity:=28941) j).val=32+j.val := by
    change 32+(0+1*j.val)=32+j.val;omega
  rw [←hp]
  exact (load_nat (sources d fresh) 0 (by norm_num [extent]) (ProducerBankRead020E6.ramPtr (cap:=877) (capacity:=28941) j)).trans
    (ProducerBankRead020E6.ram_read hc hf hl d.core j)

theorem rom_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin romSize) :
    readWord (sources d fresh) (3 : Fin 7) (word j.val)=read d.rom.bank j := by
  have hp : (fillPtr j).val=j.val := by change 0+1*j.val=j.val;omega
  rw [←hp,load_nat (sources d fresh) (3 : Fin 7) (by change romSize+1≤2^511;norm_num [romSize]) (fillPtr j)]
  exact fill_read wordCodec (by norm_num [romSize]) d.rom j

theorem tape_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin tapeSize) :
    readWord (sources d fresh) (2 : Fin 7) (word j.val)=boolWord (read d.tape.bank j) := by
  have hp : (fillPtr j).val=j.val := by change 0+1*j.val=j.val;omega
  rw [←hp,load_nat (sources d fresh) (2 : Fin 7) (by change tapeSize+1≤2^511;norm_num [tapeSize]) (fillPtr j)]
  exact fill_read boolCodec (by norm_num [tapeSize]) d.tape j

end FT1536.S05.ProducerMemoryRead020E7
