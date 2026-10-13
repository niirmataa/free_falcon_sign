import ProducerSlotSyntax020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerOutputSlots020E8
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerReference020E7 ProducerReferenceSlots020E8
open ProducerCoreRead020E6

theorem produced (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 96) :
    read (ProducerStored020E6.run d fresh) j=eval (env d) (ProducerCoreSlots020E6.cells j) :=
  (congrArg (fun a : Bank Word 96 => read a j) (stored_output d fresh)).trans (congrFun (read_load _) j)

/-- Every actual control-slot word equals the old reference outside act. -/
theorem control (d : BoundaryPayload020E5.Data) (fresh : Bool)
    (ha : d.core.phase≠CoreState020E5.Phase.act) (j : Fin 16) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (controlSlot j,f))=
      read (ProducerSlotLayout020E7.encodedReference d) (finProdFinEquiv (controlSlot j,f)) := by
  apply (produced d fresh _).trans
  rw [ProducerSlotSyntax020E8.control_expression,control_word]
  fin_cases f
  · rfl
  · change word ((143906+j.val : Nat) : Int)=word (metaPtr j).val
    exact congrArg (fun n : Nat => word n) (metaPtr_val j).symm
  · change eval (env d) (ProducerCoreCircuit020E6.nextMeta j.val)=_
    exact (ProducerControlNonact020E8.raw d ha j).trans (ProducerMetaWords020E8.meta_codec hc hf hl _ j).symm

/-- All thirteen unused slots are exactly zero, also during act. -/
theorem padding (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 13) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (paddingSlot j,f))=
      read (ProducerSlotLayout020E7.encodedReference d) (finProdFinEquiv (paddingSlot j,f)) := by
  apply (produced d fresh _).trans
  rw [ProducerSlotSyntax020E8.padding_expression,padding_word]
  rfl

end FT1536.S05.ProducerOutputSlots020E8
