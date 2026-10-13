import ProducerEval020E7
import ProducerParserRead020E6
import ProducerCoreSource020E6
import ProducerBankRead020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerReads020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerCoreView020E6 ProducerCoreRead020E6
open ProducerParserRead020E6 ProducerWordLaws020E6 ProducerEval020E7

theorem used_eval (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) used=word d.parser.arena.used.val := by
  change readWord (sources d fresh) (1 : Fin 7) (word (usedPtr (cap:=877)).val)=_
  rw [load_nat (sources d fresh) (1 : Fin 7) (by change 5266≤2^511;norm_num) (usedPtr (cap:=877))]
  change read (ParserStore020E5.image hc hc d.parser) usedPtr=_
  exact used_read hc hc d.parser

theorem node_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 877) (f : Fin 5) :
    readWord (sources d fresh) (1 : Fin 7) (word ((5*j.val+f.val : Nat) : Int))=
      ArenaWords020E1.nodeWords (read d.parser.arena.bank j) f := by
  have h : (nodePtr j f).val=5*j.val+f.val := by change f.val+5*j.val=5*j.val+f.val;omega
  rw [←h]
  rw [load_nat (sources d fresh) (1 : Fin 7) (by change 5266≤2^511;norm_num) (nodePtr j f)]
  change read (ParserStore020E5.image hc hc d.parser) (nodePtr j f)=_
  exact node_read hc hc d.parser j f

theorem reg_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 32) :
    readWord (sources d fresh) (0 : Fin 7) (word j.val)=read d.core.state.reg j := by
  have hp : (ProducerBankRead020E6.regPtr (cap:=877) (capacity:=28941) j).val=j.val := by change 0+1*j.val=j.val;omega
  rw [←hp]
  exact (load_nat (sources d fresh) 0 (by norm_num [extent]) (ProducerBankRead020E6.regPtr (cap:=877) (capacity:=28941) j)).trans
    (ProducerBankRead020E6.reg_read hc hf hl d.core j)

theorem node_eval (d : BoundaryPayload020E5.Data) (fresh : Bool) (p : ProducerScalar020E6.E 7)
    (j : Fin 877) (h : eval (sources d fresh) p=word j.val) (f : Fin 5) :
    eval (sources d fresh) (nodeAt p f.val)=ArenaWords020E1.nodeWords (read d.parser.arena.bank j) f := by
  have hj : j.val<2^511 := lt_trans j.isLt (by norm_num)
  have hf' : f.val<2^511 := lt_trans f.isLt (by norm_num)
  simp only [nodeAt,load_eval,add_eval,mul_eval,literal,h,
    mul_nat (a:=5) (b:=j.val) (by norm_num) hj,
    add_nat (a:=5*j.val) (b:=f.val) (by omega) hf']
  exact node_word d fresh j f

end FT1536.S05.ProducerReads020E7
