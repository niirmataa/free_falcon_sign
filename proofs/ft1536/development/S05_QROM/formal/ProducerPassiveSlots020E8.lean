import ProducerReferenceData020E8
import ProducerOutputSlots020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerPassiveSlots020E8
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerCoreSlots020E6 ProducerReference020E7
open ProducerReferenceData020E8 ProducerCoreRead020E6 ProducerEval020E7
attribute [local irreducible] ProducerCoreCircuit020E6.isPhase ProducerCoreCircuit020E6.w

def Passive (d : BoundaryPayload020E5.Data) : Prop :=
  d.core.phase=.check ∨ d.core.phase=.done ∨ d.core.phase=.bad

theorem flag (d : BoundaryPayload020E5.Data) (h : Passive d) (j : Nat) : eval (env d) (dataPresent j)=0 := by
  rcases h with hp|hp|hp <;>
    simp only [dataPresent,valueStep,actStore,pushStore,and_eval,or_eval,
      ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),
      ProducerPhaseCases020E8.phase d 3 (by decide),ProducerPhaseCases020E8.phase d 4 (by decide),hp,CoreEncoding020E5.phaseTag]
  all_goals rfl

theorem data (d : BoundaryPayload020E5.Data) (fresh : Bool) (h : Passive d) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (ProducerSlotLayout020E7.encodedReference d) (finProdFinEquiv (dataSlot j,f)) := by
  have he : ProducerDataCases020E8.code hc hf hl d.parser.arena (ProducerSlotLayout020E7.input d) d.core=[] := by
    rcases h with hp|hp|hp
    · exact ProducerDataCases020E8.check hc hf hl _ _ _ hp
    · exact ProducerDataCases020E8.done hc hf hl _ _ _ hp
    · exact ProducerDataCases020E8.bad hc hf hl _ _ _ hp
  apply (ProducerOutputSlots020E8.produced d fresh _).trans
  rw [empty_word d he j f]
  have hd : (finProdFinEquiv (dataSlot j,f)).val/3=j.val := by
    change (f.val+3*j.val)/3=j.val
    have := f.isLt;omega
  simp only [cells,hd,ite_eq_left j.isLt,choose_eval,flag d h,literal]
  rfl

end FT1536.S05.ProducerPassiveSlots020E8
