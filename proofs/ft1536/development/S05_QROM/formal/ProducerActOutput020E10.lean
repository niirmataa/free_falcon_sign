import ProducerControlAct020E10
import ProducerWholeLayout020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActOutput020E10
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerReference020E7 ProducerReferenceSlots020E8 ProducerCoreRead020E6

theorem control (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.act) (j : Fin 16) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (controlSlot j,f))=
      read (ProducerSlotLayout020E7.encodedReference d) (finProdFinEquiv (controlSlot j,f)) := by
  apply (ProducerOutputSlots020E8.produced d fresh _).trans
  rw [ProducerSlotSyntax020E8.control_expression,ProducerReferenceSlots020E8.control_word]
  fin_cases f
  · rfl
  · change word ((143906+j.val : Nat) : Int)=word (metaPtr j).val
    exact congrArg (fun n : Nat => word n) (metaPtr_val j).symm
  · change eval (env d) (ProducerCoreCircuit020E6.nextMeta j.val)=_
    exact (ProducerControlAct020E10.correct d hp j).trans (ProducerMetaWords020E8.meta_codec hc hf hl _ j).symm

end FT1536.S05.ProducerActOutput020E10
